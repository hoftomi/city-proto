package hu.webstar.tronnelkul.game.service;

import hu.webstar.tronnelkul.common.ApiException;
import hu.webstar.tronnelkul.game.api.Dtos;
import hu.webstar.tronnelkul.game.engine.*;
import hu.webstar.tronnelkul.game.model.*;
import hu.webstar.tronnelkul.game.world.CityDef;
import hu.webstar.tronnelkul.game.world.MapDefinition;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.*;

/**
 * A játékos nézete a játékról, a láthatósági szabályok szerint (11. fejezet):
 * mások értékeit csak a saját szintjének megfelelő pontossággal kapja meg, mások rejtett befolyását csak összesítve.
 */
@Service
public class GameViewService {
    private final GameRepository games;
    private final PlayerRepository players;
    private final OrderRepository orders;
    private final ReportRepository reports;
    private final GameStateStore store;

    public GameViewService(GameRepository games, PlayerRepository players, OrderRepository orders, ReportRepository reports, GameStateStore store) {
        this.games = games; this.players = players; this.orders = orders; this.reports = reports; this.store = store;
    }

    record Ctx(GameEntity game, PlayerEntity player, EngineState state) {}

    Ctx ctx(String gameId, UUID userId) {
        GameEntity g = games.findById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        PlayerEntity p = players.findByGameIdAndUserId(g.id, userId).orElseThrow(() -> ApiException.forbidden("Nem vagy tagja ennek a játéknak."));
        if (g.status == GameStatus.OPEN || g.status == GameStatus.ANNOUNCED) throw ApiException.conflict("A játék még nem kezdődött el.");
        return new Ctx(g, p, store.load(g));
    }

    @Transactional(readOnly = true)
    public Dtos.GameState state(String gameId, UUID userId) {
        Ctx c = ctx(gameId, userId);
        EngineState s = c.state();
        MapDefinition map = s.map;
        String me = c.player().id.toString();
        PlayerState ps = s.players.get(me);
        Map<String, Integer> net = Network.of(s, me);

        List<OrderEntity> myOrders = orders.findByGameIdAndPlayerIdOrderByCreatedAtAsc(c.game().id, c.player().id);
        int[] pend = new int[4];
        List<Dtos.OrderView> orderViews = new ArrayList<>();
        Set<String> pendingRoutes = new HashSet<>();
        for (OrderEntity o : myOrders) {
            ActionType t = ActionType.of(o.type);
            Cost cost = t.cost(o.hidden);
            pend[0] += cost.pp(); pend[1] += cost.arany(); pend[2] += cost.bp(); pend[3] += cost.ke();
            String cityLabel = t == ActionType.ROUTE ? map.nodeName(o.nodeFrom) + " → " + map.nodeName(o.nodeTo) : map.nodeName(o.city);
            String target = o.targetId == null ? null : Optional.ofNullable(s.players.get(o.targetId.toString())).map(x -> x.name).orElse(null);
            orderViews.add(new Dtos.OrderView(o.id.toString(), t.id(), t.label, cityLabel, o.faction, o.hidden, target, dto(cost)));
            if (t == ActionType.ROUTE) pendingRoutes.add(o.nodeFrom + "|" + o.nodeTo);
        }

        List<Dtos.RouteView> routeViews = new ArrayList<>();
        for (Edge e : s.routesOf(me)) routeViews.add(new Dtos.RouteView(e.a(), e.b(), "own"));
        for (String pr : pendingRoutes) { String[] k = pr.split("\\|"); routeViews.add(new Dtos.RouteView(k[0], k[1], "pending")); }

        List<Dtos.Buildable> buildable = new ArrayList<>();
        for (List<String> e : map.allEdges()) {
            String a = e.get(0), b = e.get(1);
            if (Network.owns(s, me, a, b) || pendingRoutes.contains(a + "|" + b) || pendingRoutes.contains(b + "|" + a)) continue;
            String from = net.containsKey(a) ? a : net.containsKey(b) ? b : null;
            if (from == null) continue;
            String to = from.equals(a) ? b : a;
            if (!map.isCity(to) || net.containsKey(to)) continue;
            buildable.add(new Dtos.Buildable(from, to, map.nodeName(from), map.nodeName(to)));
        }

        List<Dtos.CityView> cities = new ArrayList<>();
        for (CityDef city : map.cities()) {
            Integer dist = net.get(city.id());
            Stability st = s.stability.get(city.id());
            List<Dtos.FactionView> facs = new ArrayList<>();
            Levels.Level best = Levels.Level.NONE;
            for (Faction f : Faction.values()) {
                Levels.Level lvl = Levels.level(s, city.id(), f, me);
                if (lvl.rank > best.rank) best = lvl;
                facs.add(factionView(s, city.id(), f, me, lvl));
            }
            double decay = Rules.DECAY_OPEN + Rules.DECAY_PER_DISTANCE * Math.max(0, (dist == null ? 3 : dist) - 1) + st.extraDecay;
            cities.add(new Dtos.CityView(city.id(), city.name(), st.id(), dist != null ? "reachable" : "unreachable", dist, best.id,
                (int) Math.round(Math.min(Rules.DECAY_CAP, decay) * 100), facs));
        }

        List<Dtos.ActionInfo> actions = Arrays.stream(ActionType.values()).filter(a -> a != ActionType.ROUTE)
            .map(a -> new Dtos.ActionInfo(a.id(), a.label, a.factions.stream().map(Faction::id).toList(), a.power, a.needsPresence,
                dto(a.cost(false)), dto(a.cost(true)))).toList();

        Dtos.Me meDto = new Dtos.Me(me, ps.name, ps.tincture, c.player().background, ps.estateNode, ps.pp, Rules.PP_MAX,
            ps.arany, ps.bp, ps.ke, ps.legit, ps.sealedRound == s.round);
        return new Dtos.GameState(c.game().id, c.game().name, c.game().mapId, c.game().status.apiId, s.round, c.game().maxRounds(),
            c.game().status == GameStatus.RUNNING ? Clock.nextResolution(Instant.now()) : null, meDto,
            new Dtos.Cost(pend[0], pend[1], pend[2], pend[3]), routeViews, buildable, cities, orderViews, actions);
    }

