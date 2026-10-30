package com.hof.tronnelkul.game.engine;

import com.hof.tronnelkul.game.engine.EngineState.*;
import com.hof.tronnelkul.game.engine.Rules.*;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.world.GoodDef;
import com.hof.tronnelkul.game.world.MapDefinition;

import java.util.*;
import java.util.random.RandomGenerator;
import java.util.stream.Collectors;

/**
 * Rulebook v0.2 rule engine: order sheets with maturation, settlement at 8:00 / 20:00, elections, spies, news,
 * information market. One instance works on one loaded state and collects reports in `out`.
 * All player-facing text is emitted as Msg (i18n keys engine.*, catalog.*, world.*); the engine has no wording.
 */
public final class Engine {
    public record Cost(int pp, int gold) {
        public Cost plus(Cost other) { return new Cost(pp + other.pp, gold + other.gold); }
    }

    public static final String CITY = "_city";

    public final MapDefinition map;
    public final EngineState state;
    public final List<ReportOut> out = new ArrayList<>();
    private final RandomGenerator rng;

    public Engine(MapDefinition map, EngineState state, long seed) {
        this.map = map; this.state = state; this.rng = new SplittableRandom(seed);
    }

    static double r1(double value) { return Math.round(value * 10) / 10.0; }

    /** A house's name (stored text), or a Msg for an unknown house. */
    public Object name(String player) {
        PlayerSt ps = state.players.get(player);
        return ps == null ? Msg.of("engine.unknown_house") : ps.name;
    }

    /** Name of a city or estate node (Msg). */
    public Object cityName(String id) { return map.nodeName(id); }

    public CitySt city(String id) {
        CitySt cs = state.cities.get(id);
        if (cs == null) {
            throw new EngineException(err("unknown_city"));
        }
        return cs;
    }

    private static Msg err(String id, Object... kv) { return Msg.of("engine.error." + id, kv); }

    private static Msg title(String id, Object... kv) { return Msg.of("engine.report." + id + ".title", kv); }

    private static Msg text(String id, Object... kv) { return Msg.of("engine.report." + id + ".text", kv); }

    /** Good name inside a sentence (lowercase). */
    private static Msg goodLower(String good) { return GoodDef.label(good).lower(); }

    private boolean npc(String player) { PlayerSt ps = state.players.get(player); return ps != null && ps.npc; }

    // ---------- Network (chapter 4) ----------

    /** Nodes reachable from the estate via own routes, with their distance. NPC networks are unrestricted. */
    public Map<String, Integer> network(String player) {
        PlayerSt ps = state.players.get(player);
        Map<String, Integer> dist = new LinkedHashMap<>();
        if (ps == null) {
            return dist;
        }
        if (ps.npc) {
            for (CityDef city : map.cities()) {
                dist.put(city.id(), 1);
            }
            return dist;
        }
        if (ps.estate == null) {
            return dist;
        }
        dist.put(ps.estate, 0);
        Deque<String> queue = new ArrayDeque<>(List.of(ps.estate));
        List<Edge> own = state.routesOf(player);
        while (!queue.isEmpty()) {
            String node = queue.poll();
            for (Edge edge : own) {
                if (!edge.touches(node)) {
                    continue;
                }
                String next = edge.other(node);
                if (!dist.containsKey(next)) { dist.put(next, dist.get(node) + 1); queue.add(next); }
            }
        }
        return dist;
    }

    public boolean reaches(String player, String node) { return network(player).containsKey(node); }

    public boolean hasRoute(String player, String from, String to) { return state.routesOf(player).stream().anyMatch(edge -> edge.same(from, to)); }

    // ---------- Helpers ----------

    public double popOf(String city, String player) { return state.cities.get(city).pop.getOrDefault(player, Rules.POP_BASE); }

    /** Popularity change, clamped to 0–100; above 60 a positive effect is worth half (4.5). */
    public void addPop(String city, String player, double delta) {
        double cur = popOf(city, player), change = delta;
        if (change > 0 && cur >= Rules.POP_SOFT_CAP) {
            change /= 2;
        }
        state.cities.get(city).pop.put(player, Math.max(0, Math.min(100, r1(cur + change))));
    }

    public static int cityShare(Good good) { return Math.max(0, 100 - good.shares.values().stream().mapToInt(Integer::intValue).sum()); }

    /** Market value of a point: average profit per point over the last 3 settlements × 10 (5.4). */
    public static double marketValue(Good good) {
        List<Double> recent = good.history.subList(Math.max(0, good.history.size() - 3), good.history.size());
        double avg = recent.isEmpty() ? Rules.MARKET_VALUE_DEFAULT_PROFIT : recent.stream().mapToDouble(Double::doubleValue).average().orElse(0);
        return Math.max(Rules.MARKET_VALUE_MIN, r1(avg * 10));
    }

    /** Seat-weighted average of the council parties' program rates; 20% without a council (6.2). */
    public double taxRate(String city) {
        CitySt cs = state.cities.get(city);
        int total = cs.council.values().stream().mapToInt(Integer::intValue).sum();
        if (total == 0) {
            return Rules.DEFAULT_TAX;
        }
        double sum = 0;
        for (var entry : cs.council.entrySet()) {
            sum += Program.of(cs.parties.get(entry.getKey())).rate * entry.getValue();
        }
        return sum / total;
    }

    /** The next settlement is an election: festival effect and price are doubled (6.3). */
    public boolean isCampaign() { return (state.settlements + 1) % Rules.ELECTION_EVERY == 0; }

    public int nextElectionIn() { return Rules.ELECTION_EVERY - (state.settlements % Rules.ELECTION_EVERY); }

    public boolean newsTruth(String city, String template, String target, String good) {
        CitySt cs = state.cities.get(city);
        return switch (NewsTemplate.of(template)) {
            case USURY -> {
                Good goodState = good == null ? null : cs.goods.get(good);
                String margin = goodState == null || !goodState.shares.containsKey(target) ? null : goodState.margins.get(target);
                yield Margin.EXPENSIVE.id.equals(margin) || Margin.USURY.id.equals(margin);
            }
            case BOUGHT_OUT -> state.events.stream().anyMatch(event -> "buyout".equals(event.type) && target.equals(event.by) && city.equals(event.city)
                && state.settlements - event.settlement <= Rules.NEWS_TRUTH_WINDOW);
            case TAX_HIKE -> Program.HIGH.id.equals(cs.parties.get(target));
            case SPIES -> cs.spies.getOrDefault(target, 0) > 0;
            case FRIEND -> {
                double avg = cs.pop.values().stream().mapToDouble(Double::doubleValue).average().orElse(Rules.POP_BASE);
                yield popOf(city, target) > avg;
            }
        };
    }

    /** The news text: the template with {t} = target house and {g} = good (lowercase). */
    public Msg newsText(String template, String target, String good) {
        return Msg.of(NewsTemplate.of(template).labelKey(), "t", name(target), "g", good == null ? "" : goodLower(good));
    }

    public Msg newsText(News news) { return newsText(news.template, news.target, news.good); }

    public Optional<News> news(String id) { return state.news.stream().filter(news -> news.id.equals(id)).findFirst(); }

    public Optional<Sheet> sheet(String id) { return state.sheets.stream().filter(sheet -> sheet.id.equals(id)).findFirst(); }

