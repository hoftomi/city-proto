package hu.webstar.tronnelkul.game.service;

import java.util.List;

/** Az NPC-házak sablonjai (9.1). */
final class Npcs {
    private Npcs() {}

    record Template(String name, String tincture, String persona, String favorite) {}

    static final List<Template> ALL = List.of(
        new Template("Ezüstpart-ház", "arany", "kalmar", "kereskedok"),
        new Template("Ősi Tölgy", "zold", "nemzetseg", "nemesseg"),
        new Template("Varjúvár", "fekete", "zsoldos", "katonasag"),
        new Template("Bíbor Kéz", "bibor", "arnyek", "kereskedok"));

    static boolean isNpcName(String name) { return ALL.stream().anyMatch(t -> t.name().equalsIgnoreCase(name.strip())); }
}
