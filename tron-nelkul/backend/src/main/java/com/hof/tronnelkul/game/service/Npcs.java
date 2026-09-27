package com.hof.tronnelkul.game.service;

import java.util.List;

/** Az NPC-házak sablonjai. A jellem (persona) dönti el, melyik ágban játszanak (engine.Engine.npcPlan). */
final class Npcs {
    private Npcs() {}

    record Template(String name, String tincture, String persona) {}

    static final List<Template> ALL = List.of(
        new Template("Ezüstpart-ház", "arany", "kalmar"),
        new Template("Ősi Tölgy", "zold", "politikus"),
        new Template("Bíbor Kéz", "bibor", "kem"),
        new Template("Varjúvár", "fekete", "felvasarlo"));

    static boolean isNpcName(String name) { return ALL.stream().anyMatch(t -> t.name().equalsIgnoreCase(name.strip())); }
}
