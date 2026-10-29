package com.hof.tronnelkul.game.world;

import com.hof.tronnelkul.game.engine.Msg;

/** A good of a city: supply and demand per settlement (rulebook v0.2, 1 and 5.3). Name: i18n world.good.<id>. */
public record GoodDef(String id, int supply, int demand) {
    public static Msg label(String id) { return Msg.of("world.good." + id); }

    public Msg label() { return label(id); }
}
