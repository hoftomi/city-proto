package com.hof.tronnelkul.game.engine;

import com.hof.tronnelkul.game.engine.EngineState.*;
import com.hof.tronnelkul.game.engine.Rules.*;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.world.MapDefinition;

import java.util.*;
import java.util.random.RandomGenerator;
import java.util.stream.Collectors;

/**
 * Szabálykönyv v0.2 szabálymotor: parancslapok érleléssel, elszámolás 8:00 / 20:00, választás, kémek, hírek,
 * információs piac. Egy példány egy betöltött állapoton dolgozik; a jelentéseket az `out` listába gyűjti.
 */
public final class Engine {
    public record Cost(int pp, int gold) {
        public Cost plus(Cost o) { return new Cost(pp + o.pp, gold + o.gold); }
    }

    public static final String CITY = "_varos";

    public final MapDefinition map;
    public final EngineState s;
    public final List<ReportOut> out = new ArrayList<>();
    private final RandomGenerator rng;

    public Engine(MapDefinition map, EngineState s, long seed) {
        this.map = map; this.s = s; this.rng = new SplittableRandom(seed);
    }

    static double r1(double v) { return Math.round(v * 10) / 10.0; }

    public String name(String p) {
        PlayerSt ps = s.players.get(p);
        return ps == null ? "Ismeretlen" : ps.name;
    }

    public String cityName(String id) { return map.nodeName(id); }

    public CitySt city(String id) {
        CitySt c = s.cities.get(id);
        if (c == null) throw new EngineException("Ismeretlen város.");
        return c;
    }

    private boolean npc(String p) { PlayerSt ps = s.players.get(p); return ps != null && ps.npc; }

    // ---------- Hálózat (4. fejezet) ----------

    /** A birtokból saját útvonalakon elérhető csomópontok és távolságuk. Az NPC-k hálózata nem korlátozott. */
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

    // ---------- Segédek ----------

    public double popOf(String city, String p) { return s.cities.get(city).pop.getOrDefault(p, Rules.POP_BASE); }

    /** Népszerűség változása 0 és 100 között; 60 fölött a pozitív hatás fele annyit ér (4.5). */
    public void addPop(String city, String p, double delta) {
        double cur = popOf(city, p), d = delta;
        if (d > 0 && cur >= Rules.POP_SOFT_CAP) d /= 2;
        s.cities.get(city).pop.put(p, Math.max(0, Math.min(100, r1(cur + d))));
    }

    public static int cityShare(Good g) { return Math.max(0, 100 - g.shares.values().stream().mapToInt(Integer::intValue).sum()); }

    /** Egy pont piaci értéke: az utolsó 3 elszámolás átlagos haszna pontonként × 10 (5.4). */
    public static double marketValue(Good g) {
        List<Double> h = g.history.subList(Math.max(0, g.history.size() - 3), g.history.size());
        double avg = h.isEmpty() ? Rules.MARKET_VALUE_DEFAULT_PROFIT : h.stream().mapToDouble(Double::doubleValue).average().orElse(0);
        return Math.max(Rules.MARKET_VALUE_MIN, r1(avg * 10));
    }

    /** A tanácsi pártok programkulcsának mandátummal súlyozott átlaga; tanács nélkül 20% (6.2). */
    public double taxRate(String city) {
        CitySt c = s.cities.get(city);
        int total = c.council.values().stream().mapToInt(Integer::intValue).sum();
        if (total == 0) return Rules.DEFAULT_TAX;
        double sum = 0;
        for (var e : c.council.entrySet()) sum += Program.of(c.parties.get(e.getKey())).rate * e.getValue();
        return sum / total;
    }

    /** A következő elszámolás választás: a fesztivál hatása és ára dupla (6.3). */
    public boolean isCampaign() { return (s.settlements + 1) % Rules.ELECTION_EVERY == 0; }

    public int nextElectionIn() { return Rules.ELECTION_EVERY - (s.settlements % Rules.ELECTION_EVERY); }

    public boolean newsTruth(String city, String template, String target, String good) {
        CitySt c = s.cities.get(city);
        return switch (NewsTemplate.of(template)) {
            case UZSORA -> {
                Good g = good == null ? null : c.goods.get(good);
                String m = g == null || !g.shares.containsKey(target) ? null : g.margins.get(target);
                yield "draga".equals(m) || "uzsora".equals(m);
            }
            case KIVASAROLT -> s.events.stream().anyMatch(e -> "buyout".equals(e.type) && target.equals(e.by) && city.equals(e.city)
                && s.settlements - e.settlement <= Rules.NEWS_TRUTH_WINDOW);
            case ADOEMELES -> "magas".equals(c.parties.get(target));
            case KEMEK -> c.spies.getOrDefault(target, 0) > 0;
            case BARAT -> {
                double avg = c.pop.values().stream().mapToDouble(Double::doubleValue).average().orElse(Rules.POP_BASE);
                yield popOf(city, target) > avg;
            }
        };
    }

    public String newsText(String template, String target, String goodName) {
        return NewsTemplate.of(template).label.replace("{t}", name(target)).replace("{g}", goodName == null ? "" : goodName.toLowerCase());
    }

    public String newsText(News n) { return newsText(n.template, n.target, n.goodName); }

    public Optional<News> news(String id) { return s.news.stream().filter(n -> n.id.equals(id)).findFirst(); }

    public Optional<Lap> lap(String id) { return s.laps.stream().filter(l -> l.id.equals(id)).findFirst(); }

    /** A lap egy kivásárlási parancsa, amely p ellen irányul. */
    public Optional<Order> buyoutAgainst(String p, String lapId, String orderId) {
        return lap(lapId).flatMap(l -> l.orders.stream()
            .filter(o -> o.id.equals(orderId) && "buyout".equals(o.type) && p.equals(o.target)).findFirst());
    }

    public boolean isProtected(String city, String good, String p) {
        return s.protection.getOrDefault(city + "|" + good + "|" + p, -1) > s.settlements;
    }

    // ---------- Költség ----------