    /** A buyout order of the sheet that targets the player. */
    public Optional<Order> buyoutAgainst(String player, String sheetId, String orderId) {
        return sheet(sheetId).flatMap(sheet -> sheet.orders.stream()
            .filter(order -> order.id.equals(orderId) && "buyout".equals(order.type) && player.equals(order.target)).findFirst());
    }

    public boolean isProtected(String city, String good, String player) {
        return state.protection.getOrDefault(city + "|" + good + "|" + player, -1) > state.settlements;
    }

    // ---------- Cost ----------

    public Cost cost(String player, Order order) {
        Action action = Action.of(order.type);
        double gold = action.gold == null ? 0 : action.gold;
        CitySt cs = order.city == null ? null : state.cities.get(order.city);
        Good good = cs == null || order.good == null ? null : cs.goods.get(order.good);
        switch (action) {
            case BUY_SHARES -> gold = Rules.CITY_SHARE_COST * order.pts;
            case BUYOUT -> gold = good == null ? 0 : Math.ceil(marketValue(good) * order.pts * Rules.BUYOUT_PREMIUM);
            case DEFEND -> {
                Order bo = buyoutAgainst(player, order.sheetId, order.orderId).orElse(null);
                Good bg = bo == null ? null : cs.goods.get(bo.good);
                gold = bg == null ? 0 : Math.ceil(marketValue(bg) * bo.pts);
            }
            case FESTIVAL -> {
                if (isCampaign()) {
                    gold *= 2;
                }
            }
            default -> {}
        }
        return new Cost(action.pp, (int) Math.round(gold));
    }

    public Cost draftCost(String player) {
        Cost total = new Cost(0, 0);
        for (Order order : state.draftOf(player)) {
            total = total.plus(new Cost(Action.of(order.type).pp, order.gold));
        }
        return total;
    }

    /** The order's description. depth: 1 type only, 2 with target, 3 with cost too (scouting accuracy, 7.2). */
    public Msg orderLabel(Order order, int depth) {
        Action action = Action.of(order.type);
        if (depth <= 1) {
            return action.label();
        }
        Object cn = order.city == null ? "" : cityName(order.city);
        Good goodState = order.city == null || order.good == null ? null : state.cities.get(order.city).goods.get(order.good);
        String good = goodState == null ? null : order.good;
        Object gn = good == null ? "" : GoodDef.label(good);
        Msg txt = switch (action) {
            case ROUTE -> Msg.of("engine.order.route", "action", action.label(), "from", map.nodeName(order.from), "to", map.nodeName(order.to));
            case MARGIN -> Msg.of("engine.order.margin", "good", gn, "level", Margin.of(order.level).label(), "city", cn);
            case BUY_SHARES -> Msg.of("engine.order.buyShares", "pts", order.pts, "good", gn, "city", cn);
            case BUYOUT -> Msg.of("engine.order.buyout", "pts", order.pts, "target", name(order.target), "good", gn, "city", cn);
            case DEFEND -> Msg.of("engine.order.defend", "good", gn, "city", cn);
            case PROGRAM -> Msg.of("engine.order.program", "program", Program.of(order.level).label(), "city", cn);
            case NEWS -> Msg.of("engine.order.news", "news", newsText(order.template, order.target, good), "city", cn);
            case SPY -> Msg.of("engine.order.spy", "target", name(order.target), "city", cn);
            case MOVE_SPY -> Msg.of("engine.order.moveSpy", "from", cn, "to", cityName(order.to));
            default -> Msg.of("engine.order.other", "action", action.label(), "city", cn);
        };
        return depth >= 3 ? Msg.of("engine.order.with_cost", "order", txt, "gold", order.gold) : txt;
    }

    /** The scouted orders of an intel at its depth. */
    public List<Msg> intelLines(Intel it) { return it.orders.stream().map(order -> orderLabel(order, it.depth)).toList(); }

    // ---------- Validity ----------

    /** null if the order can run now; otherwise the reason. */
    public Msg validate(String player, Order order) {
        Action action;
        try { action = Action.of(order.type); } catch (EngineException ex) { return ex.msg(); }
        if (action == Action.ROUTE) {
            if (order.from == null || order.to == null || !map.hasEdge(order.from, order.to)) {
                return err("no_road");
            }
            if (!map.isCity(order.to)) {
                return err("route_city_only");
            }
            if (!reaches(player, order.from)) {
                return err("route_from_network");
            }
            if (hasRoute(player, order.from, order.to)) {
                return err("route_owned");
            }
            return null;
        }
        if (order.city == null || !state.cities.containsKey(order.city)) {
            return err("unknown_city");
        }
        if (!reaches(player, order.city)) {
            return err("city_not_in_network");
        }
        CitySt cs = state.cities.get(order.city);
        Good good = order.good == null ? null : cs.goods.get(order.good);
        int spies = cs.spies.getOrDefault(player, 0), free = spies - cs.guards.getOrDefault(player, 0);
        switch (action) {
            case MARGIN -> {
                if (good == null) {
                    return err("unknown_good");
                }
                if (good.shares.getOrDefault(player, 0) <= 0) {
                    return err("needs_shares");
                }
                if (!Margin.valid(order.level)) {
                    return err("unknown_margin");
                }
            }
            case BUY_SHARES -> {
                if (good == null) {
                    return err("unknown_good");
                }
                if (order.pts < 1 || order.pts > Rules.MAX_SHARES_PER_ORDER) {
                    return err("shares_per_order", "max", Rules.MAX_SHARES_PER_ORDER);
                }
                if (cityShare(good) < order.pts) {
                    return err("city_shares_left", "pts", cityShare(good));
                }
            }
            case BUYOUT -> {
                if (good == null) {
                    return err("unknown_good");
                }
                if (order.target == null || order.target.equals(player)) {
                    return err("pick_rival");
                }
                if (order.pts < 1 || order.pts > Rules.MAX_SHARES_PER_ORDER) {
                    return err("buyout_per_order", "max", Rules.MAX_SHARES_PER_ORDER);
                }
                if (good.shares.getOrDefault(order.target, 0) < order.pts) {
                    return err("target_lacks_shares");
                }
                if (isProtected(order.city, order.good, order.target)) {
                    return err("target_protected");
                }
            }
            case DEFEND -> {
                Optional<Order> bo = buyoutAgainst(player, order.sheetId, order.orderId);
                if (bo.isEmpty()) {
                    return err("buyout_already_ran");
                }
                if (!order.city.equals(bo.get().city)) {
                    return err("defend_wrong_city");
                }
            }
            case FOUND_PARTY -> {
                if (cs.parties.containsKey(player)) {
                    return err("party_exists");
                }
            }
            case PROGRAM -> {
                if (!cs.parties.containsKey(player)) {
                    return err("needs_party");
                }
                if (!Program.valid(order.level)) {
                    return err("unknown_program");
                }
            }
            case FESTIVAL -> {
                if (!cs.parties.containsKey(player)) {
                    return err("needs_party");
                }
            }
            case NEWS -> {
                NewsTemplate template;
                try { template = NewsTemplate.of(order.template); } catch (EngineException ex) { return ex.msg(); }
                if (order.target == null || !state.players.containsKey(order.target) || order.target.equals(player)) {
                    return err("pick_target");
                }
                if (template.needsGood && good == null) {
                    return err("pick_good");
                }
            }
            case HIRE_SPY -> {
                if (spies >= Rules.SPIES_PER_CITY) {
                    return err("spy_limit", "max", Rules.SPIES_PER_CITY);
                }
            }
            case GUARD -> {
                if (free < 1) {
                    return err("no_free_spy");
                }
            }
            case MOVE_SPY -> {
                if (free < 1) {
                    return err("no_free_spy");
                }
                if (order.to == null || !state.cities.containsKey(order.to) || order.to.equals(order.city)) {
                    return err("pick_target_city");
                }
                if (!reaches(player, order.to)) {
                    return err("spy_move_network");
                }
                if (state.cities.get(order.to).spies.getOrDefault(player, 0) >= Rules.SPIES_PER_CITY) {
                    return err("spy_limit_there", "max", Rules.SPIES_PER_CITY);
                }
            }
            case SPY -> {
                if (free < 1) {
                    return err("needs_free_spy");
                }
                if (order.target == null || order.target.equals(player) || !state.players.containsKey(order.target)) {
                    return err("pick_target");
                }
            }
            case VERIFY, DEBUNK -> {
                if (spies < 1) {
                    return err("needs_spy");
                }
                News news = news(order.newsId).orElse(null);
                if (news == null || !news.city.equals(order.city) || news.debunked) {
                    return err("no_such_news");
                }
                if (news.author.equals(player)) {
                    return err("own_news");
                }
                if (action == Action.DEBUNK && !Boolean.FALSE.equals(state.players.get(player).verified.get(news.id))) {
                    return err("verify_first");
                }
            }
            default -> {}
        }
        return null;
    }

