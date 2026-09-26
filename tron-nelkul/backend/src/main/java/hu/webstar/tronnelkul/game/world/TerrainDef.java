package hu.webstar.tronnelkul.game.world;

import java.util.List;

/**
 * A térkép dekoratív domborzata. A kliens rajzolja ki, játékinformációt nem hordoz.
 * mountains: [x, y, méret], forests: [x, y, darab], fields: [x, y, szélesség, magasság, forgatás], marsh: [x, y, darab].
 */
public record TerrainDef(String sea, List<String> rivers, List<double[]> mountains, List<double[]> forests,
                         List<double[]> fields, List<double[]> marsh) {}
