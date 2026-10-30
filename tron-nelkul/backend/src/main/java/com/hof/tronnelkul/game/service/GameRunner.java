package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.game.engine.*;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.i18n.Messages;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import tools.jackson.databind.json.JsonMapper;

import java.time.Instant;
import java.util.*;
import java.util.function.BiFunction;

/**
 * Loading, advancing and saving the state. Every write locks the game row, so the scheduler
 * and player orders do not overwrite each other.
 */
@Component
public class GameRunner {
    private static final Logger log = LoggerFactory.getLogger(GameRunner.class);

    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final ReportRepository reportRepository;
    private final ArchivedGameRepository archivedGameRepository;
    private final ArchivedPlayerRepository archivedPlayerRepository;
    private final ArchivedReportRepository archivedReportRepository;
    private final JsonMapper json;
    private final Messages messages;

    public GameRunner(GameRepository gameRepository, PlayerRepository playerRepository, ReportRepository reportRepository, ArchivedGameRepository archivedGameRepository,
                      ArchivedPlayerRepository archivedPlayerRepository, ArchivedReportRepository archivedReportRepository, JsonMapper json, Messages messages) {
        this.gameRepository = gameRepository; this.playerRepository = playerRepository; this.reportRepository = reportRepository;
        this.archivedGameRepository = archivedGameRepository; this.archivedPlayerRepository = archivedPlayerRepository; this.archivedReportRepository = archivedReportRepository;
        this.json = json; this.messages = messages;
    }

    public EngineState read(GameEntity game) {
        if (game.getState() == null) {
            throw ApiException.conflict("server.game_not_started");
        }
        // A state saved by an older version is upgraded (money to bronze…); it is written back at the next save
        return StateUpgrade.read(json, game.getState());
    }

    public Engine engine(GameEntity game) {
        EngineState state = read(game);
        return new Engine(MapRegistry.get(game.getMapId()), state, game.getId().hashCode() * 31L + state.seq * 7919L + state.clock);
    }

    /**
     * Locks the running game, runs the sheets and settlements due by now, then the operation, and saves
     * the result. An engine rule violation becomes a 400 error with its message (and nothing is saved).
     */
    @Transactional
    public <T> T mutate(String gameId, BiFunction<GameEntity, Engine, T> op) {
        GameEntity game = lockRunning(gameId);
        Engine engine = engine(game);
        catchUp(game, engine);
        T result;
        try {
            result = op.apply(game, engine);
        } catch (EngineException ex) {
            throw ApiException.badRequest(ex.msg());
        }
        persist(game, engine);
        return result;
    }

    /**
     * Admin: moves the game clock forward by `minutes` (null: to the next maturing sheet or settlement) and runs
     * what became due. Returns the minutes actually added.
     */
    @Transactional
    public int advanceClock(String gameId, Integer minutes) {
        return mutate(gameId, (game, engine) -> {
            int added = minutes != null ? minutes : minutesUntil(game.now().toEpochMilli(), engine.nextEventAt());
            game.setTimeOffsetMinutes(game.getTimeOffsetMinutes() + added);
            catchUp(game, engine);
            return added;
        });
    }

    /** Whole minutes from `now` to `at` (epoch ms), rounded up, at least 1. */
    static int minutesUntil(long now, long at) {
        long ms = Math.max(0, at - now);
        return (int) Math.max(1, Math.min(Integer.MAX_VALUE, (ms + 59_999) / 60_000));
    }

    /**
     * Admin: ends the season now. The Coronation Council and the archiving run as at the last settlement.
     * Returns the settlements the season had.
     */
    @Transactional
    public int endSeason(String gameId) {
        GameEntity game = lockRunning(gameId);
        Engine engine = engine(game);
        catchUp(game, engine);
        persist(game, engine, true);
        return engine.state.settlements;
    }

    private GameEntity lockRunning(String gameId) {
        GameEntity game = gameRepository.lockById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        if (game.getStatus() != GameStatus.RUNNING) {
            throw ApiException.conflict("server.game_not_running");
        }
        return game;
    }

    /** Runs the sheets and settlements due by the game clock. */
    private static void catchUp(GameEntity game, Engine engine) {
        engine.advance(game.now().toEpochMilli(), GameEntity.MATURATION_MINUTES, GameEntity.maxSettlements());
    }

