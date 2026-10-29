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
        CreateGameRequest request = request();
        change.accept(request);
        ApiException ex = assertThrows(ApiException.class, () -> AdminGameService.newGame(request, NOW));
        assertEquals(HttpStatus.BAD_REQUEST, ex.status);
        assertEquals(key, ex.msg.key());
    }

    @Test
    void validGameIsOpen() {
        GameEntity game = AdminGameService.newGame(request(), NOW);
        assertEquals("autumn-cup-2", game.getId());
        assertEquals("Autumn cup", game.getName());
        assertEquals(GameStatus.OPEN, game.getStatus());
        assertEquals("kodos", game.getMapId());
        assertEquals(30, game.getMaxPlayers());
        assertEquals(2, game.getNpcCount());
        assertEquals("League,a b", game.getTags());
        assertNull(game.getOpensAt());
        assertEquals(NOW.plus(Duration.ofDays(2)), game.getClosesAt());
        assertEquals(0, game.getTimeOffsetMinutes());
    }

    @Test
    void futureOpeningIsAnnounced() {
        CreateGameRequest request = request();
        request.setOpensAt(NOW.plus(Duration.ofDays(1)));
        assertEquals(GameStatus.ANNOUNCED, AdminGameService.newGame(request, NOW).getStatus());
        request.setOpensAt(NOW.minus(Duration.ofMinutes(1)));
        assertEquals(GameStatus.OPEN, AdminGameService.newGame(request, NOW).getStatus());
        request.setClosesAt(null);
        assertEquals(GameStatus.OPEN, AdminGameService.newGame(request, NOW).getStatus());
    }

    @Test
    void validation() {
        rejects("server.admin.game_id_invalid", request -> request.setId(null));
        rejects("server.admin.game_id_invalid", request -> request.setId("ab"));
        rejects("server.admin.game_id_invalid", request -> request.setId("Autumn"));
        rejects("server.admin.game_id_invalid", request -> request.setId("autumn_cup"));
        rejects("server.admin.game_id_invalid", request -> request.setId("a".repeat(41)));
        rejects("server.admin.game_name_required", request -> request.setName("   "));
        rejects("server.admin.game_name_required", request -> request.setName(null));
        rejects("server.admin.game_name_long", request -> request.setName("x".repeat(81)));
        rejects("server.admin.map_unknown", request -> request.setMapId("atlantis"));
        rejects("server.admin.map_unknown", request -> request.setMapId(null));
        rejects("server.admin.max_players_range", request -> request.setMaxPlayers(0));
        rejects("server.admin.max_players_range", request -> request.setMaxPlayers(201));
        rejects("server.admin.max_players_range", request -> request.setMaxPlayers(null));
        rejects("server.admin.npc_count_range", request -> request.setNpcCount(-1));
        rejects("server.admin.npc_count_range", request -> request.setNpcCount(Npcs.count() + 1));
        rejects("server.admin.closes_before_opens", request -> { request.setOpensAt(NOW.plus(Duration.ofDays(3))); request.setClosesAt(NOW.plus(Duration.ofDays(3))); });
        rejects("server.admin.tags_long", request -> request.setTags(Arrays.asList("t".repeat(301))));
    }

    @Test
    void limits() {
        CreateGameRequest request = request();
        request.setId("a".repeat(40)); request.setMaxPlayers(200); request.setNpcCount(Npcs.count()); request.setTags(null);
        GameEntity game = AdminGameService.newGame(request, NOW);
        assertEquals(200, game.getMaxPlayers());
        assertEquals("", game.getTags());
        request.setMaxPlayers(1); request.setNpcCount(0);
        assertEquals(1, AdminGameService.newGame(request, NOW).getMaxPlayers());
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