    public Cost cost(String p, Order o) {
        Action a = Action.of(o.type);
        double gold = a.gold == null ? 0 : a.gold;
        CitySt c = o.city == null ? null : s.cities.get(o.city);
        Good g = c == null || o.good == null ? null : c.goods.get(o.good);
        switch (a) {
            case BUY_SHARES -> gold = Rules.CITY_SHARE_COST * o.pts;
            case BUYOUT -> gold = g == null ? 0 : Math.ceil(marketValue(g) * o.pts * Rules.BUYOUT_PREMIUM);
            case DEFEND -> {
                Order bo = buyoutAgainst(p, o.lapId, o.orderId).orElse(null);
                Good bg = bo == null ? null : c.goods.get(bo.good);
                gold = bg == null ? 0 : Math.ceil(marketValue(bg) * bo.pts);
            }
            case FESTIVAL -> { if (isCampaign()) gold *= 2; }
            default -> {}
        }
        // 20 népszerűség alatt a városi akciók aranyköltsége +50% (4.5)
        if (c != null && gold > 0 && popOf(o.city, p) < Rules.LOW_POP) gold = Math.ceil(gold * Rules.LOW_POP_MULTIPLIER);
        return new Cost(a.pp, (int) Math.round(gold));
    }

    public Cost draftCost(String p) {
        Cost c = new Cost(0, 0);
        for (Order o : s.draftOf(p)) c = c.plus(new Cost(Action.of(o.type).pp, o.gold));
        return c;
    }

    /** A parancs leírása. depth: 1 csak a típus, 2 célponttal, 3 költséggel is (a kifürkészés pontossága, 7.2). */
    public String orderLabel(Order o, int depth) {
        Action a = Action.of(o.type);
        if (depth <= 1) return a.label;
        String c = o.city == null ? "" : cityName(o.city);
        Good g = o.city == null || o.good == null ? null : s.cities.get(o.city).goods.get(o.good);
        String gn = g == null ? "" : g.name;
        String txt = switch (a) {
            case ROUTE -> a.label + ": " + map.nodeName(o.from) + " → " + map.nodeName(o.to);
            case MARGIN -> gn + " ára: " + Margin.of(o.level).label + " · " + c;
            case BUY_SHARES -> o.pts + " részesedés (" + gn + ") a Várostól · " + c;
            case BUYOUT -> "Kivásárlás: " + o.pts + " pont " + name(o.target) + " részéből (" + gn + ") · " + c;
            case DEFEND -> "Védekező vétel (" + gn + ") · " + c;
            case PROGRAM -> "Program: " + Program.of(o.level).label + " · " + c;
            case NEWS -> "Hír: " + newsText(o.template, o.target, gn) + " · " + c;
            case SPY -> "Kifürkészés: " + name(o.target) + " parancslapja · " + c;
            case MOVE_SPY -> "Kém áthelyezése: " + c + " → " + cityName(o.to);
            default -> a.label + " · " + c;
        };
        return depth >= 3 ? txt + " (" + o.gold + " A)" : txt;
    }

    // ---------- Érvényesség ----------

    /** null, ha a parancs most végrehajtható; különben a magyar nyelvű ok. */
    public String validate(String p, Order o) {
        Action a;
        try { a = Action.of(o.type); } catch (EngineException e) { return e.getMessage(); }
        if (a == Action.ROUTE) {
            if (o.from == null || o.to == null || !map.hasEdge(o.from, o.to)) return "Ezen a két helyen között nincs út.";
            if (!map.isCity(o.to)) return "Útvonal csak városállamba vezethet.";
            if (!reaches(p, o.from)) return "Útvonalat csak a hálózatodból indíthatsz.";
            if (hasRoute(p, o.from, o.to)) return "Ez az útvonal már a tiéd.";
            return null;
        }
        if (o.city == null || !s.cities.containsKey(o.city)) return "Ismeretlen város.";
        if (!reaches(p, o.city)) return "Akciót csak a hálózatodban lévő városban indíthatsz. Építs előbb útvonalat.";
        CitySt cs = s.cities.get(o.city);
        Good g = o.good == null ? null : cs.goods.get(o.good);
        int spies = cs.spies.getOrDefault(p, 0), free = spies - cs.guards.getOrDefault(p, 0);
        switch (a) {
            case MARGIN -> {
                if (g == null) return "Ismeretlen árucikk.";
                if (g.shares.getOrDefault(p, 0) <= 0) return "Ehhez részesedés kell ebből az árucikkből.";
                if (!Margin.valid(o.level)) return "Ismeretlen fokozat.";
            }
            case BUY_SHARES -> {
                if (g == null) return "Ismeretlen árucikk.";
                if (o.pts < 1 || o.pts > Rules.MAX_SHARES_PER_ORDER) return "Egy parancsban 1–" + Rules.MAX_SHARES_PER_ORDER + " pont vehető.";
                if (cityShare(g) < o.pts) return "A Várostól már csak " + cityShare(g) + " pont vehető.";
            }
            case BUYOUT -> {
                if (g == null) return "Ismeretlen árucikk.";
                if (o.target == null || o.target.equals(p)) return "Válassz rivális kereskedőt.";
                if (o.pts < 1 || o.pts > Rules.MAX_SHARES_PER_ORDER) return "Egy ajánlatban 1–" + Rules.MAX_SHARES_PER_ORDER + " pont vásárolható ki.";
                if (g.shares.getOrDefault(o.target, 0) < o.pts) return "A célpontnak nincs ennyi részesedése.";
                if (isProtected(o.city, o.good, o.target)) return "Ezt a kereskedőt nemrég kivásárolták, most védett.";
            }
            case DEFEND -> {
                Optional<Order> bo = buyoutAgainst(p, o.lapId, o.orderId);
                if (bo.isEmpty()) return "Ez a kivásárlási ajánlat már lefutott.";
                if (!o.city.equals(bo.get().city)) return "A védekező vételt abban a városban kell indítanod, ahol a kivásárlás fenyeget.";
            }
            case FOUND_PARTY -> { if (cs.parties.containsKey(p)) return "Ebben a városban már van pártod."; }
            case PROGRAM -> {
                if (!cs.parties.containsKey(p)) return "Ehhez párt kell ebben a városban.";
                if (!Program.valid(o.level)) return "Ismeretlen program.";
            }
            case FESTIVAL -> { if (!cs.parties.containsKey(p)) return "Ehhez párt kell ebben a városban."; }
            case NEWS -> {
                NewsTemplate t;
                try { t = NewsTemplate.of(o.template); } catch (EngineException e) { return e.getMessage(); }
                if (o.target == null || !s.players.containsKey(o.target) || o.target.equals(p)) return "Válassz célpontot.";
                if (t.needsGood && g == null) return "Válassz árucikket.";
            }
            case HIRE_SPY -> { if (spies >= Rules.SPIES_PER_CITY) return "Városonként legfeljebb " + Rules.SPIES_PER_CITY + " kémed lehet."; }
            case GUARD -> { if (free < 1) return "Nincs szabad kémed ebben a városban."; }
            case MOVE_SPY -> {
                if (free < 1) return "Nincs szabad kémed ebben a városban.";
                if (o.to == null || !s.cities.containsKey(o.to) || o.to.equals(o.city)) return "Válassz célvárost.";
                if (!reaches(p, o.to)) return "Kémet csak a hálózatodban lévő városba helyezhetsz át.";
                if (s.cities.get(o.to).spies.getOrDefault(p, 0) >= Rules.SPIES_PER_CITY) return "Ott már " + Rules.SPIES_PER_CITY + " kémed van.";
            }
            case SPY -> {
                if (free < 1) return "Ehhez legalább egy szabad kém kell a városban.";
                if (o.target == null || o.target.equals(p) || !s.players.containsKey(o.target)) return "Válassz célpontot.";
            }
            case VERIFY, DEBUNK -> {
                if (spies < 1) return "Ehhez kém kell a városban.";
                News n = news(o.newsId).orElse(null);
                if (n == null || !n.city.equals(o.city) || n.debunked) return "Nincs ilyen hír.";
                if (n.author.equals(p)) return "A saját híredet nem ellenőrizheted.";
                if (a == Action.DEBUNK && !Boolean.FALSE.equals(s.players.get(p).verified.get(n.id))) return "Előbb ellenőrizd, hogy hamis-e.";
            }
            default -> {}
        }
        return null;
    }

