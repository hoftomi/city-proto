package com.hof.tronnelkul.admin;

import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.game.engine.EngineState;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.i18n.Messages;
import com.hof.tronnelkul.i18n.TranslationService;
import com.hof.tronnelkul.user.AppUser;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import tools.jackson.databind.json.JsonMapper;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

class AdminMapperTest {
    final AdminMapper mapper = Mappers.getMapper(AdminMapper.class);
    final Messages messages = new Messages(new TranslationService(JsonMapper.builder().build()));
    { mapper.messages = messages; }

    @Test
    void liveGame() {
        GameEntity g = new GameEntity("g1", "Game one", GameStatus.RUNNING, "delkelet", 30, 4, "A, B");
        g.closesAt = Instant.parse("2026-11-01T07:00:00Z");
        g.timeOffsetMinutes = 90;
        Instant clock = Instant.parse("2026-11-02T08:00:00Z");
        AdminGame a = mapper.game(g, 7, 12, clock);
        assertEquals("g1", a.getId());
        assertEquals("Game one", a.getName());
        assertEquals("running", a.getStatus());
        assertEquals("delkelet", a.getMapId());
        assertEquals(messages.text(MapRegistry.DELKELET.label()), a.getMapName());
        assertNotEquals("world.map.delkelet", a.getMapName());
        assertEquals("citizen", a.getMode());
        assertEquals(g.closesAt, a.getClosesAt());
        assertNull(a.getOpensAt());
        assertEquals(g.createdAt, a.getCreatedAt());
        assertEquals(30, a.getMaxPlayers());
        assertEquals(4, a.getNpcCount());
        assertEquals(7, a.getHumans());
        assertEquals(12, a.getSettlements());
        assertEquals(GameEntity.maxSettlements(), a.getMaxSettlements());
        assertEquals(clock, a.getClock());
        assertEquals(90, a.getTimeOffsetMinutes());
        assertNull(a.getWinner());
        assertEquals(List.of("A", "B"), a.getTags());

        AdminGame open = mapper.game(new GameEntity("g2", "Two", GameStatus.OPEN, "so", 10, 0, ""), 0, null, null);
        assertEquals("open", open.getStatus());
        assertNull(open.getSettlements());
        assertNull(open.getClock());
        assertEquals(List.of(), open.getTags());
    }

    @Test
    void archivedGame() {
        GameEntity live = new GameEntity("g3", "Three", GameStatus.RUNNING, "kodos", 30, 2, "X");
        live.opensAt = Instant.parse("2026-10-01T07:00:00Z");
        live.timeOffsetMinutes = 300;
        AdminGame a = mapper.game(new ArchivedGameEntity(live, "Ravenhold (NPC)"), 5, 2);
        assertEquals("finished", a.getStatus());
        assertEquals(live.opensAt, a.getOpensAt());
        assertNull(a.getClosesAt());
        assertEquals(5, a.getMaxPlayers());
        assertEquals(5, a.getHumans());
        assertEquals(2, a.getNpcCount());
        assertNull(a.getSettlements());
        assertNull(a.getClock());
        assertEquals(0, a.getTimeOffsetMinutes());
        assertEquals(GameEntity.maxSettlements(), a.getMaxSettlements());
        assertEquals("Ravenhold (NPC)", a.getWinner());
        assertEquals(List.of("X"), a.getTags());
        assertEquals(messages.text(MapRegistry.KODOS.label()), a.getMapName());
    }

    @Test
    void houses() {
        UUID user = UUID.randomUUID();
        PlayerEntity p = new PlayerEntity("g1", user, "Bluecrow", "blue");
        p.id = UUID.randomUUID(); p.background = "merchant"; p.legit = 14;
        EngineState.PlayerSt st = new EngineState.PlayerSt();
        st.gold = 12.5; st.pp = 3; st.legit = 99;
        AdminHouse h = mapper.house(p, "Anna", st);
        assertEquals(p.id.toString(), h.getPlayerId());
        assertEquals(user, h.getUserId());
        assertEquals("Anna", h.getUserName());
        assertEquals("Bluecrow", h.getHouseName());
        assertEquals("blue", h.getTincture());
        assertEquals("merchant", h.getBackground());
        assertFalse(h.getNpc());
        assertNull(h.getPersona());
        assertEquals(14, h.getLegit());
        assertEquals(12.5, h.getGold());
        assertEquals(3, h.getPp());
        assertNull(h.getPlace());
        assertEquals(p.createdAt, h.getJoinedAt());

        AdminHouse before = mapper.house(p, null, null);
        assertNull(before.getGold());
        assertNull(before.getPp());
        assertNull(before.getUserName());

        AdminHouse archived = mapper.house(new ArchivedPlayerEntity(p, 2), "Anna");
        assertEquals(p.id.toString(), archived.getPlayerId());
        assertEquals(2, archived.getPlace());
        assertNull(archived.getGold());
        assertNull(archived.getPp());
        assertEquals(14, archived.getLegit());
        assertEquals(p.createdAt, archived.getJoinedAt());
    }

    @Test
    void reports() {
        UUID pid = UUID.randomUUID();
        Instant at = Instant.parse("2026-11-02T08:00:00Z");
        ReportEntity r = new ReportEntity("g1", pid, 4, "market", "weak", "Title", "Body", "warn", true, at);
        r.id = UUID.randomUUID();
        AdminReport a = mapper.report(r, "Bluecrow");
        assertEquals(r.id.toString(), a.getId());
        assertEquals(pid.toString(), a.getPlayerId());
        assertEquals("Bluecrow", a.getHouseName());
        assertEquals(4, a.getSettlement());
        assertEquals("market", a.getKind());
        assertEquals("weak", a.getConfidence());
        assertEquals("Title", a.getTitle());
        assertEquals("Body", a.getBody());
        assertEquals("warn", a.getTone());
        assertTrue(a.getIsPublic());
        assertEquals(at, a.getCreatedAt());

        AdminReport b = mapper.report(new ArchivedReportEntity(r), "Bluecrow");
        assertEquals(a, b);
    }

    @Test
    void mapAndUser() {
        AdminMap m = mapper.map(MapRegistry.SO);
        assertEquals("so", m.getId());
        assertEquals(messages.text(MapRegistry.SO.label()), m.getName());
        assertEquals(MapRegistry.SO.cities().size(), m.getCities());
        assertEquals(MapRegistry.SO.starts().size(), m.getStarts());

        AppUser u = new AppUser("Anna", "ADMIN");
        u.id = UUID.randomUUID();
        AdminUser a = mapper.user(u, "anna@example.com", List.of("discord", "google"), 3);
        assertEquals(u.id, a.getId());
        assertEquals("Anna", a.getName());
        assertEquals("ADMIN", a.getRole());
        assertEquals("anna@example.com", a.getEmail());
        assertEquals(List.of("discord", "google"), a.getProviders());
        assertEquals(u.createdAt, a.getCreatedAt());
        assertEquals(3, a.getGames());
    }
}
