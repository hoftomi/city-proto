package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.game.engine.Msg;

import java.util.List;

/** NPC house templates. The persona decides which branch they play (engine.Engine.npcPlanFor). Names: i18n world.npc.<id>. */
final class Npcs {
    private Npcs() {}

    record Template(String id, String tincture, String persona) {
        Msg label() { return Msg.of("world.npc." + id); }
    }

    static final List<Template> ALL = List.of(
        new Template("silvershore", "gold", "trader"),
        new Template("ancientOak", "green", "politician"),
        new Template("crimsonHand", "purple", "spymaster"),
        new Template("ravenhold", "black", "raider"));
}
