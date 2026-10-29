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
import com.hof.tronnelkul.i18n.Messages;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class LobbyService {
    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final ArchivedGameRepository archivedGameRepository;
    private final ArchivedPlayerRepository archivedPlayerRepository;
    private final GameRunner runner;
    private final Messages messages;
    private final LobbyMapper lobbyMapper;
    private final LobbySummaryProvider lobbySummaryProvider;
    private final LobbyValidator lobbyValidator;

    public LobbyService(GameRepository gameRepository, PlayerRepository playerRepository, ArchivedGameRepository archivedGameRepository,
                        ArchivedPlayerRepository archivedPlayerRepository, GameRunner runner, Messages messages, LobbyMapper lobbyMapper,
                        LobbySummaryProvider lobbySummaryProvider, LobbyValidator lobbyValidator) {
        this.gameRepository = gameRepository; this.playerRepository = playerRepository; this.archivedGameRepository = archivedGameRepository; this.archivedPlayerRepository = archivedPlayerRepository;
        this.runner = runner; this.messages = messages; this.lobbyMapper = lobbyMapper; this.lobbySummaryProvider = lobbySummaryProvider;
        this.lobbyValidator = lobbyValidator;
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
            GameEntity game = live.get();
            int round = game.getStatus() == GameStatus.RUNNING ? runner.read(game).settlements : 0;
            return lobbyMapper.detail(game, lobbySummaryProvider.card(game, userId), round, (int) playerRepository.countByGameIdAndNpcFalse(game.getId()),
                MapRegistry.get(game.getMapId()).cities().size(), joinOptions(game.getMapId()));
        }
        ArchivedGameEntity archived = archivedGameRepository.findById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        return lobbyMapper.detail(archived, lobbySummaryProvider.card(archived, userId), (int) archivedPlayerRepository.countByGameIdAndNpcFalse(archived.getId()),
            (int) archivedPlayerRepository.countByGameIdAndNpcTrue(archived.getId()), MapRegistry.get(archived.getMapId()).cities().size(), joinOptions(archived.getMapId()));
    }

    private LobbyMapper.JoinOptions joinOptions(String mapId) {
        MapDefinition map = MapRegistry.get(mapId);
        List<StartSlotDto> starts = map.starts().stream().map(start -> {
            CityDef home = map.city(start.homeCity()).orElseThrow();
            return new StartSlotDto(start.id(), messages.text(map.startLabel(start)), start.x(), start.y(), start.neighbors(),
                start.neighbors().stream().map(node -> messages.resolve(map.nodeName(node))).toList(), messages.text(map.startNote(start)),
                home.id(), messages.text(home.label()), home.goods().stream().map(good -> new GoodOption(good.id(), messages.text(good.label()))).toList());
        }).toList();
        return new LobbyMapper.JoinOptions(starts, Backgrounds.dtos(messages));
    }

    @Transactional
    public void join(String gameId, UUID userId, JoinRequest request) {
        GameEntity game = game(gameId);
        LobbyValidator.JoinPlan plan = lobbyValidator.validateJoin(game, userId, request);
        PlayerEntity player = new PlayerEntity(game.getId(), userId, plan.houseName());
        player.setBackground(plan.background());
        player.setStartSlot(plan.slot().id());
        player.setStartGood(plan.startGood());
        player = playerRepository.save(player);
        if (plan.late()) {
            // Running game: the house enters the state at once (2.2)
            String pid = player.getId().toString();
            runner.mutate(game.getId(), (lockedGame, engine) -> { Setup.addPlayer(engine.state, pid, plan.houseName(), plan.background(), plan.slot(), plan.startGood()); return null; });
        }
    }

    @Transactional
    public void withdraw(String gameId, UUID userId) {
        GameEntity game = game(gameId);
        if (game.getStatus() != GameStatus.OPEN) {
            throw ApiException.conflict("server.withdraw_closed");
        }
        PlayerEntity player = playerRepository.findByGameIdAndUserId(game.getId(), userId).orElseThrow(() -> ApiException.notFound("server.not_joined"));
        playerRepository.delete(player);
    }

    GameEntity game(String id) { return gameRepository.findById(id).orElseThrow(() -> ApiException.notFound("server.game_not_found")); }
}
