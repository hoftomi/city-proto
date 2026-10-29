package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.game.model.ArchivedGameRepository;
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
import java.util.List;
import java.util.stream.Collectors;

/**
 * The sample games. On an empty database they are created at startup; the admin can recreate the missing ones
 * (POST /api/admin/games/seed). A sample game is missing if its id is neither live nor archived. Delkelet starts at
 * once so it can be tried out. Names and tags come from i18n (world.seed.<gameId>.name, world.tag.<tagId>) and are
 * stored as display text.
 */
@Component
public class SeedData implements ApplicationRunner {
    private static final Logger log = LoggerFactory.getLogger(SeedData.class);
    /** The sample game that starts at once. */
    static final String STARTED = "delkelet-1";

    private final GameRepository gameRepository;
    private final ArchivedGameRepository archivedGameRepository;
    private final GameLifecycleService lifecycle;
    private final Messages messages;

    public SeedData(GameRepository gameRepository, ArchivedGameRepository archivedGameRepository, GameLifecycleService lifecycle, Messages messages) {
        this.gameRepository = gameRepository; this.archivedGameRepository = archivedGameRepository; this.lifecycle = lifecycle; this.messages = messages;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (gameRepository.count() > 0) {
            return;
        }
        int created = seedMissing();
        if (created > 0) {
            log.info("Sample games created: {}", created);
        }
    }

    /** Creates the sample games that are neither live nor archived; returns how many were created. */
    public int seedMissing() {
        int created = 0;
        for (GameEntity sample : samples(Instant.now().truncatedTo(ChronoUnit.HOURS))) {
            if (gameRepository.existsById(sample.getId()) || archivedGameRepository.existsById(sample.getId())) {
                continue;
            }
            gameRepository.save(sample);
            if (sample.getId().equals(STARTED)) {
                lifecycle.start(sample.getId());
            }
            created++;
        }
        return created;
    }

    private List<GameEntity> samples(Instant day) {
        GameEntity delkelet = game(STARTED, GameStatus.OPEN, "delkelet", 30, 4, "beginnerFriendly");
        delkelet.setClosesAt(day);

        GameEntity kodos = game("kodos-autumn", GameStatus.OPEN, "kodos", 30, 3, "beginnerFriendly", "strongNpcs");
        kodos.setClosesAt(day.plus(Duration.ofDays(2)));

        GameEntity so = game("so-league-1", GameStatus.OPEN, "so", 40, 2, "league", "spies");
        so.setClosesAt(day.plus(Duration.ofDays(5)));

        GameEntity lightning = game("lightning-1", GameStatus.OPEN, "kodos", 30, 1, "veterans");
        lightning.setClosesAt(day.plus(Duration.ofDays(1)));

        GameEntity spring = game("spring-championship", GameStatus.ANNOUNCED, "so", 60, 2, "ranked");
        spring.setOpensAt(day.plus(Duration.ofDays(12)));
        spring.setClosesAt(day.plus(Duration.ofDays(20)));

        return List.of(delkelet, kodos, so, lightning, spring);
    }

    private GameEntity game(String id, GameStatus status, String mapId, int maxPlayers, int npcCount, String... tags) {
        String tagText = Arrays.stream(tags).map(tag -> messages.text("world.tag." + tag)).collect(Collectors.joining(","));
        return new GameEntity(id, messages.text("world.seed." + id + ".name"), status, mapId, maxPlayers, npcCount, tagText);
    }
}
