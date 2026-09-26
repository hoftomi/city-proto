package hu.webstar.tronnelkul.game.engine;

import java.util.*;
import java.util.random.RandomGenerator;

/** Az NPC-házak döntési sorrendje (9.2), egyszerűsítve a 0.0.1-hez. */
public final class NpcBrain {
    private NpcBrain() {}

    public static List<OrderSpec> plan(EngineState s, RandomGenerator r) {
        List<OrderSpec> out = new ArrayList<>();
        List<String> cities = new ArrayList<>(s.influence.keySet());
        for (PlayerState h : s.players.values()) {
            if (!h.npc) continue;
            int[] pp = { Rules.NPC_PP };
            boolean hidden = "arnyek".equals(h.persona);
            java.util.function.Consumer<OrderSpec> push = o -> {
                int c = o.type.baseCost.pp();
                if (pp[0] >= c) { pp[0] -= c; out.add(o); }
            };
            // 1. Védekezés: ha Domináns, és a második 8 pontnál közelebb van
            for (String city : cities) for (Faction f : Faction.values()) {
                Map<String, Share> fac = s.fac(city, f);
                if (!h.id.equals(Levels.dominant(fac))) continue;
                List<Map.Entry<String, Share>> rk = Levels.ranking(fac);
                if (rk.size() > 1 && rk.get(0).getValue().open - rk.get(1).getValue().open < 8) {
                    push.accept(OrderSpec.action(h.id, ActionType.CONSOLIDATE, city, f, false, null));
                    push.accept(OrderSpec.action(h.id, ActionType.PATRON, city, f, hidden, null));
                }
            }
            // 3. Terjeszkedés a kedvenc frakcióban, ahol a legtöbb a Semleges
            List<String> byNeutral = new ArrayList<>(cities);
            byNeutral.sort((a, b) -> Double.compare(Levels.neutral(s.fac(b, h.favorite)), Levels.neutral(s.fac(a, h.favorite))));
            push.accept(OrderSpec.action(h.id, ActionType.GRANT, byNeutral.get(0), h.favorite, hidden, null));
            if (!"nemzetseg".equals(h.persona) && byNeutral.size() > 1)
                push.accept(OrderSpec.action(h.id, ActionType.PATRON, byNeutral.get(1), h.favorite, hidden, null));
            // 5. Intrika: Lejáratás a legerősebb emberi játékos ellen, ahol mindketten jelen vannak
            int roll = 1 + r.nextInt(6);
            int threshold = ("zsoldos".equals(h.persona) || "arnyek".equals(h.persona)) ? 4 : 5;
            if (roll >= threshold && h.npcCooldown <= s.round) {
                String bestCity = null; Faction bestF = null; String bestTarget = null; double best = 10;
                for (String city : cities) for (Faction f : Faction.values()) {
                    Map<String, Share> fac = s.fac(city, f);
                    if (!fac.containsKey(h.id)) continue;
                    for (Map.Entry<String, Share> e : fac.entrySet()) {
                        PlayerState t = s.players.get(e.getKey());
                        if (t == null || t.npc || e.getValue().open <= best) continue;
                        best = e.getValue().open; bestCity = city; bestF = f; bestTarget = t.id;
                    }
                }
                if (bestTarget != null) {
                    h.npcCooldown = s.round + 3;
                    push.accept(OrderSpec.action(h.id, ActionType.SMEAR, bestCity, bestF, false, bestTarget));
                }
            }
            if (r.nextBoolean())
                push.accept(OrderSpec.action(h.id, ActionType.PATRON, cities.get(r.nextInt(cities.size())), h.favorite, hidden, null));
        }
        return out;
    }
}
