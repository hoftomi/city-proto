package com.hof.tronnelkul.game.engine;

import java.time.*;

/** Settlement times: every day at 8:00 and 20:00 (Europe/Budapest) (3.2). */
public final class Time {
    private Time() {}

    public static final ZoneId ZONE = ZoneId.of("Europe/Budapest");
    public static final int[] SETTLEMENT_HOURS = { 8, 20 };

    /** The first settlement strictly after t (epoch ms). */
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

    /** Short timestamp like "09. 27. 20:00" for reports. */
    public static String fmt(long t) {
        ZonedDateTime z = Instant.ofEpochMilli(t).atZone(ZONE);
        return String.format("%02d. %02d. %02d:%02d", z.getMonthValue(), z.getDayOfMonth(), z.getHour(), z.getMinute());
    }
}
