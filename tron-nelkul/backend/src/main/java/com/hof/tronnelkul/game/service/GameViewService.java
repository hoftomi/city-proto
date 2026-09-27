package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.game.engine.*;
import com.hof.tronnelkul.game.engine.EngineState.*;
import com.hof.tronnelkul.game.engine.Rules.*;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.world.MapDefinition;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.*;

/**
 * A játékos nézete (szabálykönyv v0.2). Nyilvános: az eladók neve, részesedése és fokozata (5.2), a népszerűség,
 * a pártok, a tanács és a hírek. Rejtett: mások parancsai (csak kifürkészéssel), és mások kémeinek száma (csak pletyka).
 */
@Service
public class GameViewService {
    private final GameRepository games;
    private final PlayerRepository players;
    private final ReportRepository reports;
    private final GameRunner runner;

    public GameViewService(GameRepository games, PlayerRepository players, ReportRepository reports, GameRunner runner) {
        this.games = games; this.players = players; this.reports = reports; this.runner = runner;
    }

    private static final Catalog CATALOG = new Catalog(
        Arrays.stream(Action.values()).map(a -> new ActionInfo(a.id, a.label, a.branch, a.pp, a.gold)).toList(),
        Arrays.stream(Margin.values()).map(m -> new LevelInfo(m.id, m.label, (int) Math.round(m.rate * 100), m.pop)).toList(),
        Arrays.stream(Program.values()).map(p -> new LevelInfo(p.id, p.label, (int) Math.round(p.rate * 100), p.pop)).toList(),
        Arrays.stream(NewsTemplate.values()).map(n -> new NewsTemplateInfo(n.id, n.label, n.effect, n.needsGood)).toList(),
        new RulesInfo(Rules.BASE_PRICE, Rules.CITY_SHARE_COST, Rules.MAX_SHARES_PER_ORDER, (int) Math.round(Rules.BUYOUT_PREMIUM * 100),
            Rules.PARTY_COST, Rules.FESTIVAL_GOLD, (int) Rules.FESTIVAL_POP, Rules.NEWS_GOLD, Rules.SPY_COST, Rules.SPY_UPKEEP,
            Rules.SPIES_PER_CITY, (int) Math.round(Rules.GUARD_CHANCE * 100), (int) Rules.DEBUNK_REWARD_POP, Rules.DEBUNK_REWARD_GOLD,
            Rules.DEBUNK_REWARD_LEGIT, Rules.ROUTE_COST, Rules.ROUTE_UPKEEP, Rules.COUNCIL_SEATS, Rules.INFO_PRICE, (int) Rules.LOW_POP));

    /** Futó játéknál előbb lefuttatja a mostanáig esedékes eseményeket; lezárult játéknál a végállapotot mutatja. */
    public GameState state(String gameId, UUID userId) {
        GameEntity g = games.findById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        PlayerEntity p = players.findByGameIdAndUserId(g.id, userId).orElseThrow(() -> ApiException.forbidden("Nem vagy tagja ennek a játéknak."));
        if (g.status == GameStatus.OPEN || g.status == GameStatus.ANNOUNCED) throw ApiException.conflict("A játék még nem kezdődött el.");
        String me = p.id.toString();
        if (g.status == GameStatus.RUNNING) return runner.mutate(gameId, (gg, e) -> build(gg, e, me));
        return build(g, runner.engine(g), me);
    }

