package hu.webstar.tronnelkul.game.service;

import hu.webstar.tronnelkul.common.ApiException;
import hu.webstar.tronnelkul.game.api.Dtos.OrderRequest;
import hu.webstar.tronnelkul.game.engine.*;
import hu.webstar.tronnelkul.game.model.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/** Parancsok felvétele, törlése és a parancslap lepecsételése. */
@Service
public class OrderService {
    private final GameRepository games;
    private final PlayerRepository players;
    private final OrderRepository orders;
    private final GameStateStore store;

    public OrderService(GameRepository games, PlayerRepository players, OrderRepository orders, GameStateStore store) {
        this.games = games; this.players = players; this.orders = orders; this.store = store;
    }

    private record Ctx(GameEntity game, PlayerEntity player) {}

    private Ctx ctx(String gameId, UUID userId) {
        GameEntity g = games.findById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        if (g.status != GameStatus.RUNNING) throw ApiException.conflict("A játék nem fut.");
        PlayerEntity p = players.findByGameIdAndUserId(g.id, userId).orElseThrow(() -> ApiException.forbidden("Nem vagy tagja ennek a játéknak."));
        return new Ctx(g, p);
    }

    @Transactional
    public void add(String gameId, UUID userId, OrderRequest r) {
        Ctx c = ctx(gameId, userId);
        if (c.player().sealedRound == c.game().round) throw ApiException.conflict("A parancslap le van pecsételve. Előbb törd fel a pecsétet.");
        ActionType type;
        try { type = ActionType.of(r.type()); } catch (IllegalArgumentException e) { throw ApiException.badRequest("Ismeretlen akció."); }
        EngineState s = store.load(c.game());
        String me = c.player().id.toString();
        Map<String, Integer> net = Network.of(s, me);
        OrderEntity o = new OrderEntity(c.game().id, c.player().id, c.game().round, type.id());

        if (type == ActionType.ROUTE) {
            if (r.from() == null || r.to() == null || !s.map.hasEdge(r.from(), r.to())) throw ApiException.badRequest("Ezen a két helyen között nincs út.");
            if (!net.containsKey(r.from())) throw ApiException.badRequest("Útvonalat csak a hálózatodból indíthatsz (4.2).");
            if (!s.map.isCity(r.to())) throw ApiException.badRequest("Útvonal csak városállamba vezethet.");
            if (Network.owns(s, me, r.from(), r.to())) throw ApiException.conflict("Ez az útvonal már a tiéd.");
            long pendingRoutes = orders.findByGameIdAndPlayerIdOrderByCreatedAtAsc(c.game().id, c.player().id).stream().filter(x -> x.type.equals("route")).count();
            if (s.routesOf(me).size() + pendingRoutes >= Rules.ROUTE_MAX + 2)
                throw ApiException.conflict("Elérted az útvonalak felső korlátját.");
            o.nodeFrom = r.from(); o.nodeTo = r.to();
        } else {
            if (r.city() == null || s.map.city(r.city()).isEmpty()) throw ApiException.badRequest("Ismeretlen város.");
            if (!net.containsKey(r.city())) throw ApiException.badRequest("Akciót csak a hálózatodban lévő városban indíthatsz (4.3). Építs előbb útvonalat.");
            Faction f;
            try { f = Faction.of(r.faction()); } catch (IllegalArgumentException e) { throw ApiException.badRequest("Ismeretlen frakció."); }
            if (!type.factions.contains(f)) throw ApiException.badRequest(type.label + " nem indítható a " + f.label() + " körében.");
            if (type.needsPresence) {
                Share own = s.fac(r.city(), f).get(me);
                if (own == null || own.open < Rules.T_JELENLET) throw ApiException.badRequest("Ehhez legalább Jelenlét (10 nyílt befolyás) kell.");
            }
            if (type == ActionType.SMEAR) {
                if (r.targetId() == null) throw ApiException.badRequest("Válassz célpontot.");
                Share t = s.fac(r.city(), f).get(r.targetId());
                if (r.targetId().equals(me) || t == null || t.open <= 0.5) throw ApiException.badRequest("A célpontnak nincs nyílt befolyása ebben a frakcióban.");
                o.targetId = UUID.fromString(r.targetId());
            }
            o.city = r.city(); o.faction = f.id();
            o.hidden = Boolean.TRUE.equals(r.hidden()) && type.isGain();
        }

        Cost need = type.cost(o.hidden);
        for (OrderEntity x : orders.findByGameIdAndPlayerIdOrderByCreatedAtAsc(c.game().id, c.player().id))
            need = need.plus(ActionType.of(x.type).cost(x.hidden));
        PlayerEntity p = c.player();
        if (need.pp() > p.pp) throw ApiException.badRequest("Nincs elég parancspont: " + need.pp() + " kellene, " + p.pp + " van.");
        if (need.arany() > p.arany) throw ApiException.badRequest("Nincs elég arany: " + need.arany() + " kellene, " + p.arany + " van.");
        if (need.bp() > p.bp) throw ApiException.badRequest("Nincs elég befolyáspont: " + need.bp() + " kellene, " + p.bp + " van.");
        if (need.ke() > p.ke) throw ApiException.badRequest("Nincs elég katonai erő: " + need.ke() + " kellene, " + p.ke + " van.");
        orders.save(o);
    }

    @Transactional
    public void remove(String gameId, UUID userId, UUID orderId) {
        Ctx c = ctx(gameId, userId);
        if (c.player().sealedRound == c.game().round) throw ApiException.conflict("A parancslap le van pecsételve.");
        OrderEntity o = orders.findByIdAndPlayerId(orderId, c.player().id).orElseThrow(() -> ApiException.notFound("Nincs ilyen parancs."));
        orders.delete(o);
    }

    @Transactional
    public void seal(String gameId, UUID userId, boolean sealed) {
        Ctx c = ctx(gameId, userId);
        List<OrderEntity> mine = orders.findByGameIdAndPlayerIdOrderByCreatedAtAsc(c.game().id, c.player().id);
        if (sealed && mine.isEmpty()) throw ApiException.badRequest("Üres parancslapot nem lehet lepecsételni.");
        c.player().sealedRound = sealed ? c.game().round : 0;
        players.save(c.player());
    }
}
