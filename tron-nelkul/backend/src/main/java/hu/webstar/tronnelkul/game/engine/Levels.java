package hu.webstar.tronnelkul.game.engine;

import java.util.*;

/** Kontrollszintek és segédszámítások (6. fejezet). */
public final class Levels {
    private Levels() {}

    public enum Level {
        NONE(null, 0), JELENLET("jelenlet", 1), PARTNER("partner", 2), DOMINANS("dominans", 3),
        VAROSKONTROLL("varoskontroll", 4), PROTEKTORATUS("protektoratus", 5);
        public final String id; public final int rank;
        Level(String id, int rank) { this.id = id; this.rank = rank; }
        public String label() {
            return switch (this) {
                case NONE -> "nincs jelenlét"; case JELENLET -> "Jelenlét"; case PARTNER -> "Helyi partner";
                case DOMINANS -> "Domináns"; case VAROSKONTROLL -> "Városkontroll"; case PROTEKTORATUS -> "Protektorátus";
            };
        }
    }

    public static double neutral(Map<String, Share> fac) {
        double used = 0;
        for (Share s : fac.values()) used += s.total();
        return Math.max(0, 100 - used);
    }

    /** Nyílt befolyás szerint csökkenő sorrend. */
    public static List<Map.Entry<String, Share>> ranking(Map<String, Share> fac) {
        List<Map.Entry<String, Share>> list = new ArrayList<>(fac.entrySet());
        list.sort((x, y) -> Double.compare(y.getValue().open, x.getValue().open));
        return list;
    }

    /** A Domináns szereplő, ha van: legalább 35 nyílt és legalább 5 pont előny. */
    public static String dominant(Map<String, Share> fac) {
        List<Map.Entry<String, Share>> r = ranking(fac);
        if (r.isEmpty()) return null;
        double first = r.get(0).getValue().open, second = r.size() > 1 ? r.get(1).getValue().open : 0;
        return first >= Rules.T_DOMINANS && first - second >= Rules.T_LEAD ? r.get(0).getKey() : null;
    }

    public static int dominantCount(EngineState s, String city, String player) {
        int n = 0;
        for (Faction f : Faction.values()) if (player.equals(dominant(s.fac(city, f)))) n++;
        return n;
    }

    public static Level level(EngineState s, String city, Faction f, String player) {
        Map<String, Share> fac = s.fac(city, f);
        double mine = fac.containsKey(player) ? fac.get(player).open : 0;
        boolean dom = player.equals(dominant(fac));
        int doms = dominantCount(s, city, player);
        if (dom && doms == 3) return Level.PROTEKTORATUS;
        if (dom && doms == 2) return Level.VAROSKONTROLL;
        if (dom) return Level.DOMINANS;
        if (mine >= Rules.T_PARTNER) return Level.PARTNER;
        if (mine >= Rules.T_JELENLET) return Level.JELENLET;
        return Level.NONE;
    }
}
