package com.hof.tronnelkul.game.engine;

import java.time.*;

/** Az elszámolások ideje: minden nap 8:00 és 20:00 (Europe/Budapest) (3.2). */
public final class Time {
    private Time() {}

    public static final ZoneId ZONE = ZoneId.of("Europe/Budapest");
    public static final int[] SETTLEMENT_HOURS = { 8, 20 };

    /** Az első elszámolás szigorúan t után (epoch ms). */
    public static long nextSettlement(long t) {
        ZonedDateTime z = Instant.ofEpochMilli(t).atZone(ZONE);
        for (int d = 0; d < 3; d++) {
            LocalDate day = z.toLocalDate().plusDays(d);
            for (int h : SETTLEMENT_HOURS) {
                long c = day.atTime(h, 0).atZone(ZONE).toInstant().toEpochMilli();
                if (c > t) return c;
            }
        }
        return t + Duration.ofHours(12).toMillis();
    }

    /** „09. 27. 20:00” alakú rövid időpont a jelentésekhez. */
    public static String fmt(long t) {
        ZonedDateTime z = Instant.ofEpochMilli(t).atZone(ZONE);
        return String.format("%02d. %02d. %02d:%02d", z.getMonthValue(), z.getDayOfMonth(), z.getHour(), z.getMinute());
    }
}
