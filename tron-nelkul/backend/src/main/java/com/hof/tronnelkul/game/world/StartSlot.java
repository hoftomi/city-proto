package com.hof.tronnelkul.game.world;

import java.util.List;

/**
 * Start slot (estate). Free routes lead from the estate to its neighbouring cities; the first neighbour is the home city.
 * Name and note: i18n world.start.<mapId>.<id> (MapDefinition.startLabel / startNote).
 */
public record StartSlot(String id, int x, int y, List<String> neighbors) {
    public static final String NODE_PREFIX = "estate:";

    /** Node id of the estate in the network. */
    public String nodeId() { return NODE_PREFIX + id; }

    /** The home city: popularity is 20 here, and the background's starting bonus applies here (2.2). */
    public String homeCity() { return neighbors.get(0); }
}
