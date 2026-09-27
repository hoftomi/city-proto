package com.hof.tronnelkul.game.world;

import java.util.List;

/** Kezdőhely (birtok). A birtokból a szomszédos városokba ingyenes útvonal indul; az első szomszéd a kezdőváros. */
public record StartSlot(String id, String name, int x, int y, List<String> neighbors, String note) {
    /** A birtok csomópontazonosítója a hálózatban. */
    public String nodeId() { return "birtok:" + id; }

    /** A kezdőváros: itt 20 a népszerűség, és ide szól a háttér induló bónusza (2.2). */
    public String homeCity() { return neighbors.get(0); }
}
