package com.hof.tronnelkul.game.world;

import com.hof.tronnelkul.game.engine.Msg;

import java.util.List;

/** A city-state on the map. Coordinates refer to the 360×260 map canvas. Name and profile: i18n world.city.<id>. */
public record CityDef(String id, int x, int y, boolean key, boolean coast, List<GoodDef> goods) {
    public static Msg label(String id) { return Msg.of("world.city." + id + ".name"); }

    public Msg label() { return label(id); }

    /** Short profile, e.g. grain country. */
    public Msg desc() { return Msg.of("world.city." + id + ".desc"); }
}
