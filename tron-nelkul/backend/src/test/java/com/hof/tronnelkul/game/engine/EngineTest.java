package com.hof.tronnelkul.game.engine;

import com.hof.tronnelkul.game.engine.EngineState.*;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.GoodDef;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.i18n.Messages;
import com.hof.tronnelkul.i18n.TranslationService;
import org.junit.jupiter.api.Test;
import tools.jackson.databind.json.JsonMapper;

import java.time.LocalDate;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class EngineTest {
    static final MapDefinition MAP = MapRegistry.DELKELET;
    /** 09:30 on a day: the next settlement is at 20:00. */
    static final long START = LocalDate.of(2026, 9, 1).atTime(9, 30).atZone(Time.ZONE).toInstant().toEpochMilli();
    static final long MIN = 60_000L;
    static final Messages MESSAGES = new Messages(new TranslationService(JsonMapper.builder().build()));

    static Engine game() { return new Engine(MAP, Setup.initial(MAP, START), 42); }

    static Order order(String type, String city) { Order o = new Order(); o.type = type; o.city = city; return o; }

    static void join(Engine e, String id, String background, String startGood) {
        Setup.addPlayer(e.s, id, id.toUpperCase(), "blue", background, MAP.start("west").orElseThrow(), startGood);
    }

    @Test
    void demandSplitsByWeightLikeTheRulebookExample() {
        // 5.3 example: Feketerev, salt. A 50 points Expensive P30, B 30 points Cheap P50, the City's 20 points Market P20.
        Engine e = game();
        for (String p : new String[] { "a", "b" }) { PlayerSt ps = new PlayerSt(); ps.id = p; ps.name = p; ps.npc = true; e.s.players.put(p, ps); }
        CitySt c = e.s.cities.get("feketerev");
        Good salt = c.goods.get("salt");
        salt.shares.put("a", 50); salt.margins.put("a", "expensive");
        salt.shares.put("b", 30); salt.margins.put("b", "cheap");
        c.pop.put("a", 30.0); c.pop.put("b", 50.0);
        e.settle();
        assertEquals(35.1, salt.sold.get("a"), 0.05);
        assertEquals(30.0, salt.sold.get("b"), 0.05);
        assertEquals(14.9, salt.sold.get(Engine.CITY), 0.05);
        // B is the cheapest: +1 (Cheap) +1 (cheapest), then the drift −2
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
        join(e, "te", "merchant", "grain");
        Order r = order("route", null); r.from = "szelmezo"; r.to = "feketerev";
        e.addDraft("te", r);
        e.seal("te", START, 120);
        assertEquals(2, e.s.routesOf("te").size(), "two free routes start from the estate");
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
        assertEquals("engine.error.sheet_maturing", ex.msg().key());
    }

    @Test
    void sealedDefenceBlocksBuyout() {
        Engine e = game();
        join(e, "a", "merchant", "grain");
        join(e, "b", "merchant", "grain");
        e.s.players.get("a").gold = 200;
        Order bo = order("buyout", "szelmezo"); bo.good = "grain"; bo.target = "b"; bo.pts = 5;
        e.addDraft("a", bo);
        Sheet attack = e.seal("a", START, 120);
        // B seals an hour later: its sheet would run after the offer, but it defends while maturing
        Order d = order("defend", "szelmezo"); d.sheetId = attack.id; d.orderId = attack.orders.get(0).id;
        e.s.players.get("b").gold = 200;
        e.addDraft("b", d);
        e.seal("b", START + 60 * MIN, 120);
        e.advance(START + 200 * MIN, 120, 28);
        Good g = e.s.cities.get("szelmezo").goods.get("grain");
        assertEquals(20, g.shares.get("b"));
        assertEquals(20, g.shares.get("a"));
        assertEquals(200, e.s.players.get("a").gold, 0.001, "the price of the foiled offer is refunded");
    }

    @Test
    void buyoutTransfersSharesAndPaysTheRival() {
        Engine e = game();
        join(e, "a", "merchant", "grain");
        join(e, "b", "merchant", "grain");
        e.s.players.get("a").gold = 200;
        Order bo = order("buyout", "szelmezo"); bo.good = "grain"; bo.target = "b"; bo.pts = 5;
        Order added = e.addDraft("a", bo);
        e.seal("a", START, 120);
        e.advance(START + 121 * MIN, 120, 28);
        Good g = e.s.cities.get("szelmezo").goods.get("grain");
        assertEquals(25, g.shares.get("a"));
        assertEquals(15, g.shares.get("b"));
        assertEquals(30 + added.gold, e.s.players.get("b").gold, 0.001);
        assertTrue(e.isProtected("szelmezo", "grain", "b"));
        assertTrue(e.newsTruth("szelmezo", "boughtOut", "a", null));
    }

    @Test
    void falseNewsCanBeVerifiedAndDebunked() {
        Engine e = game();
        join(e, "liar", null, null);
        join(e, "victim", "merchant", "grain");
        join(e, "spy", "shadow", null);
        Order n = order("news", "szelmezo"); n.template = "usury"; n.target = "victim"; n.good = "grain"; // Market: false
        assertFalse(e.newsTruth("szelmezo", "usury", "victim", "grain"));
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
        assertEquals(10.0, e.popOf("szelmezo", "liar"), 0.001, "20 − 10 penalty");
        assertEquals(Rules.DEBUNK_REWARD_LEGIT, e.s.players.get("spy").legit);
    }

    @Test
    void settlementRunsAtEightPmAndElectionEverySixth() {
        Engine e = game();
        join(e, "te", "noble", null);
        e.advance(START + 11 * 60 * MIN, 120, 28); // 20:30
        assertEquals(1, e.s.settlements);
        assertEquals(20, e.s.players.get("te").pp);
        e.advance(START + 3 * 24 * 60 * MIN, 120, 28);
        assertEquals(6, e.s.settlements);
        assertTrue(e.s.cities.get("szelmezo").council.getOrDefault("te", 0) > 0, "the noble house's party got into the council");
    }

    @Test
    void stateSurvivesJsonRoundTrip() {
        Engine e = game();
        join(e, "te", "merchant", "grain");
        Setup.addNpc(e.s, MAP, 0, "npc", "NPC", "gold", "trader");
        e.advance(START + 2 * 24 * 60 * MIN, 120, 28);
        JsonMapper json = JsonMapper.builder().build();
        String a = json.writeValueAsString(e.s);
        String b = json.writeValueAsString(json.readValue(a, EngineState.class));
        assertEquals(a, b);
    }

    @Test
    void fullSeasonWithNpcsRunsToTheEnd() {
        Engine e = game();
        join(e, "te", "merchant", "grain");
        String[][] npcs = { { "trader", "gold" }, { "politician", "green" }, { "spymaster", "purple" }, { "raider", "black" } };
        for (int i = 0; i < npcs.length; i++) Setup.addNpc(e.s, MAP, i, "npc" + i, "NPC" + i, npcs[i][1], npcs[i][0]);
        e.advance(START + 15L * 24 * 60 * MIN, 120, 28);
        assertEquals(28, e.s.settlements);
        e.coronation();
        assertTrue(e.s.players.values().stream().anyMatch(p -> p.legit > 0));
        assertTrue(e.s.cities.values().stream().anyMatch(c -> !c.council.isEmpty()), "there was an election");
        assertTrue(e.out.stream().anyMatch(r -> r.title().key().equals("engine.report.buyout_threat.title") || r.title().key().equals("engine.report.plans.title")),
            "NPCs act against the player too");
        // Every report text resolves fully: no missing key, no unfilled placeholder
        for (ReportOut r : e.out) for (Msg m : new Msg[] { r.title(), r.text() }) {
            String t = MESSAGES.text(m);
            assertFalse(t.contains("{") || t.startsWith("engine.") || t.contains(" engine.") || t.contains("world.") || t.contains("catalog."), m.key() + ": " + t);
        }
        e.s.players.values().forEach(p -> assertTrue(p.gold >= 0 && p.pp <= Rules.PP_MAX));
    }

    @Test
    void scoutingRevealsOnlyOrdersOfThatCity() {
        Engine e = game();
        join(e, "target", "merchant", "grain");
        join(e, "spy", "shadow", null);
        e.s.players.get("target").gold = 100;
        e.addDraft("target", order("hireSpy", "delkapu"));
        Order m = order("margin", "szelmezo"); m.good = "grain"; m.level = "expensive";
        e.addDraft("target", m);
        e.seal("target", START, 120);
        Order sp = order("spy", "szelmezo"); sp.target = "target";
        e.addDraft("spy", sp);
        e.seal("spy", START + 10 * MIN, 100); // the spy's runs first
        e.advance(START + 115 * MIN, 120, 28);
        Intel it = e.s.intel.get(0);
        assertEquals(1, it.orders.size());
        Msg line = e.intelLines(it).get(0);
        assertEquals("engine.order.margin", line.key());
        String text = MESSAGES.text(line);
        assertTrue(text.startsWith(MESSAGES.text(GoodDef.label("grain"))) && text.contains(MESSAGES.text(Rules.Margin.EXPENSIVE.label())), text);
    }

    @Test
    void spyCanBeMovedToAnotherCityInTheNetwork() {
        Engine e = game();
        join(e, "te", "shadow", null);
        Order mv = order("moveSpy", "szelmezo"); mv.to = "delkapu";
        e.addDraft("te", mv);
        e.seal("te", START, 120);
        e.advance(START + 121 * MIN, 120, 28);
        assertEquals(1, e.s.cities.get("szelmezo").spies.get("te"));
        assertEquals(1, e.s.cities.get("delkapu").spies.get("te"));
        Order far = order("moveSpy", "szelmezo"); far.to = "holtag";
        assertThrows(EngineException.class, () -> e.addDraft("te", far), "holtag is not in the network");
    }

    @Test
    void npcsSealWithTheSameMaturationAtAnyTime() {
        Engine e = game();
        join(e, "te", null, null);
        Setup.addNpc(e.s, MAP, 0, "npc", "NPC", "gold", "trader");
        e.scheduleNpcs();
        long planAt = e.s.players.get("npc").nextPlanAt;
        assertTrue(planAt >= START && planAt < START + 6 * 60 * MIN);
        e.advance(planAt, 120, 28);
        Sheet sheet = e.s.sheetOf("npc").orElseThrow();
        assertEquals(planAt, sheet.sealedAt);
        assertEquals(120 * MIN, sheet.executeAt - sheet.sealedAt);
    }
}
