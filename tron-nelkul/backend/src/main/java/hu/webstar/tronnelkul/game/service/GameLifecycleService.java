package hu.webstar.tronnelkul.game.service;

import hu.webstar.tronnelkul.common.ApiException;
import hu.webstar.tronnelkul.game.engine.*;
import hu.webstar.tronnelkul.game.model.*;
import hu.webstar.tronnelkul.game.world.CityDef;
import hu.webstar.tronnelkul.game.world.MapDefinition;
import hu.webstar.tronnelkul.game.world.MapRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;

/** Játék indítása, körök feldolgozása, szezonvég. */
@Service
public class GameLifecycleService {
    private static final Logger log = LoggerFactory.getLogger(GameLifecycleService.class);

    private final GameRepository games;
    private final PlayerRepository players;
    private final InfluenceRepository influence;
    private final CityStateRepository cityStates;
    private final ReportRepository reports;
    private final GameStateStore store;

    public GameLifecycleService(GameRepository games, PlayerRepository players, InfluenceRepository influence,
                                CityStateRepository cityStates, ReportRepository reports, GameStateStore store) {
        this.games = games; this.players = players; this.influence = influence; this.cityStates = cityStates;
        this.reports = reports; this.store = store;
    }

    /** Elindít egy nyitott játékot: NPC-házak, kezdő befolyás, városállapotok, 1. kör. */
    @Transactional
    public void start(String gameId) {
        GameEntity g = games.findById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        if (g.status == GameStatus.RUNNING) return;
        if (g.status != GameStatus.OPEN) throw ApiException.conflict("Csak nyitott játék indítható.");
        MapDefinition map = MapRegistry.get(g.mapId);
        List<CityDef> cities = map.cities();

        for (CityDef c : cities) cityStates.save(new CityStateEntity(g.id, c.id(), c.initialStability()));

        for (int i = 0; i < Math.min(g.npcCount, Npcs.ALL.size()); i++) {
            Npcs.Template t = Npcs.ALL.get(i);
            PlayerEntity p = new PlayerEntity(g.id, null, t.name(), t.tincture());
            p.npc = true; p.persona = t.persona(); p.favorite = t.favorite();
            p.pp = Rules.NPC_PP; p.npcCooldown = 3;
            p = players.save(p);
            // 13.3: minden NPC-ház 10 ponttal indul a kedvenc frakciójában két városban
            for (int k = 0; k < 2; k++) {
                CityDef c = cities.get((i * 2 + k) % cities.size());
                influence.save(new InfluenceEntity(g.id, c.id(), t.favorite(), p.id, 10, 0));
            }
        }
        g.status = GameStatus.RUNNING;
        g.round = 1;
        for (PlayerEntity p : players.findByGameId(g.id)) {
            if (p.npc) continue;
            reports.save(new ReportEntity(g.id, p.id, 0, "esemeny", null, "Elkezdődött a szezon",
                "A " + map.name() + " városállamai várják a házakat. Az első feldolgozás 8:00-kor vagy 20:00-kor lesz.", "info"));
        }
        log.info("Elindult a játék: {}", g.id);
    }

    /** Egy kör feldolgozása. Az ütemező és az admin végpont is ezt hívja. */
    @Transactional
    public int resolve(String gameId) {
        GameEntity g = games.findById(gameId).orElseThrow(() -> ApiException.notFound("Nincs ilyen játék."));
        if (g.status != GameStatus.RUNNING) throw ApiException.conflict("A játék nem fut.");
        EngineState s = store.load(g);
        int round = s.round;
        List<ReportOut> out = RoundResolver.resolve(s, (long) g.id.hashCode() * 7919L + round);
        store.save(g, s, out, round);
        if (g.round > g.maxRounds()) finish(g, s);
        log.info("Feldolgozva: {} {}. kör, {} jelentés", g.id, round, out.size());
        return round;
    }

    private void finish(GameEntity g, EngineState s) {
        PlayerState winner = s.players.values().stream().max(Comparator.comparingInt(p -> p.legit)).orElse(null);
        g.status = GameStatus.FINISHED;
        g.winner = winner == null ? null : winner.name + (winner.npc ? " (NPC)" : "");
        for (PlayerState p : s.players.values()) {
            if (p.npc) continue;
            reports.save(new ReportEntity(g.id, java.util.UUID.fromString(p.id), g.round, "esemeny", null, "Koronázási Tanács",
                "A szezon véget ért. A tanács " + g.winner + " házát ismerte el a legtöbb Legitimitással.", "info"));
        }
    }
}
