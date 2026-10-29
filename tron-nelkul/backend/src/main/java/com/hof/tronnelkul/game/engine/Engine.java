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
        public Cost plus(Cost o) { return new Cost(pp + o.pp, gold + o.gold); }
    }

    public static final String CITY = "_city";

    public final MapDefinition map;
    public final EngineState s;
    public final List<ReportOut> out = new ArrayList<>();
    private final RandomGenerator rng;

    public Engine(MapDefinition map, EngineState s, long seed) {
        this.map = map; this.s = s; this.rng = new SplittableRandom(seed);
    }

    static double r1(double v) { return Math.round(v * 10) / 10.0; }

    /** A house's name (stored text), or a Msg for an unknown house. */
    public Object name(String p) {
        PlayerSt ps = s.players.get(p);
        return ps == null ? Msg.of("engine.unknown_house") : ps.name;
    }

    /** Name of a city or estate node (Msg). */
    public Object cityName(String id) { return map.nodeName(id); }

    public CitySt city(String id) {
        CitySt c = s.cities.get(id);
        if (c == null) throw new EngineException(err("unknown_city"));
        return c;
    }

    private static Msg err(String id, Object... kv) { return Msg.of("engine.error." + id, kv); }

    private static Msg title(String id, Object... kv) { return Msg.of("engine.report." + id + ".title", kv); }

    private static Msg text(String id, Object... kv) { return Msg.of("engine.report." + id + ".text", kv); }

    /** Good name inside a sentence (lowercase). */
    private static Msg goodLower(String good) { return GoodDef.label(good).lower(); }

    private boolean npc(String p) { PlayerSt ps = s.players.get(p); return ps != null && ps.npc; }

    // ---------- Network (chapter 4) ----------

    /** Nodes reachable from the estate via own routes, with their distance. NPC networks are unrestricted. */
    public Map<String, Integer> network(String p) {
        PlayerSt ps = s.players.get(p);
        Map<String, Integer> dist = new LinkedHashMap<>();
        if (ps == null) return dist;
        if (ps.npc) { for (CityDef c : map.cities()) dist.put(c.id(), 1); return dist; }
        if (ps.estate == null) return dist;
        dist.put(ps.estate, 0);
        Deque<String> q = new ArrayDeque<>(List.of(ps.estate));
        List<Edge> own = s.routesOf(p);
        while (!q.isEmpty()) {
            String n = q.poll();
            for (Edge e : own) {
                if (!e.touches(n)) continue;
                String m = e.other(n);
                if (!dist.containsKey(m)) { dist.put(m, dist.get(n) + 1); q.add(m); }
            }
        }
        return dist;
    }

    public boolean reaches(String p, String node) { return network(p).containsKey(node); }

    public boolean hasRoute(String p, String a, String b) { return s.routesOf(p).stream().anyMatch(e -> e.same(a, b)); }

    // ---------- Helpers ----------

    public double popOf(String city, String p) { return s.cities.get(city).pop.getOrDefault(p, Rules.POP_BASE); }

    /** Popularity change, clamped to 0–100; above 60 a positive effect is worth half (4.5). */
    public void addPop(String city, String p, double delta) {
        double cur = popOf(city, p), d = delta;
        if (d > 0 && cur >= Rules.POP_SOFT_CAP) d /= 2;
        s.cities.get(city).pop.put(p, Math.max(0, Math.min(100, r1(cur + d))));
    }

    public static int cityShare(Good g) { return Math.max(0, 100 - g.shares.values().stream().mapToInt(Integer::intValue).sum()); }

    /** Market value of a point: average profit per point over the last 3 settlements × 10 (5.4). */
    public static double marketValue(Good g) {
        List<Double> h = g.history.subList(Math.max(0, g.history.size() - 3), g.history.size());
        double avg = h.isEmpty() ? Rules.MARKET_VALUE_DEFAULT_PROFIT : h.stream().mapToDouble(Double::doubleValue).average().orElse(0);
        return Math.max(Rules.MARKET_VALUE_MIN, r1(avg * 10));
    }

    /** Seat-weighted average of the council parties' program rates; 20% without a council (6.2). */
    public double taxRate(String city) {
        CitySt c = s.cities.get(city);
        int total = c.council.values().stream().mapToInt(Integer::intValue).sum();
        if (total == 0) return Rules.DEFAULT_TAX;
        double sum = 0;
        for (var e : c.council.entrySet()) sum += Program.of(c.parties.get(e.getKey())).rate * e.getValue();
        return sum / total;
    }

    /** The next settlement is an election: festival effect and price are doubled (6.3). */
    public boolean isCampaign() { return (s.settlements + 1) % Rules.ELECTION_EVERY == 0; }

    public int nextElectionIn() { return Rules.ELECTION_EVERY - (s.settlements % Rules.ELECTION_EVERY); }

    public boolean newsTruth(String city, String template, String target, String good) {
        CitySt c = s.cities.get(city);
        return switch (NewsTemplate.of(template)) {
            case USURY -> {
                Good g = good == null ? null : c.goods.get(good);
                String m = g == null || !g.shares.containsKey(target) ? null : g.margins.get(target);
                yield Margin.EXPENSIVE.id.equals(m) || Margin.USURY.id.equals(m);
            }
            case BOUGHT_OUT -> s.events.stream().anyMatch(e -> "buyout".equals(e.type) && target.equals(e.by) && city.equals(e.city)
                && s.settlements - e.settlement <= Rules.NEWS_TRUTH_WINDOW);
            case TAX_HIKE -> Program.HIGH.id.equals(c.parties.get(target));
            case SPIES -> c.spies.getOrDefault(target, 0) > 0;
            case FRIEND -> {
                double avg = c.pop.values().stream().mapToDouble(Double::doubleValue).average().orElse(Rules.POP_BASE);
                yield popOf(city, target) > avg;
            }
        };
    }

    /** The news text: the template with {t} = target house and {g} = good (lowercase). */
    public Msg newsText(String template, String target, String good) {
        return Msg.of(NewsTemplate.of(template).labelKey(), "t", name(target), "g", good == null ? "" : goodLower(good));
    }

    public Msg newsText(News n) { return newsText(n.template, n.target, n.good); }

    public Optional<News> news(String id) { return s.news.stream().filter(n -> n.id.equals(id)).findFirst(); }

    public Optional<Sheet> sheet(String id) { return s.sheets.stream().filter(l -> l.id.equals(id)).findFirst(); }

    /** A buyout order of the sheet that targets p. */
    public Optional<Order> buyoutAgainst(String p, String sheetId, String orderId) {
        return sheet(sheetId).flatMap(l -> l.orders.stream()
            .filter(o -> o.id.equals(orderId) && "buyout".equals(o.type) && p.equals(o.target)).findFirst());
    }

    public boolean isProtected(String city, String good, String p) {
        return s.protection.getOrDefault(city + "|" + good + "|" + p, -1) > s.settlements;
    }

    // ---------- Cost ----------

    public Cost cost(String p, Order o) {
        Action a = Action.of(o.type);
        double gold = a.gold == null ? 0 : a.gold;
        CitySt c = o.city == null ? null : s.cities.get(o.city);
        Good g = c == null || o.good == null ? null : c.goods.get(o.good);
        switch (a) {
            case BUY_SHARES -> gold = Rules.CITY_SHARE_COST * o.pts;
            case BUYOUT -> gold = g == null ? 0 : Math.ceil(marketValue(g) * o.pts * Rules.BUYOUT_PREMIUM);
            case DEFEND -> {
                Order bo = buyoutAgainst(p, o.sheetId, o.orderId).orElse(null);
                Good bg = bo == null ? null : c.goods.get(bo.good);
                gold = bg == null ? 0 : Math.ceil(marketValue(bg) * bo.pts);
            }
            case FESTIVAL -> { if (isCampaign()) gold *= 2; }
            default -> {}
        }
        // Below 20 popularity the gold cost of city actions is +50% (4.5)
        if (c != null && gold > 0 && popOf(o.city, p) < Rules.LOW_POP) gold = Math.ceil(gold * Rules.LOW_POP_MULTIPLIER);
        return new Cost(a.pp, (int) Math.round(gold));
    }

    public Cost draftCost(String p) {
        Cost c = new Cost(0, 0);
        for (Order o : s.draftOf(p)) c = c.plus(new Cost(Action.of(o.type).pp, o.gold));
        return c;
    }

    /** The order's description. depth: 1 type only, 2 with target, 3 with cost too (scouting accuracy, 7.2). */
    public Msg orderLabel(Order o, int depth) {
        Action a = Action.of(o.type);
        if (depth <= 1) return a.label();
        Object c = o.city == null ? "" : cityName(o.city);
        Good g = o.city == null || o.good == null ? null : s.cities.get(o.city).goods.get(o.good);
        String good = g == null ? null : o.good;
        Object gn = good == null ? "" : GoodDef.label(good);
        Msg txt = switch (a) {
            case ROUTE -> Msg.of("engine.order.route", "action", a.label(), "from", map.nodeName(o.from), "to", map.nodeName(o.to));
            case MARGIN -> Msg.of("engine.order.margin", "good", gn, "level", Margin.of(o.level).label(), "city", c);
            case BUY_SHARES -> Msg.of("engine.order.buyShares", "pts", o.pts, "good", gn, "city", c);
            case BUYOUT -> Msg.of("engine.order.buyout", "pts", o.pts, "target", name(o.target), "good", gn, "city", c);
            case DEFEND -> Msg.of("engine.order.defend", "good", gn, "city", c);
            case PROGRAM -> Msg.of("engine.order.program", "program", Program.of(o.level).label(), "city", c);
            case NEWS -> Msg.of("engine.order.news", "news", newsText(o.template, o.target, good), "city", c);
            case SPY -> Msg.of("engine.order.spy", "target", name(o.target), "city", c);
            case MOVE_SPY -> Msg.of("engine.order.moveSpy", "from", c, "to", cityName(o.to));
            default -> Msg.of("engine.order.other", "action", a.label(), "city", c);
        };
        return depth >= 3 ? Msg.of("engine.order.with_cost", "order", txt, "gold", o.gold) : txt;
    }

    /** The scouted orders of an intel at its depth. */
    public List<Msg> intelLines(Intel it) { return it.orders.stream().map(x -> orderLabel(x, it.depth)).toList(); }

    // ---------- Validity ----------

    /** null if the order can run now; otherwise the reason. */
    public Msg validate(String p, Order o) {
        Action a;
        try { a = Action.of(o.type); } catch (EngineException e) { return e.msg(); }
        if (a == Action.ROUTE) {
            if (o.from == null || o.to == null || !map.hasEdge(o.from, o.to)) return err("no_road");
            if (!map.isCity(o.to)) return err("route_city_only");
            if (!reaches(p, o.from)) return err("route_from_network");
            if (hasRoute(p, o.from, o.to)) return err("route_owned");
            return null;
        }
        if (o.city == null || !s.cities.containsKey(o.city)) return err("unknown_city");
        if (!reaches(p, o.city)) return err("city_not_in_network");
        CitySt cs = s.cities.get(o.city);
        Good g = o.good == null ? null : cs.goods.get(o.good);
        int spies = cs.spies.getOrDefault(p, 0), free = spies - cs.guards.getOrDefault(p, 0);
        switch (a) {
            case MARGIN -> {
                if (g == null) return err("unknown_good");
                if (g.shares.getOrDefault(p, 0) <= 0) return err("needs_shares");
                if (!Margin.valid(o.level)) return err("unknown_margin");
            }
            case BUY_SHARES -> {
                if (g == null) return err("unknown_good");
                if (o.pts < 1 || o.pts > Rules.MAX_SHARES_PER_ORDER) return err("shares_per_order", "max", Rules.MAX_SHARES_PER_ORDER);
                if (cityShare(g) < o.pts) return err("city_shares_left", "pts", cityShare(g));
            }
            case BUYOUT -> {
                if (g == null) return err("unknown_good");
                if (o.target == null || o.target.equals(p)) return err("pick_rival");
                if (o.pts < 1 || o.pts > Rules.MAX_SHARES_PER_ORDER) return err("buyout_per_order", "max", Rules.MAX_SHARES_PER_ORDER);
                if (g.shares.getOrDefault(o.target, 0) < o.pts) return err("target_lacks_shares");
                if (isProtected(o.city, o.good, o.target)) return err("target_protected");
            }
            case DEFEND -> {
                Optional<Order> bo = buyoutAgainst(p, o.sheetId, o.orderId);
                if (bo.isEmpty()) return err("buyout_already_ran");
                if (!o.city.equals(bo.get().city)) return err("defend_wrong_city");
            }
            case FOUND_PARTY -> { if (cs.parties.containsKey(p)) return err("party_exists"); }
            case PROGRAM -> {
                if (!cs.parties.containsKey(p)) return err("needs_party");
                if (!Program.valid(o.level)) return err("unknown_program");
            }
            case FESTIVAL -> { if (!cs.parties.containsKey(p)) return err("needs_party"); }
            case NEWS -> {
                NewsTemplate t;
                try { t = NewsTemplate.of(o.template); } catch (EngineException e) { return e.msg(); }
                if (o.target == null || !s.players.containsKey(o.target) || o.target.equals(p)) return err("pick_target");
                if (t.needsGood && g == null) return err("pick_good");
            }
            case HIRE_SPY -> { if (spies >= Rules.SPIES_PER_CITY) return err("spy_limit", "max", Rules.SPIES_PER_CITY); }
            case GUARD -> { if (free < 1) return err("no_free_spy"); }
            case MOVE_SPY -> {
                if (free < 1) return err("no_free_spy");
                if (o.to == null || !s.cities.containsKey(o.to) || o.to.equals(o.city)) return err("pick_target_city");
                if (!reaches(p, o.to)) return err("spy_move_network");
                if (s.cities.get(o.to).spies.getOrDefault(p, 0) >= Rules.SPIES_PER_CITY) return err("spy_limit_there", "max", Rules.SPIES_PER_CITY);
            }
            case SPY -> {
                if (free < 1) return err("needs_free_spy");
                if (o.target == null || o.target.equals(p) || !s.players.containsKey(o.target)) return err("pick_target");
            }
            case VERIFY, DEBUNK -> {
                if (spies < 1) return err("needs_spy");
                News n = news(o.newsId).orElse(null);
                if (n == null || !n.city.equals(o.city) || n.debunked) return err("no_such_news");
                if (n.author.equals(p)) return err("own_news");
                if (a == Action.DEBUNK && !Boolean.FALSE.equals(s.players.get(p).verified.get(n.id))) return err("verify_first");
            }
            default -> {}
        }
        return null;
    }

    // ---------- Player operations ----------

    public Order addDraft(String p, Order o) {
        Msg invalid = validate(p, o);
        if (invalid != null) throw new EngineException(invalid);
        if (o.type.equals("defend")) {
            Order bo = buyoutAgainst(p, o.sheetId, o.orderId).orElseThrow();
            o.good = bo.good; o.pts = bo.pts;
            if (s.draftOf(p).stream().anyMatch(x -> "defend".equals(x.type) && o.orderId.equals(x.orderId)))
                throw new EngineException(err("defend_on_draft"));
        }
        Cost c = draftCost(p), add = cost(p, o);
        PlayerSt ps = s.players.get(p);
        if (c.pp() + add.pp() > ps.pp) throw new EngineException(err("not_enough_pp", "need", c.pp() + add.pp(), "have", ps.pp));
        if (c.gold() + add.gold() > ps.gold) throw new EngineException(err("not_enough_gold", "need", c.gold() + add.gold(), "have", (int) ps.gold));
        o.id = s.nextId("o");
        o.gold = add.gold();
        s.draftOf(p).add(o);
        return o;
    }

    public void removeDraft(String p, String orderId) {
        if (!s.draftOf(p).removeIf(o -> o.id.equals(orderId))) throw new EngineException(err("no_such_draft_order"));
    }

    /** Sealing: the cost is reserved, the sheet runs `maturationMin` minutes later (3.1). */
    public Sheet seal(String p, long now, int maturationMin) {
        List<Order> draft = s.draftOf(p);
        if (draft.isEmpty()) throw new EngineException(err("empty_sheet"));
        if (s.sheetOf(p).isPresent()) throw new EngineException(err("sheet_maturing"));
        Cost c = draftCost(p);
        PlayerSt ps = s.players.get(p);
        if (c.pp() > ps.pp) throw new EngineException(err("not_enough_pp", "need", c.pp(), "have", ps.pp));
        if (c.gold() > ps.gold) throw new EngineException(err("not_enough_gold", "need", c.gold(), "have", (int) ps.gold));
        return pushSheet(p, new ArrayList<>(draft), now, now + maturationMin * 60_000L, c, draft::clear);
    }

    private Sheet pushSheet(String p, List<Order> orders, long sealedAt, long executeAt, Cost c, Runnable after) {
        PlayerSt ps = s.players.get(p);
        ps.pp -= c.pp(); ps.gold = r1(ps.gold - c.gold());
        Sheet sheet = new Sheet();
        sheet.id = s.nextId("L"); sheet.player = p; sheet.orders = orders; sheet.sealedAt = sealedAt; sheet.executeAt = executeAt;
        sheet.pp = c.pp(); sheet.gold = c.gold();
        s.sheets.add(sheet);
        after.run();
        // The buyout offer is public to its target (5.4)
        for (Order o : orders) {
            if (!"buyout".equals(o.type)) continue;
            report(o.target, "faction", null, title("buyout_threat", "house", name(p)),
                text("buyout_threat", "pts", o.pts, "good", goodLower(o.good), "city", cityName(o.city), "time", Time.fmt(executeAt)), "danger", sealedAt);
        }
        return sheet;
    }

    // ---------- Information market (7.5) ----------

    public void offerIntel(String seller, String intelId, String buyer, int price) {
        Intel it = s.intel.stream().filter(x -> x.id.equals(intelId) && x.owner.equals(seller)).findFirst()
            .orElseThrow(() -> new EngineException(err("no_such_intel")));
        if (sheet(it.sheetId).isEmpty()) throw new EngineException(err("intel_expired"));
        if (buyer == null || !s.players.containsKey(buyer) || buyer.equals(seller)) throw new EngineException(err("pick_buyer"));
        if (buyer.equals(it.of)) throw new EngineException(err("own_plans"));
        if (it.offeredTo.contains(buyer)) throw new EngineException(err("already_offered"));
        if (price < 1 || price > 500) throw new EngineException(err("price_range", "min", 1, "max", 500));
        it.offeredTo.add(buyer);
        PlayerSt b = s.players.get(buyer);
        if (b.npc) {
            // NPCs decide at once: they buy cheap, fresh information.
            if (price <= Rules.INFO_PRICE * 1.5 && b.gold >= price) completeSale(it, seller, buyer, price);
            else report(seller, "spy", null, title("intel_rejected", "house", name(buyer)), text("intel_rejected", "price", price), "warn", s.clock);
            return;
        }
        Offer o = new Offer();
        o.id = s.nextId("f"); o.intelId = it.id; o.seller = seller; o.buyer = buyer; o.price = price;
        s.offers.add(o);
        report(buyer, "spy", null, title("intel_offer", "house", name(seller)), text("intel_offer", "of", name(it.of), "price", price), "info", s.clock);
    }

    public void acceptOffer(String buyer, String offerId) {
        Offer o = offer(buyer, offerId);
        Intel it = s.intel.stream().filter(x -> x.id.equals(o.intelId)).findFirst().orElse(null);
        if (it == null || sheet(it.sheetId).isEmpty()) { s.offers.remove(o); throw new EngineException(err("offer_expired")); }
        if (s.players.get(buyer).gold < o.price) throw new EngineException(err("not_enough_gold_offer", "need", o.price));
        s.offers.remove(o);
        completeSale(it, o.seller, buyer, o.price);
    }

    public void declineOffer(String buyer, String offerId) {
        Offer o = offer(buyer, offerId);
        s.offers.remove(o);
        report(o.seller, "spy", null, title("intel_declined", "house", name(buyer)), text("intel_declined"), "warn", s.clock);
    }

    private Offer offer(String buyer, String offerId) {
        return s.offers.stream().filter(x -> x.id.equals(offerId) && x.buyer.equals(buyer)).findFirst()
            .orElseThrow(() -> new EngineException(err("no_such_offer")));
    }

    private void completeSale(Intel it, String seller, String buyer, int price) {
        PlayerSt sp = s.players.get(seller), bp = s.players.get(buyer);
        bp.gold = r1(bp.gold - price); sp.gold = r1(sp.gold + price);
        Intel copy = new Intel();
        copy.id = s.nextId("i"); copy.owner = buyer; copy.sheetId = it.sheetId; copy.of = it.of; copy.executeAt = it.executeAt;
        copy.orders = it.orders.stream().map(Order::copy).collect(Collectors.toCollection(ArrayList::new)); copy.depth = it.depth; copy.bought = true;
        if (!bp.npc) s.intel.add(copy);
        Object bonus = "";
        if (s.settlements - sp.lastInfoSale >= Rules.INFO_LEGIT_EVERY) {
            sp.legit += Rules.INFO_LEGIT; sp.lastInfoSale = s.settlements; bonus = Msg.of("engine.report.intel_sold.bonus", "legit", Rules.INFO_LEGIT);
        }
        report(seller, "spy", null, title("intel_sold", "house", name(buyer)),
            text("intel_sold", "buyer", name(buyer), "price", price, "of", name(it.of), "bonus", bonus), "ok", s.clock);
        report(buyer, "spy", depthConfidence(it.depth), title("plans", "house", name(it.of), "time", Time.fmt(it.executeAt)),
            text("intel_bought", "lines", Msg.join(" · ", intelLines(it)), "price", price, "seller", name(seller)), "info", s.clock);
    }

    // ---------- Time (3.1–3.2) ----------

    /**
     * Runs the maturing sheets and settlements due until `until`, in time order.
     * Stops after the season's last (maxSettlements-th) settlement.
     */
    public void advance(long until, int maturationMin, int maxSettlements) {
        for (int guard = 0; guard < 1000 && s.settlements < maxSettlements; guard++) {
            long nextSheet = s.sheets.stream().mapToLong(l -> l.executeAt).min().orElse(Long.MAX_VALUE);
            long nextSet = Time.nextSettlement(s.clock);
            PlayerSt nextNpc = s.players.values().stream().filter(x -> x.npc && x.nextPlanAt > 0).min(Comparator.comparingLong(x -> x.nextPlanAt)).orElse(null);
            long npcAt = nextNpc == null ? Long.MAX_VALUE : Math.max(nextNpc.nextPlanAt, s.clock);
            long t = Math.min(Math.min(nextSheet, nextSet), npcAt);
            if (t > until) break;
            s.clock = t;
            if (npcAt == t && npcAt < nextSheet && npcAt < nextSet) {
                // NPCs may seal at any time, with the same maturation time (3.1)
                nextNpc.nextPlanAt = 0;
                npcPlanFor(nextNpc, maturationMin);
            } else if (nextSheet <= nextSet) {
                // For simultaneous sheets the sealing order decides (3.1)
                Sheet sheet = s.sheets.stream().filter(l -> l.executeAt == t).min(Comparator.comparingLong((Sheet l) -> l.sealedAt).thenComparing(l -> l.id)).orElseThrow();
                s.sheets.remove(sheet);
                executeSheet(sheet);
            } else {
                settle();
                if (s.settlements >= maxSettlements) return;
                scheduleNpcs();
            }
        }
        s.clock = Math.max(s.clock, until);
    }

    /** For development: immediate settlement instead of 8:00 / 20:00 (scheduled settlements still run). */
    public void settleNow(int maturationMin) {
        settle();
        scheduleNpcs();
    }

    /** Time of the next event (sheet or settlement). */
    public long nextEventAt() {
        long nextSheet = s.sheets.stream().mapToLong(l -> l.executeAt).min().orElse(Long.MAX_VALUE);
        return Math.min(nextSheet, Time.nextSettlement(s.clock));
    }

    void report(String player, String kind, String confidence, Msg title, Msg text, String tone, long at) {
        if (player == null || npc(player) || !s.players.containsKey(player)) return;
        out.add(new ReportOut(player, false, at, kind, confidence, title, text, tone));
    }

    void publicReport(String kind, Msg title, Msg text, String tone) {
        out.add(new ReportOut(null, true, s.clock, kind, null, title, text, tone));
    }

    private static String depthConfidence(int depth) { return depth >= 3 ? "strong" : depth >= 2 ? "medium" : "weak"; }

    // ---------- Executing a sheet ----------

    private void executeSheet(Sheet sheet) {
        String p = sheet.player;
        PlayerSt ps = s.players.get(p);
        if (ps == null) return;
        long t = s.clock;
        for (Order o : sheet.orders) {
            if ("defend".equals(o.type) && s.events.stream().anyMatch(e -> "defendUsed".equals(e.type) && o.orderId.equals(e.orderId))) {
                report(p, "faction", null, title("defend_used"), text("defend_used"), "info", t);
                continue;
            }
            Msg invalid = validate(p, o);
            if (invalid != null) {
                ps.gold = r1(ps.gold + o.gold); // gold is refunded, PP is not
                report(p, "faction", null, title("order_failed", "action", Action.of(o.type).label()), text("order_failed", "reason", invalid), "warn", t);
                continue;
            }
            CitySt cs = o.city == null ? null : s.cities.get(o.city);
            Good g = cs == null || o.good == null ? null : cs.goods.get(o.good);
            Object cn = o.city == null ? "" : cityName(o.city);
            switch (Action.of(o.type)) {
                case ROUTE -> {
                    s.routesOf(p).add(new Edge(o.from, o.to));
                    report(p, "diplomacy", null, title("route", "city", cityName(o.to)), text("route", "city", cityName(o.to)), "ok", t);
                }
                case MARGIN -> {
                    g.margins.put(p, o.level);
                    report(p, "faction", null, title("margin", "good", GoodDef.label(o.good), "level", Margin.of(o.level).label()), text("margin", "city", cn), "info", t);
                }
                case BUY_SHARES -> {
                    g.shares.merge(p, o.pts, Integer::sum); g.margins.putIfAbsent(p, Margin.MARKET.id);
                    report(p, "faction", null, title("buyShares", "pts", o.pts, "good", GoodDef.label(o.good)),
                        text("buyShares", "city", cn, "good", goodLower(o.good), "share", g.shares.get(p)), "ok", t);
                }
                case BUYOUT -> buyout(sheet, o, cs, g);
                case DEFEND -> {
                    MarketEvent e = new MarketEvent();
                    e.type = "defend"; e.sheetId = o.sheetId; e.orderId = o.orderId; e.by = p; e.city = o.city; e.good = o.good; e.settlement = s.settlements;
                    s.events.add(e);
                    report(p, "faction", null, title("defend", "good", GoodDef.label(o.good)), text("defend"), "info", t);
                }
                case FOUND_PARTY -> {
                    cs.parties.put(p, Program.MEDIUM.id);
                    report(p, "diplomacy", null, title("foundParty", "city", cn), text("foundParty"), "ok", t);
                }
                case PROGRAM -> {
                    cs.parties.put(p, o.level);
                    report(p, "diplomacy", null, title("program", "program", Program.of(o.level).label()), text("program", "city", cn), "info", t);
                }
                case FESTIVAL -> {
                    String key = o.city + "|" + p;
                    boolean recent = s.festivals.containsKey(key) && s.settlements - s.festivals.get(key) < Rules.FESTIVAL_COOLDOWN;
                    double gain = (recent ? Rules.FESTIVAL_POP / 2 : Rules.FESTIVAL_POP) * (isCampaign() ? 2 : 1);
                    addPop(o.city, p, gain);
                    s.festivals.put(key, s.settlements);
                    report(p, "event", null, title("festival", "gain", fmt(gain)),
                        recent ? Msg.of("engine.report.festival.text_recent") : text("festival"), "ok", t);
                }
                case NEWS -> {
                    News n = new News();
                    n.id = s.nextId("n"); n.city = o.city; n.author = p; n.target = o.target; n.template = o.template;
                    n.good = NewsTemplate.of(o.template).needsGood ? o.good : null;
                    n.effect = NewsTemplate.of(o.template).effect; n.createdAt = t;
                    n.trueAtCreation = newsTruth(o.city, n.template, n.target, n.good);
                    addPop(o.city, n.target, n.effect);
                    s.news.add(0, n);
                    publicReport("faction", title("news", "city", cn), newsText(n), n.effect < 0 ? "warn" : "ok");
                }
                case HIRE_SPY -> {
                    cs.spies.merge(p, 1, Integer::sum);
                    report(p, "spy", null, title("hireSpy", "city", cn), text("hireSpy", "spies", cs.spies.get(p)), "ok", t);
                }
                case GUARD -> {
                    cs.guards.merge(p, 1, Integer::sum);
                    report(p, "spy", null, title("guard"), text("guard", "city", cn, "guards", cs.guards.get(p)), "info", t);
                }
                case SPY -> spy(p, o, cs);
                case MOVE_SPY -> {
                    int left = cs.spies.get(p) - 1;
                    if (left <= 0) cs.spies.remove(p); else cs.spies.put(p, left);
                    s.cities.get(o.to).spies.merge(p, 1, Integer::sum);
                    report(p, "spy", null, title("moveSpy", "to", cityName(o.to)), text("moveSpy", "from", cn, "to", cityName(o.to)), "info", t);
                }
                case VERIFY -> {
                    News n = news(o.newsId).orElseThrow();
                    if (caught(o.city, p, n.author)) continue;
                    ps.verified.put(n.id, n.trueAtCreation);
                    report(p, "spy", "strong", n.trueAtCreation ? Msg.of("engine.report.verify.title_true") : Msg.of("engine.report.verify.title_false"),
                        n.trueAtCreation ? Msg.of("engine.report.verify.text_true", "news", newsText(n))
                            : Msg.of("engine.report.verify.text_false", "news", newsText(n), "author", name(n.author)),
                        n.trueAtCreation ? "info" : "warn", t);
                }
                case DEBUNK -> {
                    News n = news(o.newsId).orElseThrow();
                    if (caught(o.city, p, n.author)) continue;
                    n.debunked = true;
                    addPop(n.city, n.target, -n.effect);
                    addPop(n.city, n.author, -Rules.DEBUNK_PENALTY);
                    addPop(n.city, p, Rules.DEBUNK_REWARD_POP);
                    ps.gold = r1(ps.gold + Rules.DEBUNK_REWARD_GOLD); ps.legit += Rules.DEBUNK_REWARD_LEGIT;
                    publicReport("spy", title("debunk", "author", name(n.author)),
                        text("debunk", "news", newsText(n), "author", name(n.author), "penalty", fmt(Rules.DEBUNK_PENALTY), "house", name(p),
                            "gold", Rules.DEBUNK_REWARD_GOLD, "legit", Rules.DEBUNK_REWARD_LEGIT), "ok");
                }
            }
        }
        if (ps.npc && ps.nextPlanAt == 0) ps.nextPlanAt = t + (30 + rng.nextInt(210)) * 60_000L;
        // Intel on an executed sheet is worthless, its offers expire (7.5)
        Set<String> dead = s.intel.stream().filter(i -> i.sheetId.equals(sheet.id)).map(i -> i.id).collect(Collectors.toSet());
        s.offers.removeIf(o -> dead.contains(o.intelId));
    }

    private void buyout(Sheet sheet, Order o, CitySt cs, Good g) {
        String p = sheet.player;
        long t = s.clock;
        // The defensive purchase works if it already ran, or if it is sealed and maturing (5.4: it may redeem during the offer's maturation)
        boolean done = s.events.stream().anyMatch(e -> "defend".equals(e.type) && sheet.id.equals(e.sheetId) && o.id.equals(e.orderId));
        boolean sealed = s.sheetOf(o.target).map(l -> l.orders.stream().anyMatch(x -> "defend".equals(x.type) && o.id.equals(x.orderId))).orElse(false);
        if (sealed && !done) {
            MarketEvent used = new MarketEvent();
            used.type = "defendUsed"; used.sheetId = sheet.id; used.orderId = o.id; used.by = o.target; used.city = o.city; used.good = o.good; used.settlement = s.settlements;
            s.events.add(used);
        }
        if (done || sealed) {
            s.players.get(p).gold = r1(s.players.get(p).gold + o.gold);
            report(p, "faction", null, title("buyout_failed"), text("buyout_failed", "target", name(o.target)), "warn", t);
            report(o.target, "faction", null, title("buyout_defended"), text("buyout_defended", "house", name(p)), "ok", t);
            return;
        }
        int left = g.shares.get(o.target) - o.pts;
        if (left <= 0) { g.shares.remove(o.target); g.margins.remove(o.target); } else g.shares.put(o.target, left);
        g.shares.merge(p, o.pts, Integer::sum); g.margins.putIfAbsent(p, Margin.MARKET.id);
        PlayerSt tp = s.players.get(o.target);
        tp.gold = r1(tp.gold + o.gold);
        s.protection.put(o.city + "|" + o.good + "|" + o.target, s.settlements + Rules.BUYOUT_PROTECTION);
        MarketEvent e = new MarketEvent();
        e.type = "buyout"; e.city = o.city; e.good = o.good; e.by = p; e.target = o.target; e.settlement = s.settlements;
        s.events.add(e);
        report(p, "faction", null, title("buyout_done", "target", name(o.target)),
            text("buyout_done", "pts", o.pts, "good", goodLower(o.good), "gold", o.gold, "target", name(o.target), "turns", Rules.BUYOUT_PROTECTION), "ok", t);
        report(o.target, "faction", null, title("bought_out", "house", name(p)),
            text("bought_out", "pts", o.pts, "good", goodLower(o.good), "city", cityName(o.city), "gold", o.gold), "danger", t);
    }

    private void spy(String p, Order o, CitySt cs) {
        long t = s.clock;
        if (caught(o.city, p, o.target)) return;
        Sheet target = s.sheetOf(o.target).orElse(null);
        if (target == null) {
            report(p, "spy", null, title("spy_nothing"), text("spy_nothing", "target", name(o.target)), "warn", t);
            return;
        }
        int free = Math.min(3, cs.spies.getOrDefault(p, 0) - cs.guards.getOrDefault(p, 0));
        // Only orders issued in that city are visible (7.2); a route belongs to its target city
        List<Order> seen = target.orders.stream().filter(x -> o.city.equals(x.city) || ("route".equals(x.type) && o.city.equals(x.to)))
            .map(Order::copy).collect(Collectors.toCollection(ArrayList::new));
        if (seen.isEmpty()) {
            report(p, "spy", null, title("spy_nothing_here", "target", name(o.target)),
                text("spy_nothing_here", "city", cityName(o.city), "time", Time.fmt(target.executeAt)), "info", t);
            return;
        }
        Intel it = new Intel();
        it.id = s.nextId("i"); it.owner = p; it.sheetId = target.id; it.of = o.target; it.executeAt = target.executeAt;
        it.orders = seen; it.depth = free;
        if (!npc(p)) s.intel.add(0, it);
        report(p, "spy", depthConfidence(free), title("plans", "house", name(o.target), "time", Time.fmt(target.executeAt)),
            text("plans", "lines", Msg.join(" · ", intelLines(it))), "info", t);
    }

    /** Counter-espionage (7.4): each of the victim's guards catches the spy with 25% chance (at most 75%). */
    private boolean caught(String city, String attacker, String victim) {
        CitySt cs = s.cities.get(city);
        int guards = cs.guards.getOrDefault(victim, 0);
        if (guards == 0 || rng.nextDouble() >= Math.min(Rules.GUARD_MAX, guards * Rules.GUARD_CHANCE)) return false;
        int left = cs.spies.getOrDefault(attacker, 0) - 1;
        if (left <= 0) cs.spies.remove(attacker); else cs.spies.put(attacker, left);
        if (cs.guards.getOrDefault(attacker, 0) > Math.max(0, left)) cs.guards.put(attacker, Math.max(0, left));
        addPop(city, attacker, -Rules.CAUGHT_POP);
        report(attacker, "spy", null, title("spy_caught"), text("spy_caught", "house", name(victim), "city", cityName(city), "pop", fmt(Rules.CAUGHT_POP)),
            "danger", s.clock);
        report(victim, "spy", "strong", title("spy_captured", "house", name(attacker)), text("spy_captured", "city", cityName(city)), "ok", s.clock);
        return true;
    }

    static String fmt(double v) { return v == Math.rint(v) ? String.valueOf((long) v) : String.valueOf(r1(v)).replace('.', ','); }

    // ---------- Settlement (3.2) ----------

    private static final class Seller {
        final String p; final double cap, m, pop; double w, sold;
        Seller(String p, double cap, double m, double pop) { this.p = p; this.cap = cap; this.m = m; this.pop = pop; }
    }

    void settle() {
        Map<String, double[]> inc = new LinkedHashMap<>(); // player → [gold, legit]
        s.players.keySet().forEach(p -> inc.put(p, new double[2]));
        for (var ce : s.cities.entrySet()) {
            String city = ce.getKey();
            CitySt cs = ce.getValue();
            Map<String, Double> profits = new LinkedHashMap<>();
            // 5.3 Demand and sales
            for (Good g : cs.goods.values()) {
                List<Seller> sellers = new ArrayList<>();
                g.shares.forEach((p, v) -> { if (v > 0) sellers.add(new Seller(p, g.supply * v / 100.0, Margin.of(g.margins.get(p)).rate, popOf(city, p))); });
                int cityPts = cityShare(g);
                if (cityPts > 0) sellers.add(new Seller(CITY, g.supply * cityPts / 100.0, Rules.CITY_MARGIN, Rules.CITY_POP));
                sellers.forEach(x -> x.w = x.cap * (1 + x.pop / 100) / (1 + x.m));
                double rem = g.demand;
                List<Seller> active = new ArrayList<>(sellers.stream().filter(x -> x.cap > 0).toList());
                for (int k = 0; k < 10 && rem > 1e-6 && !active.isEmpty(); k++) {
                    double W = active.stream().mapToDouble(x -> x.w).sum(), left = 0;
                    for (Seller x : active) { double want = rem * x.w / W, give = Math.min(want, x.cap - x.sold); x.sold += give; left += want - give; }
                    rem = left;
                    active.removeIf(x -> x.cap - x.sold <= 1e-6);
                }
                g.sold.clear();
                double totalProfit = 0; int totalPts = 0;
                for (Seller x : sellers) {
                    g.sold.put(x.p, r1(x.sold));
                    if (x.p.equals(CITY)) continue;
                    double profit = x.sold * Rules.BASE_PRICE * x.m;
                    profits.merge(x.p, profit, Double::sum);
                    addPop(city, x.p, Margin.of(g.margins.get(x.p)).pop);
                    totalProfit += profit; totalPts += g.shares.get(x.p);
                }
                g.history.add(totalPts > 0 ? totalProfit / totalPts : Rules.MARKET_VALUE_DEFAULT_PROFIT);
                while (g.history.size() > 3) g.history.remove(0);
                List<Seller> players = sellers.stream().filter(x -> !x.p.equals(CITY)).toList();
                // Cheapest seller bonus; nobody on a tie (5.2)
                if (players.size() > 1) {
                    double min = players.stream().mapToDouble(x -> x.m).min().orElse(0);
                    List<Seller> cheapest = players.stream().filter(x -> x.m == min).toList();
                    if (cheapest.size() == 1) addPop(city, cheapest.get(0).p, 1);
                }
                // Legitimacy: the good's top seller (8.)
                players.stream().max(Comparator.comparingDouble(x -> x.sold))
                    .filter(x -> x.sold > 0).ifPresent(x -> inc.get(x.p)[1] += Rules.TOP_SELLER_LEGIT);
            }
            // 6.2 Tax: merchants pay, council parties receive
            double rate = taxRate(city), base = profits.values().stream().mapToDouble(Double::doubleValue).sum(), pool = base * rate;
            int totalSeats = cs.council.values().stream().mapToInt(Integer::intValue).sum();
            profits.forEach((p, v) -> inc.get(p)[0] += v * (totalSeats > 0 ? 1 - rate : 1));
            if (totalSeats > 0) cs.council.forEach((p, v) -> { if (inc.containsKey(p)) inc.get(p)[0] += pool * v / totalSeats; });
            cs.lastTaxPool = totalSeats > 0 ? r1(pool) : null;
            // Effect of programs on popularity
            cs.parties.forEach((p, prog) -> addPop(city, p, Program.of(prog).pop));
            // Legitimacy: seats, majority, most popular
            cs.council.forEach((p, v) -> {
                if (!inc.containsKey(p) || v <= 0) return;
                inc.get(p)[1] += v * Rules.SEAT_LEGIT + (v >= Rules.MAJORITY_SEATS ? Rules.MAJORITY_LEGIT : 0);
            });
            List<Map.Entry<String, Double>> popTop = cs.pop.entrySet().stream().sorted(Map.Entry.<String, Double>comparingByValue().reversed()).toList();
            if (!popTop.isEmpty() && (popTop.size() == 1 || popTop.get(0).getValue() > popTop.get(1).getValue()) && inc.containsKey(popTop.get(0).getKey()))
                inc.get(popTop.get(0).getKey())[1] += Rules.MOST_POPULAR_LEGIT;
            // Spy upkeep
            cs.spies.forEach((p, n) -> { if (inc.containsKey(p)) inc.get(p)[0] -= n * Rules.SPY_UPKEEP; });
            // Drift back to the base value
            cs.pop.replaceAll((p, v) -> r1(v > Rules.POP_BASE ? Math.max(Rules.POP_BASE, v - Rules.POP_DRIFT) : Math.min(Rules.POP_BASE, v + Rules.POP_DRIFT)));
        }
        // Route upkeep, income, PP
        s.players.forEach((p, ps) -> { if (!ps.npc) inc.get(p)[0] -= s.routesOf(p).size() * Rules.ROUTE_UPKEEP; });
        s.settlements += 1;
        s.players.forEach((p, ps) -> {
            double[] v = inc.get(p);
            ps.gold = Math.max(0, r1(ps.gold + v[0]));
            ps.legit += (int) v[1];
            ps.pp = Math.min(Rules.PP_MAX, ps.pp + Rules.PP_PER_SETTLEMENT);
            report(p, "event", null, title("settlement", "time", Time.fmt(s.clock)),
                text("settlement", "income", (v[0] >= 0 ? "+" : "") + fmt(r1(v[0])), "legit", (int) v[1], "pp", Rules.PP_PER_SETTLEMENT), "info", s.clock);
        });
        s.events.removeIf(e -> s.settlements - e.settlement > 10);
        if (s.news.size() > 60) s.news.subList(60, s.news.size()).clear();
        if (s.settlements % Rules.ELECTION_EVERY == 0) elections();
    }

    // ---------- Election (6.3), D'Hondt ----------

    public static Map<String, Integer> dhondt(Map<String, Double> votes, int seats, double threshold) {
        double total = votes.values().stream().mapToDouble(Double::doubleValue).sum();
        List<Map.Entry<String, Double>> ok = votes.entrySet().stream().filter(e -> total > 0 && e.getValue() / total >= threshold).toList();
        Map<String, Integer> out = new LinkedHashMap<>();
        ok.forEach(e -> out.put(e.getKey(), 0));
        for (int i = 0; i < seats && !ok.isEmpty(); i++) {
            Map.Entry<String, Double> best = ok.stream().max(Comparator.comparingDouble(e -> e.getValue() / (out.get(e.getKey()) + 1))).orElseThrow();
            out.merge(best.getKey(), 1, Integer::sum);
        }
        out.values().removeIf(v -> v == 0);
        return out;
    }

    private void elections() {
        for (var ce : s.cities.entrySet()) {
            String city = ce.getKey();
            CitySt cs = ce.getValue();
            if (cs.parties.isEmpty()) continue;
            Map<String, Double> votes = new LinkedHashMap<>();
            cs.parties.keySet().forEach(p -> votes.put(p, popOf(city, p)));
            Map<String, Integer> before = new LinkedHashMap<>(cs.council);
            cs.council = dhondt(votes, Rules.COUNCIL_SEATS, Rules.ELECTION_THRESHOLD);
            List<Msg.Join> seats = cs.council.entrySet().stream().sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .map(e -> Msg.join(" ", List.of(name(e.getKey()), e.getValue()))).toList();
            publicReport("diplomacy", title("election", "city", cityName(city)),
                text("election", "council", seats.isEmpty() ? Msg.of("engine.report.election.nobody") : Msg.join(", ", seats)), "info");
            for (String p : cs.parties.keySet()) {
                int now = cs.council.getOrDefault(p, 0), was = before.getOrDefault(p, 0);
                if (now == was) continue;
                report(p, "diplomacy", null, title("seats", "delta", now > was ? "+" + (now - was) : "−" + (was - now), "city", cityName(city)),
                    now > 0 ? text("seats", "seats", now) : Msg.of("engine.report.seats.text_lost"), now > was ? "ok" : "warn", s.clock);
            }
        }
    }

    /** Coronation Council at season end (8.): each city council votes for the house with most seats, +10 L per vote. */
    public void coronation() {
        List<Msg.Join> votes = new ArrayList<>();
        for (var ce : s.cities.entrySet()) {
            List<Map.Entry<String, Integer>> rk = ce.getValue().council.entrySet().stream().sorted(Map.Entry.<String, Integer>comparingByValue().reversed()).toList();
            if (rk.isEmpty() || (rk.size() > 1 && rk.get(0).getValue().equals(rk.get(1).getValue()))) continue;
            String p = rk.get(0).getKey();
            s.players.get(p).legit += Rules.CORONATION_LEGIT;
            votes.add(Msg.join(": ", List.of(cityName(ce.getKey()), name(p))));
        }
        publicReport("event", title("coronation"),
            votes.isEmpty() ? Msg.of("engine.report.coronation.text_none") : text("coronation", "legit", Rules.CORONATION_LEGIT, "votes", Msg.join(", ", votes)), "info");
    }

    // ---------- NPC houses ----------

    /** At start and after each settlement every NPC seals at some point in the next 6 hours. */
    public void scheduleNpcs() {
        for (PlayerSt h : s.players.values())
            if (h.npc && h.nextPlanAt == 0 && s.sheetOf(h.id).isEmpty()) h.nextPlanAt = s.clock + rng.nextInt(360) * 60_000L;
    }

    private void npcPlanFor(PlayerSt h, int maturationMin) {
        List<String> humans = s.players.values().stream().filter(x -> !x.npc).map(x -> x.id).toList();
        List<String> cities = new ArrayList<>(s.cities.keySet());
        {
            if (s.sheetOf(h.id).isPresent()) return;
            List<Order> orders = new ArrayList<>();
            int[] pp = { h.pp };
            double[] gold = { h.gold };
            java.util.function.Consumer<Order> push = o -> {
                if (validate(h.id, o) != null) return;
                if (o.type.equals("defend")) { Order bo = buyoutAgainst(h.id, o.sheetId, o.orderId).orElseThrow(); o.good = bo.good; o.pts = bo.pts; }
                Cost c = cost(h.id, o);
                if (c.pp() > pp[0] || c.gold() > gold[0]) return;
                pp[0] -= c.pp(); gold[0] -= c.gold();
                o.id = s.nextId("o"); o.gold = c.gold();
                orders.add(o);
            };
            Collections.shuffle(cities, new Random(rng.nextLong()));
            String human = humans.isEmpty() ? null : humans.get(rng.nextInt(humans.size()));
            // Defence: every persona redeems a buyout against it if it can afford to
            for (Sheet l : s.sheets) for (Order bo : l.orders)
                if ("buyout".equals(bo.type) && h.id.equals(bo.target)) push.accept(order("defend", bo.city, x -> { x.sheetId = l.id; x.orderId = bo.id; }));
            switch (h.persona == null ? "" : h.persona) {
                case "trader" -> {
                    for (String c : cities) for (var ge : s.cities.get(c).goods.entrySet()) {
                        Good g = ge.getValue();
                        if (g.shares.containsKey(h.id)) {
                            if (popOf(c, h.id) < 15 && !"cheap".equals(g.margins.get(h.id))) push.accept(order("margin", c, x -> { x.good = ge.getKey(); x.level = "cheap"; }));
                            else if (popOf(c, h.id) > 30 && !"expensive".equals(g.margins.get(h.id))) push.accept(order("margin", c, x -> { x.good = ge.getKey(); x.level = "expensive"; }));
                        }
                        if (cityShare(g) >= 5 && rng.nextDouble() < 0.3) push.accept(order("buyShares", c, x -> { x.good = ge.getKey(); x.pts = 5; }));
                    }
                }
                case "raider" -> {
                    boolean recent = s.events.stream().anyMatch(e -> "buyout".equals(e.type) && h.id.equals(e.by) && s.settlements - e.settlement < 3);
                    if (!recent && human != null) for (String c : cities) for (var ge : s.cities.get(c).goods.entrySet()) {
                        int theirs = ge.getValue().shares.getOrDefault(human, 0);
                        if (theirs >= 5 && rng.nextDouble() < 0.35 && orders.stream().noneMatch(x -> x.type.equals("buyout")))
                            push.accept(order("buyout", c, x -> { x.good = ge.getKey(); x.target = human; x.pts = Math.min(5, theirs); }));
                    }
                    String c0 = cities.get(0);
                    push.accept(order("buyShares", c0, x -> { x.good = s.cities.get(c0).goods.keySet().iterator().next(); x.pts = 5; }));
                }
                case "politician" -> {
                    for (String c : cities) {
                        CitySt cs = s.cities.get(c);
                        if (!cs.parties.containsKey(h.id) && gold[0] > 60) push.accept(order("foundParty", c, x -> {}));
                        if (cs.parties.containsKey(h.id) && (isCampaign() || rng.nextDouble() < 0.3)) push.accept(order("festival", c, x -> {}));
                        if (human != null && cs.parties.containsKey(human) && rng.nextDouble() < 0.4)
                            push.accept(order("news", c, x -> { x.target = human; x.template = "taxHike"; }));
                    }
                }
                case "spymaster" -> {
                    for (String c : cities) {
                        CitySt cs = s.cities.get(c);
                        if (cs.spies.getOrDefault(h.id, 0) < 2 && rng.nextDouble() < 0.4) push.accept(order("hireSpy", c, x -> {}));
                        if (human != null && s.sheetOf(human).isPresent() && cs.spies.getOrDefault(h.id, 0) > 0)
                            push.accept(order("spy", c, x -> x.target = human));
                        if (human != null && rng.nextDouble() < 0.35) {
                            cs.goods.entrySet().stream().filter(ge -> ge.getValue().shares.containsKey(human)).findFirst()
                                .ifPresent(ge -> push.accept(order("news", c, x -> { x.target = human; x.template = "usury"; x.good = ge.getKey(); })));
                        }
                    }
                }
                default -> {}
            }
            if (orders.isEmpty()) return;
            Cost c = new Cost(0, 0);
            for (Order o : orders) c = c.plus(new Cost(Action.of(o.type).pp, o.gold));
            pushSheet(h.id, orders, s.clock, s.clock + maturationMin * 60_000L, c, () -> {});
        }
    }

    private static Order order(String type, String city, java.util.function.Consumer<Order> fill) {
        Order o = new Order();
        o.type = type; o.city = city;
        fill.accept(o);
        return o;
    }
}
