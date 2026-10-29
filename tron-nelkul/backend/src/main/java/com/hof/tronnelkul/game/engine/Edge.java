package com.hof.tronnelkul.game.engine;

import com.fasterxml.jackson.annotation.JsonAlias;

/** Undirected edge on the map. Stored states written before the rename use "a" / "b". */
public record Edge(@JsonAlias("a") String from, @JsonAlias("b") String to) {
    public boolean touches(String node) { return from.equals(node) || to.equals(node); }
    public String other(String node) { return from.equals(node) ? to : from; }
    public boolean same(String first, String second) {
        return (from.equals(first) && to.equals(second)) || (from.equals(second) && to.equals(first));
    }
}
