package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.game.engine.*;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.MapRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import tools.jackson.databind.json.JsonMapper;

import java.time.Instant;
import java.util.*;
import java.util.function.BiFunction;

/**
 * Az állapot betöltése, előrevitele és mentése. Minden írás zárolja a játék sorát, így az ütemező
 * és a játékosok parancsai nem írják felül egymást.
 */
@Component
public class GameRunner {
    private static final Logger log = LoggerFactory.getLogger(GameRunner.class);

    private final GameRepository games;
    private final PlayerRepository players;
    private final ReportRepository reports;
    private final JsonMapper json;

    public GameRunner(GameRepository games, PlayerRepository players, ReportRepository reports, JsonMapper json) {
        this.games = games; this.players = players; this.reports = reports; this.json = json;
    }

    public EngineState read(GameEntity g) {
        if (g.state == null) throw ApiException.conflict("A játék még nem kezdődött el.");
        return json.readValue(g.state, EngineState.class);
    }

    public Engine engine(GameEntity g) {
        EngineState s = read(g);
        return new Engine(MapRegistry.get(g.mapId), s, g.id.hashCode() * 31L + s.seq * 7919L + s.clock);
    }

    /**
     * Zárolja a futó játékot, lefuttatja a mostanáig esedékes lapokat és elszámolásokat, majd a műveletet,
     * és elmenti az eredményt. A motor szabálysértése 400-as, magyar üzenetű hiba lesz (és semmi sem mentődik).
     */
    @Transactional
    public <T> T mutate(String gameId, BiFunction<GameEntity, Engine, T> op) {
        GameEntity g = games.lockById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        if (g.status != GameStatus.RUNNING) throw ApiException.conflict("A játék nem fut.");
        Engine e = engine(g);
        e.advance(g.now().toEpochMilli(), g.maturationMinutes, g.maxSettlements());
        T result;
        try {
            result = op.apply(g, e);
        } catch (EngineException ex) {
            throw ApiException.badRequest(ex.getMessage());
        }
        persist(g, e);
        return result;
    }

    /** Az állapot, a jelentések és a Legitimitás-másolat mentése; a szezon végén a Koronázási Tanács. */
    void persist(GameEntity g, Engine e) {
        if (g.status == GameStatus.RUNNING && e.s.settlements >= g.maxSettlements()) finish(g, e);
        g.state = json.writeValueAsString(e.s);
        g.settlements = e.s.settlements;
        List<PlayerEntity> all = players.findByGameId(g.id);
        for (PlayerEntity p : all) {
            EngineState.PlayerSt ps = e.s.players.get(p.id.toString());
            if (ps != null) p.legit = ps.legit;
        }
        List<ReportEntity> rep = new ArrayList<>();
        for (ReportOut r : e.out) {
            Instant at = Instant.ofEpochMilli(r.at());
            if (r.isPublic()) {
                for (PlayerEntity p : all)
                    if (!p.npc) rep.add(new ReportEntity(g.id, p.id, e.s.settlements, r.kind(), r.confidence(), r.title(), r.text(), r.tone(), true, at));
            } else if (r.playerId() != null) {
                rep.add(new ReportEntity(g.id, UUID.fromString(r.playerId()), e.s.settlements, r.kind(), r.confidence(), r.title(), r.text(), r.tone(), false, at));
            }
        }
        reports.saveAll(rep);
        e.out.clear();
    }

    private void finish(GameEntity g, Engine e) {
        e.coronation();
        EngineState.PlayerSt winner = e.s.players.values().stream().max(Comparator.comparingInt(p -> p.legit)).orElse(null);
        g.status = GameStatus.FINISHED;
        g.winner = winner == null ? null : winner.name + (winner.npc ? " (NPC)" : "");
        e.out.add(new ReportOut(null, true, e.s.clock, "esemeny", null, "A szezon véget ért",
            "A Koronázási Tanács " + (g.winner == null ? "senkit sem" : g.winner + " házát") + " ismerte el a legtöbb Legitimitással.", "info"));
        log.info("Véget ért a játék: {}, győztes: {}", g.id, g.winner);
    }
}
