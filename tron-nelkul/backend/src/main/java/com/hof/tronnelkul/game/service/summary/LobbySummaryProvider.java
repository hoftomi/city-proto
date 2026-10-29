package com.hof.tronnelkul.game.service.summary;

import com.hof.tronnelkul.api.model.GameSummary;
import com.hof.tronnelkul.game.mapper.LobbyMapper;
import com.hof.tronnelkul.game.model.*;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

/**
 * The lobby's game cards. The own games start from the user's player rows (one query, already sorted), the available
 * games need no house, and whether they can be joined is computed with two grouped queries for the whole list.
 */
@Component
public class LobbySummaryProvider {
    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final ArchivedPlayerRepository archivedPlayerRepository;
    private final LobbyMapper lobbyMapper;

    public LobbySummaryProvider(GameRepository gameRepository, PlayerRepository playerRepository, ArchivedPlayerRepository archivedPlayerRepository,
                                LobbyMapper lobbyMapper) {
        this.gameRepository = gameRepository; this.playerRepository = playerRepository; this.archivedPlayerRepository = archivedPlayerRepository;
        this.lobbyMapper = lobbyMapper;
    }

    /** Live games the user joined, in lobby order. */
    public List<GameSummary> joined(UUID userId) {
        return playerRepository.findGamesOf(userId).stream().map(pg -> lobbyMapper.card(pg.game(), pg.player(), false)).toList();
    }

    /** Live games the user has not joined, in lobby order. */
    public List<GameSummary> available(UUID userId) {
        List<GameEntity> games = gameRepository.findNotJoined(userId);
        Set<String> joinable = joinable(games);
        return games.stream().map(game -> lobbyMapper.card(game, null, joinable.contains(game.getId()))).toList();
    }

    /** Finished games the user played in, newest first. */
    public List<GameSummary> archived(UUID userId) {
        return archivedPlayerRepository.findGamesOf(userId).stream().map(pg -> lobbyMapper.card(pg.game(), pg.player())).toList();
    }

    /** One live game's card for the user (details, join). */
    public GameSummary card(GameEntity game, UUID userId) {
        Optional<PlayerEntity> mine = userId == null ? Optional.empty() : playerRepository.findByGameIdAndUserId(game.getId(), userId);
        return lobbyMapper.card(game, mine.orElse(null), mine.isEmpty() && joinable(List.of(game)).contains(game.getId()));
    }

    /** One finished game's card for the user. */
    public GameSummary card(ArchivedGameEntity archived, UUID userId) {
        return lobbyMapper.card(archived, userId == null ? null : archivedPlayerRepository.findByGameIdAndUserId(archived.getId(), userId).orElse(null));
    }

    /** Ids of the games a not-yet-joined user may join: open, or running inside the late-join window, and with room left. */
    private Set<String> joinable(List<GameEntity> games) {
        List<GameEntity> candidates = games.stream().filter(game -> game.getStatus() == GameStatus.OPEN || game.getStatus() == GameStatus.RUNNING).toList();
        if (candidates.isEmpty()) {
            return Set.of();
        }
        Map<String, Long> humans = playerRepository.countHumans(candidates.stream().map(game -> game.getId()).toList()).stream()
            .collect(Collectors.toMap(PlayerRepository.Headcount::getGameId, PlayerRepository.Headcount::getHumans));
        List<String> running = candidates.stream().filter(game -> game.getStatus() == GameStatus.RUNNING).map(game -> game.getId()).toList();
        Map<String, Integer> settlements = running.isEmpty() ? Map.of() : gameRepository.findProgress(running).stream()
            .filter(progress -> progress.getSettlements() != null)
            .collect(Collectors.toMap(GameRepository.Progress::getGameId, GameRepository.Progress::getSettlements));
        return candidates.stream()
            .filter(game -> humans.getOrDefault(game.getId(), 0L) < game.getMaxPlayers())
            .filter(game -> game.getStatus() == GameStatus.OPEN || settlements.getOrDefault(game.getId(), Integer.MAX_VALUE) <= GameEntity.LATE_JOIN_SETTLEMENTS)
            .map(GameEntity::getId).collect(Collectors.toSet());
    }
}
