package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.game.engine.*;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.i18n.Messages;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

/** Starting a game, advancing the clock (scheduler), and the development immediate settlement. */
@Service
public class GameLifecycleService {
    private static final Logger log = LoggerFactory.getLogger(GameLifecycleService.class);

    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final GameRunner runner;
    private final Messages messages;

    public GameLifecycleService(GameRepository gameRepository, PlayerRepository playerRepository, GameRunner runner, Messages messages) {
        this.gameRepository = gameRepository; this.playerRepository = playerRepository; this.runner = runner; this.messages = messages;
    }

    /** Starts an open game: cities, NPC houses, the starting position of those who joined. */
    @Transactional
    public void start(String gameId) {
        GameEntity g = gameRepository.lockById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        if (g.status == GameStatus.RUNNING) return;
        if (g.status != GameStatus.OPEN) throw ApiException.conflict("server.only_open_start");
        MapDefinition map = MapRegistry.get(g.mapId);
        EngineState s = Setup.initial(map, Instant.now().toEpochMilli());
        for (int i = 0; i < Math.min(g.npcCount, Npcs.ALL.size()); i++) {
            Npcs.Template t = Npcs.ALL.get(i);
            String name = messages.text(t.label());
            PlayerEntity p = new PlayerEntity(g.id, null, name, t.tincture());
            p.npc = true; p.persona = t.persona();
            p = playerRepository.save(p);
            Setup.addNpc(s, map, i, p.id.toString(), name, t.tincture(), t.persona());
        }
        Engine e = new Engine(map, s, g.id.hashCode());
        for (PlayerEntity p : playerRepository.findByGameId(g.id)) {
            if (p.npc) continue;
            Setup.addPlayer(s, p.id.toString(), p.houseName, p.tincture, p.background, map.start(p.startSlot).orElseThrow(), p.startGood);
            e.out.add(new ReportOut(p.id.toString(), false, s.clock, "event", null, Msg.of("server.season_start.title"),
                Msg.of("server.season_start.text", "map", map.label(), "time", Time.fmt(Time.nextSettlement(s.clock))), "info"));
        }
        e.scheduleNpcs();
        g.status = GameStatus.RUNNING;
        runner.persist(g, e);
        log.info("Game started: {}", g.id);
    }

    /** Called by the scheduler: runs the maturing sheets and settlements due by now. */
    public void tick(String gameId) { runner.mutate(gameId, (g, e) -> null); }

    /** For development (ADMIN): immediate settlement. */
    public int settleNow(String gameId) {
        return runner.mutate(gameId, (g, e) -> { e.settleNow(GameEntity.MATURATION_MINUTES); return e.s.settlements; });
    }
}
