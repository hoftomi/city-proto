package com.hof.tronnelkul.game.engine;

import org.junit.jupiter.api.Test;
import tools.jackson.databind.json.JsonMapper;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class StateUpgradeTest {
    final JsonMapper json = JsonMapper.builder().build();

    /** A state saved before the bronze change: no version, money in decimal gold. */
    static final String OLD = """
        {"clock":1,"settlements":3,"seq":40,
         "players":{"a":{"id":"a","name":"A","gold":117.0,"pp":5,"legit":2},"b":{"id":"b","name":"B","gold":12.345,"pp":1,"legit":0}},
         "cities":{"szelmezo":{"lastTaxPool":4.35,"pop":{"a":12.5},"goods":{"grain":{"supply":10,"demand":8,"sold":{"a":3.5},"history":[0.3,0.45]}}},
                   "delkapu":{"lastTaxPool":null,"goods":{}}},
         "drafts":{"a":[{"id":"o1","type":"route","from":"x","to":"y","gold":3}]},
         "sheets":[{"id":"L2","player":"b","gold":23,"pp":2,"orders":[{"id":"o2","type":"buyout","city":"szelmezo","good":"grain","target":"a","pts":5,"gold":23}]}],
         "intel":[{"id":"i3","owner":"a","sheetId":"L2","of":"b","depth":3,"orders":[{"id":"o2","type":"buyout","pts":5,"gold":23}]}],
         "offers":[{"id":"f4","intelId":"i3","seller":"a","buyer":"b","price":10}]}
        """;

    @Test
    void oldStateMoneyIsConvertedToBronze() {
        EngineState state = StateUpgrade.read(json, OLD);
        assertEquals(EngineState.CURRENT_VERSION, state.version);
        assertEquals(11_700, state.players.get("a").gold);
        assertEquals(1235, state.players.get("b").gold, "rounded to whole bronze");
        assertEquals(435L, state.cities.get("szelmezo").lastTaxPool);
        assertNull(state.cities.get("delkapu").lastTaxPool);
        EngineState.Good grain = state.cities.get("szelmezo").goods.get("grain");
        assertEquals(List.of(30.0, 45.0), grain.history);
        assertEquals(300, state.draftOf("a").get(0).gold);
        assertEquals(2300, state.sheets.get(0).gold);
        assertEquals(2300, state.sheets.get(0).orders.get(0).gold);
        assertEquals(2300, state.intel.get(0).orders.get(0).gold);
        assertEquals(1000, state.offers.get(0).price);
        // Non-money values stay
        assertEquals(5, state.players.get("a").pp);
        assertEquals(12.5, state.cities.get("szelmezo").pop.get("a"));
        assertEquals(3.5, grain.sold.get("a"));
        assertEquals(5, state.sheets.get(0).orders.get(0).pts);
        assertEquals(10, grain.supply);
        // The market value is now per point in bronze: avg(30, 45) × 10
        assertEquals(375, Engine.marketValue(grain));
    }

    @Test
    void currentStateIsNotConvertedAgain() {
        String once = json.writeValueAsString(StateUpgrade.read(json, OLD));
        assertTrue(once.contains("\"version\":" + EngineState.CURRENT_VERSION), once);
        String twice = json.writeValueAsString(StateUpgrade.read(json, once));
        assertEquals(once, twice);
    }

    @Test
    void newStateHasTheCurrentVersion() {
        assertEquals(EngineState.CURRENT_VERSION, new EngineState().version);
        EngineState state = Setup.initial(EngineTest.MAP, EngineTest.START);
        assertEquals(state.version, StateUpgrade.read(json, json.writeValueAsString(state)).version);
    }
}
