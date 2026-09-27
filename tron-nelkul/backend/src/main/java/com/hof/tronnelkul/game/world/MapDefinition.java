package com.hof.tronnelkul.game.world;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/** Egy régió térképe: városok, utak, kezdőhelyek és domborzat. */
public record MapDefinition(String id, String name, List<CityDef> cities, List<List<String>> cityEdges,
                            List<StartSlot> starts, TerrainDef terrain) {

    public Optional<CityDef> city(String id) { return cities.stream().filter(c -> c.id().equals(id)).findFirst(); }

    public Optional<StartSlot> start(String id) { return starts.stream().filter(s -> s.id().equals(id)).findFirst(); }

    public boolean isCity(String node) { return city(node).isPresent(); }

    /** Minden él: város–város utak és birtok–szomszéd utak. */
    public List<List<String>> allEdges() {
        List<List<String>> out = new ArrayList<>(cityEdges);
        for (StartSlot s : starts) for (String n : s.neighbors()) out.add(List.of(s.nodeId(), n));
        return out;
    }

    public boolean hasEdge(String a, String b) {
        return allEdges().stream().anyMatch(e -> (e.get(0).equals(a) && e.get(1).equals(b)) || (e.get(0).equals(b) && e.get(1).equals(a)));
    }

    public String nodeName(String node) {
        if (node.startsWith("birtok:")) return start(node.substring(7)).map(StartSlot::name).orElse(node);
        return city(node).map(CityDef::name).orElse(node);
    }
}