    // ---------- Játékos-műveletek ----------

    public Order addDraft(String p, Order o) {
        String err = validate(p, o);
        if (err != null) throw new EngineException(err);
        if (o.type.equals("defend")) {
            Order bo = buyoutAgainst(p, o.lapId, o.orderId).orElseThrow();
            o.good = bo.good; o.pts = bo.pts;
            if (s.draftOf(p).stream().anyMatch(x -> "defend".equals(x.type) && o.orderId.equals(x.orderId)))
                throw new EngineException("Ez a védekező vétel már a vázlatodon van.");
        }
        Cost c = draftCost(p), add = cost(p, o);
        PlayerSt ps = s.players.get(p);
        if (c.pp() + add.pp() > ps.pp) throw new EngineException("Nincs elég parancspont: " + (c.pp() + add.pp()) + " kellene, " + ps.pp + " van.");
        if (c.gold() + add.gold() > ps.gold) throw new EngineException("Nincs elég arany: " + (c.gold() + add.gold()) + " kellene, " + (int) ps.gold + " van.");
        o.id = s.nextId("o");
        o.gold = add.gold();
        s.draftOf(p).add(o);
        return o;
    }

    public void removeDraft(String p, String orderId) {
        if (!s.draftOf(p).removeIf(o -> o.id.equals(orderId))) throw new EngineException("Nincs ilyen parancs a vázlaton.");
    }

    /** Lepecsételés: a költség lefoglalódik, a lap `maturationMin` perc múlva fut le (3.1). */
    public Lap seal(String p, long now, int maturationMin) {
        List<Order> draft = s.draftOf(p);
        if (draft.isEmpty()) throw new EngineException("Üres parancslapot nem lehet lepecsételni.");
        if (s.lapOf(p).isPresent()) throw new EngineException("Már van érlelő parancslapod. A következőt a végrehajtás után pecsételheted le.");
        Cost c = draftCost(p);
        PlayerSt ps = s.players.get(p);
        if (c.pp() > ps.pp) throw new EngineException("Nincs elég parancspont: " + c.pp() + " kellene, " + ps.pp + " van.");
        if (c.gold() > ps.gold) throw new EngineException("Nincs elég arany: " + c.gold() + " kellene, " + (int) ps.gold + " van.");
        return pushLap(p, new ArrayList<>(draft), now, now + maturationMin * 60_000L, c, draft::clear);
    }

    private Lap pushLap(String p, List<Order> orders, long sealedAt, long executeAt, Cost c, Runnable after) {
        PlayerSt ps = s.players.get(p);
        ps.pp -= c.pp(); ps.gold = r1(ps.gold - c.gold());
        Lap lap = new Lap();
        lap.id = s.nextId("L"); lap.player = p; lap.orders = orders; lap.sealedAt = sealedAt; lap.executeAt = executeAt;
        lap.pp = c.pp(); lap.gold = c.gold();
        s.laps.add(lap);
        after.run();
        // A kivásárlási ajánlat a célpont számára nyilvános (5.4)
        for (Order o : orders) {
            if (!"buyout".equals(o.type)) continue;
            Good g = s.cities.get(o.city).goods.get(o.good);
            report(o.target, "frakcio", null, name(p) + " ki akar vásárolni",
                o.pts + " pontot akar a(z) " + g.name.toLowerCase() + " részesedésedből (" + cityName(o.city) + "). Az ajánlat " + Time.fmt(executeAt)
                    + "-kor fut le. Védekező vétellel kiválthatod a Vásártéren.", "danger", sealedAt);
        }
        return lap;
    }

    // ---------- Információs piac (7.5) ----------

