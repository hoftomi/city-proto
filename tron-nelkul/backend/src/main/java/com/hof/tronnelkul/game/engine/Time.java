package com.hof.tronnelkul.game.engine;

import java.time.*;

/** Settlement times: every day at 8:00 and 20:00 (Europe/Budapest) (3.2). */
public final class Time {
    private Time() {}

    public static final ZoneId ZONE = ZoneId.of("Europe/Budapest");
    public static final int[] SETTLEMENT_HOURS = { 8, 20 };

    /** The first settlement strictly after `after` (epoch ms). */
    public static long nextSettlement(long after) {
        ZonedDateTime zoned = Instant.ofEpochMilli(after).atZone(ZONE);
        for (int dayOffset = 0; dayOffset < 3; dayOffset++) {
            LocalDate day = zoned.toLocalDate().plusDays(dayOffset);
            for (int hour : SETTLEMENT_HOURS) {
                long candidate = day.atTime(hour, 0).atZone(ZONE).toInstant().toEpochMilli();
                if (candidate > after) {
                    return candidate;
                }
            }
        }
        return after + Duration.ofHours(12).toMillis();
    }

    /** Short timestamp like "09. 27. 20:00" for reports. */
    public static String fmt(long time) {
        ZonedDateTime zoned = Instant.ofEpochMilli(time).atZone(ZONE);
        return String.format("%02d. %02d. %02d:%02d", zoned.getMonthValue(), zoned.getDayOfMonth(), zoned.getHour(), zoned.getMinute());
    }
}