    // ---------- Player operations ----------

    /**
     * Adds an order to the player's draft (unsealed sheet). A margin order replaces the draft margin order of the same
     * city and good (at most one pending level change per good); asking for the level already in effect only drops that
     * pending order. Returns the added order, or empty when nothing was added (the pending change was cancelled).
     */
    public Optional<Order> addDraft(String player, Order order) {
        Msg invalid = validate(player, order);
        if (invalid != null) {
            throw new EngineException(invalid);
        }
        List<Order> replaced = List.of();
        if (Action.of(order.type) == Action.MARGIN) {
            replaced = state.draftOf(player).stream().filter(queued -> isSameMarginChange(queued, order)).toList();
            String current = state.cities.get(order.city).goods.get(order.good).margins.getOrDefault(player, Margin.MARKET.id);
            if (current.equals(order.level)) {
                state.draftOf(player).removeAll(replaced);
                return Optional.empty();
            }
        }
        if (order.type.equals("defend")) {
            Order bo = buyoutAgainst(player, order.sheetId, order.orderId).orElseThrow();
            order.good = bo.good; order.pts = bo.pts;
            if (state.draftOf(player).stream().anyMatch(queued -> "defend".equals(queued.type) && order.orderId.equals(queued.orderId))) {
                throw new EngineException(err("defend_on_draft"));
            }
        }
        Cost drafted = draftCost(player), add = cost(player, order);
        for (Order queued : replaced) {
            drafted = drafted.plus(new Cost(-Action.of(queued.type).pp, -queued.gold));
        }
        PlayerSt ps = state.players.get(player);
        if (drafted.pp() + add.pp() > ps.pp) {
            throw new EngineException(err("not_enough_pp", "need", drafted.pp() + add.pp(), "have", ps.pp));
        }
        if (drafted.gold() + add.gold() > ps.gold) {
            throw new EngineException(err("not_enough_gold", "need", drafted.gold() + add.gold(), "have", (int) ps.gold));
        }
        state.draftOf(player).removeAll(replaced);
        order.id = state.nextId("o");
        order.gold = add.gold();
        state.draftOf(player).add(order);
        return Optional.of(order);
    }

    private static boolean isSameMarginChange(Order queued, Order order) {
        return Action.of(queued.type) == Action.MARGIN && Objects.equals(queued.city, order.city) && Objects.equals(queued.good, order.good);
    }

    public void removeDraft(String player, String orderId) {
        if (!state.draftOf(player).removeIf(order -> order.id.equals(orderId))) {
            throw new EngineException(err("no_such_draft_order"));
        }
    }

    /** Sealing: the cost is reserved, the sheet runs `maturationMin` minutes later (3.1). */
    public Sheet seal(String player, long now, int maturationMin) {
        List<Order> draft = state.draftOf(player);
        if (draft.isEmpty()) {
            throw new EngineException(err("empty_sheet"));
        }
        if (state.sheetOf(player).isPresent()) {
            throw new EngineException(err("sheet_maturing"));
        }
        Cost total = draftCost(player);
        PlayerSt ps = state.players.get(player);
        if (total.pp() > ps.pp) {
            throw new EngineException(err("not_enough_pp", "need", total.pp(), "have", ps.pp));
        }
        if (total.gold() > ps.gold) {
            throw new EngineException(err("not_enough_gold", "need", total.gold(), "have", (int) ps.gold));
        }
        return pushSheet(player, new ArrayList<>(draft), now, now + maturationMin * 60_000L, total, draft::clear);
    }

    private Sheet pushSheet(String player, List<Order> orders, long sealedAt, long executeAt, Cost cost, Runnable after) {
        PlayerSt ps = state.players.get(player);
        ps.pp -= cost.pp(); ps.gold = r1(ps.gold - cost.gold());
        Sheet sheet = new Sheet();
        sheet.id = state.nextId("L"); sheet.player = player; sheet.orders = orders; sheet.sealedAt = sealedAt; sheet.executeAt = executeAt;
        sheet.pp = cost.pp(); sheet.gold = cost.gold();
        state.sheets.add(sheet);
        after.run();
        // The buyout offer is public to its target (5.4)
        for (Order order : orders) {
            if (!"buyout".equals(order.type)) {
                continue;
            }
            report(order.target, "faction", null, title("buyout_threat", "house", name(player)),
                text("buyout_threat", "pts", order.pts, "good", goodLower(order.good), "city", cityName(order.city), "time", Time.fmt(executeAt)), "danger", sealedAt);
        }
        return sheet;
    }

    // ---------- Information market (7.5) ----------

    public void offerIntel(String seller, String intelId, String buyer, int price) {
        Intel it = state.intel.stream().filter(intel -> intel.id.equals(intelId) && intel.owner.equals(seller)).findFirst()
            .orElseThrow(() -> new EngineException(err("no_such_intel")));
        if (sheet(it.sheetId).isEmpty()) {
            throw new EngineException(err("intel_expired"));
        }
        if (buyer == null || !state.players.containsKey(buyer) || buyer.equals(seller)) {
            throw new EngineException(err("pick_buyer"));
        }
        if (buyer.equals(it.of)) {
            throw new EngineException(err("own_plans"));
        }
        if (it.offeredTo.contains(buyer)) {
            throw new EngineException(err("already_offered"));
        }
        if (price < 1 || price > 500) {
            throw new EngineException(err("price_range", "min", 1, "max", 500));
        }
        it.offeredTo.add(buyer);
        PlayerSt buyerState = state.players.get(buyer);
        if (buyerState.npc) {
            // NPCs decide at once: they buy cheap, fresh information.
            if (price <= Rules.INFO_PRICE * 1.5 && buyerState.gold >= price) {
                completeSale(it, seller, buyer, price);
            } else {
                report(seller, "spy", null, title("intel_rejected", "house", name(buyer)), text("intel_rejected", "price", price), "warn", state.clock);
            }
            return;
        }
        Offer offer = new Offer();
        offer.id = state.nextId("f"); offer.intelId = it.id; offer.seller = seller; offer.buyer = buyer; offer.price = price;
        state.offers.add(offer);
        report(buyer, "spy", null, title("intel_offer", "house", name(seller)), text("intel_offer", "of", name(it.of), "price", price), "info", state.clock);
    }

