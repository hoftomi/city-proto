package hu.webstar.tronnelkul.game.service;

import hu.webstar.tronnelkul.game.model.GameEntity;
import hu.webstar.tronnelkul.game.model.GameRepository;
import hu.webstar.tronnelkul.game.model.GameStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

/** Üres adatbázis esetén létrehozza a 0.0.1 mintajátékait. A Délkelet azonnal fut, hogy ki lehessen próbálni. */
@Component
public class SeedData implements ApplicationRunner {
    private static final Logger log = LoggerFactory.getLogger(SeedData.class);
    private final GameRepository games;
    private final GameLifecycleService lifecycle;

    public SeedData(GameRepository games, GameLifecycleService lifecycle) { this.games = games; this.lifecycle = lifecycle; }

    @Override
    public void run(ApplicationArguments args) {
        if (games.count() > 0) return;
        Instant day = Instant.now().truncatedTo(ChronoUnit.HOURS);

        GameEntity delkelet = new GameEntity("delkelet-1", "Délkelet", "1. szezon", GameStatus.OPEN, "delkelet", 14, 30, 4, "Kezdőbarát");
        delkelet.startsAt = day;
        games.save(delkelet);

        GameEntity kodos = new GameEntity("kodos-osz", "Ködös Hegyvidék", "Őszi szezon", GameStatus.OPEN, "kodos", 14, 30, 3, "Kezdőbarát,Erős NPC-k");
        kodos.startsAt = day.plus(Duration.ofDays(2));
        games.save(kodos);

        GameEntity so = new GameEntity("so-liga-1", "Sóvidék ligája", "Liga · 1. forduló", GameStatus.OPEN, "so", 30, 40, 2, "Szövetségek,Rejtett befolyás");
        so.startsAt = day.plus(Duration.ofDays(5));
        games.save(so);

        GameEntity villam = new GameEntity("villam-1", "Villámszezon", "Gyors játék", GameStatus.OPEN, "kodos", 7, 30, 1, "Gyors,Tapasztaltaknak");
        villam.startsAt = day.plus(Duration.ofDays(1));
        games.save(villam);

        GameEntity tavasz = new GameEntity("tavasz-bajnoksag", "Tavaszi bajnokság", "Bajnokság", GameStatus.ANNOUNCED, "so", 45, 60, 2, "Rangsorolt");
        tavasz.opensAt = day.plus(Duration.ofDays(12));
        tavasz.startsAt = day.plus(Duration.ofDays(20));
        games.save(tavasz);

        lifecycle.start(delkelet.id);
        log.info("Mintajátékok létrehozva.");
    }
}
