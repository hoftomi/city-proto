package hu.webstar.tronnelkul.game.engine;

import java.util.Arrays;
import java.util.EnumSet;
import java.util.Set;

/** Akciók (5.1, 12.1, 4.2). */
public enum ActionType {
    PATRON("patron", "Pártfogás", new Cost(1, 3, 0, 0), 4, EnumSet.allOf(Faction.class), false),
    GRANT("grant", "Nagy adomány", new Cost(2, 8, 0, 0), 10, EnumSet.allOf(Faction.class), false),
    COUNCIL("council", "Tanácstag megnyerése", new Cost(2, 0, 3, 0), 8, EnumSet.of(Faction.NEMESSEG), true),
    GUARD("guard", "Városőrség támogatása", new Cost(1, 0, 0, 1), 6, EnumSet.of(Faction.KATONASAG), false),
    SMEAR("smear", "Lejáratás", new Cost(2, 0, 2, 0), 0, EnumSet.allOf(Faction.class), false),
    CONSOLIDATE("consolidate", "Megszilárdítás", new Cost(1, 0, 0, 0), 0, EnumSet.allOf(Faction.class), false),
    ROUTE("route", "Útvonal kiépítése", new Cost(Rules.ROUTE_PP, Rules.ROUTE_ARANY, 0, 0), 0, EnumSet.noneOf(Faction.class), false);

    private final String id;
    public final String label;
    public final Cost baseCost;
    public final double power;
    public final Set<Faction> factions;
    public final boolean needsPresence;

    ActionType(String id, String label, Cost baseCost, double power, Set<Faction> factions, boolean needsPresence) {
        this.id = id; this.label = label; this.baseCost = baseCost; this.power = power; this.factions = factions; this.needsPresence = needsPresence;
    }

    public String id() { return id; }
    public boolean isGain() { return power > 0; }

    public Cost cost(boolean hidden) { return hidden && isGain() ? baseCost.hidden() : baseCost; }

    public static ActionType of(String id) {
        return Arrays.stream(values()).filter(a -> a.id.equals(id)).findFirst()
            .orElseThrow(() -> new IllegalArgumentException("Ismeretlen akció: " + id));
    }
}
