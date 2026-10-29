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
        GameEntity game = gameRepository.lockById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        if (game.getStatus() == GameStatus.RUNNING) {
            return;
        }
        if (game.getStatus() != GameStatus.OPEN) {
            throw ApiException.conflict("server.only_open_start");
        }
        MapDefinition map = MapRegistry.get(game.getMapId());
        EngineState state = Setup.initial(map, game.now().toEpochMilli());
        for (int index = 0; index < Math.min(game.getNpcCount(), Npcs.ALL.size()); index++) {
            Npcs.Template template = Npcs.ALL.get(index);
            String name = messages.text(template.label());
            PlayerEntity npc = new PlayerEntity(game.getId(), null, name);
            npc.setNpc(true); npc.setPersona(template.persona());
            npc = playerRepository.save(npc);
            Setup.addNpc(state, map, index, npc.getId().toString(), name, template.persona());
        }
        Engine engine = new Engine(map, state, game.getId().hashCode());
        for (PlayerEntity player : playerRepository.findByGameId(game.getId())) {
            if (player.isNpc()) {
                continue;
            }
            Setup.addPlayer(state, player.getId().toString(), player.getHouseName(), player.getBackground(), map.start(player.getStartSlot()).orElseThrow(), player.getStartGood());
            engine.out.add(new ReportOut(player.getId().toString(), false, state.clock, "event", null, Msg.of("server.season_start.title"),
                Msg.of("server.season_start.text", "map", map.label(), "time", Time.fmt(Time.nextSettlement(state.clock))), "info"));
        }
        engine.scheduleNpcs();
        game.setStatus(GameStatus.RUNNING);
        runner.persist(game, engine);
        log.info("Game started: {}", game.getId());
    }

    /** Called by the scheduler: runs the maturing sheets and settlements due by now. */
    public void tick(String gameId) { runner.mutate(gameId, (game, engine) -> null); }

    /** Largest admin time advance: 7 days. */
    public static final int MAX_ADVANCE_MINUTES = 7 * 24 * 60;

    /** Admin: moves the game clock forward (null: to the next event); returns the minutes added. */
    public int advance(String gameId, Integer minutes) {
        if (minutes != null && (minutes < 1 || minutes > MAX_ADVANCE_MINUTES)) {
            throw ApiException.badRequest("server.admin.advance_range", "max", MAX_ADVANCE_MINUTES);
        }
        return runner.advanceClock(gameId, minutes);
    }

    /** Admin: ends the season now (coronation, archive); returns the settlements the season had. */
    public int finish(String gameId) { return runner.endSeason(gameId); }

    /** For development (ADMIN): immediate settlement. */
    public int settleNow(String gameId) {
        return runner.mutate(gameId, (game, engine) -> { engine.settleNow(GameEntity.MATURATION_MINUTES); return engine.state.settlements; });
    }
}
