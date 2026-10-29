package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.api.model.BackgroundDto;
import com.hof.tronnelkul.i18n.Messages;

import java.util.List;
import java.util.Optional;

/** Background types (rulebook v0.2, 2.2). They only give a starting bonus, none locks into a branch. Texts: i18n world.background.<id>. */
public final class Backgrounds {
    private Backgrounds() {}

    record Background(String id, String icon) {}

    static final List<Background> ALL = List.of(new Background("merchant", "merchants"), new Background("noble", "nobility"), new Background("shadow", "hidden"));

    public static final List<String> TINCTURES = List.of("red", "blue", "green", "gold", "purple", "black", "orange", "mulberry");

    public static boolean exists(String id) { return ALL.stream().anyMatch(b -> b.id().equals(id)); }

    public static String name(Messages m, String id) { return m.text("world.background." + id + ".name"); }

    public static List<BackgroundDto> dtos(Messages m) {
        return ALL.stream().map(b -> new BackgroundDto(b.id(), name(m, b.id()), b.icon(),
            List.of(m.text("world.background." + b.id() + ".perk1"), m.text("world.background." + b.id() + ".perk2")))).toList();
    }
}
