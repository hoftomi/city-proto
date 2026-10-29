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

    public EngineState read(GameEntity g) {
        if (g.state == null) throw ApiException.conflict("server.game_not_started");
        return json.readValue(g.state, EngineState.class);
    }

    public Engine engine(GameEntity g) {
        EngineState s = read(g);
        return new Engine(MapRegistry.get(g.mapId), s, g.id.hashCode() * 31L + s.seq * 7919L + s.clock);
    }

    /**
     * Locks the running game, runs the sheets and settlements due by now, then the operation, and saves
     * the result. An engine rule violation becomes a 400 error with its message (and nothing is saved).
     */
    @Transactional
    public <T> T mutate(String gameId, BiFunction<GameEntity, Engine, T> op) {
        GameEntity g = lockRunning(gameId);
        Engine e = engine(g);
        catchUp(g, e);
        T result;
        try {
            result = op.apply(g, e);
        } catch (EngineException ex) {
            throw ApiException.badRequest(ex.msg());
        }
        persist(g, e);
        return result;
    }

    /**
     * Admin: moves the game clock forward by `minutes` (null: to the next maturing sheet or settlement) and runs
     * what became due. Returns the minutes actually added.
     */
    @Transactional
    public int advanceClock(String gameId, Integer minutes) {
        return mutate(gameId, (g, e) -> {
            int m = minutes != null ? minutes : minutesUntil(g.now().toEpochMilli(), e.nextEventAt());
            g.timeOffsetMinutes += m;
            catchUp(g, e);
            return m;
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
        GameEntity g = lockRunning(gameId);
        Engine e = engine(g);
        catchUp(g, e);
        persist(g, e, true);
        return e.s.settlements;
    }

    private GameEntity lockRunning(String gameId) {
        GameEntity g = gameRepository.lockById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        if (g.status != GameStatus.RUNNING) throw ApiException.conflict("server.game_not_running");
        return g;
    }

    /** Runs the sheets and settlements due by the game clock. */
    private static void catchUp(GameEntity g, Engine e) {
        e.advance(g.now().toEpochMilli(), GameEntity.MATURATION_MINUTES, GameEntity.maxSettlements());
    }

    /**
     * Saves the state, the reports (texts resolved here) and the Legitimacy copy. At season end the Coronation
     * Council decides, and the game moves to the archive.
     */
    void persist(GameEntity g, Engine e) { persist(g, e, false); }

    /** endSeason: the season ends now, even before its last settlement. */
    private void persist(GameEntity g, Engine e, boolean endSeason) {
        boolean over = g.status == GameStatus.RUNNING && (endSeason || e.s.settlements >= GameEntity.maxSettlements());
        List<String> ranking = over ? finish(g, e) : List.of();
        g.state = json.writeValueAsString(e.s);
        List<PlayerEntity> all = playerRepository.findByGameId(g.id);
        for (PlayerEntity p : all) {
            EngineState.PlayerSt ps = e.s.players.get(p.id.toString());
            if (ps != null) p.legit = ps.legit;
        }
        List<ReportEntity> rep = new ArrayList<>();
        for (ReportOut r : e.out) {
            Instant at = Instant.ofEpochMilli(r.at());
            String title = messages.text(r.title()), text = messages.text(r.text());
            if (r.isPublic()) {
                for (PlayerEntity p : all)
                    if (!p.npc) rep.add(new ReportEntity(g.id, p.id, e.s.settlements, r.kind(), r.confidence(), title, text, r.tone(), true, at));
            } else if (r.playerId() != null) {
                rep.add(new ReportEntity(g.id, UUID.fromString(r.playerId()), e.s.settlements, r.kind(), r.confidence(), title, text, r.tone(), false, at));
            }
        }
        reportRepository.saveAll(rep);
        e.out.clear();
        if (over) archive(g, e, ranking);
    }

    /** The Coronation Council: the winner's house (or null) and the public closing report. */
    private List<String> finish(GameEntity g, Engine e) {
        e.coronation();
        List<String> ranking = ranking(e);
        EngineState.PlayerSt top = ranking.isEmpty() ? null : e.s.players.get(ranking.getFirst());
        String winner = winnerName(top);
        e.out.add(new ReportOut(null, true, e.s.clock, "event", null, Msg.of("server.season_end.title"),
            Msg.of("server.season_end.text", "who", winner == null ? Msg.of("server.season_end.nobody") : Msg.of("server.season_end.winner", "house", winner)), "info"));
        log.info("Game finished: {}, winner: {}", g.id, winner);
        return ranking;
    }

    /** Final ranking by Legitimacy, highest first; ties keep the state's order, so the winner is always the first. */
    private static List<String> ranking(Engine e) {
        return e.s.players.entrySet().stream().sorted(Comparator.comparingInt((Map.Entry<String, EngineState.PlayerSt> x) -> x.getValue().legit).reversed())
            .map(Map.Entry::getKey).toList();
    }

    private static String winnerName(EngineState.PlayerSt top) { return top == null ? null : top.name + (top.npc ? " (NPC)" : ""); }

    /** The finished game, its houses (with their final place) and reports move to the archived_* tables. */
    private void archive(GameEntity g, Engine e, List<String> ranking) {
        archivedGameRepository.save(new ArchivedGameEntity(g, winnerName(ranking.isEmpty() ? null : e.s.players.get(ranking.getFirst()))));
        List<PlayerEntity> ps = playerRepository.findByGameId(g.id);
        archivedPlayerRepository.saveAll(ps.stream().map(p -> new ArchivedPlayerEntity(p, place(ranking, p))).toList());
        List<ReportEntity> rs = reportRepository.findByGameId(g.id);
        archivedReportRepository.saveAll(rs.stream().map(ArchivedReportEntity::new).toList());
        reportRepository.deleteAll(rs);
        playerRepository.deleteAll(ps);
        gameRepository.delete(g);
        log.info("Archived: {}", g.id);
    }

    /** 1-based place in the final ranking; a house missing from the state comes last. */
    private static int place(List<String> ranking, PlayerEntity p) {
        int i = ranking.indexOf(p.id.toString());
        return i < 0 ? ranking.size() + 1 : i + 1;
    }
}
