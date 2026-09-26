package hu.webstar.tronnelkul.game.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/** A láthatósági sávok (11. fejezet): a kliens soha nem kapja meg a pontos értéket, ha nem jogosult rá. */
class VisibilityTest {
    @Test
    void bands() {
        assertEquals("42,3", GameViewService.label(42.31, "exact"));
        assertEquals("40", GameViewService.label(41.9, "band5"));
        assertEquals("40–50", GameViewService.label(47.2, "band10"));
        assertEquals(45.0, GameViewService.barValue(47.2, "band10"));
    }
}
