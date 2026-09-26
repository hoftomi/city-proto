package hu.webstar.tronnelkul.game.engine;

import java.util.*;

/** Egy játékos hálózata: a birtokából saját útvonalain elérhető csomópontok és távolságuk (4.2–4.4). */
public final class Network {
    private Network() {}

    public static Map<String, Integer> of(EngineState s, String player) {
        PlayerState p = s.players.get(player);
        Map<String, Integer> dist = new LinkedHashMap<>();
        if (p == null || p.estateNode == null) return dist;
        dist.put(p.estateNode, 0);
        Deque<String> q = new ArrayDeque<>(List.of(p.estateNode));
        List<Edge> own = s.routesOf(player);
        while (!q.isEmpty()) {
            String n = q.poll();
            for (Edge e : own) {
                if (!e.touches(n)) continue;
                String m = e.other(n);
                if (!dist.containsKey(m)) { dist.put(m, dist.get(n) + 1); q.add(m); }
            }
        }
        return dist;
    }

    /** Az NPC-k hálózata a 0.0.1-ben nem korlátozott. */
    public static boolean reaches(EngineState s, String player, String city) {
        PlayerState p = s.players.get(player);
        if (p != null && p.npc) return true;
        return of(s, player).containsKey(city);
    }

    public static boolean owns(EngineState s, String player, String a, String b) {
        return s.routesOf(player).stream().anyMatch(e -> e.same(a, b));
    }
}
