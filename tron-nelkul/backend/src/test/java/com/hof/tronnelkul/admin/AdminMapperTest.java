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
        GameEntity game = new GameEntity("g1", "Game one", GameStatus.RUNNING, "delkelet", 30, 4, "A, B");
        game.setClosesAt(Instant.parse("2026-11-01T07:00:00Z"));
        game.setTimeOffsetMinutes(90);
        Instant clock = Instant.parse("2026-11-02T08:00:00Z");
        AdminGame adminGame = mapper.game(game, 7, 12, clock);
        assertEquals("g1", adminGame.getId());
        assertEquals("Game one", adminGame.getName());
        assertEquals("running", adminGame.getStatus());
        assertEquals("delkelet", adminGame.getMapId());
        assertEquals(messages.text(MapRegistry.DELKELET.label()), adminGame.getMapName());
        assertNotEquals("world.map.delkelet", adminGame.getMapName());
        assertEquals("citizen", adminGame.getMode());
        assertEquals(game.getClosesAt(), adminGame.getClosesAt());
        assertNull(adminGame.getOpensAt());
        assertEquals(game.getCreatedAt(), adminGame.getCreatedAt());
        assertEquals(30, adminGame.getMaxPlayers());
        assertEquals(4, adminGame.getNpcCount());
        assertEquals(7, adminGame.getHumans());
        assertEquals(12, adminGame.getSettlements());
        assertEquals(GameEntity.maxSettlements(), adminGame.getMaxSettlements());
        assertEquals(clock, adminGame.getClock());
        assertEquals(90, adminGame.getTimeOffsetMinutes());
        assertNull(adminGame.getWinner());
        assertEquals(List.of("A", "B"), adminGame.getTags());

        AdminGame open = mapper.game(new GameEntity("g2", "Two", GameStatus.OPEN, "so", 10, 0, ""), 0, null, null);
        assertEquals("open", open.getStatus());
        assertNull(open.getSettlements());
        assertNull(open.getClock());
        assertEquals(List.of(), open.getTags());
    }

    @Test
    void archivedGame() {
        GameEntity live = new GameEntity("g3", "Three", GameStatus.RUNNING, "kodos", 30, 2, "X");
        live.setOpensAt(Instant.parse("2026-10-01T07:00:00Z"));
        live.setTimeOffsetMinutes(300);
        AdminGame adminGame = mapper.game(new ArchivedGameEntity(live, "Ravenhold (NPC)"), 5, 2);
        assertEquals("finished", adminGame.getStatus());
        assertEquals(live.getOpensAt(), adminGame.getOpensAt());
        assertNull(adminGame.getClosesAt());
        assertEquals(5, adminGame.getMaxPlayers());
        assertEquals(5, adminGame.getHumans());
        assertEquals(2, adminGame.getNpcCount());
        assertNull(adminGame.getSettlements());
        assertNull(adminGame.getClock());
        assertEquals(0, adminGame.getTimeOffsetMinutes());
        assertEquals(GameEntity.maxSettlements(), adminGame.getMaxSettlements());
        assertEquals("Ravenhold (NPC)", adminGame.getWinner());
        assertEquals(List.of("X"), adminGame.getTags());
        assertEquals(messages.text(MapRegistry.KODOS.label()), adminGame.getMapName());
    }

    @Test
    void houses() {
        UUID user = UUID.randomUUID();
        PlayerEntity player = new PlayerEntity("g1", user, "Bluecrow");
        player.setId(UUID.randomUUID()); player.setBackground(Background.MERCHANT); player.setLegit(14);
        EngineState.PlayerSt st = new EngineState.PlayerSt();
        st.gold = 12.5; st.pp = 3; st.legit = 99;
        AdminHouse house = mapper.house(player, "Anna", st);
        assertEquals(player.getId().toString(), house.getPlayerId());
        assertEquals(user, house.getUserId());
        assertEquals("Anna", house.getUserName());
        assertEquals("Bluecrow", house.getHouseName());
        assertEquals(Background.MERCHANT, house.getBackground());
        assertFalse(house.getNpc());
        assertNull(house.getPersona());
        assertEquals(14, house.getLegit());
        assertEquals(12.5, house.getGold());
        assertEquals(3, house.getPp());
        assertNull(house.getPlace());
        assertEquals(player.getCreatedAt(), house.getJoinedAt());

        AdminHouse before = mapper.house(player, null, null);
        assertNull(before.getGold());
        assertNull(before.getPp());
        assertNull(before.getUserName());

        AdminHouse archived = mapper.house(new ArchivedPlayerEntity(player, 2), "Anna");
        assertEquals(player.getId().toString(), archived.getPlayerId());
        assertEquals(2, archived.getPlace());
        assertNull(archived.getGold());
        assertNull(archived.getPp());
        assertEquals(14, archived.getLegit());
        assertEquals(Background.MERCHANT, archived.getBackground());
        assertEquals(player.getCreatedAt(), archived.getJoinedAt());
    }

    @Test
    void reports() {
        UUID pid = UUID.randomUUID();
        Instant at = Instant.parse("2026-11-02T08:00:00Z");
        ReportEntity report = new ReportEntity("g1", pid, 4, "market", "weak", "Title", "Body", "warn", true, at);
        report.setId(UUID.randomUUID());
        AdminReport adminReport = mapper.report(report, "Bluecrow");
        assertEquals(report.getId().toString(), adminReport.getId());
        assertEquals(pid.toString(), adminReport.getPlayerId());
        assertEquals("Bluecrow", adminReport.getHouseName());
        assertEquals(4, adminReport.getSettlement());
        assertEquals("market", adminReport.getKind());
        assertEquals("weak", adminReport.getConfidence());
        assertEquals("Title", adminReport.getTitle());
        assertEquals("Body", adminReport.getBody());
        assertEquals("warn", adminReport.getTone());
        assertTrue(adminReport.getIsPublic());
        assertEquals(at, adminReport.getCreatedAt());

        AdminReport archived = mapper.report(new ArchivedReportEntity(report), "Bluecrow");
        assertEquals(adminReport, archived);
    }

    @Test
    void mapAndUser() {
        AdminMap adminMap = mapper.map(MapRegistry.SO);
        assertEquals("so", adminMap.getId());
        assertEquals(messages.text(MapRegistry.SO.label()), adminMap.getName());
        assertEquals(MapRegistry.SO.cities().size(), adminMap.getCities());
        assertEquals(MapRegistry.SO.starts().size(), adminMap.getStarts());

        AppUser appUser = new AppUser("Anna", "ADMIN");
        appUser.setId(UUID.randomUUID());
        AdminUser adminUser = mapper.user(appUser, "anna@example.com", List.of("discord", "google"), 3);
        assertEquals(appUser.getId(), adminUser.getId());
        assertEquals("Anna", adminUser.getName());
        assertEquals("ADMIN", adminUser.getRole());
        assertEquals("anna@example.com", adminUser.getEmail());
        assertEquals(List.of("discord", "google"), adminUser.getProviders());
        assertEquals(appUser.getCreatedAt(), adminUser.getCreatedAt());
        assertEquals(3, adminUser.getGames());
    }
}
