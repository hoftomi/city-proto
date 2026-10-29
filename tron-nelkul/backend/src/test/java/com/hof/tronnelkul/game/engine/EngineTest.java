package com.hof.tronnelkul.game.engine;

import com.hof.tronnelkul.api.model.Background;
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

    static Order order(String type, String city) { Order order = new Order(); order.type = type; order.city = city; return order; }

    static void join(Engine engine, String id, Background background, String startGood) {
        Setup.addPlayer(engine.state, id, id.toUpperCase(), background, MAP.start("west").orElseThrow(), startGood);
    }

    @Test
    void demandSplitsByWeightLikeTheRulebookExample() {
        // 5.3 example: Feketerev, salt. A 50 points Expensive P30, B 30 points Cheap P50, the City's 20 points Market P20.
        Engine engine = game();
        for (String player : new String[] { "a", "b" }) {
            PlayerSt house = new PlayerSt(); house.id = player; house.name = player; house.npc = true; engine.state.players.put(player, house);
        }
        CitySt cs = engine.state.cities.get("feketerev");
        Good salt = cs.goods.get("salt");
        salt.shares.put("a", 50); salt.margins.put("a", "expensive");
        salt.shares.put("b", 30); salt.margins.put("b", "cheap");
        cs.pop.put("a", 30.0); cs.pop.put("b", 50.0);
        engine.settle();
        assertEquals(35.1, salt.sold.get("a"), 0.05);
        assertEquals(30.0, salt.sold.get("b"), 0.05);
        assertEquals(14.9, salt.sold.get(Engine.CITY), 0.05);
        // B is the cheapest: +1 (Cheap) +1 (cheapest), then the drift −2
        assertEquals(50.0, cs.pop.get("b"), 0.001);
    }

    @Test
    void dhondtWithThreshold() {
        assertEquals(Map.of("a", 6, "b", 2, "c", 1), Engine.dhondt(Map.of("a", 100.0, "b", 45.0, "c", 20.0), 9, 0.05));
        assertFalse(Engine.dhondt(Map.of("a", 100.0, "d", 4.0), 9, 0.05).containsKey("d"));
    }

    @Test
    void sealedSheetRunsAfterMaturation() {
        Engine engine = game();
        join(engine, "te", Background.MERCHANT, "grain");
        Order order = order("route", null); order.from = "szelmezo"; order.to = "feketerev";
        engine.addDraft("te", order);
        engine.seal("te", START, 120);
        assertEquals(2, engine.state.routesOf("te").size(), "two free routes start from the estate");
        engine.advance(START + 119 * MIN, 120, 28);
        assertFalse(engine.hasRoute("te", "szelmezo", "feketerev"));
        engine.advance(START + 121 * MIN, 120, 28);
        assertTrue(engine.hasRoute("te", "szelmezo", "feketerev"));
        assertEquals(10 - 1, engine.state.players.get("te").pp);
        assertEquals(30 - 3, engine.state.players.get("te").gold, 0.001);
    }

    @Test
    void onlyOneMaturingSheet() {
        Engine engine = game();
        join(engine, "te", null, null);
        engine.state.players.get("te").gold = 100;
        engine.addDraft("te", order("hireSpy", "szelmezo"));
        engine.seal("te", START, 120);
        engine.addDraft("te", order("hireSpy", "szelmezo"));
        EngineException ex = assertThrows(EngineException.class, () -> engine.seal("te", START + MIN, 120));
        assertEquals("engine.error.sheet_maturing", ex.msg().key());
    }

    @Test
    void sealedDefenceBlocksBuyout() {
        Engine engine = game();
        join(engine, "a", Background.MERCHANT, "grain");
        join(engine, "b", Background.MERCHANT, "grain");
        engine.state.players.get("a").gold = 200;
        Order bo = order("buyout", "szelmezo"); bo.good = "grain"; bo.target = "b"; bo.pts = 5;
        engine.addDraft("a", bo);
        Sheet attack = engine.seal("a", START, 120);
        // B seals an hour later: its sheet would run after the offer, but it defends while maturing
        Order defence = order("defend", "szelmezo"); defence.sheetId = attack.id; defence.orderId = attack.orders.get(0).id;
        engine.state.players.get("b").gold = 200;
        engine.addDraft("b", defence);
        engine.seal("b", START + 60 * MIN, 120);
        engine.advance(START + 200 * MIN, 120, 28);
        Good good = engine.state.cities.get("szelmezo").goods.get("grain");
        assertEquals(20, good.shares.get("b"));
        assertEquals(20, good.shares.get("a"));
        assertEquals(200, engine.state.players.get("a").gold, 0.001, "the price of the foiled offer is refunded");
    }

    @Test
    void buyoutTransfersSharesAndPaysTheRival() {
        Engine engine = game();
        join(engine, "a", Background.MERCHANT, "grain");
        join(engine, "b", Background.MERCHANT, "grain");
        engine.state.players.get("a").gold = 200;
        Order bo = order("buyout", "szelmezo"); bo.good = "grain"; bo.target = "b"; bo.pts = 5;
        Order added = engine.addDraft("a", bo);
        engine.seal("a", START, 120);
        engine.advance(START + 121 * MIN, 120, 28);
        Good good = engine.state.cities.get("szelmezo").goods.get("grain");
        assertEquals(25, good.shares.get("a"));
        assertEquals(15, good.shares.get("b"));
        assertEquals(30 + added.gold, engine.state.players.get("b").gold, 0.001);
        assertTrue(engine.isProtected("szelmezo", "grain", "b"));
        assertTrue(engine.newsTruth("szelmezo", "boughtOut", "a", null));
    }

    @Test
    void falseNewsCanBeVerifiedAndDebunked() {
        Engine engine = game();
        join(engine, "liar", null, null);
        join(engine, "victim", Background.MERCHANT, "grain");
        join(engine, "spy", Background.SHADOW, null);
        Order newsOrder = order("news", "szelmezo"); newsOrder.template = "usury"; newsOrder.target = "victim"; newsOrder.good = "grain"; // Market: false
        assertFalse(engine.newsTruth("szelmezo", "usury", "victim", "grain"));
        engine.addDraft("liar", newsOrder);
        engine.seal("liar", START, 120);
        engine.advance(START + 121 * MIN, 120, 28);
        News news = engine.state.news.get(0);
        assertFalse(news.trueAtCreation);
        assertEquals(15.0, engine.popOf("szelmezo", "victim"), 0.001);

        Order verify = order("verify", "szelmezo"); verify.newsId = news.id;
        engine.addDraft("spy", verify);
        engine.seal("spy", START + 130 * MIN, 120);
        engine.advance(START + 260 * MIN, 120, 28);
        assertEquals(Boolean.FALSE, engine.state.players.get("spy").verified.get(news.id));

        Order debunk = order("debunk", "szelmezo"); debunk.newsId = news.id;
        engine.addDraft("spy", debunk);
        engine.seal("spy", START + 270 * MIN, 120);
        engine.advance(START + 400 * MIN, 120, 28);
        assertTrue(news.debunked);
        assertEquals(20.0, engine.popOf("szelmezo", "victim"), 0.001);
        assertEquals(10.0, engine.popOf("szelmezo", "liar"), 0.001, "20 − 10 penalty");
        assertEquals(Rules.DEBUNK_REWARD_LEGIT, engine.state.players.get("spy").legit);
    }

    @Test
    void settlementRunsAtEightPmAndElectionEverySixth() {
        Engine engine = game();
        join(engine, "te", Background.NOBLE, null);
        engine.advance(START + 11 * 60 * MIN, 120, 28); // 20:30
        assertEquals(1, engine.state.settlements);
        assertEquals(20, engine.state.players.get("te").pp);
        engine.advance(START + 3 * 24 * 60 * MIN, 120, 28);
        assertEquals(6, engine.state.settlements);
        assertTrue(engine.state.cities.get("szelmezo").council.getOrDefault("te", 0) > 0, "the noble house's party got into the council");
    }

    @Test
    void stateSurvivesJsonRoundTrip() {
        Engine engine = game();
        join(engine, "te", Background.MERCHANT, "grain");
        Setup.addNpc(engine.state, MAP, 0, "npc", "NPC", "trader");
        engine.advance(START + 2 * 24 * 60 * MIN, 120, 28);
        JsonMapper json = JsonMapper.builder().build();
        String written = json.writeValueAsString(engine.state);
        String rewritten = json.writeValueAsString(json.readValue(written, EngineState.class));
        assertEquals(written, rewritten);
    }

    @Test
    void fullSeasonWithNpcsRunsToTheEnd() {
        Engine engine = game();
        join(engine, "te", Background.MERCHANT, "grain");
        String[] npcs = { "trader", "politician", "spymaster", "raider" };
        for (int npcIndex = 0; npcIndex < npcs.length; npcIndex++) {
            Setup.addNpc(engine.state, MAP, npcIndex, "npc" + npcIndex, "NPC" + npcIndex, npcs[npcIndex]);
        }
        engine.advance(START + 15L * 24 * 60 * MIN, 120, 28);
        assertEquals(28, engine.state.settlements);
        engine.coronation();
        assertTrue(engine.state.players.values().stream().anyMatch(house -> house.legit > 0));
        assertTrue(engine.state.cities.values().stream().anyMatch(cs -> !cs.council.isEmpty()), "there was an election");
        assertTrue(engine.out.stream().anyMatch(report -> report.title().key().equals("engine.report.buyout_threat.title") || report.title().key().equals("engine.report.plans.title")),
            "NPCs act against the player too");
        // Every report text resolves fully: no missing key, no unfilled placeholder
        for (ReportOut report : engine.out) {
            for (Msg msg : new Msg[] { report.title(), report.text() }) {
                String text = MESSAGES.text(msg);
                assertFalse(text.contains("{") || text.startsWith("engine.") || text.contains(" engine.") || text.contains("world.") || text.contains("catalog."), msg.key() + ": " + text);
            }
        }
        engine.state.players.values().forEach(house -> assertTrue(house.gold >= 0 && house.pp <= Rules.PP_MAX));
    }

    @Test
    void scoutingRevealsOnlyOrdersOfThatCity() {
        Engine engine = game();
        join(engine, "target", Background.MERCHANT, "grain");
        join(engine, "spy", Background.SHADOW, null);
        engine.state.players.get("target").gold = 100;
        engine.addDraft("target", order("hireSpy", "delkapu"));
        Order margin = order("margin", "szelmezo"); margin.good = "grain"; margin.level = "expensive";
        engine.addDraft("target", margin);
        engine.seal("target", START, 120);
        Order sp = order("spy", "szelmezo"); sp.target = "target";
        engine.addDraft("spy", sp);
        engine.seal("spy", START + 10 * MIN, 100); // the spy's runs first
        engine.advance(START + 115 * MIN, 120, 28);
        Intel it = engine.state.intel.get(0);
        assertEquals(1, it.orders.size());
        Msg line = engine.intelLines(it).get(0);
        assertEquals("engine.order.margin", line.key());
        String text = MESSAGES.text(line);
        assertTrue(text.startsWith(MESSAGES.text(GoodDef.label("grain"))) && text.contains(MESSAGES.text(Rules.Margin.EXPENSIVE.label())), text);
    }

    @Test
    void spyCanBeMovedToAnotherCityInTheNetwork() {
        Engine engine = game();
        join(engine, "te", Background.SHADOW, null);
        Order mv = order("moveSpy", "szelmezo"); mv.to = "delkapu";
        engine.addDraft("te", mv);
        engine.seal("te", START, 120);
        engine.advance(START + 121 * MIN, 120, 28);
        assertEquals(1, engine.state.cities.get("szelmezo").spies.get("te"));
        assertEquals(1, engine.state.cities.get("delkapu").spies.get("te"));
        Order far = order("moveSpy", "szelmezo"); far.to = "holtag";
        assertThrows(EngineException.class, () -> engine.addDraft("te", far), "holtag is not in the network");
    }

    @Test
    void npcsSealWithTheSameMaturationAtAnyTime() {
        Engine engine = game();
        join(engine, "te", null, null);
        Setup.addNpc(engine.state, MAP, 0, "npc", "NPC", "trader");
        engine.scheduleNpcs();
        long planAt = engine.state.players.get("npc").nextPlanAt;
        assertTrue(planAt >= START && planAt < START + 6 * 60 * MIN);
        engine.advance(planAt, 120, 28);
        Sheet sheet = engine.state.sheetOf("npc").orElseThrow();
        assertEquals(planAt, sheet.sealedAt);
        assertEquals(120 * MIN, sheet.executeAt - sheet.sealedAt);
    }
}
