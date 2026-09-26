package hu.webstar.tronnelkul.game.service;

import hu.webstar.tronnelkul.game.engine.*;
import hu.webstar.tronnelkul.game.model.*;
import hu.webstar.tronnelkul.game.world.MapDefinition;
import hu.webstar.tronnelkul.game.world.MapRegistry;
import org.springframework.stereotype.Component;

import java.util.*;

/** Az adatbázis és a szabálymotor állapota közti fordítás. */
@Component
public class GameStateStore {
    private final PlayerRepository players;
    private final RouteRepository routes;
    private final InfluenceRepository influence;
    private final CityStateRepository cityStates;
    private final SuspicionRepository suspicions;
    private final OrderRepository orders;
    private final ReportRepository reports;

    public GameStateStore(PlayerRepository players, RouteRepository routes, InfluenceRepository influence, CityStateRepository cityStates,
                          SuspicionRepository suspicions, OrderRepository orders, ReportRepository reports) {
        this.players = players; this.routes = routes; this.influence = influence; this.cityStates = cityStates;
        this.suspicions = suspicions; this.orders = orders; this.reports = reports;
    }

    public static Faction bonusFaction(PlayerEntity p) {
        if (p.npc) return p.favorite == null ? null : Faction.of(p.favorite);
        if (p.background == null) return null;
        return switch (p.background) {
            case "nemesi" -> Faction.NEMESSEG;
            case "kereskedo" -> Faction.KERESKEDOK;
            case "hadur" -> Faction.KATONASAG;
            default -> null;
        };
    }

    public EngineState load(GameEntity g) {
        MapDefinition map = MapRegistry.get(g.mapId);
        EngineState s = new EngineState(map, g.round);
        for (PlayerEntity p : players.findByGameId(g.id)) {
            PlayerState ps = new PlayerState(p.id.toString(), p.houseName, p.tincture, p.npc, p.persona,
                p.favorite == null ? null : Faction.of(p.favorite), bonusFaction(p), p.startSlot == null ? null : "birtok:" + p.startSlot);
            ps.pp = p.pp; ps.arany = p.arany; ps.bp = p.bp; ps.ke = p.ke; ps.legit = p.legit;
            ps.npcCooldown = p.npcCooldown; ps.sealedRound = p.sealedRound;
            s.players.put(ps.id, ps);
        }
        for (CityStateEntity c : cityStates.findByGameId(g.id)) s.stability.put(c.city, Stability.valueOf(c.stability));
        for (InfluenceEntity i : influence.findByGameId(g.id)) {
            Share sh = s.share(i.city, Faction.of(i.faction), i.playerId.toString());
            sh.open = i.openValue; sh.hidden = i.hiddenValue;
        }
        for (RouteEntity r : routes.findByGameId(g.id)) s.routesOf(r.playerId.toString()).add(new Edge(r.nodeA, r.nodeB));
        for (SuspicionEntity x : suspicions.findByGameId(g.id))
            s.suspicion.put(EngineState.susKey(x.playerId.toString(), x.city, Faction.of(x.faction)), new Suspicion(x.value, x.lastRound));
        for (OrderEntity o : orders.findByGameId(g.id)) {
            s.orders.add(new OrderSpec(o.playerId.toString(), ActionType.of(o.type), o.city, o.faction == null ? null : Faction.of(o.faction),
                o.hidden, o.targetId == null ? null : o.targetId.toString(), o.nodeFrom, o.nodeTo));
        }
        return s;
    }

    /** A feldolgozott állapot visszaírása. Ugyanabban a tranzakcióban kell hívni, mint a betöltést. */
    public void save(GameEntity g, EngineState s, List<ReportOut> out, int reportRound) {
        Map<String, PlayerEntity> byId = new HashMap<>();
        for (PlayerEntity p : players.findByGameId(g.id)) byId.put(p.id.toString(), p);
        for (PlayerState ps : s.players.values()) {
            PlayerEntity p = byId.get(ps.id);
            if (p == null) continue;
            p.pp = ps.pp; p.arany = ps.arany; p.bp = ps.bp; p.ke = ps.ke; p.legit = ps.legit;
            p.npcCooldown = ps.npcCooldown; p.sealedRound = ps.sealedRound;
        }
        players.saveAll(byId.values());

        influence.deleteAllForGame(g.id);
        List<InfluenceEntity> inf = new ArrayList<>();
        s.influence.forEach((city, facs) -> facs.forEach((f, map) -> map.forEach((pid, sh) -> {
            if (sh.total() >= 0.05) inf.add(new InfluenceEntity(g.id, city, f.id(), UUID.fromString(pid), sh.open, sh.hidden));
        })));
        influence.saveAll(inf);

        cityStates.deleteAllForGame(g.id);
        List<CityStateEntity> cs = new ArrayList<>();
        s.stability.forEach((city, st) -> cs.add(new CityStateEntity(g.id, city, st.name())));
        cityStates.saveAll(cs);

        suspicions.deleteAllForGame(g.id);
        List<SuspicionEntity> sus = new ArrayList<>();
        s.suspicion.forEach((key, v) -> {
            if (v.value <= 0) return;
            String[] k = key.split("\\|");
            sus.add(new SuspicionEntity(g.id, UUID.fromString(k[0]), k[1], k[2], v.value, v.lastRound));
        });
        suspicions.saveAll(sus);

        routes.deleteAllForGame(g.id);
        List<RouteEntity> rs = new ArrayList<>();
        s.routes.forEach((pid, list) -> list.forEach(e -> rs.add(new RouteEntity(g.id, UUID.fromString(pid), e.a(), e.b()))));
        routes.saveAll(rs);

        orders.deleteAllForGame(g.id);

        List<ReportEntity> rep = new ArrayList<>();
        for (ReportOut r : out) {
            if (r.playerId() == null) continue;
            rep.add(new ReportEntity(g.id, UUID.fromString(r.playerId()), reportRound, r.kind(), r.confidence(), r.title(), r.text(), r.tone()));
        }
        reports.saveAll(rep);
        g.round = s.round;
    }
}
