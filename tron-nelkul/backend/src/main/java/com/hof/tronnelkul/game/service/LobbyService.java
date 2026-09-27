package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.game.engine.Setup;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.game.world.StartSlot;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class LobbyService {
    /** Késői csatlakozás: futó játékba az első ennyi elszámolásig még be lehet lépni. */
    static final int LATE_JOIN_SETTLEMENTS = 3;
    /** A ProblemDetail `code` mezője, ha a ház neve hibás vagy foglalt (a kliens a névmezőhöz lép vissza). */
    static final String HOUSE_NAME = "house_name";

    private final GameRepository games;
    private final PlayerRepository players;
    private final GameRunner runner;

    public LobbyService(GameRepository games, PlayerRepository players, GameRunner runner) {
        this.games = games; this.players = players; this.runner = runner;
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
        List<StartSlotDto> starts = map.starts().stream().map(s -> {
            CityDef home = map.city(s.homeCity()).orElseThrow();
            return new StartSlotDto(s.id(), s.name(), s.x(), s.y(), s.neighbors(), s.neighbors().stream().map(map::nodeName).toList(), s.note(),
                home.id(), home.name(), home.goods().stream().map(gd -> new GoodOption(gd.id(), gd.name())).toList());
        }).toList();
        return new GameDetail(summary(g, userId), starts, Backgrounds.ALL, Backgrounds.TINCTURES);
    }

    @Transactional
    public GameSummary join(String gameId, UUID userId, JoinRequest r) {
        GameEntity g = game(gameId);
        boolean late = g.status == GameStatus.RUNNING && g.settlements <= LATE_JOIN_SETTLEMENTS;
        if (g.status != GameStatus.OPEN && !late) throw ApiException.conflict("Ebbe a játékba most nem lehet jelentkezni.");
        if (players.findByGameIdAndUserId(g.id, userId).isPresent()) throw ApiException.conflict("Már jelentkeztél ebbe a játékba.");
        if (players.countByGameIdAndNpcFalse(g.id) >= g.maxPlayers) throw ApiException.conflict("A játék betelt.");

        String name = r.getHouseName() == null ? "" : r.getHouseName().strip().replaceAll("\\s+", " ");
        if (name.length() < 3) throw ApiException.badRequest("A ház neve legalább 3 betű legyen.").withCode(HOUSE_NAME);
        if (name.length() > 24) throw ApiException.badRequest("A ház neve legfeljebb 24 betű lehet.").withCode(HOUSE_NAME);
        if (Npcs.isNpcName(name) || players.existsByGameIdAndHouseNameIgnoreCase(g.id, name))
            throw ApiException.conflict("Ez a név ebben a játékban már foglalt.").withCode(HOUSE_NAME);
        if (r.getTincture() == null || !Backgrounds.TINCTURES.contains(r.getTincture())) throw ApiException.badRequest("Válassz tinktúrát.");
        if (Backgrounds.of(r.getBackground()).isEmpty()) throw ApiException.badRequest("Válassz hátteret.");
        MapDefinition map = MapRegistry.get(g.mapId);
        StartSlot slot = map.start(r.getStartSlot()).orElseThrow(() -> ApiException.badRequest("Válassz kezdőhelyet."));
        String startGood = null;
        if ("kereskedo".equals(r.getBackground())) {
            CityDef home = map.city(slot.homeCity()).orElseThrow();
            if (r.getStartGood() == null || home.goods().stream().noneMatch(gd -> gd.id().equals(r.getStartGood())))
                throw ApiException.badRequest("Válaszd ki, melyik árucikkből kapsz részesedést (" + home.name() + ").");
            startGood = r.getStartGood();
        }

        PlayerEntity p = new PlayerEntity(g.id, userId, name, r.getTincture());
        p.background = r.getBackground();
        p.startSlot = slot.id();
        p.startGood = startGood;
        p = players.save(p);
        if (late) {
            // Futó játék: a ház azonnal bekerül az állapotba (2.2)
            String pid = p.id.toString(), sg = startGood;
            runner.mutate(g.id, (gg, e) -> { Setup.addPlayer(e.s, pid, name, r.getTincture(), r.getBackground(), slot, sg); return null; });
        }
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
            Backgrounds.of(p.background).map(BackgroundDto::getName).orElse(null), p.startSlot)).orElse(null);
        Integer place = null;
        if (mine.isPresent() && g.status == GameStatus.FINISHED) {
            List<PlayerEntity> all = new ArrayList<>(players.findByGameId(g.id));
            all.sort(Comparator.comparingInt((PlayerEntity p) -> p.legit).reversed());
            for (int i = 0; i < all.size(); i++) if (all.get(i).id.equals(mine.get().id)) place = i + 1;
        }
        return new GameSummary(g.id, g.name, g.season, g.status.apiId, g.mapId, g.startsAt, g.opensAt, g.days, g.roundsPerDay, g.settlements,
            g.maxSettlements(), (int) players.countByGameIdAndNpcFalse(g.id), g.maxPlayers, map.cities().size(), g.npcCount, g.tagList(),
            g.winner, place, house);
    }
}