    public void offerIntel(String seller, String intelId, String buyer, int price) {
        Intel it = s.intel.stream().filter(x -> x.id.equals(intelId) && x.owner.equals(seller)).findFirst()
            .orElseThrow(() -> new EngineException("Nincs ilyen kifürkészett parancslap."));
        if (lap(it.lapId).isEmpty()) throw new EngineException("Ez a parancslap már lefutott, az információ értéktelen.");
        if (buyer == null || !s.players.containsKey(buyer) || buyer.equals(seller)) throw new EngineException("Válassz vevőt.");
        if (buyer.equals(it.of)) throw new EngineException("A saját terveit nem adhatod el neki.");
        if (it.offeredTo.contains(buyer)) throw new EngineException("Ennek a háznak már felkínáltad.");
        if (price < 1 || price > 500) throw new EngineException("Az ár 1 és 500 arany között lehet.");
        it.offeredTo.add(buyer);
        PlayerSt b = s.players.get(buyer);
        if (b.npc) {
            // Az NPC-k azonnal döntenek: olcsó és friss információt megvesznek.
            if (price <= Rules.INFO_PRICE * 1.5 && b.gold >= price) completeSale(it, seller, buyer, price);
            else report(seller, "kem", null, name(buyer) + " nem vette meg", "Túl drágának tartotta az ajánlatot (" + price + " A).", "warn", s.clock);
            return;
        }
        Offer o = new Offer();
        o.id = s.nextId("f"); o.intelId = it.id; o.seller = seller; o.buyer = buyer; o.price = price;
        s.offers.add(o);
        report(buyer, "kem", null, name(seller) + " információt kínál",
            name(it.of) + " érlelő parancslapjáról, " + price + " aranyért. Az Alvilágban fogadhatod el; letét: fizetéskor azonnal megkapod.", "info", s.clock);
    }

    public void acceptOffer(String buyer, String offerId) {
        Offer o = offer(buyer, offerId);
        Intel it = s.intel.stream().filter(x -> x.id.equals(o.intelId)).findFirst().orElse(null);
        if (it == null || lap(it.lapId).isEmpty()) { s.offers.remove(o); throw new EngineException("A parancslap már lefutott, az ajánlat lejárt."); }
        if (s.players.get(buyer).gold < o.price) throw new EngineException("Nincs elég aranyad: " + o.price + " kellene.");
        s.offers.remove(o);
        completeSale(it, o.seller, buyer, o.price);
    }

    public void declineOffer(String buyer, String offerId) {
        Offer o = offer(buyer, offerId);
        s.offers.remove(o);
        report(o.seller, "kem", null, name(buyer) + " elutasította az ajánlatodat", "Az információt más háznak még eladhatod.", "warn", s.clock);
    }

    private Offer offer(String buyer, String offerId) {
        return s.offers.stream().filter(x -> x.id.equals(offerId) && x.buyer.equals(buyer)).findFirst()
            .orElseThrow(() -> new EngineException("Nincs ilyen ajánlat."));
    }

    private void completeSale(Intel it, String seller, String buyer, int price) {
        PlayerSt sp = s.players.get(seller), bp = s.players.get(buyer);
        bp.gold = r1(bp.gold - price); sp.gold = r1(sp.gold + price);
        Intel copy = new Intel();
        copy.id = s.nextId("i"); copy.owner = buyer; copy.lapId = it.lapId; copy.of = it.of; copy.executeAt = it.executeAt;
        copy.lines = new ArrayList<>(it.lines); copy.depth = it.depth; copy.bought = true;
        if (!bp.npc) s.intel.add(copy);
        String bonus = "";
        if (s.settlements - sp.lastInfoSale >= Rules.INFO_LEGIT_EVERY) { sp.legit += Rules.INFO_LEGIT; sp.lastInfoSale = s.settlements; bonus = " +" + Rules.INFO_LEGIT + " Legitimitás."; }
        report(seller, "kem", null, "Információ eladva: " + name(buyer),
            name(buyer) + " " + price + " aranyat fizetett " + name(it.of) + " terveiért. A letét lezárult." + bonus, "ok", s.clock);
        report(buyer, "kem", depthConfidence(it.depth), name(it.of) + " tervei (lejár: " + Time.fmt(it.executeAt) + ")",
            String.join(" · ", it.lines) + " (" + price + " aranyért vetted " + name(seller) + " házától)", "info", s.clock);
    }

    // ---------- Idő (3.1–3.2) ----------

    /**
     * Lefuttatja az `until` időpontig esedékes érlelő lapokat és elszámolásokat, időrendben.
     * A szezon utolsó (maxSettlements.) elszámolása után megáll.
     */
    public void advance(long until, int maturationMin, int maxSettlements) {
        for (int guard = 0; guard < 1000 && s.settlements < maxSettlements; guard++) {
            long nextLap = s.laps.stream().mapToLong(l -> l.executeAt).min().orElse(Long.MAX_VALUE);
            long nextSet = Time.nextSettlement(s.clock);
            PlayerSt nextNpc = s.players.values().stream().filter(x -> x.npc && x.nextPlanAt > 0).min(Comparator.comparingLong(x -> x.nextPlanAt)).orElse(null);
            long npcAt = nextNpc == null ? Long.MAX_VALUE : Math.max(nextNpc.nextPlanAt, s.clock);
            long t = Math.min(Math.min(nextLap, nextSet), npcAt);
            if (t > until) break;
            s.clock = t;
            if (npcAt == t && npcAt < nextLap && npcAt < nextSet) {
                // Az NPC-k bármikor pecsételhetnek, ugyanazzal az érlelési idővel (3.1)
                nextNpc.nextPlanAt = 0;
                npcPlanFor(nextNpc, maturationMin);
            } else if (nextLap <= nextSet) {
                // Egyidejű lapoknál a lepecsételés sorrendje dönt (3.1)
                Lap lap = s.laps.stream().filter(l -> l.executeAt == t).min(Comparator.comparingLong((Lap l) -> l.sealedAt).thenComparing(l -> l.id)).orElseThrow();
                s.laps.remove(lap);
                executeLap(lap);
            } else {
                settle();
                if (s.settlements >= maxSettlements) return;
                scheduleNpcs();
            }
        }
        s.clock = Math.max(s.clock, until);
    }

    /** Fejlesztéshez: azonnali elszámolás a 8:00 / 20:00 helyett (az ütemezett elszámolások ettől még lefutnak). */
    public void settleNow(int maturationMin) {
        settle();
        scheduleNpcs();
    }

    /** A következő esemény (lap vagy elszámolás) időpontja. */
    public long nextEventAt() {
        long nextLap = s.laps.stream().mapToLong(l -> l.executeAt).min().orElse(Long.MAX_VALUE);
        return Math.min(nextLap, Time.nextSettlement(s.clock));
    }

    void report(String player, String kind, String confidence, String title, String text, String tone, long at) {
        if (player == null || npc(player) || !s.players.containsKey(player)) return;
        out.add(new ReportOut(player, false, at, kind, confidence, title, text, tone));
    }

    void publicReport(String kind, String title, String text, String tone) {
        out.add(new ReportOut(null, true, s.clock, kind, null, title, text, tone));
    }

