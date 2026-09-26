package hu.webstar.tronnelkul.game.world;

import java.util.List;

/** Kezdőhely (birtok). A birtokból a szomszédos városokba ingyenes útvonal indul. */
public record StartSlot(String id, String name, int x, int y, List<String> neighbors, String note) {
    /** A birtok csomópontazonosítója a hálózatban. */
    public String nodeId() { return "birtok:" + id; }
}
