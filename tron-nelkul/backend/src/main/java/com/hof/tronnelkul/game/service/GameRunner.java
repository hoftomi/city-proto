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

    private final GameRepository games;
    private final PlayerRepository players;
    private final ReportRepository reports;
    private final ArchivedGameRepository archivedGames;
    private final ArchivedPlayerRepository archivedPlayers;
    private final ArchivedReportRepository archivedReports;
    private final JsonMapper json;
    private final Messages messages;

    public GameRunner(GameRepository games, PlayerRepository players, ReportRepository reports, ArchivedGameRepository archivedGames,
                      ArchivedPlayerRepository archivedPlayers, ArchivedReportRepository archivedReports, JsonMapper json, Messages messages) {
        this.games = games; this.players = players; this.reports = reports;
        this.archivedGames = archivedGames; this.archivedPlayers = archivedPlayers; this.archivedReports = archivedReports;
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
        GameEntity g = games.lockById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        if (g.status != GameStatus.RUNNING) throw ApiException.conflict("server.game_not_running");
        Engine e = engine(g);
        e.advance(Instant.now().toEpochMilli(), GameEntity.MATURATION_MINUTES, GameEntity.maxSettlements());
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
     * Saves the state, the reports (texts resolved here) and the Legitimacy copy. At season end the Coronation
     * Council decides, and the game moves to the archive.
     */
    void persist(GameEntity g, Engine e) {
        boolean over = g.status == GameStatus.RUNNING && e.s.settlements >= GameEntity.maxSettlements();
        String winner = over ? finish(g, e) : null;
        g.state = json.writeValueAsString(e.s);
        List<PlayerEntity> all = players.findByGameId(g.id);
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
        reports.saveAll(rep);
        e.out.clear();
        if (over) archive(g, winner);
    }

    /** The Coronation Council: the winner's house (or null) and the public closing report. */
    private String finish(GameEntity g, Engine e) {
        e.coronation();
        EngineState.PlayerSt top = e.s.players.values().stream().max(Comparator.comparingInt(p -> p.legit)).orElse(null);
        String winner = top == null ? null : top.name + (top.npc ? " (NPC)" : "");
        e.out.add(new ReportOut(null, true, e.s.clock, "event", null, Msg.of("server.season_end.title"),
            Msg.of("server.season_end.text", "who", winner == null ? Msg.of("server.season_end.nobody") : Msg.of("server.season_end.winner", "house", winner)), "info"));
        log.info("Game finished: {}, winner: {}", g.id, winner);
        return winner;
    }

    /** The finished game, its houses and reports move to the archived_* tables. */
    private void archive(GameEntity g, String winner) {
        archivedGames.save(new ArchivedGameEntity(g, winner));
        List<PlayerEntity> ps = players.findByGameId(g.id);
        archivedPlayers.saveAll(ps.stream().map(ArchivedPlayerEntity::new).toList());
        List<ReportEntity> rs = reports.findByGameId(g.id);
        archivedReports.saveAll(rs.stream().map(ArchivedReportEntity::new).toList());
        reports.deleteAll(rs);
        players.deleteAll(ps);
        games.delete(g);
        log.info("Archived: {}", g.id);
    }
}
