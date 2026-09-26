package hu.webstar.tronnelkul.game.service;

import hu.webstar.tronnelkul.config.AppProperties;
import hu.webstar.tronnelkul.game.model.GameEntity;
import hu.webstar.tronnelkul.game.model.GameRepository;
import hu.webstar.tronnelkul.game.model.GameStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.Instant;

/**
 * Ütemezés: a futó játékok körei minden nap 8:00-kor és 20:00-kor (Europe/Budapest) futnak le;
 * percenként ellenőrzi az induló és a jelentkezést nyitó játékokat.
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

    @Scheduled(cron = "0 0 8,20 * * *", zone = "Europe/Budapest")
    public void resolveRounds() {
        if (!props.scheduler().enabled()) return;
        for (GameEntity g : games.findByStatus(GameStatus.RUNNING)) {
            try { lifecycle.resolve(g.id); } catch (RuntimeException e) { log.error("Nem sikerült feldolgozni: {}", g.id, e); }
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
