package hu.webstar.tronnelkul.game.service;

import hu.webstar.tronnelkul.common.ApiException;
import hu.webstar.tronnelkul.game.api.Dtos.*;
import hu.webstar.tronnelkul.game.engine.Rules;
import hu.webstar.tronnelkul.game.model.*;
import hu.webstar.tronnelkul.game.world.MapDefinition;
import hu.webstar.tronnelkul.game.world.MapRegistry;
import hu.webstar.tronnelkul.game.world.StartSlot;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class LobbyService {
    /** Késői csatlakozás: futó játékba az első ennyi körben még be lehet lépni (0.0.1). */
    static final int LATE_JOIN_ROUNDS = 3;

    private final GameRepository games;
    private final PlayerRepository players;
    private final RouteRepository routes;

    public LobbyService(GameRepository games, PlayerRepository players, RouteRepository routes) {
        this.games = games; this.players = players; this.routes = routes;
    }

    @Transactional(readOnly = true)
    public List<GameSummary> list(UUID userId) {
        List<GameEntity> all = new ArrayList<>(games.findAll());
        all.sort(Comparator.comparingInt((GameEntity g) -> switch (g.status) { case RUNNING -> 0; case OPEN -> 1; case ANNOUNCED -> 2; case FINISHED -> 3; })
            .thenComparing(g -> g.startsAt == null ? g.createdAt : g.startsAt));
        return all.stream().map(g -> summary(g, userId)).toList();
    }

    @Transactional(readOnly = true)
    public GameDetail detail(String gameId, UUID userId) {
        GameEntity g = game(gameId);
        MapDefinition map = MapRegistry.get(g.mapId);
        List<StartSlotDto> starts = map.starts().stream().map(s -> new StartSlotDto(s.id(), s.name(), s.x(), s.y(), s.neighbors(),
            s.neighbors().stream().map(map::nodeName).toList(), s.note())).toList();
        return new GameDetail(summary(g, userId), starts, Backgrounds.ALL, Backgrounds.TINCTURES);
    }

    @Transactional
    public GameSummary join(String gameId, UUID userId, JoinRequest r) {
        GameEntity g = game(gameId);
        boolean late = g.status == GameStatus.RUNNING && g.round <= LATE_JOIN_ROUNDS;
        if (g.status != GameStatus.OPEN && !late) throw ApiException.conflict("Ebbe a játékba most nem lehet jelentkezni.");
        if (players.findByGameIdAndUserId(g.id, userId).isPresent()) throw ApiException.conflict("Már jelentkeztél ebbe a játékba.");
        if (players.countByGameIdAndNpcFalse(g.id) >= g.maxPlayers) throw ApiException.conflict("A játék betelt.");

        String name = r.houseName() == null ? "" : r.houseName().strip().replaceAll("\\s+", " ");
        if (name.length() < 3) throw ApiException.badRequest("A ház neve legalább 3 betű legyen.");
        if (name.length() > 24) throw ApiException.badRequest("A ház neve legfeljebb 24 betű lehet.");
        if (Npcs.isNpcName(name) || players.existsByGameIdAndHouseNameIgnoreCase(g.id, name))
            throw ApiException.conflict("Ez a név ebben a játékban már foglalt.");
        if (r.tincture() == null || !Backgrounds.TINCTURES.contains(r.tincture())) throw ApiException.badRequest("Válassz tinktúrát.");
        if (Backgrounds.of(r.background()).isEmpty()) throw ApiException.badRequest("Válassz hátteret.");
        StartSlot slot = MapRegistry.get(g.mapId).start(r.startSlot()).orElseThrow(() -> ApiException.badRequest("Válassz kezdőhelyet."));

        PlayerEntity p = new PlayerEntity(g.id, userId, name, r.tincture());
        p.background = r.background();
        p.startSlot = slot.id();
        p.pp = Rules.START_PP; p.arany = Rules.START_ARANY; p.bp = Rules.START_BP; p.ke = Rules.START_KE;
        p = players.save(p);
        // 13.3: két ingyenes, azonnal aktív útvonal a birtokkal szomszédos városokba
        for (String n : slot.neighbors()) routes.save(new RouteEntity(g.id, p.id, slot.nodeId(), n));
        return summary(g, userId);
    }

    @Transactional
    public void withdraw(String gameId, UUID userId) {
        GameEntity g = game(gameId);
        if (g.status != GameStatus.OPEN) throw ApiException.conflict("A jelentkezés a kezdés után már nem vonható vissza.");
        PlayerEntity p = players.findByGameIdAndUserId(g.id, userId).orElseThrow(() -> ApiException.notFound("Nem jelentkeztél ebbe a játékba."));
        players.delete(p);
    }

    GameEntity game(String id) { return games.findById(id).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék.")); }

    GameSummary summary(GameEntity g, UUID userId) {
        MapDefinition map = MapRegistry.get(g.mapId);
        Optional<PlayerEntity> mine = userId == null ? Optional.empty() : players.findByGameIdAndUserId(g.id, userId);
        MyHouse house = mine.map(p -> new MyHouse(p.id.toString(), p.houseName, p.tincture, p.background,
            Backgrounds.of(p.background).map(BackgroundDto::name).orElse(null), p.startSlot)).orElse(null);
        Integer place = null;
        if (mine.isPresent() && g.status == GameStatus.FINISHED) {
            List<PlayerEntity> all = new ArrayList<>(players.findByGameId(g.id));
            all.sort(Comparator.comparingInt((PlayerEntity p) -> p.legit).reversed());
            for (int i = 0; i < all.size(); i++) if (all.get(i).id.equals(mine.get().id)) place = i + 1;
        }
        return new GameSummary(g.id, g.name, g.season, g.status.apiId, g.mapId, g.startsAt, g.opensAt, g.days, g.roundsPerDay, g.round,
            g.maxRounds(), (int) players.countByGameIdAndNpcFalse(g.id), g.maxPlayers, map.cities().size(), g.npcCount, g.tagList(),
            g.winner, place, house);
    }
}
