package hu.webstar.tronnelkul.game.world;

import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

/** A 0.0.1 térképei. Később adatbázisba vagy fájlba költöztethetők. */
public final class MapRegistry {
    private MapRegistry() {}

    private static double[] p(double... v) { return v; }

    public static final MapDefinition DELKELET = new MapDefinition("delkelet", "Délkelet",
        List.of(
            new CityDef("szelmezo", "Szélmező", 70, 72, false, false, "Gabonavidék", "INGATAG"),
            new CityDef("vaskapu", "Vaskapu", 205, 56, false, false, "Erődváros", "STABIL"),
            new CityDef("feketerev", "Feketerév", 238, 122, true, true, "Kikötőváros", "STABIL"),
            new CityDef("holtag", "Holtág", 205, 208, false, false, "Mocsári csempészváros", "LAZONGO"),
            new CityDef("delkapu", "Délkapu", 95, 190, false, false, "Határváros", "INGATAG")),
        List.of(List.of("szelmezo", "feketerev"), List.of("szelmezo", "vaskapu"), List.of("vaskapu", "feketerev"),
            List.of("feketerev", "holtag"), List.of("delkapu", "holtag"), List.of("szelmezo", "delkapu")),
        List.of(
            new StartSlot("nyugat", "Nyugati birtok", 28, 125, List.of("szelmezo", "delkapu"), "Két Ingatag város. Kiegyensúlyozott kezdés."),
            new StartSlot("mocsar", "Mocsárszél", 160, 238, List.of("holtag", "delkapu"), "Lázongó szomszéd: kockázatos, de kevés a rivális."),
            new StartSlot("hegyalja", "Hegyalja", 132, 112, List.of("szelmezo", "vaskapu"), "Közel a Katonasághoz és a kulcsvároshoz.")),
        new TerrainDef("M252 0C240 40 268 72 254 110C240 148 282 172 300 204C316 232 292 248 298 260H360V0Z",
            List.of("M168 36C176 60 206 70 216 90C224 104 238 100 257 98"),
            List.of(p(106, 42, 0.8), p(122, 32, 1), p(142, 24, 1.2), p(164, 32, 1), p(186, 26, 0.9)),
            List.of(p(56, 152, 7), p(176, 152, 6), p(270, 236, 4)),
            List.of(p(30, 36, 34, 18, -6), p(92, 86, 28, 16, 8)),
            List.of(p(198, 228, 6), p(226, 238, 4))));

    public static final MapDefinition KODOS = new MapDefinition("kodos", "Ködös Hegyvidék",
        List.of(
            new CityDef("kodvar", "Ködvár", 70, 90, true, false, "Hegyi nemesi fészek", "STABIL"),
            new CityDef("sziklaszirt", "Sziklaszirt", 170, 70, false, false, "Bányaváros", "INGATAG"),
            new CityDef("farkasrev", "Farkasrév", 290, 100, false, false, "Folyami rév", "STABIL"),
            new CityDef("ezustpatak", "Ezüstpatak", 110, 170, false, false, "Kereskedőváros", "INGATAG"),
            new CityDef("harmaskut", "Hármaskút", 240, 170, false, false, "Vásárváros", "STABIL"),
            new CityDef("melyvolgy", "Mélyvölgy", 180, 230, false, false, "Erődített völgy", "LAZONGO")),
        List.of(List.of("kodvar", "sziklaszirt"), List.of("sziklaszirt", "farkasrev"), List.of("kodvar", "ezustpatak"),
            List.of("sziklaszirt", "harmaskut"), List.of("farkasrev", "harmaskut"), List.of("ezustpatak", "harmaskut"),
            List.of("ezustpatak", "melyvolgy"), List.of("harmaskut", "melyvolgy")),
        List.of(
            new StartSlot("nyugat", "Nyugati erdőség", 24, 150, List.of("kodvar", "ezustpatak"), "Két gyenge, Ingatag város. Csendes kezdés."),
            new StartSlot("hago", "Hágó alatt", 180, 130, List.of("sziklaszirt", "harmaskut"), "A térkép közepe: sok lehetőség, sok rivális."),
            new StartSlot("kelet", "Keleti fennsík", 330, 160, List.of("farkasrev", "harmaskut"), "Erős katonai városok a közelben.")),
        new TerrainDef(null,
            List.of("M40 200C90 170 120 190 160 150C190 120 230 130 300 90C320 80 340 60 360 50"),
            List.of(p(60, 50, 1.1), p(84, 40, 1.3), p(110, 52, 1), p(230, 40, 1.2), p(254, 30, 1.4), p(280, 46, 1), p(300, 200, 1.1), p(322, 214, 0.9), p(140, 230, 0.9)),
            List.of(p(40, 120, 8), p(200, 190, 7), p(310, 130, 5)),
            List.of(p(120, 90, 30, 16, 6)),
            List.of()));

    public static final MapDefinition SO = new MapDefinition("so", "Sóvidék",
        List.of(
            new CityDef("sohegy", "Sóhegy", 60, 50, false, false, "Sóbánya", "STABIL"),
            new CityDef("kalmarrev", "Kalmárrév", 170, 110, true, true, "Kikötőváros", "STABIL"),
            new CityDef("tornyos", "Tornyos", 300, 70, false, false, "Erődváros", "INGATAG"),
            new CityDef("sosviz", "Sósvíz", 90, 150, false, true, "Halászváros", "INGATAG"),
            new CityDef("delirev", "Délirév", 250, 170, false, true, "Csempészkikötő", "LAZONGO")),
        List.of(List.of("sohegy", "kalmarrev"), List.of("kalmarrev", "tornyos"), List.of("sohegy", "sosviz"),
            List.of("sosviz", "kalmarrev"), List.of("kalmarrev", "delirev"), List.of("tornyos", "delirev")),
        List.of(
            new StartSlot("bany", "Bányavidék", 120, 30, List.of("sohegy", "kalmarrev"), "Közel a kulcsvároshoz. Erős Kereskedők."),
            new StartSlot("part", "Nyugati part", 30, 110, List.of("sohegy", "sosviz"), "Két kisváros, nyugodt partvidék."),
            new StartSlot("torony", "Tornyos-völgy", 330, 130, List.of("tornyos", "delirev"), "Távol a központtól, de védett.")),
        new TerrainDef("M0 190C60 180 90 210 140 200C200 188 240 220 300 206C330 200 350 214 360 210V260H0Z",
            List.of("M200 20C196 60 220 90 210 130C204 160 220 180 230 205"),
            List.of(p(300, 40, 1), p(322, 52, 0.8)),
            List.of(p(70, 80, 6), p(260, 110, 6)),
            List.of(p(120, 40, 34, 18, -4), p(40, 140, 30, 16, 6), p(280, 150, 30, 16, -8)),
            List.of(p(110, 170, 5))));

    private static final Map<String, MapDefinition> ALL = Map.of(DELKELET.id(), DELKELET, KODOS.id(), KODOS, SO.id(), SO);

    public static MapDefinition get(String id) {
        MapDefinition m = ALL.get(id);
        if (m == null) throw new NoSuchElementException("Ismeretlen térkép: " + id);
        return m;
    }
}
