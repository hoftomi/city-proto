package com.hof.tronnelkul.game.engine;

import com.hof.tronnelkul.game.engine.EngineState.*;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.world.GoodDef;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.StartSlot;

import java.util.List;

/** Az induló állapot: városok, NPC-házak, csatlakozó játékos (szabálykönyv v0.2, 2. fejezet). */
public final class Setup {
    private Setup() {}

    public static EngineState initial(MapDefinition map, long startAt) {
        EngineState s = new EngineState();
        s.clock = startAt;
        for (CityDef c : map.cities()) {
            CitySt cs = new CitySt();
            for (GoodDef gd : c.goods()) {
                Good g = new Good();
                g.name = gd.name(); g.supply = gd.supply(); g.demand = gd.demand();
                cs.goods.put(gd.id(), g);
            }
            s.cities.put(c.id(), cs);
        }
        return s;
    }

    /**
     * Egy NPC-ház a jelleme szerinti kezdőállással, két városban (az i. NPC a 2i. és 2i+1. városban).
     * persona: kalmar (árazó kereskedő), felvasarlo (kivásárló), politikus (párt, fesztivál, hírek), kem (kémek, álhírek).
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
            case "kalmar" -> { take(ca, 0, id, 30, "draga"); take(cb, 0, id, 15, "piaci"); }
            case "felvasarlo" -> { take(ca, 0, id, 35, "uzsora"); take(cb, 1, id, 25, "piaci"); ca.parties.put(id, "magas"); }
            case "politikus" -> { ca.parties.put(id, "kozepes"); cb.parties.put(id, "alacsony"); take(ca, 1, id, 15, "draga"); ca.pop.put(id, 22.0); cb.pop.put(id, 20.0); }
            case "kem" -> { ca.spies.put(id, 2); cb.spies.put(id, 1); take(ca, 1, id, 10, "uzsora"); take(cb, 0, id, 20, "piaci"); }
            default -> {}
        }
    }

    /**
     * Csatlakozó játékos: 10 PP, 30 A, a kezdővárosban 20 N, két ingyenes útvonal a birtokból (2.2), és a háttér bónusza:
     * kereskedo: 20 részesedés a választott árucikkből · nemesi: párt és +10 N · arnyek: 2 kém — mind a kezdővárosban.
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
            case "kereskedo" -> {
                Good g = startGood == null ? null : cs.goods.get(startGood);
                if (g == null) g = cs.goods.values().stream().max((x, y) -> Integer.compare(Engine.cityShare(x), Engine.cityShare(y))).orElseThrow();
                int pts = Math.min(Rules.MERCHANT_START_SHARES, Engine.cityShare(g));
                if (pts > 0) { g.shares.merge(id, pts, Integer::sum); g.margins.put(id, "piaci"); }
            }
            case "nemesi" -> { cs.parties.put(id, "kozepes"); cs.pop.put(id, Rules.POP_HOME + Rules.NOBLE_START_POP); }
            case "arnyek" -> cs.spies.put(id, Rules.SHADOW_START_SPIES);
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
