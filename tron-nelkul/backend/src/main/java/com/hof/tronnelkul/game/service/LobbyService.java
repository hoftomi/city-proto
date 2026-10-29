package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.game.engine.Setup;
import com.hof.tronnelkul.game.mapper.LobbyMapper;
import com.hof.tronnelkul.game.service.summary.LobbySummaryProvider;
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
    /** ProblemDetail `code` when the house name is invalid or taken (the client returns to the name field). */
    static final String HOUSE_NAME = "house_name";

    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final ArchivedGameRepository archivedGameRepository;
    private final ArchivedPlayerRepository archivedPlayerRepository;
    private final GameRunner runner;
    private final Messages messages;
    private final LobbyMapper lobbyMapper;
    private final LobbySummaryProvider lobbySummaryProvider;

    public LobbyService(GameRepository gameRepository, PlayerRepository playerRepository, ArchivedGameRepository archivedGameRepository,
                        ArchivedPlayerRepository archivedPlayerRepository, GameRunner runner, Messages messages, LobbyMapper lobbyMapper,
                        LobbySummaryProvider lobbySummaryProvider) {
        this.gameRepository = gameRepository; this.playerRepository = playerRepository; this.archivedGameRepository = archivedGameRepository; this.archivedPlayerRepository = archivedPlayerRepository;
        this.runner = runner; this.messages = messages; this.lobbyMapper = lobbyMapper; this.lobbySummaryProvider = lobbySummaryProvider;
    }

    /** Live games the user joined (running, open, announced), in lobby order. */
    @Transactional(readOnly = true)
    public List<GameSummary> joined(UUID userId) { return lobbySummaryProvider.joined(userId); }

    /** Live games the user has not joined, in lobby order. */
    @Transactional(readOnly = true)
    public List<GameSummary> available(UUID userId) { return lobbySummaryProvider.available(userId); }

    /** Finished games the user played in, newest first. */
    @Transactional(readOnly = true)
    public List<GameSummary> archived(UUID userId) { return lobbySummaryProvider.archived(userId); }

    @Transactional(readOnly = true)
    public GameDetail detail(String gameId, UUID userId) {
        Optional<GameEntity> live = gameRepository.findById(gameId);
        if (live.isPresent()) {
            GameEntity g = live.get();
            int round = g.status == GameStatus.RUNNING ? runner.read(g).settlements : 0;
            return lobbyMapper.detail(g, lobbySummaryProvider.card(g, userId), round, (int) playerRepository.countByGameIdAndNpcFalse(g.id),
                MapRegistry.get(g.mapId).cities().size(), joinOptions(g.mapId));
        }
        ArchivedGameEntity a = archivedGameRepository.findById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        return lobbyMapper.detail(a, lobbySummaryProvider.card(a, userId), (int) archivedPlayerRepository.countByGameIdAndNpcFalse(a.id),
            (int) archivedPlayerRepository.countByGameIdAndNpcTrue(a.id), MapRegistry.get(a.mapId).cities().size(), joinOptions(a.mapId));
    }

    private LobbyMapper.JoinOptions joinOptions(String mapId) {
        MapDefinition map = MapRegistry.get(mapId);
        List<StartSlotDto> starts = map.starts().stream().map(s -> {
            CityDef home = map.city(s.homeCity()).orElseThrow();
            return new StartSlotDto(s.id(), messages.text(map.startLabel(s)), s.x(), s.y(), s.neighbors(),
                s.neighbors().stream().map(n -> messages.resolve(map.nodeName(n))).toList(), messages.text(map.startNote(s)),
                home.id(), messages.text(home.label()), home.goods().stream().map(gd -> new GoodOption(gd.id(), messages.text(gd.label()))).toList());
        }).toList();
        return new LobbyMapper.JoinOptions(starts, Backgrounds.dtos(messages), Backgrounds.TINCTURES);
    }

    @Transactional
    public GameSummary join(String gameId, UUID userId, JoinRequest r) {
        GameEntity g = game(gameId);
        boolean late = g.status == GameStatus.RUNNING && runner.read(g).settlements <= GameEntity.LATE_JOIN_SETTLEMENTS;
        if (g.status != GameStatus.OPEN && !late) throw ApiException.conflict("server.join_closed");
        if (playerRepository.findByGameIdAndUserId(g.id, userId).isPresent()) throw ApiException.conflict("server.already_joined");
        if (playerRepository.countByGameIdAndNpcFalse(g.id) >= g.maxPlayers) throw ApiException.conflict("server.game_full");

        String name = r.getHouseName() == null ? "" : r.getHouseName().strip().replaceAll("\\s+", " ");
        if (name.length() < 3) throw ApiException.badRequest("server.house_name_short", "min", 3).withCode(HOUSE_NAME);
        if (name.length() > 24) throw ApiException.badRequest("server.house_name_long", "max", 24).withCode(HOUSE_NAME);
        if (isNpcName(name) || playerRepository.existsByGameIdAndHouseNameIgnoreCase(g.id, name))
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
        p = playerRepository.save(p);
        if (late) {
            // Running game: the house enters the state at once (2.2)
            String pid = p.id.toString(), sg = startGood;
            runner.mutate(g.id, (gg, e) -> { Setup.addPlayer(e.s, pid, name, r.getTincture(), r.getBackground(), slot, sg); return null; });
        }
        return lobbySummaryProvider.card(g, userId);
    }

    @Transactional
    public void withdraw(String gameId, UUID userId) {
        GameEntity g = game(gameId);
        if (g.status != GameStatus.OPEN) throw ApiException.conflict("server.withdraw_closed");
        PlayerEntity p = playerRepository.findByGameIdAndUserId(g.id, userId).orElseThrow(() -> ApiException.notFound("server.not_joined"));
        playerRepository.delete(p);
    }

    GameEntity game(String id) { return gameRepository.findById(id).orElseThrow(() -> ApiException.notFound("server.game_not_found")); }

    /** NPC house names are reserved. */
    private boolean isNpcName(String name) { return Npcs.ALL.stream().anyMatch(t -> messages.text(t.label()).equalsIgnoreCase(name.strip())); }
}
