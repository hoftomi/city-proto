package com.hof.tronnelkul.game.model;

import com.hof.tronnelkul.api.model.Background;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

/** Stores a Background as its API value ('merchant', 'noble', 'shadow') in players.background and archived_players.background. */
@Converter(autoApply = true)
public class BackgroundConverter implements AttributeConverter<Background, String> {
    @Override
    public String convertToDatabaseColumn(Background background) { return background == null ? null : background.getValue(); }

    @Override
    public Background convertToEntityAttribute(String value) { return value == null ? null : Background.fromValue(value); }
}
