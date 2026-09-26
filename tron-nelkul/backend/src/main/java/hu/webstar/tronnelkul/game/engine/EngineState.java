package hu.webstar.tronnelkul.game.engine;

import hu.webstar.tronnelkul.game.world.CityDef;
import hu.webstar.tronnelkul.game.world.MapDefinition;

import java.util.*;

/**
 * Egy játék teljes állapota a szabálymotor számára. Nincs benne Spring vagy JPA:
 * a szolgáltatási réteg tölti fel az adatbázisból, és írja vissza a feldolgozás után.
 */
public final class EngineState {
    public final MapDefinition map;
    public int round;
    public final Map<String, PlayerState> players = new LinkedHashMap<>();
    /** város → frakció → játékos → befolyás */
    public final Map<String, EnumMap<Faction, Map<String, Share>>> influence = new LinkedHashMap<>();
    public final Map<String, Stability> stability = new LinkedHashMap<>();
    /** játékos → saját útvonalai */
    public final Map<String, List<Edge>> routes = new LinkedHashMap<>();
    /** "játékos|város|frakció" → gyanú */
    public final Map<String, Suspicion> suspicion = new LinkedHashMap<>();
    public final List<OrderSpec> orders = new ArrayList<>();

    public EngineState(MapDefinition map, int round) {
        this.map = map;
        this.round = round;
        for (CityDef c : map.cities()) {
            EnumMap<Faction, Map<String, Share>> facs = new EnumMap<>(Faction.class);
            for (Faction f : Faction.values()) facs.put(f, new LinkedHashMap<>());
            influence.put(c.id(), facs);
            stability.put(c.id(), Stability.valueOf(c.initialStability()));
        }
    }

    public Map<String, Share> fac(String city, Faction f) { return influence.get(city).get(f); }

    public Share share(String city, Faction f, String player) {
        return fac(city, f).computeIfAbsent(player, k -> new Share(0, 0));
    }

    public List<Edge> routesOf(String player) { return routes.computeIfAbsent(player, k -> new ArrayList<>()); }

    public static String susKey(String player, String city, Faction f) { return player + "|" + city + "|" + f.id(); }

    public int suspicionOf(String player, String city, Faction f) {
        Suspicion s = suspicion.get(susKey(player, city, f));
        return s == null ? 0 : s.value;
    }
}
