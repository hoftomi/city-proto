package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.game.model.GameEntity;
import com.hof.tronnelkul.game.model.GameRepository;
import com.hof.tronnelkul.game.model.GameStatus;
import com.hof.tronnelkul.i18n.Messages;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.stream.Collectors;

/**
 * Creates the sample games on an empty database. Delkelet starts at once so it can be tried out.
 * Names and tags come from i18n (world.seed.<gameId>.name, world.tag.<tagId>) and are stored as display text.
 */
@Component
public class SeedData implements ApplicationRunner {
    private static final Logger log = LoggerFactory.getLogger(SeedData.class);
    private final GameRepository gameRepository;
    private final GameLifecycleService lifecycle;
    private final Messages messages;

    public SeedData(GameRepository gameRepository, GameLifecycleService lifecycle, Messages messages) {
        this.gameRepository = gameRepository; this.lifecycle = lifecycle; this.messages = messages;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (gameRepository.count() > 0) return;
        Instant day = Instant.now().truncatedTo(ChronoUnit.HOURS);

        GameEntity delkelet = game("delkelet-1", GameStatus.OPEN, "delkelet", 30, 4, "beginnerFriendly");
        delkelet.closesAt = day;
        gameRepository.save(delkelet);

        GameEntity kodos = game("kodos-autumn", GameStatus.OPEN, "kodos", 30, 3, "beginnerFriendly", "strongNpcs");
        kodos.closesAt = day.plus(Duration.ofDays(2));
        gameRepository.save(kodos);

        GameEntity so = game("so-league-1", GameStatus.OPEN, "so", 40, 2, "league", "spies");
        so.closesAt = day.plus(Duration.ofDays(5));
        gameRepository.save(so);

        GameEntity lightning = game("lightning-1", GameStatus.OPEN, "kodos", 30, 1, "veterans");
        lightning.closesAt = day.plus(Duration.ofDays(1));
        gameRepository.save(lightning);

        GameEntity spring = game("spring-championship", GameStatus.ANNOUNCED, "so", 60, 2, "ranked");
        spring.opensAt = day.plus(Duration.ofDays(12));
        spring.closesAt = day.plus(Duration.ofDays(20));
        gameRepository.save(spring);

        lifecycle.start(delkelet.id);
        log.info("Sample games created.");
    }

    private GameEntity game(String id, GameStatus status, String mapId, int maxPlayers, int npcCount, String... tags) {
        String tagText = Arrays.stream(tags).map(t -> messages.text("world.tag." + t)).collect(Collectors.joining(","));
        return new GameEntity(id, messages.text("world.seed." + id + ".name"), status, mapId, maxPlayers, npcCount, tagText);
    }
}
