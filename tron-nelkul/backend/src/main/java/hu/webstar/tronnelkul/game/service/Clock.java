package hu.webstar.tronnelkul.game.service;

import java.time.*;

/** A feldolgozások ideje: minden nap 8:00 és 20:00 (Europe/Budapest). */
public final class Clock {
    private Clock() {}

    public static final ZoneId ZONE = ZoneId.of("Europe/Budapest");

    public static Instant nextResolution(Instant now) {
        ZonedDateTime t = now.atZone(ZONE);
        ZonedDateTime eight = t.toLocalDate().atTime(8, 0).atZone(ZONE), twenty = t.toLocalDate().atTime(20, 0).atZone(ZONE);
        if (t.isBefore(eight)) return eight.toInstant();
        if (t.isBefore(twenty)) return twenty.toInstant();
        return t.toLocalDate().plusDays(1).atTime(8, 0).atZone(ZONE).toInstant();
    }
}
