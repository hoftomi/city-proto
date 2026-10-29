package com.hof.tronnelkul.game.world;

import com.hof.tronnelkul.game.engine.Msg;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/** A region's map: cities, roads, start slots and terrain. Names: i18n world.*. */
public record MapDefinition(String id, List<CityDef> cities, List<List<String>> cityEdges,
                            List<StartSlot> starts, TerrainDef terrain) {

    public Optional<CityDef> city(String id) { return cities.stream().filter(city -> city.id().equals(id)).findFirst(); }

    public Optional<StartSlot> start(String id) { return starts.stream().filter(slot -> slot.id().equals(id)).findFirst(); }

    public boolean isCity(String node) { return city(node).isPresent(); }

    public Msg label() { return Msg.of("world.map." + id); }

    public Msg startLabel(StartSlot slot) { return Msg.of("world.start." + id + "." + slot.id() + ".name"); }

    public Msg startNote(StartSlot slot) { return Msg.of("world.start." + id + "." + slot.id() + ".note"); }

    /** All edges: city–city roads and estate–neighbour roads. */
    public List<List<String>> allEdges() {
        List<List<String>> out = new ArrayList<>(cityEdges);
        for (StartSlot slot : starts) {
            for (String neighbor : slot.neighbors()) {
                out.add(List.of(slot.nodeId(), neighbor));
            }
        }
        return out;
    }

    public boolean hasEdge(String from, String to) {
        return allEdges().stream().anyMatch(edge -> (edge.get(0).equals(from) && edge.get(1).equals(to)) || (edge.get(0).equals(to) && edge.get(1).equals(from)));
    }

    /** Name of a node: a city or an estate ("estate:<slot>"). An unknown node is shown by its id. */
    public Object nodeName(String node) {
        if (node.startsWith(StartSlot.NODE_PREFIX)) {
            return start(node.substring(StartSlot.NODE_PREFIX.length())).<Object>map(this::startLabel).orElse(node);
        }
        return city(node).<Object>map(CityDef::label).orElse(node);
    }
}