    private static String depthConfidence(int depth) { return depth >= 3 ? "eros" : depth >= 2 ? "kozepes" : "gyenge"; }

    // ---------- Parancslap végrehajtása ----------

    private void executeLap(Lap lap) {
        String p = lap.player;
        PlayerSt ps = s.players.get(p);
        if (ps == null) return;
        long t = s.clock;
        for (Order o : lap.orders) {
            if ("defend".equals(o.type) && s.events.stream().anyMatch(e -> "defendUsed".equals(e.type) && o.orderId.equals(e.orderId))) {
                report(p, "frakcio", null, "Védekező vétel", "A Városnak kifizetett ár már megvédte a részesedésedet.", "info", t);
                continue;
            }
            String err = validate(p, o);
            if (err != null) {
                ps.gold = r1(ps.gold + o.gold); // az arany visszajár, a PP nem
                report(p, "frakcio", null, "Elmaradt: " + Action.of(o.type).label, err + " Az aranyat visszakaptad.", "warn", t);
                continue;
            }
            CitySt cs = o.city == null ? null : s.cities.get(o.city);
            Good g = cs == null || o.good == null ? null : cs.goods.get(o.good);
            String cn = o.city == null ? "" : cityName(o.city);
            switch (Action.of(o.type)) {
                case ROUTE -> {
                    s.routesOf(p).add(new Edge(o.from, o.to));
                    report(p, "diplomacia", null, "Új útvonal: " + cityName(o.to), "A karavánút megnyílt. " + cityName(o.to) + " mostantól a hálózatod része.", "ok", t);
                }
                case MARGIN -> {
                    g.margins.put(p, o.level);
                    report(p, "frakcio", null, g.name + " ára: " + Margin.of(o.level).label, cn + " üzleteiben az új árak kikerültek a pultra.", "info", t);
                }
                case BUY_SHARES -> {
                    g.shares.merge(p, o.pts, Integer::sum); g.margins.putIfAbsent(p, "piaci");
                    report(p, "frakcio", null, "+" + o.pts + " részesedés: " + g.name,
                        "A városi tanács jóváhagyta az adásvételt. " + cn + " " + g.name.toLowerCase() + "kínálatának " + g.shares.get(p) + "%-a a tiéd.", "ok", t);
                }
                case BUYOUT -> buyout(lap, o, cs, g);
                case DEFEND -> {
                    MarketEvent e = new MarketEvent();
                    e.type = "defend"; e.lapId = o.lapId; e.orderId = o.orderId; e.by = p; e.city = o.city; e.good = o.good; e.settlement = s.settlements;
                    s.events.add(e);
                    report(p, "frakcio", null, "Védekező vétel: " + g.name, "Kifizetted a Városnak a részesedésed árát. A kivásárlási ajánlat meghiúsul.", "info", t);
                }
                case FOUND_PARTY -> {
                    cs.parties.put(p, "kozepes");
                    report(p, "diplomacia", null, "Pártot alapítottál: " + cn, "A párt a következő választáson indul. Programja: közepes adó.", "ok", t);
                }
                case PROGRAM -> {
                    cs.parties.put(p, o.level);
                    report(p, "diplomacia", null, "Új program: " + Program.of(o.level).label, "A pártod " + cn + " városában meghirdette az új adóprogramot.", "info", t);
                }
                case FESTIVAL -> {
                    String key = o.city + "|" + p;
                    boolean recent = s.festivals.containsKey(key) && s.settlements - s.festivals.get(key) < Rules.FESTIVAL_COOLDOWN;
                    double gain = (recent ? Rules.FESTIVAL_POP / 2 : Rules.FESTIVAL_POP) * (isCampaign() ? 2 : 1);
                    addPop(o.city, p, gain);
                    s.festivals.put(key, s.settlements);
                    report(p, "esemeny", null, "Fesztivál: +" + fmt(gain) + " népszerűség",
                        recent ? "A nép mulatott, de a legutóbbi ünnep még túl friss az emlékezetében." : "Zászlók, zene, sült ökör a főtéren. A városlakók a nevedet éltetik.", "ok", t);
                }
                case NEWS -> {
                    News n = new News();
                    n.id = s.nextId("n"); n.city = o.city; n.author = p; n.target = o.target; n.template = o.template;
                    n.good = NewsTemplate.of(o.template).needsGood ? o.good : null; n.goodName = n.good == null ? null : g.name;
                    n.effect = NewsTemplate.of(o.template).effect; n.createdAt = t;
                    n.trueAtCreation = newsTruth(o.city, n.template, n.target, n.good);
                    addPop(o.city, n.target, n.effect);
                    s.news.add(0, n);
                    publicReport("frakcio", "Hír terjed: " + cn, newsText(n), n.effect < 0 ? "warn" : "ok");
                }
                case HIRE_SPY -> {
                    cs.spies.merge(p, 1, Integer::sum);
                    report(p, "kem", null, "Új kém: " + cn, "Egy megbízható ember az alvilágban. Kémeid itt: " + cs.spies.get(p) + ".", "ok", t);
                }
                case GUARD -> {
                    cs.guards.merge(p, 1, Integer::sum);
                    report(p, "kem", null, "Őr beállítva", cn + " városában " + cs.guards.get(p) + " kémed figyeli az idegen ügynököket.", "info", t);
                }
                case SPY -> spy(p, o, cs);
                case MOVE_SPY -> {
                    int left = cs.spies.get(p) - 1;
                    if (left <= 0) cs.spies.remove(p); else cs.spies.put(p, left);
                    s.cities.get(o.to).spies.merge(p, 1, Integer::sum);
                    report(p, "kem", null, "Kém áthelyezve: " + cityName(o.to), "Az ügynököd " + cn + " városából átköltözött " + cityName(o.to) + " alvilágába.", "info", t);
                }
                case VERIFY -> {
                    News n = news(o.newsId).orElseThrow();
                    if (caught(o.city, p, n.author)) continue;
                    ps.verified.put(n.id, n.trueAtCreation);
                    report(p, "kem", "eros", n.trueAtCreation ? "A hír igaz volt" : "A hír hamis!",
                        newsText(n) + (n.trueAtCreation ? " A terjesztő nem hazudott." : " " + name(n.author) + " tudatosan hazudott. Leleplezheted."),
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
                    publicReport("kem", "Leleplezve: " + name(n.author) + " hazudott",
                        newsText(n) + " A hír hamis volt. " + name(n.author) + " −" + fmt(Rules.DEBUNK_PENALTY) + " népszerűség, " + name(p) + " jutalma +"
                            + Rules.DEBUNK_REWARD_GOLD + " arany és +" + Rules.DEBUNK_REWARD_LEGIT + " Legitimitás.", "ok");
                }
            }
        }
        if (ps.npc && ps.nextPlanAt == 0) ps.nextPlanAt = t + (30 + rng.nextInt(210)) * 60_000L;
        // A lefutott laphoz tartozó információ értéktelen, az ajánlatok lejárnak (7.5)
        Set<String> dead = s.intel.stream().filter(i -> i.lapId.equals(lap.id)).map(i -> i.id).collect(Collectors.toSet());
        s.offers.removeIf(o -> dead.contains(o.intelId));
    }

    private void buyout(Lap lap, Order o, CitySt cs, Good g) {
        String p = lap.player;
        long t = s.clock;
        // A védekező vétel hat, ha már lefutott, vagy ha lepecsételve érlelődik (5.4: „az ajánlat érlelése alatt kiválthatja”)
        boolean done = s.events.stream().anyMatch(e -> "defend".equals(e.type) && lap.id.equals(e.lapId) && o.id.equals(e.orderId));
        boolean sealed = s.lapOf(o.target).map(l -> l.orders.stream().anyMatch(x -> "defend".equals(x.type) && o.id.equals(x.orderId))).orElse(false);
        if (sealed && !done) {
            MarketEvent used = new MarketEvent();
            used.type = "defendUsed"; used.lapId = lap.id; used.orderId = o.id; used.by = o.target; used.city = o.city; used.good = o.good; used.settlement = s.settlements;
            s.events.add(used);
        }
        if (done || sealed) {
            s.players.get(p).gold = r1(s.players.get(p).gold + o.gold);
            report(p, "frakcio", null, "Kivásárlás meghiúsult", name(o.target) + " kiváltotta a részesedését. Az ajánlat árát visszakaptad.", "warn", t);
            report(o.target, "frakcio", null, "Megvédted a részesedésedet", name(p) + " kivásárlási ajánlata elbukott.", "ok", t);
            return;
        }
        int left = g.shares.get(o.target) - o.pts;
        if (left <= 0) { g.shares.remove(o.target); g.margins.remove(o.target); } else g.shares.put(o.target, left);
        g.shares.merge(p, o.pts, Integer::sum); g.margins.putIfAbsent(p, "piaci");
        PlayerSt tp = s.players.get(o.target);
        tp.gold = r1(tp.gold + o.gold);
        s.protection.put(o.city + "|" + o.good + "|" + o.target, s.settlements + Rules.BUYOUT_PROTECTION);
        MarketEvent e = new MarketEvent();
        e.type = "buyout"; e.city = o.city; e.good = o.good; e.by = p; e.target = o.target; e.settlement = s.settlements;
        s.events.add(e);
        report(p, "frakcio", null, "Kivásároltad: " + name(o.target),
            o.pts + " pont " + g.name.toLowerCase() + " " + o.gold + " aranyért. " + name(o.target) + " " + Rules.BUYOUT_PROTECTION + " elszámolásig védett.", "ok", t);
        report(o.target, "frakcio", null, name(p) + " kivásárolt",
            o.pts + " pontot veszítettél a(z) " + g.name.toLowerCase() + " árucikkből (" + cityName(o.city) + "), " + o.gold + " aranyat kaptál érte.", "danger", t);
    }

    private void spy(String p, Order o, CitySt cs) {
        long t = s.clock;
        if (caught(o.city, p, o.target)) return;
        Lap target = s.lapOf(o.target).orElse(null);
        if (target == null) {
            report(p, "kem", null, "Nincs mit kifürkészni", name(o.target) + " parancslapja már lefutott, vagy nincs érlelő parancslapja.", "warn", t);
            return;
        }
        int free = Math.min(3, cs.spies.getOrDefault(p, 0) - cs.guards.getOrDefault(p, 0));
        // Csak az adott városban kiadott parancsok látszanak (7.2); az útvonal a célvárosához tartozik
        List<String> lines = target.orders.stream().filter(x -> o.city.equals(x.city) || ("route".equals(x.type) && o.city.equals(x.to)))
            .map(x -> orderLabel(x, free)).toList();
        if (lines.isEmpty()) {
            report(p, "kem", null, name(o.target) + " itt nem tervez semmit", "Érlelő parancslapján nincs " + cityName(o.city)
                + " városára vonatkozó parancs. A lap " + Time.fmt(target.executeAt) + "-kor fut le.", "info", t);
            return;
        }
        if (!npc(p)) {
            Intel it = new Intel();
            it.id = s.nextId("i"); it.owner = p; it.lapId = target.id; it.of = o.target; it.executeAt = target.executeAt;
            it.lines = new ArrayList<>(lines); it.depth = free;
            s.intel.add(0, it);
        }
        report(p, "kem", depthConfidence(free), name(o.target) + " tervei (lejár: " + Time.fmt(target.executeAt) + ")", String.join(" · ", lines), "info", t);
    }

    /** Ellenkémkedés (7.4): a célpont őrei őrönként 25% (legfeljebb 75%) eséllyel lebuktatják a kémet. */
    private boolean caught(String city, String attacker, String victim) {
        CitySt cs = s.cities.get(city);
        int guards = cs.guards.getOrDefault(victim, 0);
        if (guards == 0 || rng.nextDouble() >= Math.min(Rules.GUARD_MAX, guards * Rules.GUARD_CHANCE)) return false;
        int left = cs.spies.getOrDefault(attacker, 0) - 1;
        if (left <= 0) cs.spies.remove(attacker); else cs.spies.put(attacker, left);
        if (cs.guards.getOrDefault(attacker, 0) > Math.max(0, left)) cs.guards.put(attacker, Math.max(0, left));
        addPop(city, attacker, -Rules.CAUGHT_POP);
        report(attacker, "kem", null, "Lebukott a kémed", name(victim) + " őrei elfogták az ügynöködet " + cityName(city)
            + " városában. A kém elveszett, és −" + fmt(Rules.CAUGHT_POP) + " népszerűséget kaptál.", "danger", s.clock);
        report(victim, "kem", "eros", "Elfogtuk " + name(attacker) + " kémjét", "Az őreid " + cityName(city) + " városában lefülelték az ügynököt.", "ok", s.clock);
        return true;
    }

    static String fmt(double v) { return v == Math.rint(v) ? String.valueOf((long) v) : String.valueOf(r1(v)).replace('.', ','); }

    // ---------- Elszámolás (3.2) ----------

    private static final class Seller {
        final String p; final double cap, m, pop; double w, sold;
        Seller(String p, double cap, double m, double pop) { this.p = p; this.cap = cap; this.m = m; this.pop = pop; }
    }

    void settle() {
        Map<String, double[]> inc = new LinkedHashMap<>(); // játékos → [arany, legit]
        s.players.keySet().forEach(p -> inc.put(p, new double[2]));
        for (var ce : s.cities.entrySet()) {
            String city = ce.getKey();
            CitySt cs = ce.getValue();
            Map<String, Double> profits = new LinkedHashMap<>();
            // 5.3 Kereslet és értékesítés
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
                // Legolcsóbb eladó bónusz; döntetlennél senki (5.2)
                if (players.size() > 1) {
                    double min = players.stream().mapToDouble(x -> x.m).min().orElse(0);
                    List<Seller> cheapest = players.stream().filter(x -> x.m == min).toList();
                    if (cheapest.size() == 1) addPop(city, cheapest.get(0).p, 1);
                }
                // Legitimitás: az árucikk legnagyobb eladója (8.)
                players.stream().max(Comparator.comparingDouble(x -> x.sold))
                    .filter(x -> x.sold > 0).ifPresent(x -> inc.get(x.p)[1] += Rules.TOP_SELLER_LEGIT);
            }
            // 6.2 Adó: a kereskedők fizetik, a tanácsi pártok kapják
            double rate = taxRate(city), base = profits.values().stream().mapToDouble(Double::doubleValue).sum(), pool = base * rate;
            int totalSeats = cs.council.values().stream().mapToInt(Integer::intValue).sum();
            profits.forEach((p, v) -> inc.get(p)[0] += v * (totalSeats > 0 ? 1 - rate : 1));
            if (totalSeats > 0) cs.council.forEach((p, v) -> { if (inc.containsKey(p)) inc.get(p)[0] += pool * v / totalSeats; });
            cs.lastTaxPool = totalSeats > 0 ? r1(pool) : null;
            // Programok hatása a népszerűségre
            cs.parties.forEach((p, prog) -> addPop(city, p, Program.of(prog).pop));
            // Legitimitás: mandátum, többség, legnépszerűbb
            cs.council.forEach((p, v) -> {
                if (!inc.containsKey(p) || v <= 0) return;
                inc.get(p)[1] += v * Rules.SEAT_LEGIT + (v >= Rules.MAJORITY_SEATS ? Rules.MAJORITY_LEGIT : 0);
            });
            List<Map.Entry<String, Double>> popTop = cs.pop.entrySet().stream().sorted(Map.Entry.<String, Double>comparingByValue().reversed()).toList();
            if (!popTop.isEmpty() && (popTop.size() == 1 || popTop.get(0).getValue() > popTop.get(1).getValue()) && inc.containsKey(popTop.get(0).getKey()))
                inc.get(popTop.get(0).getKey())[1] += Rules.MOST_POPULAR_LEGIT;
            // Kémek fenntartása
            cs.spies.forEach((p, n) -> { if (inc.containsKey(p)) inc.get(p)[0] -= n * Rules.SPY_UPKEEP; });
            // Visszahúzás az alapértékhez
            cs.pop.replaceAll((p, v) -> r1(v > Rules.POP_BASE ? Math.max(Rules.POP_BASE, v - Rules.POP_DRIFT) : Math.min(Rules.POP_BASE, v + Rules.POP_DRIFT)));
        }
        // Útvonalak fenntartása, bevétel, PP
        s.players.forEach((p, ps) -> { if (!ps.npc) inc.get(p)[0] -= s.routesOf(p).size() * Rules.ROUTE_UPKEEP; });
        s.settlements += 1;
        s.players.forEach((p, ps) -> {
            double[] v = inc.get(p);
            ps.gold = Math.max(0, r1(ps.gold + v[0]));
            ps.legit += (int) v[1];
            ps.pp = Math.min(Rules.PP_MAX, ps.pp + Rules.PP_PER_SETTLEMENT);
            report(p, "esemeny", null, "Elszámolás · " + Time.fmt(s.clock),
                "Bevétel: " + (v[0] >= 0 ? "+" : "") + fmt(r1(v[0])) + " arany (haszon, adó, fenntartás), +" + (int) v[1] + " Legitimitás, +" + Rules.PP_PER_SETTLEMENT + " PP.", "info", s.clock);
        });
        s.events.removeIf(e -> s.settlements - e.settlement > 10);
        if (s.news.size() > 60) s.news.subList(60, s.news.size()).clear();
        if (s.settlements % Rules.ELECTION_EVERY == 0) elections();
    }

