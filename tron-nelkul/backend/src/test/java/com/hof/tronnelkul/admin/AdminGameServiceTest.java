package com.hof.tronnelkul.admin;

import com.hof.tronnelkul.api.model.CreateGameRequest;
import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.game.model.GameEntity;
import com.hof.tronnelkul.game.model.GameStatus;
import com.hof.tronnelkul.game.service.Npcs;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;

import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;
import java.util.function.Consumer;

import static org.junit.jupiter.api.Assertions.*;

class AdminGameServiceTest {
    static final Instant NOW = Instant.parse("2026-11-01T10:00:00Z");

    static CreateGameRequest request() {
        return new CreateGameRequest("autumn-cup-2", " Autumn cup ", "kodos", null, NOW.plus(Duration.ofDays(2)), 30, 2, List.of("League", " ", "a,b"));
    }

    static void rejects(String key, Consumer<CreateGameRequest> change) {
        CreateGameRequest r = request();
        change.accept(r);
        ApiException e = assertThrows(ApiException.class, () -> AdminGameService.newGame(r, NOW));
        assertEquals(HttpStatus.BAD_REQUEST, e.status);
        assertEquals(key, e.msg.key());
    }

    @Test
    void validGameIsOpen() {
        GameEntity g = AdminGameService.newGame(request(), NOW);
        assertEquals("autumn-cup-2", g.id);
        assertEquals("Autumn cup", g.name);
        assertEquals(GameStatus.OPEN, g.status);
        assertEquals("kodos", g.mapId);
        assertEquals(30, g.maxPlayers);
        assertEquals(2, g.npcCount);
        assertEquals("League,a b", g.tags);
        assertNull(g.opensAt);
        assertEquals(NOW.plus(Duration.ofDays(2)), g.closesAt);
        assertEquals(0, g.timeOffsetMinutes);
    }

    @Test
    void futureOpeningIsAnnounced() {
        CreateGameRequest r = request();
        r.setOpensAt(NOW.plus(Duration.ofDays(1)));
        assertEquals(GameStatus.ANNOUNCED, AdminGameService.newGame(r, NOW).status);
        r.setOpensAt(NOW.minus(Duration.ofMinutes(1)));
        assertEquals(GameStatus.OPEN, AdminGameService.newGame(r, NOW).status);
        r.setClosesAt(null);
        assertEquals(GameStatus.OPEN, AdminGameService.newGame(r, NOW).status);
    }

    @Test
    void validation() {
        rejects("server.admin.game_id_invalid", r -> r.setId(null));
        rejects("server.admin.game_id_invalid", r -> r.setId("ab"));
        rejects("server.admin.game_id_invalid", r -> r.setId("Autumn"));
        rejects("server.admin.game_id_invalid", r -> r.setId("autumn_cup"));
        rejects("server.admin.game_id_invalid", r -> r.setId("a".repeat(41)));
        rejects("server.admin.game_name_required", r -> r.setName("   "));
        rejects("server.admin.game_name_required", r -> r.setName(null));
        rejects("server.admin.game_name_long", r -> r.setName("x".repeat(81)));
        rejects("server.admin.map_unknown", r -> r.setMapId("atlantis"));
        rejects("server.admin.map_unknown", r -> r.setMapId(null));
        rejects("server.admin.max_players_range", r -> r.setMaxPlayers(0));
        rejects("server.admin.max_players_range", r -> r.setMaxPlayers(201));
        rejects("server.admin.max_players_range", r -> r.setMaxPlayers(null));
        rejects("server.admin.npc_count_range", r -> r.setNpcCount(-1));
        rejects("server.admin.npc_count_range", r -> r.setNpcCount(Npcs.count() + 1));
        rejects("server.admin.closes_before_opens", r -> { r.setOpensAt(NOW.plus(Duration.ofDays(3))); r.setClosesAt(NOW.plus(Duration.ofDays(3))); });
        rejects("server.admin.tags_long", r -> r.setTags(Arrays.asList("t".repeat(301))));
    }

    @Test
    void limits() {
        CreateGameRequest r = request();
        r.setId("a".repeat(40)); r.setMaxPlayers(200); r.setNpcCount(Npcs.count()); r.setTags(null);
        GameEntity g = AdminGameService.newGame(r, NOW);
        assertEquals(200, g.maxPlayers);
        assertEquals("", g.tags);
        r.setMaxPlayers(1); r.setNpcCount(0);
        assertEquals(1, AdminGameService.newGame(r, NOW).maxPlayers);
    }

    @Test
    void reportLimit() {
        assertEquals(100, AdminGameService.reportLimit(null));
        assertEquals(1, AdminGameService.reportLimit(0));
        assertEquals(1, AdminGameService.reportLimit(-5));
        assertEquals(250, AdminGameService.reportLimit(250));
        assertEquals(500, AdminGameService.reportLimit(10_000));
    }

    @Test
    void uuid() {
        assertTrue(AdminGameService.uuid("not-a-uuid").isEmpty());
        assertTrue(AdminGameService.uuid(null).isEmpty());
        assertTrue(AdminGameService.uuid("00000000-0000-0000-0000-000000000001").isPresent());
    }
}
