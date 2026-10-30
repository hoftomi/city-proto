package com.hof.tronnelkul.game.engine;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import tools.jackson.databind.node.ArrayNode;
import tools.jackson.databind.node.ObjectNode;

/**
 * Reads a stored state JSON and upgrades it to {@link EngineState#CURRENT_VERSION} first, so running games survive a
 * change of the state format.
 * Version 0 (no version field): money in decimal gold. Version 1: money in whole bronze, every amount ×100, rounded.
 */
public final class StateUpgrade {
    private StateUpgrade() {}

    private static final int BRONZE_PER_GOLD = (int) Money.BRONZE_PER_GOLD;

    /** The state of a JSON document, upgraded to the current version. */
    public static EngineState read(JsonMapper json, String text) {
        JsonNode tree = json.readTree(text);
        if (tree instanceof ObjectNode root) {
            upgrade(root);
        }
        return json.treeToValue(tree, EngineState.class);
    }

    /** Upgrades the state tree in place; a current tree is left as it is. */
    public static void upgrade(ObjectNode root) {
        int version = root.path("version").asInt(0);
        if (version < 1) {
            toBronze(root);
        }
        root.put("version", EngineState.CURRENT_VERSION);
    }

    /** Version 0 → 1: every amount of money from gold to whole bronze. */
    private static void toBronze(ObjectNode root) {
        for (JsonNode player : root.path("players")) {
            scale(player, "gold");
        }
        for (JsonNode city : root.path("cities")) {
            scale(city, "lastTaxPool");
            for (JsonNode good : city.path("goods")) {
                // Profit per point stays unrounded: it is averaged into the market value
                if (good.path("history") instanceof ArrayNode history) {
                    for (int index = 0; index < history.size(); index++) {
                        history.set(index, history.numberNode(history.get(index).asDouble() * BRONZE_PER_GOLD));
                    }
                }
            }
        }
        for (JsonNode draft : root.path("drafts")) {
            draft.forEach(order -> scale(order, "gold"));
        }
        for (JsonNode sheet : root.path("sheets")) {
            scale(sheet, "gold");
            sheet.path("orders").forEach(order -> scale(order, "gold"));
        }
        for (JsonNode intel : root.path("intel")) {
            intel.path("orders").forEach(order -> scale(order, "gold"));
        }
        for (JsonNode offer : root.path("offers")) {
            scale(offer, "price");
        }
    }

    /** A gold field to whole bronze; a missing or null field stays. */
    private static void scale(JsonNode node, String field) {
        if (node instanceof ObjectNode object && object.path(field).isNumber()) {
            object.put(field, Math.round(object.get(field).asDouble() * BRONZE_PER_GOLD));
        }
    }
}