    GameState build(GameEntity g, Engine e, String me) {
        EngineState s = e.s;
        MapDefinition map = e.map;
        PlayerSt ps = s.players.get(me);
        if (ps == null) throw ApiException.conflict("A házad még nincs a játékban.");
        Map<String, Integer> net = e.network(me);
        java.util.function.Function<String, HouseRef> ref = id -> {
            PlayerSt x = s.players.get(id);
            return x == null ? null : new HouseRef(id, x.name, x.tincture, x.npc, id.equals(me));
        };

        // Útvonalak: a sajátok és a vázlaton vagy az érlelő lapon lévők
        List<Order> mine = new ArrayList<>(s.draftOf(me));
        s.lapOf(me).ifPresent(l -> mine.addAll(l.orders));
        List<RouteView> routes = new ArrayList<>();
        s.routesOf(me).forEach(r -> routes.add(new RouteView(r.a(), r.b(), "own")));
        mine.stream().filter(o -> "route".equals(o.type)).forEach(o -> routes.add(new RouteView(o.from, o.to, "pending")));
        List<Buildable> buildable = new ArrayList<>();
        for (List<String> edge : map.allEdges()) {
            String a = edge.get(0), b = edge.get(1);
            if (routes.stream().anyMatch(r -> (r.getFrom().equals(a) && r.getTo().equals(b)) || (r.getFrom().equals(b) && r.getTo().equals(a)))) continue;
            String from = net.containsKey(a) ? a : net.containsKey(b) ? b : null;
            if (from == null) continue;
            String to = from.equals(a) ? b : a;
            if (!map.isCity(to) || net.containsKey(to)) continue;
            buildable.add(new Buildable(from, to, map.nodeName(from), map.nodeName(to)));
        }

        List<CityView> cities = new ArrayList<>();
        for (CityDef cd : map.cities()) cities.add(cityView(e, cd, me, net, ref));

        List<OrderView> draft = s.draftOf(me).stream().map(o -> orderView(e, me, o, true)).toList();
        Engine.Cost dc = e.draftCost(me);
        LapView lap = s.lapOf(me).map(l -> new LapView(l.id, Instant.ofEpochMilli(l.sealedAt), Instant.ofEpochMilli(l.executeAt),
            l.orders.stream().map(o -> orderView(e, me, o, false)).toList(), new Cost(l.pp, l.gold))).orElse(null);
        List<RivalLap> rivalLaps = s.laps.stream().filter(l -> !l.player.equals(me)).sorted(Comparator.comparingLong(l -> l.executeAt))
            .map(l -> new RivalLap(ref.apply(l.player), Instant.ofEpochMilli(l.executeAt))).toList();

        Set<String> defending = new HashSet<>();
        mine.stream().filter(o -> "defend".equals(o.type)).forEach(o -> defending.add(o.orderId));
        List<Threat> threats = new ArrayList<>();
        for (Lap l : s.laps) {
            if (l.player.equals(me)) continue;
            for (Order o : l.orders) {
                if (!"buyout".equals(o.type) || !me.equals(o.target)) continue;
                Order d = new Order();
                d.type = "defend"; d.city = o.city; d.lapId = l.id; d.orderId = o.id;
                Good gd = s.cities.get(o.city).goods.get(o.good);
                threats.add(new Threat(l.id, o.id, ref.apply(l.player), o.city, map.nodeName(o.city), o.good, gd == null ? o.good : gd.name, o.pts,
                    Instant.ofEpochMilli(l.executeAt), e.cost(me, d).gold(), defending.contains(o.id)));
            }
        }

        List<IntelView> intel = s.intel.stream().filter(i -> i.owner.equals(me)).limit(12)
            .map(i -> new IntelView(i.id, ref.apply(i.of), Instant.ofEpochMilli(i.executeAt), i.lines, i.depth, e.lap(i.lapId).isPresent(),
                i.offeredTo.stream().map(e::name).toList(), i.bought)).toList();
        List<OfferView> offers = new ArrayList<>();
        for (Offer o : s.offers) {
            if (!o.buyer.equals(me)) continue;
            s.intel.stream().filter(i -> i.id.equals(o.intelId)).findFirst()
                .ifPresent(i -> offers.add(new OfferView(o.id, ref.apply(o.seller), ref.apply(i.of), o.price, Instant.ofEpochMilli(i.executeAt))));
        }
        List<HouseRef> houses = s.players.keySet().stream().map(ref).toList();

        ClockView clock = new ClockView(Instant.ofEpochMilli(s.clock), Instant.ofEpochMilli(Time.nextSettlement(s.clock)), s.settlements,
            g.maxSettlements(), e.nextElectionIn(), e.isCampaign(), g.maturationMinutes);
        Me meDto = new Me(me, ps.name, ps.tincture, ps.background, ps.estate, ps.pp, Rules.PP_MAX, Math.round(ps.gold * 10) / 10.0, ps.legit);
        return new GameState(g.id, g.name, g.mapId, g.status.apiId, clock, meDto, routes, buildable, cities, draft,
            new Cost(dc.pp(), dc.gold()), lap, rivalLaps, threats, intel, offers, houses, CATALOG);
    }

