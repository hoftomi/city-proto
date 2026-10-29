package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.game.engine.Setup;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.game.world.StartSlot;
import com.hof.tronnelkul.i18n.Messages;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class LobbyService {
    /** Late join: a running game can still be joined up to this many settlements. */
    static final int LATE_JOIN_SETTLEMENTS = 3;
    /** ProblemDetail `code` when the house name is invalid or taken (the client returns to the name field). */
    static final String HOUSE_NAME = "house_name";

    private final GameRepository games;
    private final PlayerRepository players;
    private final ArchivedGameRepository archivedGames;
    private final ArchivedPlayerRepository archivedPlayers;
    private final GameRunner runner;
    private final Messages messages;

    public LobbyService(GameRepository games, PlayerRepository players, ArchivedGameRepository archivedGames,
                        ArchivedPlayerRepository archivedPlayers, GameRunner runner, Messages messages) {
        this.games = games; this.players = players; this.archivedGames = archivedGames; this.archivedPlayers = archivedPlayers;
        this.runner = runner; this.messages = messages;
    }

    @Transactional(readOnly = true)
    public List<GameSummary> list(UUID userId) {
        List<GameEntity> all = new ArrayList<>(games.findAll());
        all.sort(Comparator.comparingInt((GameEntity g) -> switch (g.status) { case RUNNING -> 0; case OPEN -> 1; case ANNOUNCED -> 2; })
            .thenComparing(g -> g.closesAt == null ? g.createdAt : g.closesAt));
        List<ArchivedGameEntity> archived = new ArrayList<>(archivedGames.findAll());
        archived.sort(Comparator.comparing((ArchivedGameEntity a) -> a.createdAt).reversed());
        List<GameSummary> out = new ArrayList<>(all.stream().map(g -> summary(g, userId)).toList());
        out.addAll(archived.stream().map(a -> summary(a, userId)).toList());
        return out;
    }

    @Transactional(readOnly = true)
    public GameDetail detail(String gameId, UUID userId) {
        Optional<GameEntity> live = games.findById(gameId);
        GameSummary summary = live.map(g -> summary(g, userId)).orElseGet(() -> summary(archivedGames.findById(gameId)
            .orElseThrow(() -> ApiException.notFound("server.game_not_found")), userId));
        MapDefinition map = MapRegistry.get(summary.getMapId());
        List<StartSlotDto> starts = map.starts().stream().map(s -> {
            CityDef home = map.city(s.homeCity()).orElseThrow();
            return new StartSlotDto(s.id(), messages.text(map.startLabel(s)), s.x(), s.y(), s.neighbors(),
                s.neighbors().stream().map(n -> messages.resolve(map.nodeName(n))).toList(), messages.text(map.startNote(s)),
                home.id(), messages.text(home.label()), home.goods().stream().map(gd -> new GoodOption(gd.id(), messages.text(gd.label()))).toList());
        }).toList();
        return new GameDetail(summary, starts, Backgrounds.dtos(messages), Backgrounds.TINCTURES);
    }

    @Transactional
    public GameSummary join(String gameId, UUID userId, JoinRequest r) {
        GameEntity g = game(gameId);
        boolean late = g.status == GameStatus.RUNNING && runner.read(g).settlements <= LATE_JOIN_SETTLEMENTS;
        if (g.status != GameStatus.OPEN && !late) throw ApiException.conflict("server.join_closed");
        if (players.findByGameIdAndUserId(g.id, userId).isPresent()) throw ApiException.conflict("server.already_joined");
        if (players.countByGameIdAndNpcFalse(g.id) >= g.maxPlayers) throw ApiException.conflict("server.game_full");

        String name = r.getHouseName() == null ? "" : r.getHouseName().strip().replaceAll("\\s+", " ");
        if (name.length() < 3) throw ApiException.badRequest("server.house_name_short", "min", 3).withCode(HOUSE_NAME);
        if (name.length() > 24) throw ApiException.badRequest("server.house_name_long", "max", 24).withCode(HOUSE_NAME);
        if (isNpcName(name) || players.existsByGameIdAndHouseNameIgnoreCase(g.id, name))
            throw ApiException.conflict("server.house_name_taken").withCode(HOUSE_NAME);
        if (r.getTincture() == null || !Backgrounds.TINCTURES.contains(r.getTincture())) throw ApiException.badRequest("server.pick_tincture");
        if (!Backgrounds.exists(r.getBackground())) throw ApiException.badRequest("server.pick_background");
        MapDefinition map = MapRegistry.get(g.mapId);
        StartSlot slot = map.start(r.getStartSlot()).orElseThrow(() -> ApiException.badRequest("server.pick_start_slot"));
        String startGood = null;
        if ("merchant".equals(r.getBackground())) {
            CityDef home = map.city(slot.homeCity()).orElseThrow();
            if (r.getStartGood() == null || home.goods().stream().noneMatch(gd -> gd.id().equals(r.getStartGood())))
                throw ApiException.badRequest("server.pick_start_good", "city", home.label());
            startGood = r.getStartGood();
        }

        PlayerEntity p = new PlayerEntity(g.id, userId, name, r.getTincture());
        p.background = r.getBackground();
        p.startSlot = slot.id();
        p.startGood = startGood;
        p = players.save(p);
        if (late) {
            // Running game: the house enters the state at once (2.2)
            String pid = p.id.toString(), sg = startGood;
            runner.mutate(g.id, (gg, e) -> { Setup.addPlayer(e.s, pid, name, r.getTincture(), r.getBackground(), slot, sg); return null; });
        }
        return summary(g, userId);
    }

    @Transactional
    public void withdraw(String gameId, UUID userId) {
        GameEntity g = game(gameId);
        if (g.status != GameStatus.OPEN) throw ApiException.conflict("server.withdraw_closed");
        PlayerEntity p = players.findByGameIdAndUserId(g.id, userId).orElseThrow(() -> ApiException.notFound("server.not_joined"));
        players.delete(p);
    }

    GameEntity game(String id) { return games.findById(id).orElseThrow(() -> ApiException.notFound("server.game_not_found")); }

    GameSummary summary(GameEntity g, UUID userId) {
        MapDefinition map = MapRegistry.get(g.mapId);
        MyHouse house = userId == null ? null : players.findByGameIdAndUserId(g.id, userId)
            .map(p -> myHouse(p.id, p.houseName, p.tincture, p.background, p.startSlot)).orElse(null);
        int round = g.status == GameStatus.RUNNING ? runner.read(g).settlements : 0;
        return new GameSummary(g.id, g.name, g.status.apiId, g.mapId, g.closesAt, g.opensAt, round, GameEntity.maxSettlements(),
            (int) players.countByGameIdAndNpcFalse(g.id), g.maxPlayers, map.cities().size(), g.npcCount, g.tagList(), null, null, house);
    }

    /** Finished game: the winner, and your placing by Legitimacy if you played in it. */
    GameSummary summary(ArchivedGameEntity a, UUID userId) {
        MapDefinition map = MapRegistry.get(a.mapId);
        Optional<ArchivedPlayerEntity> mine = userId == null ? Optional.empty() : archivedPlayers.findByGameIdAndUserId(a.id, userId);
        MyHouse house = mine.map(p -> myHouse(p.id, p.houseName, p.tincture, p.background, p.startSlot)).orElse(null);
        Integer place = null;
        if (mine.isPresent()) {
            List<ArchivedPlayerEntity> all = new ArrayList<>(archivedPlayers.findByGameId(a.id));
            all.sort(Comparator.comparingInt((ArchivedPlayerEntity p) -> p.legit).reversed());
            for (int i = 0; i < all.size(); i++) if (all.get(i).id.equals(mine.get().id)) place = i + 1;
        }
        int houses = (int) archivedPlayers.countByGameIdAndNpcFalse(a.id);
        return new GameSummary(a.id, a.name, GameStatus.FINISHED_API_ID, a.mapId, null, a.opensAt, GameEntity.maxSettlements(),
            GameEntity.maxSettlements(), houses, houses, map.cities().size(), (int) archivedPlayers.countByGameIdAndNpcTrue(a.id), a.tagList(),
            a.winner, place, house);
    }

    private MyHouse myHouse(UUID id, String houseName, String tincture, String background, String startSlot) {
        return new MyHouse(id.toString(), houseName, tincture, background, Backgrounds.exists(background) ? Backgrounds.name(messages, background) : null, startSlot);
    }

    /** NPC house names are reserved. */
    private boolean isNpcName(String name) { return Npcs.ALL.stream().anyMatch(t -> messages.text(t.label()).equalsIgnoreCase(name.strip())); }
}