    public void acceptOffer(String buyer, String offerId) {
        Offer offer = offer(buyer, offerId);
        Intel it = state.intel.stream().filter(intel -> intel.id.equals(offer.intelId)).findFirst().orElse(null);
        if (it == null || sheet(it.sheetId).isEmpty()) { state.offers.remove(offer); throw new EngineException(err("offer_expired")); }
        if (state.players.get(buyer).gold < offer.price) {
            throw new EngineException(err("not_enough_gold_offer", "need", offer.price));
        }
        state.offers.remove(offer);
        completeSale(it, offer.seller, buyer, offer.price);
    }

    public void declineOffer(String buyer, String offerId) {
        Offer offer = offer(buyer, offerId);
        state.offers.remove(offer);
        report(offer.seller, "spy", null, title("intel_declined", "house", name(buyer)), text("intel_declined"), "warn", state.clock);
    }

    private Offer offer(String buyer, String offerId) {
        return state.offers.stream().filter(offer -> offer.id.equals(offerId) && offer.buyer.equals(buyer)).findFirst()
            .orElseThrow(() -> new EngineException(err("no_such_offer")));
    }

    private void completeSale(Intel it, String seller, String buyer, int price) {
        PlayerSt sp = state.players.get(seller), bp = state.players.get(buyer);
        bp.gold = r1(bp.gold - price); sp.gold = r1(sp.gold + price);
        Intel copy = new Intel();
        copy.id = state.nextId("i"); copy.owner = buyer; copy.sheetId = it.sheetId; copy.of = it.of; copy.executeAt = it.executeAt;
        copy.orders = it.orders.stream().map(Order::copy).collect(Collectors.toCollection(ArrayList::new)); copy.depth = it.depth; copy.bought = true;
        if (!bp.npc) {
            state.intel.add(copy);
        }
        Object bonus = "";
        if (state.settlements - sp.lastInfoSale >= Rules.INFO_LEGIT_EVERY) {
            sp.legit += Rules.INFO_LEGIT; sp.lastInfoSale = state.settlements; bonus = Msg.of("engine.report.intel_sold.bonus", "legit", Rules.INFO_LEGIT);
        }
        report(seller, "spy", null, title("intel_sold", "house", name(buyer)),
            text("intel_sold", "buyer", name(buyer), "price", price, "of", name(it.of), "bonus", bonus), "ok", state.clock);
        report(buyer, "spy", depthConfidence(it.depth), title("plans", "house", name(it.of), "time", Time.fmt(it.executeAt)),
            text("intel_bought", "lines", Msg.join(" · ", intelLines(it)), "price", price, "seller", name(seller)), "info", state.clock);
    }

    // ---------- Time (3.1–3.2) ----------

    /**
     * Runs the maturing sheets and settlements due until `until`, in time order.
     * Stops after the season's last (maxSettlements-th) settlement.
     */
    public void advance(long until, int maturationMin, int maxSettlements) {
        for (int guard = 0; guard < 1000 && state.settlements < maxSettlements; guard++) {
            long nextSheet = state.sheets.stream().mapToLong(queued -> queued.executeAt).min().orElse(Long.MAX_VALUE);
            long nextSet = Time.nextSettlement(state.clock);
            PlayerSt nextNpc = state.players.values().stream().filter(ps -> ps.npc && ps.nextPlanAt > 0).min(Comparator.comparingLong(ps -> ps.nextPlanAt)).orElse(null);
            long npcAt = nextNpc == null ? Long.MAX_VALUE : Math.max(nextNpc.nextPlanAt, state.clock);
            long at = Math.min(Math.min(nextSheet, nextSet), npcAt);
            if (at > until) {
                break;
            }
            state.clock = at;
            if (npcAt == at && npcAt < nextSheet && npcAt < nextSet) {
                // NPCs may seal at any time, with the same maturation time (3.1)
                nextNpc.nextPlanAt = 0;
                npcPlanFor(nextNpc, maturationMin);
            } else if (nextSheet <= nextSet) {
                // For simultaneous sheets the sealing order decides (3.1)
                Sheet sheet = state.sheets.stream().filter(queued -> queued.executeAt == at).min(Comparator.comparingLong((Sheet queued) -> queued.sealedAt).thenComparing(queued -> queued.id)).orElseThrow();
                state.sheets.remove(sheet);
                executeSheet(sheet);
            } else {
                settle();
                if (state.settlements >= maxSettlements) {
                    return;
                }
                scheduleNpcs();
            }
        }
        state.clock = Math.max(state.clock, until);
    }

    /** For development: immediate settlement instead of 8:00 / 20:00 (scheduled settlements still run). */
    public void settleNow(int maturationMin) {
        settle();
        scheduleNpcs();
    }

    /** Time of the next event (sheet or settlement). */
    public long nextEventAt() {
        long nextSheet = state.sheets.stream().mapToLong(sheet -> sheet.executeAt).min().orElse(Long.MAX_VALUE);
        return Math.min(nextSheet, Time.nextSettlement(state.clock));
    }

    void report(String player, String kind, String confidence, Msg title, Msg text, String tone, long at) {
        if (player == null || npc(player) || !state.players.containsKey(player)) {
            return;
        }
        out.add(new ReportOut(player, false, at, kind, confidence, title, text, tone));
    }

    void publicReport(String kind, Msg title, Msg text, String tone) {
        out.add(new ReportOut(null, true, state.clock, kind, null, title, text, tone));
    }

    private static String depthConfidence(int depth) { return depth >= 3 ? "strong" : depth >= 2 ? "medium" : "weak"; }

    // ---------- Executing a sheet ----------

