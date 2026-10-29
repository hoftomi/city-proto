package com.hof.tronnelkul.game.model;

import com.hof.tronnelkul.api.model.Background;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class BackgroundConverterTest {
    final BackgroundConverter converter = new BackgroundConverter();

    @Test
    void storesTheApiValue() {
        assertEquals("merchant", converter.convertToDatabaseColumn(Background.MERCHANT));
        assertEquals("noble", converter.convertToDatabaseColumn(Background.NOBLE));
        assertEquals("shadow", converter.convertToDatabaseColumn(Background.SHADOW));
        assertNull(converter.convertToDatabaseColumn(null));
    }

    @Test
    void readsTheApiValue() {
        for (Background background : Background.values()) {
            assertEquals(background, converter.convertToEntityAttribute(background.getValue()));
        }
        assertNull(converter.convertToEntityAttribute(null));
        assertThrows(IllegalArgumentException.class, () -> converter.convertToEntityAttribute("MERCHANT"));
    }
}
