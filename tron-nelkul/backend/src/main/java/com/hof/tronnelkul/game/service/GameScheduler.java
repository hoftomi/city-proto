package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.config.AppProperties;
import com.hof.tronnelkul.game.model.GameEntity;
import com.hof.tronnelkul.game.model.GameRepository;
import com.hof.tronnelkul.game.model.GameStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.Instant;

/**
 * Ütemezés: félpercenként előreviszi a futó játékokat (az érlelő parancslapok lejárata, elszámolás 8:00-kor és 20:00-kor,
 * Europe/Budapest), és percenként ellenőrzi a jelentkezést nyitó és az induló játékokat.
 * Több szerverpéldány esetén ezt egyetlen példányon kell futtatni (SCHEDULER_ENABLED=false a többin).
 */
@Component
public class GameScheduler {
    private static final Logger log = LoggerFactory.getLogger(GameScheduler.class);
    private final GameRepository games;
    private final GameLifecycleService lifecycle;
    private final AppProperties props;

    public GameScheduler(GameRepository games, GameLifecycleService lifecycle, AppProperties props) {
        this.games = games; this.lifecycle = lifecycle; this.props = props;
    }

    @Scheduled(fixedDelay = 30_000, initialDelay = 15_000)
    public void tick() {
        if (!props.scheduler().enabled()) return;
        for (GameEntity g : games.findByStatus(GameStatus.RUNNING)) {
            try { lifecycle.tick(g.id); } catch (RuntimeException e) { log.error("Nem sikerült előrevinni: {}", g.id, e); }
        }
    }

    @Scheduled(fixedDelay = 60_000, initialDelay = 10_000)
    public void lifecycle() {
        if (!props.scheduler().enabled()) return;
        Instant now = Instant.now();
        for (GameEntity g : games.findByStatusAndOpensAtBefore(GameStatus.ANNOUNCED, now)) {
            g.status = GameStatus.OPEN;
            games.save(g);
        }
        for (GameEntity g : games.findByStatusAndStartsAtBefore(GameStatus.OPEN, now)) {
            try { lifecycle.start(g.id); } catch (RuntimeException e) { log.error("Nem sikerült elindítani: {}", g.id, e); }
        }
    }
}