    private void executeSheet(Sheet sheet) {
        String player = sheet.player;
        PlayerSt ps = state.players.get(player);
        if (ps == null) {
            return;
        }
        long now = state.clock;
        for (Order order : sheet.orders) {
            if ("defend".equals(order.type) && state.events.stream().anyMatch(event -> "defendUsed".equals(event.type) && order.orderId.equals(event.orderId))) {
                report(player, "faction", null, title("defend_used"), text("defend_used"), "info", now);
                continue;
            }
            Msg invalid = validate(player, order);
            if (invalid != null) {
                ps.gold = r1(ps.gold + order.gold); // gold is refunded, PP is not
                report(player, "faction", null, title("order_failed", "action", Action.of(order.type).label()), text("order_failed", "reason", invalid), "warn", now);
                continue;
            }
            CitySt cs = order.city == null ? null : state.cities.get(order.city);
            Good good = cs == null || order.good == null ? null : cs.goods.get(order.good);
            Object cn = order.city == null ? "" : cityName(order.city);
            switch (Action.of(order.type)) {
                case ROUTE -> {
                    state.routesOf(player).add(new Edge(order.from, order.to));
                    report(player, "diplomacy", null, title("route", "city", cityName(order.to)), text("route", "city", cityName(order.to)), "ok", now);
                }
                case MARGIN -> {
                    good.margins.put(player, order.level);
                    report(player, "faction", null, title("margin", "good", GoodDef.label(order.good), "level", Margin.of(order.level).label()), text("margin", "city", cn), "info", now);
                }
                case BUY_SHARES -> {
                    good.shares.merge(player, order.pts, Integer::sum); good.margins.putIfAbsent(player, Margin.MARKET.id);
                    report(player, "faction", null, title("buyShares", "pts", order.pts, "good", GoodDef.label(order.good)),
                        text("buyShares", "city", cn, "good", goodLower(order.good), "share", good.shares.get(player)), "ok", now);
                }
                case BUYOUT -> buyout(sheet, order, cs, good);
                case DEFEND -> {
                    MarketEvent event = new MarketEvent();
                    event.type = "defend"; event.sheetId = order.sheetId; event.orderId = order.orderId; event.by = player; event.city = order.city; event.good = order.good; event.settlement = state.settlements;
                    state.events.add(event);
                    report(player, "faction", null, title("defend", "good", GoodDef.label(order.good)), text("defend"), "info", now);
                }
                case FOUND_PARTY -> {
                    cs.parties.put(player, Program.MEDIUM.id);
                    report(player, "diplomacy", null, title("foundParty", "city", cn), text("foundParty"), "ok", now);
                }
                case PROGRAM -> {
                    cs.parties.put(player, order.level);
                    report(player, "diplomacy", null, title("program", "program", Program.of(order.level).label()), text("program", "city", cn), "info", now);
                }
                case FESTIVAL -> {
                    String key = order.city + "|" + player;
                    boolean recent = state.festivals.containsKey(key) && state.settlements - state.festivals.get(key) < Rules.FESTIVAL_COOLDOWN;
                    double gain = (recent ? Rules.FESTIVAL_POP / 2 : Rules.FESTIVAL_POP) * (isCampaign() ? 2 : 1);
                    addPop(order.city, player, gain);
                    state.festivals.put(key, state.settlements);
                    report(player, "event", null, title("festival", "gain", fmt(gain)),
                        recent ? Msg.of("engine.report.festival.text_recent") : text("festival"), "ok", now);
                }
                case NEWS -> {
                    News news = new News();
                    news.id = state.nextId("n"); news.city = order.city; news.author = player; news.target = order.target; news.template = order.template;
                    news.good = NewsTemplate.of(order.template).needsGood ? order.good : null;
                    news.effect = NewsTemplate.of(order.template).effect; news.createdAt = now;
                    news.trueAtCreation = newsTruth(order.city, news.template, news.target, news.good);
                    addPop(order.city, news.target, news.effect);
                    state.news.add(0, news);
                    publicReport("faction", title("news", "city", cn), newsText(news), news.effect < 0 ? "warn" : "ok");
                }
                case HIRE_SPY -> {
                    cs.spies.merge(player, 1, Integer::sum);
                    report(player, "spy", null, title("hireSpy", "city", cn), text("hireSpy", "spies", cs.spies.get(player)), "ok", now);
                }
                case GUARD -> {
                    cs.guards.merge(player, 1, Integer::sum);
                    report(player, "spy", null, title("guard"), text("guard", "city", cn, "guards", cs.guards.get(player)), "info", now);
                }
                case SPY -> spy(player, order, cs);
                case MOVE_SPY -> {
                    int left = cs.spies.get(player) - 1;
                    if (left <= 0) {
                        cs.spies.remove(player);
                    } else {
                        cs.spies.put(player, left);
                    }
                    state.cities.get(order.to).spies.merge(player, 1, Integer::sum);
                    report(player, "spy", null, title("moveSpy", "to", cityName(order.to)), text("moveSpy", "from", cn, "to", cityName(order.to)), "info", now);
                }
                case VERIFY -> {
                    News news = news(order.newsId).orElseThrow();
                    if (caught(order.city, player, news.author)) {
                        continue;
                    }
                    ps.verified.put(news.id, news.trueAtCreation);
                    report(player, "spy", "strong", news.trueAtCreation ? Msg.of("engine.report.verify.title_true") : Msg.of("engine.report.verify.title_false"),
                        news.trueAtCreation ? Msg.of("engine.report.verify.text_true", "news", newsText(news))
                            : Msg.of("engine.report.verify.text_false", "news", newsText(news), "author", name(news.author)),
                        news.trueAtCreation ? "info" : "warn", now);
                }
                case DEBUNK -> {
                    News news = news(order.newsId).orElseThrow();
                    if (caught(order.city, player, news.author)) {
                        continue;
                    }
                    news.debunked = true;
                    addPop(news.city, news.target, -news.effect);
                    addPop(news.city, news.author, -Rules.DEBUNK_PENALTY);
                    addPop(news.city, player, Rules.DEBUNK_REWARD_POP);
                    ps.gold = r1(ps.gold + Rules.DEBUNK_REWARD_GOLD); ps.legit += Rules.DEBUNK_REWARD_LEGIT;
                    publicReport("spy", title("debunk", "author", name(news.author)),
                        text("debunk", "news", newsText(news), "author", name(news.author), "penalty", fmt(Rules.DEBUNK_PENALTY), "house", name(player),
                            "gold", Rules.DEBUNK_REWARD_GOLD, "legit", Rules.DEBUNK_REWARD_LEGIT), "ok");
                }
            }
        }
        if (ps.npc && ps.nextPlanAt == 0) {
            ps.nextPlanAt = now + (30 + rng.nextInt(210)) * 60_000L;
        }
        // Intel on an executed sheet is worthless, its offers expire (7.5)
        Set<String> dead = state.intel.stream().filter(intel -> intel.sheetId.equals(sheet.id)).map(intel -> intel.id).collect(Collectors.toSet());
        state.offers.removeIf(order -> dead.contains(order.intelId));
    }

