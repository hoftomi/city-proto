package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.game.engine.Msg;

import java.util.List;

/** NPC house templates. The persona decides which branch they play (engine.Engine.npcPlanFor). Names: i18n world.npc.<id>. */
public final class Npcs {
    private Npcs() {}

    record Template(String id, String persona) {
        Msg label() { return Msg.of("world.npc." + id); }
    }

    static final List<Template> ALL = List.of(
        new Template("silvershore", "trader"),
        new Template("ancientOak", "politician"),
        new Template("crimsonHand", "spymaster"),
        new Template("ravenhold", "raider"));

    /** Number of NPC templates: the most NPC houses a game can have. */
    public static int count() { return ALL.size(); }
}