    private CityView cityView(Engine e, CityDef cd, String me, Map<String, Integer> net, java.util.function.Function<String, HouseRef> ref) {
        EngineState s = e.s;
        CitySt cs = s.cities.get(cd.id());
        String city = cd.id();
        List<GoodView> goods = new ArrayList<>();
        for (var ge : cs.goods.entrySet()) {
            Good g = ge.getValue();
            double cheapest = g.shares.entrySet().stream().filter(x -> x.getValue() > 0)
                .mapToDouble(x -> Margin.of(g.margins.get(x.getKey())).rate).min().orElse(Double.NaN);
            long sellersCount = g.shares.values().stream().filter(v -> v > 0).count();
            List<Seller> sellers = new ArrayList<>();
            g.shares.entrySet().stream().filter(x -> x.getValue() > 0).sorted(Map.Entry.<String, Integer>comparingByValue().reversed()).forEach(x -> {
                String m = g.margins.getOrDefault(x.getKey(), "piaci");
                sellers.add(new Seller(ref.apply(x.getKey()), false, x.getValue(), m, g.sold.get(x.getKey()),
                    sellersCount > 1 && Margin.of(m).rate == cheapest, e.isProtected(city, ge.getKey(), x.getKey())));
            });
            int cityPts = Engine.cityShare(g);
            if (cityPts > 0) sellers.add(new Seller(null, true, cityPts, "piaci", g.sold.get(Engine.CITY), false, false));
            goods.add(new GoodView(ge.getKey(), g.name, g.supply, g.demand, cityPts, Engine.marketValue(g), g.shares.getOrDefault(me, 0),
                g.shares.containsKey(me) ? g.margins.getOrDefault(me, "piaci") : null, sellers));
        }
        List<PopRow> pop = cs.pop.entrySet().stream().sorted(Map.Entry.<String, Double>comparingByValue().reversed())
            .map(x -> new PopRow(ref.apply(x.getKey()), x.getValue())).filter(r -> r.getHouse() != null).toList();
        List<PartyView> parties = cs.parties.entrySet().stream()
            .map(x -> new PartyView(ref.apply(x.getKey()), x.getValue(), (int) Math.round(e.popOf(city, x.getKey())), cs.council.getOrDefault(x.getKey(), 0)))
            .sorted(Comparator.comparingInt(PartyView::getVotes).reversed()).toList();
        List<HouseRef> foreignSpies = cs.spies.entrySet().stream().filter(x -> !x.getKey().equals(me) && x.getValue() > 0).map(x -> ref.apply(x.getKey())).toList();
        Set<String> presentIds = new LinkedHashSet<>(cs.pop.keySet());
        presentIds.addAll(cs.parties.keySet());
        cs.goods.values().forEach(g -> g.shares.forEach((p, v) -> { if (v > 0) presentIds.add(p); }));
        presentIds.remove(me);
        List<HouseRef> present = presentIds.stream().map(ref).filter(Objects::nonNull).toList();
        PlayerSt ps = s.players.get(me);
        List<NewsView> news = s.news.stream().filter(n -> n.city.equals(city)).limit(8)
            .map(n -> new NewsView(n.id, e.newsText(n), n.template, n.effect, ref.apply(n.author), ref.apply(n.target), Instant.ofEpochMilli(n.createdAt),
                n.debunked, ps.verified.get(n.id), n.author.equals(me))).toList();
        Integer dist = net.get(city);
        return new CityView(city, cd.name(), cd.profile(), cd.key(), cd.coast(), dist != null ? "reachable" : "unreachable", dist,
            e.popOf(city, me), Math.round(e.taxRate(city) * 1000) / 1000.0, cs.lastTaxPool, Rules.COUNCIL_SEATS, goods, pop, parties,
            cs.parties.get(me), cs.spies.getOrDefault(me, 0), cs.guards.getOrDefault(me, 0), foreignSpies, present, news);
    }

    /** A saját parancs nézete. A vázlaton figyelmeztet, ha a parancs most nem futna le, vagy a hír hamis (6.5). */
    private OrderView orderView(Engine e, String me, Order o, boolean draft) {
        Action a = Action.of(o.type);
        String warning = null;
        if (draft) {
            warning = e.validate(me, o);
            if (warning == null && a == Action.NEWS && !e.newsTruth(o.city, o.template, o.target, o.good)) warning = "Ez az állítás jelenleg nem igaz.";
        }
        return new OrderView(o.id, o.type, a.branch, e.orderLabel(o, 2), o.city, o.city == null ? null : e.cityName(o.city),
            new Cost(a.pp, o.gold), warning);
    }

    @Transactional(readOnly = true)
    public List<ReportView> reports(String gameId, UUID userId) {
        GameEntity g = games.findById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        PlayerEntity p = players.findByGameIdAndUserId(g.id, userId).orElseThrow(() -> ApiException.forbidden("Nem vagy tagja ennek a játéknak."));
        return reports.findTop100ByGameIdAndPlayerIdOrderByCreatedAtDesc(g.id, p.id).stream()
            .map(r -> new ReportView(r.id.toString(), r.settlement, r.kind, r.confidence, r.title, r.body, r.tone, r.createdAt, r.isPublic)).toList();
    }

    @Transactional(readOnly = true)
    public List<RankRow> ranking(String gameId, UUID userId) {
        GameEntity g = games.findById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        String me = players.findByGameIdAndUserId(g.id, userId).map(p -> p.id.toString()).orElse(null);
        if (g.state == null) {
            List<PlayerEntity> all = new ArrayList<>(players.findByGameId(g.id));
            all.sort(Comparator.comparing(p -> p.houseName));
            List<RankRow> out = new ArrayList<>();
            for (int i = 0; i < all.size(); i++) {
                PlayerEntity p = all.get(i);
                out.add(new RankRow(i + 1, p.id.toString(), p.houseName, p.tincture, p.npc, 0, 0, 0, p.id.toString().equals(me)));
            }
            return out;
        }
        EngineState s = runner.read(g);
        List<PlayerSt> all = new ArrayList<>(s.players.values());
        all.sort(Comparator.comparingInt((PlayerSt p) -> p.legit).reversed().thenComparing(p -> p.name));
        List<RankRow> out = new ArrayList<>();
        for (int i = 0; i < all.size(); i++) {
            PlayerSt p = all.get(i);
            int shares = 0, seats = 0;
            for (CitySt c : s.cities.values()) {
                seats += c.council.getOrDefault(p.id, 0);
                for (Good gd : c.goods.values()) shares += gd.shares.getOrDefault(p.id, 0);
            }
            out.add(new RankRow(i + 1, p.id, p.name, p.tincture, p.npc, p.legit, shares, seats, p.id.equals(me)));
        }
        return out;
    }
}