    private void buyout(Sheet sheet, Order order, CitySt cs, Good good) {
        String player = sheet.player;
        long now = state.clock;
        // The defensive purchase works if it already ran, or if it is sealed and maturing (5.4: it may redeem during the offer's maturation)
        boolean done = state.events.stream().anyMatch(event -> "defend".equals(event.type) && sheet.id.equals(event.sheetId) && order.id.equals(event.orderId));
        boolean sealed = state.sheetOf(order.target).map(targetSheet -> targetSheet.orders.stream().anyMatch(queued -> "defend".equals(queued.type) && order.id.equals(queued.orderId))).orElse(false);
        if (sealed && !done) {
            MarketEvent used = new MarketEvent();
            used.type = "defendUsed"; used.sheetId = sheet.id; used.orderId = order.id; used.by = order.target; used.city = order.city; used.good = order.good; used.settlement = state.settlements;
            state.events.add(used);
        }
        if (done || sealed) {
            state.players.get(player).gold = r1(state.players.get(player).gold + order.gold);
            report(player, "faction", null, title("buyout_failed"), text("buyout_failed", "target", name(order.target)), "warn", now);
            report(order.target, "faction", null, title("buyout_defended"), text("buyout_defended", "house", name(player)), "ok", now);
            return;
        }
        int left = good.shares.get(order.target) - order.pts;
        if (left <= 0) { good.shares.remove(order.target); good.margins.remove(order.target); } else {
            good.shares.put(order.target, left);
        }
        good.shares.merge(player, order.pts, Integer::sum); good.margins.putIfAbsent(player, Margin.MARKET.id);
        PlayerSt tp = state.players.get(order.target);
        tp.gold = r1(tp.gold + order.gold);
        state.protection.put(order.city + "|" + order.good + "|" + order.target, state.settlements + Rules.BUYOUT_PROTECTION);
        MarketEvent buyoutEvent = new MarketEvent();
        buyoutEvent.type = "buyout"; buyoutEvent.city = order.city; buyoutEvent.good = order.good; buyoutEvent.by = player; buyoutEvent.target = order.target;
        buyoutEvent.settlement = state.settlements;
        state.events.add(buyoutEvent);
        report(player, "faction", null, title("buyout_done", "target", name(order.target)),
            text("buyout_done", "pts", order.pts, "good", goodLower(order.good), "gold", order.gold, "target", name(order.target), "turns", Rules.BUYOUT_PROTECTION), "ok", now);
        report(order.target, "faction", null, title("bought_out", "house", name(player)),
            text("bought_out", "pts", order.pts, "good", goodLower(order.good), "city", cityName(order.city), "gold", order.gold), "danger", now);
    }

    private void spy(String player, Order order, CitySt cs) {
        long now = state.clock;
        if (caught(order.city, player, order.target)) {
            return;
        }
        Sheet target = state.sheetOf(order.target).orElse(null);
        if (target == null) {
            report(player, "spy", null, title("spy_nothing"), text("spy_nothing", "target", name(order.target)), "warn", now);
            return;
        }
        int free = Math.min(3, cs.spies.getOrDefault(player, 0) - cs.guards.getOrDefault(player, 0));
        // Only orders issued in that city are visible (7.2); a route belongs to its target city
        List<Order> seen = target.orders.stream().filter(queued -> order.city.equals(queued.city) || ("route".equals(queued.type) && order.city.equals(queued.to)))
            .map(Order::copy).collect(Collectors.toCollection(ArrayList::new));
        if (seen.isEmpty()) {
            report(player, "spy", null, title("spy_nothing_here", "target", name(order.target)),
                text("spy_nothing_here", "city", cityName(order.city), "time", Time.fmt(target.executeAt)), "info", now);
            return;
        }
        Intel it = new Intel();
        it.id = state.nextId("i"); it.owner = player; it.sheetId = target.id; it.of = order.target; it.executeAt = target.executeAt;
        it.orders = seen; it.depth = free;
        if (!npc(player)) {
            state.intel.add(0, it);
        }
        report(player, "spy", depthConfidence(free), title("plans", "house", name(order.target), "time", Time.fmt(target.executeAt)),
            text("plans", "lines", Msg.join(" · ", intelLines(it))), "info", now);
    }

    /** Counter-espionage (7.4): each of the victim's guards catches the spy with 25% chance (at most 75%). */
    private boolean caught(String city, String attacker, String victim) {
        CitySt cs = state.cities.get(city);
        int guards = cs.guards.getOrDefault(victim, 0);
        if (guards == 0 || rng.nextDouble() >= Math.min(Rules.GUARD_MAX, guards * Rules.GUARD_CHANCE)) {
            return false;
        }
        int left = cs.spies.getOrDefault(attacker, 0) - 1;
        if (left <= 0) {
            cs.spies.remove(attacker);
        } else {
            cs.spies.put(attacker, left);
        }
        if (cs.guards.getOrDefault(attacker, 0) > Math.max(0, left)) {
            cs.guards.put(attacker, Math.max(0, left));
        }
        addPop(city, attacker, -Rules.CAUGHT_POP);
        report(attacker, "spy", null, title("spy_caught"), text("spy_caught", "house", name(victim), "city", cityName(city), "pop", fmt(Rules.CAUGHT_POP)),
            "danger", state.clock);
        report(victim, "spy", "strong", title("spy_captured", "house", name(attacker)), text("spy_captured", "city", cityName(city)), "ok", state.clock);
        return true;
    }

    static String fmt(double value) { return value == Math.rint(value) ? String.valueOf((long) value) : String.valueOf(r1(value)).replace('.', ','); }

    // ---------- Settlement (3.2) ----------

    private static final class Seller {
        final String player; final double cap, margin, pop; double weight, sold;
        Seller(String player, double cap, double margin, double pop) { this.player = player; this.cap = cap; this.margin = margin; this.pop = pop; }
    }

    /** The demand of a good split among its sellers (5.3), the City included; the state is not changed. */
    private List<Seller> sell(String city, Good good) {
        List<Seller> sellers = new ArrayList<>();
        good.shares.forEach((player, pts) -> {
            if (pts > 0) {
                sellers.add(new Seller(player, good.supply * pts / 100.0, Margin.of(good.margins.get(player)).rate, popOf(city, player)));
            }
        });
        int cityPts = cityShare(good);
        if (cityPts > 0) {
            sellers.add(new Seller(CITY, good.supply * cityPts / 100.0, Rules.CITY_MARGIN, Rules.CITY_POP));
        }
        sellers.forEach(seller -> seller.weight = seller.cap * (1 + seller.pop / 100) / (1 + seller.margin));
        double rem = good.demand;
        List<Seller> active = new ArrayList<>(sellers.stream().filter(seller -> seller.cap > 0).toList());
        for (int round = 0; round < 10 && rem > 1e-6 && !active.isEmpty(); round++) {
            double totalWeight = active.stream().mapToDouble(seller -> seller.weight).sum(), left = 0;
            for (Seller seller : active) {
                double want = rem * seller.weight / totalWeight, give = Math.min(want, seller.cap - seller.sold);
                seller.sold += give;
                left += want - give;
            }
            rem = left;
            active.removeIf(seller -> seller.cap - seller.sold <= 1e-6);
        }
        return sellers;
    }

    /**
     * A player's expected gold from selling in a city at the next settlement, from the current state: the sales profit
     * after the city's tax (5.3, 6.2). Null if the player holds no shares there.
     */
    public Double expectedIncome(String city, String player) {
        CitySt cs = state.cities.get(city);
        if (cs == null || cs.goods.values().stream().noneMatch(good -> good.shares.getOrDefault(player, 0) > 0)) {
            return null;
        }
        double profit = 0;
        for (Good good : cs.goods.values()) {
            for (Seller seller : sell(city, good)) {
                if (seller.player.equals(player)) {
                    profit += seller.sold * Rules.BASE_PRICE * seller.margin;
                }
            }
        }
        int totalSeats = cs.council.values().stream().mapToInt(Integer::intValue).sum();
        return r1(profit * (totalSeats > 0 ? 1 - taxRate(city) : 1));
    }

