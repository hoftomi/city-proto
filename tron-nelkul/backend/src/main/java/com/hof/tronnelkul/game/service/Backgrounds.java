package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.api.model.Background;
import com.hof.tronnelkul.api.model.BackgroundDto;
import com.hof.tronnelkul.i18n.Messages;

import java.util.EnumMap;
import java.util.List;
import java.util.Map;

/** Background types (rulebook v0.2, 2.2). They only give a starting bonus, none locks into a branch. Texts: i18n world.background.<id>. */
public final class Backgrounds {
    private Backgrounds() {}

    /** Icon of each background, in the enum's (join form) order. */
    static final Map<Background, String> ICONS = new EnumMap<>(Map.of(Background.MERCHANT, "merchants", Background.NOBLE, "nobility", Background.SHADOW, "hidden"));

    public static String name(Messages messages, Background background) { return messages.text("world.background." + background.getValue() + ".name"); }

    public static List<BackgroundDto> dtos(Messages messages) {
        return ICONS.keySet().stream().map(background -> new BackgroundDto(background, name(messages, background), ICONS.get(background),
            List.of(messages.text("world.background." + background.getValue() + ".perk1"), messages.text("world.background." + background.getValue() + ".perk2")))).toList();
    }
}
