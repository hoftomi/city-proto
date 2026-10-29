package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.game.model.GameEntity;
import com.hof.tronnelkul.game.model.GameStatus;
import org.junit.jupiter.api.Test;

import java.time.Duration;
import java.time.Instant;

import static org.junit.jupiter.api.Assertions.*;

class GameClockTest {
    @Test
    void clockIsRealTimePlusOffset() {
        GameEntity game = new GameEntity("g1", "One", GameStatus.RUNNING, "so", 10, 0, "");
        Instant real = Instant.parse("2026-11-01T10:00:00Z");
        assertEquals(real, game.clock(real));
        game.setTimeOffsetMinutes(7 * 24 * 60);
        assertEquals(real.plus(Duration.ofDays(7)), game.clock(real));
        Instant before = Instant.now().plus(Duration.ofDays(7));
        Instant now = game.now();
        assertFalse(now.isBefore(before));
        assertTrue(now.isBefore(before.plusSeconds(5)));
    }

    @Test
    void minutesUntilRoundsUpAndIsAtLeastOne() {
        long nowMillis = 1_000_000_000L;
        assertEquals(1, GameRunner.minutesUntil(nowMillis, nowMillis));
        assertEquals(1, GameRunner.minutesUntil(nowMillis, nowMillis - 5_000));
        assertEquals(1, GameRunner.minutesUntil(nowMillis, nowMillis + 1));
        assertEquals(1, GameRunner.minutesUntil(nowMillis, nowMillis + 60_000));
        assertEquals(2, GameRunner.minutesUntil(nowMillis, nowMillis + 60_001));
        assertEquals(120, GameRunner.minutesUntil(nowMillis, nowMillis + 120 * 60_000));
    }

    @Test
    void advanceRangeIsChecked() {
        GameLifecycleService lifecycle = new GameLifecycleService(null, null, null, null);
        for (int minutes : new int[] { 0, -1, GameLifecycleService.MAX_ADVANCE_MINUTES + 1 }) {
            var ex = assertThrows(com.hof.tronnelkul.common.ApiException.class, () -> lifecycle.advance("g1", minutes));
            assertEquals("server.admin.advance_range", ex.msg.key());
        }
    }
}
