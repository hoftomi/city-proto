package com.hof.tronnelkul.game.world;

import java.util.List;

/**
 * Decorative terrain of the map. Drawn by the client, carries no game information.
 * mountains: [x, y, size], forests: [x, y, count], fields: [x, y, width, height, rotation], marsh: [x, y, count].
 */
public record TerrainDef(String sea, List<String> rivers, List<double[]> mountains, List<double[]> forests,
                         List<double[]> fields, List<double[]> marsh) {}