    void settle() {
        Map<String, double[]> inc = new LinkedHashMap<>(); // player → [gold, legit]
        state.players.keySet().forEach(player -> inc.put(player, new double[2]));
        for (var ce : state.cities.entrySet()) {
            String city = ce.getKey();
            CitySt cs = ce.getValue();
            Map<String, Double> profits = new LinkedHashMap<>();
            // 5.3 Demand and sales
            for (Good good : cs.goods.values()) {
                List<Seller> sellers = sell(city, good);
                good.sold.clear();
                double totalProfit = 0; int totalPts = 0;
                for (Seller seller : sellers) {
                    good.sold.put(seller.player, r1(seller.sold));
                    if (seller.player.equals(CITY)) {
                        continue;
                    }
                    double profit = seller.sold * Rules.BASE_PRICE * seller.margin;
                    profits.merge(seller.player, profit, Double::sum);
                    addPop(city, seller.player, Margin.of(good.margins.get(seller.player)).pop);
                    totalProfit += profit; totalPts += good.shares.get(seller.player);
                }
                good.history.add(totalPts > 0 ? totalProfit / totalPts : Rules.MARKET_VALUE_DEFAULT_PROFIT);
                while (good.history.size() > 3) {
                    good.history.remove(0);
                }
                List<Seller> players = sellers.stream().filter(seller -> !seller.player.equals(CITY)).toList();
                // Cheapest seller bonus; nobody on a tie (5.2)
                if (players.size() > 1) {
                    double min = players.stream().mapToDouble(seller -> seller.margin).min().orElse(0);
                    List<Seller> cheapest = players.stream().filter(seller -> seller.margin == min).toList();
                    if (cheapest.size() == 1) {
                        addPop(city, cheapest.get(0).player, 1);
                    }
                }
                // Legitimacy: the good's top seller (8.)
                players.stream().max(Comparator.comparingDouble(seller -> seller.sold))
                    .filter(seller -> seller.sold > 0).ifPresent(seller -> inc.get(seller.player)[1] += Rules.TOP_SELLER_LEGIT);
            }
            // 6.2 Tax: merchants pay, council parties receive
            double rate = taxRate(city), base = profits.values().stream().mapToDouble(Double::doubleValue).sum(), pool = base * rate;
            int totalSeats = cs.council.values().stream().mapToInt(Integer::intValue).sum();
            profits.forEach((player, profit) -> inc.get(player)[0] += profit * (totalSeats > 0 ? 1 - rate : 1));
            if (totalSeats > 0) {
                cs.council.forEach((player, seats) -> {
                    if (inc.containsKey(player)) {
                        inc.get(player)[0] += pool * seats / totalSeats;
                    }
                });
            }
            cs.lastTaxPool = totalSeats > 0 ? r1(pool) : null;
            // Effect of programs on popularity
            cs.parties.forEach((player, prog) -> addPop(city, player, Program.of(prog).pop));
            // Legitimacy: seats, majority, most popular
            cs.council.forEach((player, seats) -> {
                if (!inc.containsKey(player) || seats <= 0) {
                    return;
                }
                inc.get(player)[1] += seats * Rules.SEAT_LEGIT + (seats >= Rules.MAJORITY_SEATS ? Rules.MAJORITY_LEGIT : 0);
            });
            List<Map.Entry<String, Double>> popTop = cs.pop.entrySet().stream().sorted(Map.Entry.<String, Double>comparingByValue().reversed()).toList();
            if (!popTop.isEmpty() && (popTop.size() == 1 || popTop.get(0).getValue() > popTop.get(1).getValue()) && inc.containsKey(popTop.get(0).getKey())) {
                inc.get(popTop.get(0).getKey())[1] += Rules.MOST_POPULAR_LEGIT;
            }
            // Spy upkeep
            cs.spies.forEach((player, spies) -> {
                if (inc.containsKey(player)) {
                    inc.get(player)[0] -= spies * Rules.SPY_UPKEEP;
                }
            });
            // Drift back to the base value
            cs.pop.replaceAll((player, pop) -> r1(pop > Rules.POP_BASE ? Math.max(Rules.POP_BASE, pop - Rules.POP_DRIFT) : Math.min(Rules.POP_BASE, pop + Rules.POP_DRIFT)));
        }
        // Route upkeep, income, PP
        state.players.forEach((player, ps) -> {
            if (!ps.npc) {
                inc.get(player)[0] -= state.routesOf(player).size() * Rules.ROUTE_UPKEEP;
            }
        });
        state.settlements += 1;
        state.players.forEach((player, ps) -> {
            double[] income = inc.get(player);
            ps.gold = Math.max(0, r1(ps.gold + income[0]));
            ps.legit += (int) income[1];
            ps.pp = Math.min(Rules.PP_MAX, ps.pp + Rules.PP_PER_SETTLEMENT);
            report(player, "event", null, title("settlement", "time", Time.fmt(state.clock)),
                text("settlement", "income", (income[0] >= 0 ? "+" : "") + fmt(r1(income[0])), "legit", (int) income[1], "pp", Rules.PP_PER_SETTLEMENT), "info", state.clock);
        });
        state.events.removeIf(event -> state.settlements - event.settlement > 10);
        if (state.news.size() > 60) {
            state.news.subList(60, state.news.size()).clear();
        }
        if (state.settlements % Rules.ELECTION_EVERY == 0) {
            elections();
        }
    }

    // ---------- Election (6.3), D'Hondt ----------

    public static Map<String, Integer> dhondt(Map<String, Double> votes, int seats, double threshold) {
        double total = votes.values().stream().mapToDouble(Double::doubleValue).sum();
        List<Map.Entry<String, Double>> ok = votes.entrySet().stream().filter(entry -> total > 0 && entry.getValue() / total >= threshold).toList();
        Map<String, Integer> out = new LinkedHashMap<>();
        ok.forEach(entry -> out.put(entry.getKey(), 0));
        for (int seat = 0; seat < seats && !ok.isEmpty(); seat++) {
            Map.Entry<String, Double> best = ok.stream().max(Comparator.comparingDouble(entry -> entry.getValue() / (out.get(entry.getKey()) + 1))).orElseThrow();
            out.merge(best.getKey(), 1, Integer::sum);
        }
        out.values().removeIf(count -> count == 0);
        return out;
    }

    private void elections() {
        for (var ce : state.cities.entrySet()) {
            String city = ce.getKey();
            CitySt cs = ce.getValue();
            if (cs.parties.isEmpty()) {
                continue;
            }
            Map<String, Double> votes = new LinkedHashMap<>();
            cs.parties.keySet().forEach(player -> votes.put(player, popOf(city, player)));
            Map<String, Integer> before = new LinkedHashMap<>(cs.council);
            cs.council = dhondt(votes, Rules.COUNCIL_SEATS, Rules.ELECTION_THRESHOLD);
            List<Msg.Join> seats = cs.council.entrySet().stream().sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .map(entry -> Msg.join(" ", List.of(name(entry.getKey()), entry.getValue()))).toList();
            publicReport("diplomacy", title("election", "city", cityName(city)),
                text("election", "council", seats.isEmpty() ? Msg.of("engine.report.election.nobody") : Msg.join(", ", seats)), "info");
            for (String player : cs.parties.keySet()) {
                int now = cs.council.getOrDefault(player, 0), was = before.getOrDefault(player, 0);
                if (now == was) {
                    continue;
                }
                report(player, "diplomacy", null, title("seats", "delta", now > was ? "+" + (now - was) : "−" + (was - now), "city", cityName(city)),
                    now > 0 ? text("seats", "seats", now) : Msg.of("engine.report.seats.text_lost"), now > was ? "ok" : "warn", state.clock);
            }
        }
    }

