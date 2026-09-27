package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.game.engine.*;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** Játék indítása, az óra előrevitele (ütemező), és a fejlesztői időkezelés. */
@Service
public class GameLifecycleService {
    private static final Logger log = LoggerFactory.getLogger(GameLifecycleService.class);

    private final GameRepository games;
    private final PlayerRepository players;
    private final GameRunner runner;

    public GameLifecycleService(GameRepository games, PlayerRepository players, GameRunner runner) {
        this.games = games; this.players = players; this.runner = runner;
    }

    /** Elindít egy nyitott játékot: városok, NPC-házak, a jelentkezők induló állása. */
    @Transactional
    public void start(String gameId) {
        GameEntity g = games.lockById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        if (g.status == GameStatus.RUNNING) return;
        if (g.status != GameStatus.OPEN) throw ApiException.conflict("Csak nyitott játék indítható.");
        MapDefinition map = MapRegistry.get(g.mapId);
        EngineState s = Setup.initial(map, g.now().toEpochMilli());
        for (int i = 0; i < Math.min(g.npcCount, Npcs.ALL.size()); i++) {
            Npcs.Template t = Npcs.ALL.get(i);
            PlayerEntity p = new PlayerEntity(g.id, null, t.name(), t.tincture());
            p.npc = true; p.persona = t.persona();
            p = players.save(p);
            Setup.addNpc(s, map, i, p.id.toString(), t.name(), t.tincture(), t.persona());
        }
        Engine e = new Engine(map, s, g.id.hashCode());
        for (PlayerEntity p : players.findByGameId(g.id)) {
            if (p.npc) continue;
            Setup.addPlayer(s, p.id.toString(), p.houseName, p.tincture, p.background, map.start(p.startSlot).orElseThrow(), p.startGood);
            e.out.add(new ReportOut(p.id.toString(), false, s.clock, "esemeny", null, "Elkezdődött a szezon",
                "A " + map.name() + " városai várják a házakat. Az első elszámolás " + Time.fmt(Time.nextSettlement(s.clock)) + "-kor lesz.", "info"));
        }
        e.scheduleNpcs();
        g.status = GameStatus.RUNNING;
        runner.persist(g, e);
        log.info("Elindult a játék: {}", g.id);
    }

    /** Az ütemező hívja: lefuttatja a mostanáig esedékes érlelő lapokat és elszámolásokat. */
    public void tick(String gameId) { runner.mutate(gameId, (g, e) -> null); }

    /** Fejlesztéshez (ADMIN): azonnali elszámolás. */
    public int settleNow(String gameId) {
        return runner.mutate(gameId, (g, e) -> { e.settleNow(g.maturationMinutes); return e.s.settlements; });
    }

    /**
     * Fejlesztéshez (ADMIN): a játék órájának előretekerése. minutes = null: a következő eseményig
     * (érlelő lap vagy elszámolás). A valódi időhöz képesti eltolás a játékban megmarad.
     */
    @Transactional
    public int advance(String gameId, Integer minutes) {
        GameEntity g = games.lockById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        if (g.status != GameStatus.RUNNING) throw ApiException.conflict("A játék nem fut.");
        int step = minutes != null ? minutes : nextEventInMinutes(g);
        if (step < 1 || step > 7 * 24 * 60) throw ApiException.badRequest("1 perc és 7 nap között tekerhetsz előre.");
        g.timeOffsetMinutes += step;
        runner.mutate(gameId, (x, e) -> null);
        return step;
    }

    private int nextEventInMinutes(GameEntity g) {
        Engine e = runner.engine(g);
        e.advance(g.now().toEpochMilli(), g.maturationMinutes, g.maxSettlements());
        long ms = e.nextEventAt() - g.now().toEpochMilli();
        return (int) Math.max(1, Math.ceil(ms / 60_000.0));
    }
}
