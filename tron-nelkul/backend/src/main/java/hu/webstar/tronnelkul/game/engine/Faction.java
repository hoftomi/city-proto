package hu.webstar.tronnelkul.game.engine;

import java.util.Arrays;

public enum Faction {
    NEMESSEG("nemesseg", "Nemesség"), KERESKEDOK("kereskedok", "Kereskedők"), KATONASAG("katonasag", "Katonaság");

    private final String id;
    private final String label;

    Faction(String id, String label) { this.id = id; this.label = label; }

    public String id() { return id; }
    public String label() { return label; }

    public static Faction of(String id) {
        return Arrays.stream(values()).filter(f -> f.id.equals(id)).findFirst()
            .orElseThrow(() -> new IllegalArgumentException("Ismeretlen frakció: " + id));
    }
}
