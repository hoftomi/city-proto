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
        GameEntity g = new GameEntity("g1", "One", GameStatus.RUNNING, "so", 10, 0, "");
        Instant real = Instant.parse("2026-11-01T10:00:00Z");
        assertEquals(real, g.clock(real));
        g.timeOffsetMinutes = 7 * 24 * 60;
        assertEquals(real.plus(Duration.ofDays(7)), g.clock(real));
        Instant before = Instant.now().plus(Duration.ofDays(7));
        Instant now = g.now();
        assertFalse(now.isBefore(before));
        assertTrue(now.isBefore(before.plusSeconds(5)));
    }

    @Test
    void minutesUntilRoundsUpAndIsAtLeastOne() {
        long t = 1_000_000_000L;
        assertEquals(1, GameRunner.minutesUntil(t, t));
        assertEquals(1, GameRunner.minutesUntil(t, t - 5_000));
        assertEquals(1, GameRunner.minutesUntil(t, t + 1));
        assertEquals(1, GameRunner.minutesUntil(t, t + 60_000));
        assertEquals(2, GameRunner.minutesUntil(t, t + 60_001));
        assertEquals(120, GameRunner.minutesUntil(t, t + 120 * 60_000));
    }

    @Test
    void advanceRangeIsChecked() {
        GameLifecycleService lifecycle = new GameLifecycleService(null, null, null, null);
        for (int m : new int[] { 0, -1, GameLifecycleService.MAX_ADVANCE_MINUTES + 1 }) {
            var e = assertThrows(com.hof.tronnelkul.common.ApiException.class, () -> lifecycle.advance("g1", m));
            assertEquals("server.admin.advance_range", e.msg.key());
        }
    }
}