    /** Coronation Council at season end (8.): each city council votes for the house with most seats, +10 L per vote. */
    public void coronation() {
        List<Msg.Join> votes = new ArrayList<>();
        for (var ce : state.cities.entrySet()) {
            List<Map.Entry<String, Integer>> rk = ce.getValue().council.entrySet().stream().sorted(Map.Entry.<String, Integer>comparingByValue().reversed()).toList();
            if (rk.isEmpty() || (rk.size() > 1 && rk.get(0).getValue().equals(rk.get(1).getValue()))) {
                continue;
            }
            String winner = rk.get(0).getKey();
            state.players.get(winner).legit += Rules.CORONATION_LEGIT;
            votes.add(Msg.join(": ", List.of(cityName(ce.getKey()), name(winner))));
        }
        publicReport("event", title("coronation"),
            votes.isEmpty() ? Msg.of("engine.report.coronation.text_none") : text("coronation", "legit", Rules.CORONATION_LEGIT, "votes", Msg.join(", ", votes)), "info");
    }

    // ---------- NPC houses ----------

    /** At start and after each settlement every NPC seals at some point in the next 6 hours. */
    public void scheduleNpcs() {
        for (PlayerSt house : state.players.values()) {
            if (house.npc && house.nextPlanAt == 0 && state.sheetOf(house.id).isEmpty()) {
                house.nextPlanAt = state.clock + rng.nextInt(360) * 60_000L;
            }
        }
    }

    private void npcPlanFor(PlayerSt house, int maturationMin) {
        List<String> humans = state.players.values().stream().filter(ps -> !ps.npc).map(ps -> ps.id).toList();
        List<String> cities = new ArrayList<>(state.cities.keySet());
        {
            if (state.sheetOf(house.id).isPresent()) {
                return;
            }
            List<Order> orders = new ArrayList<>();
            int[] pp = { house.pp };
            double[] gold = { house.gold };
            java.util.function.Consumer<Order> push = order -> {
                if (validate(house.id, order) != null) {
                    return;
                }
                if (order.type.equals("defend")) { Order bo = buyoutAgainst(house.id, order.sheetId, order.orderId).orElseThrow(); order.good = bo.good; order.pts = bo.pts; }
                Cost cost = cost(house.id, order);
                if (cost.pp() > pp[0] || cost.gold() > gold[0]) {
                    return;
                }
                pp[0] -= cost.pp(); gold[0] -= cost.gold();
                order.id = state.nextId("o"); order.gold = cost.gold();
                orders.add(order);
            };
            Collections.shuffle(cities, new Random(rng.nextLong()));
            String human = humans.isEmpty() ? null : humans.get(rng.nextInt(humans.size()));
            // Defence: every persona redeems a buyout against it if it can afford to
            for (Sheet sheet : state.sheets) {
                for (Order bo : sheet.orders) {
                    if ("buyout".equals(bo.type) && house.id.equals(bo.target)) {
                        push.accept(order("defend", bo.city, draft -> {
                            draft.sheetId = sheet.id;
                            draft.orderId = bo.id;
                        }));
                    }
                }
            }
            switch (house.persona == null ? "" : house.persona) {
                case "trader" -> {
                    for (String city : cities) {
                        for (var ge : state.cities.get(city).goods.entrySet()) {
                            Good good = ge.getValue();
                            if (good.shares.containsKey(house.id)) {
                                if (popOf(city, house.id) < 15 && !"cheap".equals(good.margins.get(house.id))) {
                                    push.accept(order("margin", city, draft -> {
                                        draft.good = ge.getKey();
                                        draft.level = "cheap";
                                    }));
                                } else if (popOf(city, house.id) > 30 && !"expensive".equals(good.margins.get(house.id))) {
                                    push.accept(order("margin", city, draft -> {
                                        draft.good = ge.getKey();
                                        draft.level = "expensive";
                                    }));
                                }
                            }
                            if (cityShare(good) >= 5 && rng.nextDouble() < 0.3) {
                                push.accept(order("buyShares", city, draft -> {
                                    draft.good = ge.getKey();
                                    draft.pts = 5;
                                }));
                            }
                        }
                    }
                }
                case "raider" -> {
                    boolean recent = state.events.stream().anyMatch(event -> "buyout".equals(event.type) && house.id.equals(event.by) && state.settlements - event.settlement < 3);
                    if (!recent && human != null) {
                        for (String city : cities) {
                            for (var ge : state.cities.get(city).goods.entrySet()) {
                                int theirs = ge.getValue().shares.getOrDefault(human, 0);
                                if (theirs >= 5 && rng.nextDouble() < 0.35 && orders.stream().noneMatch(queued -> queued.type.equals("buyout"))) {
                                    push.accept(order("buyout", city, draft -> {
                                        draft.good = ge.getKey();
                                        draft.target = human;
                                        draft.pts = Math.min(5, theirs);
                                    }));
                                }
                            }
                        }
                    }
                    String c0 = cities.get(0);
                    push.accept(order("buyShares", c0, draft -> { draft.good = state.cities.get(c0).goods.keySet().iterator().next(); draft.pts = 5; }));
                }
                case "politician" -> {
                    for (String city : cities) {
                        CitySt cs = state.cities.get(city);
                        if (!cs.parties.containsKey(house.id) && gold[0] > 60) {
                            push.accept(order("foundParty", city, draft -> {
                            }));
                        }
                        if (cs.parties.containsKey(house.id) && (isCampaign() || rng.nextDouble() < 0.3)) {
                            push.accept(order("festival", city, draft -> {
                            }));
                        }
                        if (human != null && cs.parties.containsKey(human) && rng.nextDouble() < 0.4) {
                            push.accept(order("news", city, draft -> {
                                draft.target = human;
                                draft.template = "taxHike";
                            }));
                        }
                    }
                }
                case "spymaster" -> {
                    for (String city : cities) {
                        CitySt cs = state.cities.get(city);
                        if (cs.spies.getOrDefault(house.id, 0) < 2 && rng.nextDouble() < 0.4) {
                            push.accept(order("hireSpy", city, draft -> {
                            }));
                        }
                        if (human != null && state.sheetOf(human).isPresent() && cs.spies.getOrDefault(house.id, 0) > 0) {
                            push.accept(order("spy", city, draft -> draft.target = human));
                        }
                        if (human != null && rng.nextDouble() < 0.35) {
                            cs.goods.entrySet().stream().filter(ge -> ge.getValue().shares.containsKey(human)).findFirst()
                                .ifPresent(ge -> push.accept(order("news", city, draft -> { draft.target = human; draft.template = "usury"; draft.good = ge.getKey(); })));
                        }
                    }
                }
                default -> {}
            }
            if (orders.isEmpty()) {
                return;
            }
            Cost total = new Cost(0, 0);
            for (Order order : orders) {
                total = total.plus(new Cost(Action.of(order.type).pp, order.gold));
            }
            pushSheet(house.id, orders, state.clock, state.clock + maturationMin * 60_000L, total, () -> {});
        }
    }

    private static Order order(String type, String city, java.util.function.Consumer<Order> fill) {
        Order order = new Order();
        order.type = type; order.city = city;
        fill.accept(order);
        return order;
    }
}
