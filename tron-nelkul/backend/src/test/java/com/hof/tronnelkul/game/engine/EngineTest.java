package com.hof.tronnelkul.game.engine;

import com.hof.tronnelkul.game.engine.EngineState.*;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import org.junit.jupiter.api.Test;
import tools.jackson.databind.json.JsonMapper;

import java.time.LocalDate;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class EngineTest {
    static final MapDefinition MAP = MapRegistry.DELKELET;
    /** 09:30 egy napon: a következő elszámolás 20:00-kor. */
    static final long START = LocalDate.of(2026, 9, 1).atTime(9, 30).atZone(Time.ZONE).toInstant().toEpochMilli();
    static final long MIN = 60_000L;

    static Engine game() { return new Engine(MAP, Setup.initial(MAP, START), 42); }

    static Order order(String type, String city) { Order o = new Order(); o.type = type; o.city = city; return o; }

    static void join(Engine e, String id, String background, String startGood) {
        Setup.addPlayer(e.s, id, id.toUpperCase(), "kek", background, MAP.start("nyugat").orElseThrow(), startGood);
    }

    @Test
    void demandSplitsByWeightLikeTheRulebookExample() {
        // 5.3 példa: Feketerév, Só. A 50 pont Drága N30, B 30 pont Olcsó N50, a Város 20 pontja Piaci N20.
        Engine e = game();
        for (String p : new String[] { "a", "b" }) { PlayerSt ps = new PlayerSt(); ps.id = p; ps.name = p; ps.npc = true; e.s.players.put(p, ps); }
        CitySt c = e.s.cities.get("feketerev");
        Good so = c.goods.get("so");
        so.shares.put("a", 50); so.margins.put("a", "draga");
        so.shares.put("b", 30); so.margins.put("b", "olcso");
        c.pop.put("a", 30.0); c.pop.put("b", 50.0);
        e.settle();
        assertEquals(35.1, so.sold.get("a"), 0.05);
        assertEquals(30.0, so.sold.get("b"), 0.05);
        assertEquals(14.9, so.sold.get(Engine.CITY), 0.05);
        // B a legolcsóbb: +1 (Olcsó) +1 (legolcsóbb), majd a visszahúzás −2
        assertEquals(50.0, c.pop.get("b"), 0.001);
    }

    @Test
    void dhondtWithThreshold() {
        assertEquals(Map.of("a", 6, "b", 2, "c", 1), Engine.dhondt(Map.of("a", 100.0, "b", 45.0, "c", 20.0), 9, 0.05));
        assertFalse(Engine.dhondt(Map.of("a", 100.0, "d", 4.0), 9, 0.05).containsKey("d"));
    }

    @Test
    void sealedSheetRunsAfterMaturation() {
        Engine e = game();
        join(e, "te", "kereskedo", "gabona");
        Order r = order("route", null); r.from = "szelmezo"; r.to = "feketerev";
        e.addDraft("te", r);
        e.seal("te", START, 120);
        assertEquals(2, e.s.routesOf("te").size(), "a birtokból két ingyenes útvonal indul");
        e.advance(START + 119 * MIN, 120, 28);
        assertFalse(e.hasRoute("te", "szelmezo", "feketerev"));
        e.advance(START + 121 * MIN, 120, 28);
        assertTrue(e.hasRoute("te", "szelmezo", "feketerev"));
        assertEquals(10 - 1, e.s.players.get("te").pp);
        assertEquals(30 - 3, e.s.players.get("te").gold, 0.001);
    }

    @Test
    void onlyOneMaturingSheet() {
        Engine e = game();
        join(e, "te", null, null);
        e.s.players.get("te").gold = 100;
        e.addDraft("te", order("hireSpy", "szelmezo"));
        e.seal("te", START, 120);
        e.addDraft("te", order("hireSpy", "szelmezo"));
        EngineException ex = assertThrows(EngineException.class, () -> e.seal("te", START + MIN, 120));
        assertTrue(ex.getMessage().contains("érlelő parancslapod"));
    }

    @Test
    void sealedDefenceBlocksBuyout() {
        Engine e = game();
        join(e, "a", "kereskedo", "gabona");
        join(e, "b", "kereskedo", "gabona");
        e.s.players.get("a").gold = 200;
        Order bo = order("buyout", "szelmezo"); bo.good = "gabona"; bo.target = "b"; bo.pts = 5;
        e.addDraft("a", bo);
        Lap attack = e.seal("a", START, 120);
        // B egy órával később pecsétel: az ő lapja az ajánlat után futna le, de érlelés közben már véd
        Order d = order("defend", "szelmezo"); d.lapId = attack.id; d.orderId = attack.orders.get(0).id;
        e.s.players.get("b").gold = 200;
        e.addDraft("b", d);
        e.seal("b", START + 60 * MIN, 120);
        e.advance(START + 200 * MIN, 120, 28);
        Good g = e.s.cities.get("szelmezo").goods.get("gabona");
        assertEquals(20, g.shares.get("b"));
        assertEquals(20, g.shares.get("a"));
        assertEquals(200, e.s.players.get("a").gold, 0.001, "a meghiúsult ajánlat ára visszajár");
    }

    @Test
    void buyoutTransfersSharesAndPaysTheRival() {
        Engine e = game();
        join(e, "a", "kereskedo", "gabona");
        join(e, "b", "kereskedo", "gabona");
        e.s.players.get("a").gold = 200;
        Order bo = order("buyout", "szelmezo"); bo.good = "gabona"; bo.target = "b"; bo.pts = 5;
        Order added = e.addDraft("a", bo);
        e.seal("a", START, 120);
        e.advance(START + 121 * MIN, 120, 28);
        Good g = e.s.cities.get("szelmezo").goods.get("gabona");
        assertEquals(25, g.shares.get("a"));
        assertEquals(15, g.shares.get("b"));
        assertEquals(30 + added.gold, e.s.players.get("b").gold, 0.001);
        assertTrue(e.isProtected("szelmezo", "gabona", "b"));
        assertTrue(e.newsTruth("szelmezo", "kivasarolt", "a", null));
    }

    @Test
    void falseNewsCanBeVerifiedAndDebunked() {
        Engine e = game();
        join(e, "liar", null, null);
        join(e, "victim", "kereskedo", "gabona");
        join(e, "spy", "arnyek", null);
        Order n = order("news", "szelmezo"); n.template = "uzsora"; n.target = "victim"; n.good = "gabona"; // Piaci: hamis
        assertFalse(e.newsTruth("szelmezo", "uzsora", "victim", "gabona"));
        e.addDraft("liar", n);
        e.seal("liar", START, 120);
        e.advance(START + 121 * MIN, 120, 28);
        News news = e.s.news.get(0);
        assertFalse(news.trueAtCreation);
        assertEquals(15.0, e.popOf("szelmezo", "victim"), 0.001);

        Order v = order("verify", "szelmezo"); v.newsId = news.id;
        e.addDraft("spy", v);
        e.seal("spy", START + 130 * MIN, 120);
        e.advance(START + 260 * MIN, 120, 28);
        assertEquals(Boolean.FALSE, e.s.players.get("spy").verified.get(news.id));

        Order d = order("debunk", "szelmezo"); d.newsId = news.id;
        e.addDraft("spy", d);
        e.seal("spy", START + 270 * MIN, 120);
        e.advance(START + 400 * MIN, 120, 28);
        assertTrue(news.debunked);
        assertEquals(20.0, e.popOf("szelmezo", "victim"), 0.001);
        assertEquals(10.0, e.popOf("szelmezo", "liar"), 0.001, "20 − 10 büntetés");
        assertEquals(Rules.DEBUNK_REWARD_LEGIT, e.s.players.get("spy").legit);
    }

    @Test
    void settlementRunsAtEightPmAndElectionEverySixth() {
        Engine e = game();
        join(e, "te", "nemesi", null);
        e.advance(START + 11 * 60 * MIN, 120, 28); // 20:30
        assertEquals(1, e.s.settlements);
        assertEquals(20, e.s.players.get("te").pp);
        e.advance(START + 3 * 24 * 60 * MIN, 120, 28);
        assertEquals(6, e.s.settlements);
        assertTrue(e.s.cities.get("szelmezo").council.getOrDefault("te", 0) > 0, "a nemesi ház pártja bejutott a tanácsba");
    }

    @Test
    void stateSurvivesJsonRoundTrip() {
        Engine e = game();
        join(e, "te", "kereskedo", "gabona");
        Setup.addNpc(e.s, MAP, 0, "npc", "NPC", "arany", "kalmar");
        e.advance(START + 2 * 24 * 60 * MIN, 120, 28);
        JsonMapper json = JsonMapper.builder().build();
        String a = json.writeValueAsString(e.s);
        String b = json.writeValueAsString(json.readValue(a, EngineState.class));
        assertEquals(a, b);
    }

    @Test
    void fullSeasonWithNpcsRunsToTheEnd() {
        Engine e = game();
        join(e, "te", "kereskedo", "gabona");
        String[][] npcs = { { "kalmar", "arany" }, { "politikus", "zold" }, { "kem", "bibor" }, { "felvasarlo", "fekete" } };
        for (int i = 0; i < npcs.length; i++) Setup.addNpc(e.s, MAP, i, "npc" + i, "NPC" + i, npcs[i][1], npcs[i][0]);
        e.advance(START + 15L * 24 * 60 * MIN, 120, 28);
        assertEquals(28, e.s.settlements);
        e.coronation();
        assertTrue(e.s.players.values().stream().anyMatch(p -> p.legit > 0));
        assertTrue(e.s.cities.values().stream().anyMatch(c -> !c.council.isEmpty()), "volt választás");
        assertTrue(e.out.stream().anyMatch(r -> r.title().contains("ki akar vásárolni") || r.title().contains("tervei")), "az NPC-k a játékos ellen is lépnek");
        e.s.players.values().forEach(p -> assertTrue(p.gold >= 0 && p.pp <= Rules.PP_MAX));
    }

    @Test
    void scoutingRevealsOnlyOrdersOfThatCity() {
        Engine e = game();
        join(e, "target", "kereskedo", "gabona");
        join(e, "spy", "arnyek", null);
        e.s.players.get("target").gold = 100;
        e.addDraft("target", order("hireSpy", "delkapu"));
        Order m = order("margin", "szelmezo"); m.good = "gabona"; m.level = "draga";
        e.addDraft("target", m);
        e.seal("target", START, 120);
        Order sp = order("spy", "szelmezo"); sp.target = "target";
        e.addDraft("spy", sp);
        e.seal("spy", START + 10 * MIN, 100); // a kémé előbb fut le
        e.advance(START + 115 * MIN, 120, 28);
        Intel it = e.s.intel.get(0);
        assertEquals(1, it.lines.size());
        assertTrue(it.lines.get(0).contains("Gabona ára"), it.lines.toString());
    }

    @Test
    void spyCanBeMovedToAnotherCityInTheNetwork() {
        Engine e = game();
        join(e, "te", "arnyek", null);
        Order mv = order("moveSpy", "szelmezo"); mv.to = "delkapu";
        e.addDraft("te", mv);
        e.seal("te", START, 120);
        e.advance(START + 121 * MIN, 120, 28);
        assertEquals(1, e.s.cities.get("szelmezo").spies.get("te"));
        assertEquals(1, e.s.cities.get("delkapu").spies.get("te"));
        Order far = order("moveSpy", "szelmezo"); far.to = "holtag";
        assertThrows(EngineException.class, () -> e.addDraft("te", far), "Holtág nincs a hálózatban");
    }

    @Test
    void npcsSealWithTheSameMaturationAtAnyTime() {
        Engine e = game();
        join(e, "te", null, null);
        Setup.addNpc(e.s, MAP, 0, "npc", "NPC", "arany", "kalmar");
        e.scheduleNpcs();
        long planAt = e.s.players.get("npc").nextPlanAt;
        assertTrue(planAt >= START && planAt < START + 6 * 60 * MIN);
        e.advance(planAt, 120, 28);
        Lap lap = e.s.lapOf("npc").orElseThrow();
        assertEquals(planAt, lap.sealedAt);
        assertEquals(120 * MIN, lap.executeAt - lap.sealedAt);
    }
}
