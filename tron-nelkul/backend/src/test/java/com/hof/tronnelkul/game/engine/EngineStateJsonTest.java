package com.hof.tronnelkul.game.engine;

import com.hof.tronnelkul.api.model.Background;
import org.junit.jupiter.api.Test;
import tools.jackson.databind.json.JsonMapper;

import static org.junit.jupiter.api.Assertions.*;

class EngineStateJsonTest {
    final JsonMapper json = JsonMapper.builder().build();

    @Test
    void backgroundIsStoredAsItsApiValue() {
        EngineState.PlayerSt house = new EngineState.PlayerSt();
        house.id = "a"; house.background = Background.MERCHANT;
        String out = json.writeValueAsString(house);
        assertTrue(out.contains("\"background\":\"merchant\""), out);
        assertEquals(Background.MERCHANT, json.readValue(out, EngineState.PlayerSt.class).background);
    }

    @Test
    void stateWrittenBeforeTheTinctureRemovalStillReads() {
        EngineState.PlayerSt house = json.readValue("{\"id\":\"a\",\"name\":\"A\",\"tincture\":\"blue\",\"background\":\"noble\"}", EngineState.PlayerSt.class);
        assertEquals(Background.NOBLE, house.background);
        assertNull(json.readValue("{\"id\":\"npc\",\"tincture\":\"gold\",\"background\":null,\"npc\":true}", EngineState.PlayerSt.class).background);
    }

    @Test
    void edgeWrittenWithTheOldFieldNamesStillReads() {
        Edge old = json.readValue("{\"a\":\"estate:west\",\"b\":\"szelmezo\"}", Edge.class);
        assertEquals(new Edge("estate:west", "szelmezo"), old);
        EngineState state = json.readValue("{\"routes\":{\"p1\":[{\"a\":\"estate:west\",\"b\":\"delkapu\"}]}}", EngineState.class);
        assertEquals(new Edge("estate:west", "delkapu"), state.routesOf("p1").get(0));
        String out = json.writeValueAsString(new Edge("x1", "y1"));
        assertEquals(new Edge("x1", "y1"), json.readValue(out, Edge.class));
        assertTrue(out.contains("\"from\":\"x1\""), out);
    }
}