    private Dtos.FactionView factionView(EngineState s, String city, Faction f, String me, Levels.Level lvl) {
        Map<String, Share> fac = s.fac(city, f);
        String precision = switch (lvl) { case DOMINANS, VAROSKONTROLL, PROTEKTORATUS -> "exact"; case PARTNER -> "band5"; default -> "band10"; };
        List<Dtos.Segment> segs = new ArrayList<>();
        List<Dtos.Rival> rivals = new ArrayList<>();
        double unknown = 0, ownHidden = 0;
        for (Map.Entry<String, Share> e : Levels.ranking(fac)) {
            PlayerState p = s.players.get(e.getKey());
            if (p == null) continue;
            boolean self = p.id.equals(me);
            Share sh = e.getValue();
            if (self) ownHidden = sh.hidden; else unknown += sh.hidden;
            if (sh.open <= 0.05) continue;
            String prec = self ? "exact" : precision;
            segs.add(new Dtos.Segment(p.id, self ? "Te" : p.name, p.tincture, barValue(sh.open, prec), label(sh.open, prec), self, p.npc));
            if (!self && sh.open > 0.5) rivals.add(new Dtos.Rival(p.id, p.name));
        }
        String dom = Levels.dominant(fac);
        List<Map.Entry<String, Share>> rk = Levels.ranking(fac);
        String contested = dom != null && rk.size() > 1 && rk.get(1).getValue().open >= Rules.T_PARTNER ? s.players.get(rk.get(1).getKey()).tincture : null;
        return new Dtos.FactionView(f.id(), lvl.id, precision, segs, barValue(unknown, precision), unknown > 0.05 ? label(unknown, precision) : null,
            round1(ownHidden), round1(Levels.neutral(fac)), s.suspicionOf(me, city, f), dom == null ? null : s.players.get(dom).tincture, contested, rivals);
    }

    static double round1(double v) { return Math.round(v * 10) / 10.0; }

    static double barValue(double v, String precision) {
        return switch (precision) {
            case "exact" -> round1(v);
            case "band5" -> Math.round(v / 5) * 5.0;
            default -> Math.floor(v / 10) * 10 + 5;
        };
    }

    static String label(double v, String precision) {
        return switch (precision) {
            case "exact" -> RoundResolver.fmt(v);
            case "band5" -> String.valueOf(Math.round(v / 5) * 5);
            default -> { int lo = (int) Math.floor(v / 10) * 10; yield lo + "–" + Math.min(100, lo + 10); }
        };
    }

    static Dtos.Cost dto(Cost c) { return new Dtos.Cost(c.pp(), c.arany(), c.bp(), c.ke()); }

    @Transactional(readOnly = true)
    public List<Dtos.ReportView> reports(String gameId, UUID userId) {
        GameEntity g = games.findById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        PlayerEntity p = players.findByGameIdAndUserId(g.id, userId).orElseThrow(() -> ApiException.forbidden("Nem vagy tagja ennek a játéknak."));
        return reports.findTop60ByGameIdAndPlayerIdOrderByCreatedAtDesc(g.id, p.id).stream()
            .map(r -> new Dtos.ReportView(r.id.toString(), r.round, r.kind, r.confidence, r.title, r.body, r.tone, r.createdAt)).toList();
    }

    @Transactional(readOnly = true)
    public List<Dtos.RankRow> ranking(String gameId, UUID userId) {
        GameEntity g = games.findById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        Optional<PlayerEntity> me = players.findByGameIdAndUserId(g.id, userId);
        List<PlayerEntity> all = new ArrayList<>(players.findByGameId(g.id));
        all.sort(Comparator.comparingInt((PlayerEntity p) -> p.legit).reversed().thenComparing(p -> p.houseName));
        List<Dtos.RankRow> out = new ArrayList<>();
        for (int i = 0; i < all.size(); i++) {
            PlayerEntity p = all.get(i);
            out.add(new Dtos.RankRow(i + 1, p.id.toString(), p.houseName, p.tincture, p.npc, p.legit, me.map(m -> m.id.equals(p.id)).orElse(false)));
        }
        return out;
    }
}