    // ---------- Választás (6.3), D'Hondt ----------

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
            String list = cs.council.entrySet().stream().sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .map(e -> name(e.getKey()) + " " + e.getValue()).collect(Collectors.joining(", "));
            publicReport("diplomacia", "Választás: " + cityName(city), "Az új tanács: " + (list.isEmpty() ? "senki sem jutott be" : list) + ".", "info");
            for (String p : cs.parties.keySet()) {
                int now = cs.council.getOrDefault(p, 0), was = before.getOrDefault(p, 0);
                if (now == was) continue;
                report(p, "diplomacia", null, (now > was ? "+" + (now - was) : "−" + (was - now)) + " mandátum: " + cityName(city),
                    now > 0 ? "A pártodnak " + now + " helye van a tanácsban." : "A pártod kiesett a tanácsból.", now > was ? "ok" : "warn", s.clock);
            }
        }
    }

    /** Koronázási Tanács a szezon végén (8.): minden városi tanács a legtöbb mandátumú házra szavaz, +10 L szavazatonként. */
    public void coronation() {
        List<String> votes = new ArrayList<>();
        for (var ce : s.cities.entrySet()) {
            List<Map.Entry<String, Integer>> rk = ce.getValue().council.entrySet().stream().sorted(Map.Entry.<String, Integer>comparingByValue().reversed()).toList();
            if (rk.isEmpty() || (rk.size() > 1 && rk.get(0).getValue().equals(rk.get(1).getValue()))) continue;
            String p = rk.get(0).getKey();
            s.players.get(p).legit += Rules.CORONATION_LEGIT;
            votes.add(cityName(ce.getKey()) + ": " + name(p));
        }
        publicReport("esemeny", "Koronázási Tanács",
            votes.isEmpty() ? "Egyik városi tanácsban sem volt egyértelmű többség." : "A városi tanácsok szavazatai (+" + Rules.CORONATION_LEGIT + " L): " + String.join(", ", votes) + ".", "info");
    }

    // ---------- NPC-házak ----------

    /** Induláskor és elszámolás után minden NPC a következő 6 órában valamikor pecsétel. */
    public void scheduleNpcs() {
        for (PlayerSt h : s.players.values())
            if (h.npc && h.nextPlanAt == 0 && s.lapOf(h.id).isEmpty()) h.nextPlanAt = s.clock + rng.nextInt(360) * 60_000L;
    }

    private void npcPlanFor(PlayerSt h, int maturationMin) {
        List<String> humans = s.players.values().stream().filter(x -> !x.npc).map(x -> x.id).toList();
        List<String> cities = new ArrayList<>(s.cities.keySet());
        {
            if (s.lapOf(h.id).isPresent()) return;
            List<Order> orders = new ArrayList<>();
            int[] pp = { h.pp };
            double[] gold = { h.gold };
            java.util.function.Consumer<Order> push = o -> {
                if (validate(h.id, o) != null) return;
                if (o.type.equals("defend")) { Order bo = buyoutAgainst(h.id, o.lapId, o.orderId).orElseThrow(); o.good = bo.good; o.pts = bo.pts; }
                Cost c = cost(h.id, o);
                if (c.pp() > pp[0] || c.gold() > gold[0]) return;
                pp[0] -= c.pp(); gold[0] -= c.gold();
                o.id = s.nextId("o"); o.gold = c.gold();
                orders.add(o);
            };
            Collections.shuffle(cities, new Random(rng.nextLong()));
            String human = humans.isEmpty() ? null : humans.get(rng.nextInt(humans.size()));
            // Védekezés: minden persona kiváltja az ellene szóló kivásárlást, ha van rá pénze
            for (Lap l : s.laps) for (Order bo : l.orders)
                if ("buyout".equals(bo.type) && h.id.equals(bo.target)) push.accept(order("defend", bo.city, x -> { x.lapId = l.id; x.orderId = bo.id; }));
            switch (h.persona == null ? "" : h.persona) {
                case "kalmar" -> {
                    for (String c : cities) for (var ge : s.cities.get(c).goods.entrySet()) {
                        Good g = ge.getValue();
                        if (g.shares.containsKey(h.id)) {
                            if (popOf(c, h.id) < 15 && !"olcso".equals(g.margins.get(h.id))) push.accept(order("margin", c, x -> { x.good = ge.getKey(); x.level = "olcso"; }));
                            else if (popOf(c, h.id) > 30 && !"draga".equals(g.margins.get(h.id))) push.accept(order("margin", c, x -> { x.good = ge.getKey(); x.level = "draga"; }));
                        }
                        if (cityShare(g) >= 5 && rng.nextDouble() < 0.3) push.accept(order("buyShares", c, x -> { x.good = ge.getKey(); x.pts = 5; }));
                    }
                }
                case "felvasarlo" -> {
                    boolean recent = s.events.stream().anyMatch(e -> "buyout".equals(e.type) && h.id.equals(e.by) && s.settlements - e.settlement < 3);
                    if (!recent && human != null) for (String c : cities) for (var ge : s.cities.get(c).goods.entrySet()) {
                        int theirs = ge.getValue().shares.getOrDefault(human, 0);
                        if (theirs >= 5 && rng.nextDouble() < 0.35 && orders.stream().noneMatch(x -> x.type.equals("buyout")))
                            push.accept(order("buyout", c, x -> { x.good = ge.getKey(); x.target = human; x.pts = Math.min(5, theirs); }));
                    }
                    String c0 = cities.get(0);
                    push.accept(order("buyShares", c0, x -> { x.good = s.cities.get(c0).goods.keySet().iterator().next(); x.pts = 5; }));
                }
                case "politikus" -> {
                    for (String c : cities) {
                        CitySt cs = s.cities.get(c);
                        if (!cs.parties.containsKey(h.id) && gold[0] > 60) push.accept(order("foundParty", c, x -> {}));
                        if (cs.parties.containsKey(h.id) && (isCampaign() || rng.nextDouble() < 0.3)) push.accept(order("festival", c, x -> {}));
                        if (human != null && cs.parties.containsKey(human) && rng.nextDouble() < 0.4)
                            push.accept(order("news", c, x -> { x.target = human; x.template = "adoemeles"; }));
                    }
                }
                case "kem" -> {
                    for (String c : cities) {
                        CitySt cs = s.cities.get(c);
                        if (cs.spies.getOrDefault(h.id, 0) < 2 && rng.nextDouble() < 0.4) push.accept(order("hireSpy", c, x -> {}));
                        if (human != null && s.lapOf(human).isPresent() && cs.spies.getOrDefault(h.id, 0) > 0)
                            push.accept(order("spy", c, x -> x.target = human));
                        if (human != null && rng.nextDouble() < 0.35) {
                            cs.goods.entrySet().stream().filter(ge -> ge.getValue().shares.containsKey(human)).findFirst()
                                .ifPresent(ge -> push.accept(order("news", c, x -> { x.target = human; x.template = "uzsora"; x.good = ge.getKey(); })));
                        }
                    }
                }
                default -> {}
            }
            if (orders.isEmpty()) return;
            Cost c = new Cost(0, 0);
            for (Order o : orders) c = c.plus(new Cost(Action.of(o.type).pp, o.gold));
            pushLap(h.id, orders, s.clock, s.clock + maturationMin * 60_000L, c, () -> {});
        }
    }

    private static Order order(String type, String city, java.util.function.Consumer<Order> fill) {
        Order o = new Order();
        o.type = type; o.city = city;
        fill.accept(o);
        return o;
    }
}
