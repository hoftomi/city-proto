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
        return games.stream().map(g -> lobbyMapper.card(g, null, joinable.contains(g.id))).toList();
    }

    /** Finished games the user played in, newest first. */
    public List<GameSummary> archived(UUID userId) {
        return archivedPlayerRepository.findGamesOf(userId).stream().map(pg -> lobbyMapper.card(pg.game(), pg.player())).toList();
    }

    /** One live game's card for the user (details, join). */
    public GameSummary card(GameEntity g, UUID userId) {
        Optional<PlayerEntity> mine = userId == null ? Optional.empty() : playerRepository.findByGameIdAndUserId(g.id, userId);
        return lobbyMapper.card(g, mine.orElse(null), mine.isEmpty() && joinable(List.of(g)).contains(g.id));
    }

    /** One finished game's card for the user. */
    public GameSummary card(ArchivedGameEntity a, UUID userId) {
        return lobbyMapper.card(a, userId == null ? null : archivedPlayerRepository.findByGameIdAndUserId(a.id, userId).orElse(null));
    }

    /** Ids of the games a not-yet-joined user may join: open, or running inside the late-join window, and with room left. */
    private Set<String> joinable(List<GameEntity> games) {
        List<GameEntity> candidates = games.stream().filter(g -> g.status == GameStatus.OPEN || g.status == GameStatus.RUNNING).toList();
        if (candidates.isEmpty()) return Set.of();
        Map<String, Long> humans = playerRepository.countHumans(candidates.stream().map(g -> g.id).toList()).stream()
            .collect(Collectors.toMap(PlayerRepository.Headcount::getGameId, PlayerRepository.Headcount::getHumans));
        List<String> running = candidates.stream().filter(g -> g.status == GameStatus.RUNNING).map(g -> g.id).toList();
        Map<String, Integer> settlements = running.isEmpty() ? Map.of() : gameRepository.findProgress(running).stream()
            .filter(p -> p.getSettlements() != null)
            .collect(Collectors.toMap(GameRepository.Progress::getGameId, GameRepository.Progress::getSettlements));
        return candidates.stream()
            .filter(g -> humans.getOrDefault(g.id, 0L) < g.maxPlayers)
            .filter(g -> g.status == GameStatus.OPEN || settlements.getOrDefault(g.id, Integer.MAX_VALUE) <= GameEntity.LATE_JOIN_SETTLEMENTS)
            .map(g -> g.id).collect(Collectors.toSet());
    }
}