    /**
     * Saves the state, the reports (texts resolved here) and the Legitimacy copy. At season end the Coronation
     * Council decides, and the game moves to the archive.
     */
    void persist(GameEntity game, Engine engine) { persist(game, engine, false); }

    /** endSeason: the season ends now, even before its last settlement. */
    private void persist(GameEntity game, Engine engine, boolean endSeason) {
        boolean over = game.getStatus() == GameStatus.RUNNING && (endSeason || engine.state.settlements >= GameEntity.maxSettlements());
        List<String> ranking = over ? finish(game, engine) : List.of();
        game.setState(json.writeValueAsString(engine.state));
        List<PlayerEntity> all = playerRepository.findByGameId(game.getId());
        for (PlayerEntity player : all) {
            EngineState.PlayerSt ps = engine.state.players.get(player.getId().toString());
            if (ps != null) {
                player.setLegit(ps.legit);
            }
        }
        List<ReportEntity> rep = new ArrayList<>();
        for (ReportOut report : engine.out) {
            Instant at = Instant.ofEpochMilli(report.at());
            String title = messages.text(report.title()), text = messages.text(report.text());
            if (report.isPublic()) {
                for (PlayerEntity player : all) {
                    if (!player.isNpc()) {
                        rep.add(new ReportEntity(game.getId(), player.getId(), engine.state.settlements, report.kind(), report.confidence(), title, text, report.tone(), true, at));
                    }
                }
            } else if (report.playerId() != null) {
                rep.add(new ReportEntity(game.getId(), UUID.fromString(report.playerId()), engine.state.settlements, report.kind(), report.confidence(), title, text, report.tone(), false, at));
            }
        }
        reportRepository.saveAll(rep);
        engine.out.clear();
        if (over) {
            archive(game, engine, ranking);
        }
    }

    /** The Coronation Council: the winner's house (or null) and the public closing report. */
    private List<String> finish(GameEntity game, Engine engine) {
        engine.coronation();
        List<String> ranking = ranking(engine);
        EngineState.PlayerSt top = ranking.isEmpty() ? null : engine.state.players.get(ranking.getFirst());
        String winner = winnerName(top);
        engine.out.add(new ReportOut(null, true, engine.state.clock, "event", null, Msg.of("server.season_end.title"),
            Msg.of("server.season_end.text", "who", winner == null ? Msg.of("server.season_end.nobody") : Msg.of("server.season_end.winner", "house", winner)), "info"));
        log.info("Game finished: {}, winner: {}", game.getId(), winner);
        return ranking;
    }

    /** Final ranking by Legitimacy, highest first; ties keep the state's order, so the winner is always the first. */
    private static List<String> ranking(Engine engine) {
        return engine.state.players.entrySet().stream().sorted(Comparator.comparingInt((Map.Entry<String, EngineState.PlayerSt> entry) -> entry.getValue().legit).reversed())
            .map(Map.Entry::getKey).toList();
    }

    private static String winnerName(EngineState.PlayerSt top) { return top == null ? null : top.name + (top.npc ? " (NPC)" : ""); }

    /** The finished game, its houses (with their final place) and reports move to the archived_* tables. */
    private void archive(GameEntity game, Engine engine, List<String> ranking) {
        archivedGameRepository.save(new ArchivedGameEntity(game, winnerName(ranking.isEmpty() ? null : engine.state.players.get(ranking.getFirst()))));
        List<PlayerEntity> ps = playerRepository.findByGameId(game.getId());
        archivedPlayerRepository.saveAll(ps.stream().map(player -> new ArchivedPlayerEntity(player, place(ranking, player))).toList());
        List<ReportEntity> rs = reportRepository.findByGameId(game.getId());
        archivedReportRepository.saveAll(rs.stream().map(ArchivedReportEntity::new).toList());
        reportRepository.deleteAll(rs);
        playerRepository.deleteAll(ps);
        gameRepository.delete(game);
        log.info("Archived: {}", game.getId());
    }

    /** 1-based place in the final ranking; a house missing from the state comes last. */
    private static int place(List<String> ranking, PlayerEntity player) {
        int index = ranking.indexOf(player.getId().toString());
        return index < 0 ? ranking.size() + 1 : index + 1;
    }
}
