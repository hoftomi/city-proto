package com.hof.tronnelkul.game.engine;

import com.hof.tronnelkul.game.engine.EngineState.*;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.world.GoodDef;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.StartSlot;

import java.util.List;

/** Initial state: cities, NPC houses, joining player (rulebook v0.2, chapter 2). */
public final class Setup {
    private Setup() {}

    public static EngineState initial(MapDefinition map, long startAt) {
        EngineState s = new EngineState();
        s.clock = startAt;
        for (CityDef c : map.cities()) {
            CitySt cs = new CitySt();
            for (GoodDef gd : c.goods()) {
                Good g = new Good();
                g.supply = gd.supply(); g.demand = gd.demand();
                cs.goods.put(gd.id(), g);
            }
            s.cities.put(c.id(), cs);
        }
        return s;
    }

    /**
     * An NPC house with a starting position per its persona, in two cities (NPC i in cities 2i and 2i+1).
     * persona: trader (pricing merchant), raider (buyouts), politician (party, festivals, news), spymaster (spies, fake news).
     * name: the resolved display name.
     */
    public static void addNpc(EngineState s, MapDefinition map, int index, String id, String name, String tincture, String persona) {
        PlayerSt p = new PlayerSt();
        p.id = id; p.name = name; p.tincture = tincture; p.npc = true; p.persona = persona;
        p.gold = Rules.NPC_GOLD; p.pp = Rules.START_PP;
        s.players.put(id, p);
        List<CityDef> cities = map.cities();
        String a = cities.get((2 * index) % cities.size()).id(), b = cities.get((2 * index + 1) % cities.size()).id();
        CitySt ca = s.cities.get(a), cb = s.cities.get(b);
        ca.pop.put(id, 18.0); cb.pop.put(id, 14.0);
        switch (persona) {
            case "trader" -> { take(ca, 0, id, 30, "expensive"); take(cb, 0, id, 15, "market"); }
            case "raider" -> { take(ca, 0, id, 35, "usury"); take(cb, 1, id, 25, "market"); ca.parties.put(id, "high"); }
            case "politician" -> { ca.parties.put(id, "medium"); cb.parties.put(id, "low"); take(ca, 1, id, 15, "expensive"); ca.pop.put(id, 22.0); cb.pop.put(id, 20.0); }
            case "spymaster" -> { ca.spies.put(id, 2); cb.spies.put(id, 1); take(ca, 1, id, 10, "usury"); take(cb, 0, id, 20, "market"); }
            default -> {}
        }
    }

    /**
     * Joining player: 10 PP, 30 G, 20 P in the home city, two free routes from the estate (2.2), and the background bonus:
     * merchant: 20 shares of the chosen good · noble: party and +10 P · shadow: 2 spies — all in the home city.
     */
    public static void addPlayer(EngineState s, String id, String name, String tincture, String background, StartSlot slot, String startGood) {
        PlayerSt p = new PlayerSt();
        p.id = id; p.name = name; p.tincture = tincture; p.background = background; p.estate = slot.nodeId();
        p.gold = Rules.START_GOLD; p.pp = Rules.START_PP;
        s.players.put(id, p);
        for (String n : slot.neighbors()) s.routesOf(id).add(new Edge(slot.nodeId(), n));
        String home = slot.homeCity();
        CitySt cs = s.cities.get(home);
        cs.pop.put(id, Rules.POP_HOME);
        switch (background == null ? "" : background) {
            case "merchant" -> {
                Good g = startGood == null ? null : cs.goods.get(startGood);
                if (g == null) g = cs.goods.values().stream().max((x, y) -> Integer.compare(Engine.cityShare(x), Engine.cityShare(y))).orElseThrow();
                int pts = Math.min(Rules.MERCHANT_START_SHARES, Engine.cityShare(g));
                if (pts > 0) { g.shares.merge(id, pts, Integer::sum); g.margins.put(id, "market"); }
            }
            case "noble" -> { cs.parties.put(id, "medium"); cs.pop.put(id, Rules.POP_HOME + Rules.NOBLE_START_POP); }
            case "shadow" -> cs.spies.put(id, Rules.SHADOW_START_SPIES);
            default -> {}
        }
    }

    private static void take(CitySt cs, int goodIndex, String p, int pts, String margin) {
        List<Good> goods = List.copyOf(cs.goods.values());
        Good g = goods.get(Math.min(goodIndex, goods.size() - 1));
        int n = Math.min(pts, Engine.cityShare(g));
        if (n <= 0) return;
        g.shares.merge(p, n, Integer::sum);
        g.margins.put(p, margin);
    }
}
