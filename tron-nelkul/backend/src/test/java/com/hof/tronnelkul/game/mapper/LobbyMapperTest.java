package com.hof.tronnelkul.game.mapper;

import com.hof.tronnelkul.api.model.GameDetail;
import com.hof.tronnelkul.api.model.GameSummary;
import com.hof.tronnelkul.api.model.MyHouse;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.i18n.Messages;
import com.hof.tronnelkul.i18n.TranslationService;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import tools.jackson.databind.json.JsonMapper;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

class LobbyMapperTest {
    final LobbyMapper mapper = Mappers.getMapper(LobbyMapper.class);
    { mapper.messages = new Messages(new TranslationService(JsonMapper.builder().build())); }

    final LobbyMapper.JoinOptions options = new LobbyMapper.JoinOptions(List.of(), List.of(), List.of("red"));

    @Test
    void liveCard() {
        GameEntity g = new GameEntity("g1", "Game one", GameStatus.RUNNING, "delkelet", 30, 4, "A, B");
        g.closesAt = Instant.parse("2026-11-01T07:00:00Z");
        PlayerEntity p = new PlayerEntity("g1", UUID.randomUUID(), "Bluecrow", "blue");
        p.id = UUID.randomUUID();
        GameSummary s = mapper.card(g, p, false);
        assertEquals("g1", s.getId());
        assertEquals("Game one", s.getName());
        assertEquals("running", s.getStatus());
        assertEquals(g.closesAt, s.getClosesAt());
        assertEquals(List.of("A", "B"), s.getTags());
        assertFalse(s.getCanJoin());
        assertEquals("Bluecrow", s.getMyHouse().getHouseName());
        assertNull(s.getWinner());
        assertNull(s.getMyPlace());

        GameSummary other = mapper.card(g, null, true);
        assertTrue(other.getCanJoin());
        assertNull(other.getMyHouse());
    }

    @Test
    void archivedCard() {
        GameEntity live = new GameEntity("g2", "Game two", GameStatus.RUNNING, "so", 30, 2, "");
        ArchivedGameEntity a = new ArchivedGameEntity(live, "Ravenhold (NPC)");
        PlayerEntity p = new PlayerEntity("g2", UUID.randomUUID(), "Bluecrow", "blue");
        p.id = UUID.randomUUID();
        GameSummary s = mapper.card(a, new ArchivedPlayerEntity(p, 3));
        assertEquals("g2", s.getId());
        assertEquals("finished", s.getStatus());
        assertNull(s.getClosesAt());
        assertEquals(List.of(), s.getTags());
        assertFalse(s.getCanJoin());
        assertEquals("Ravenhold (NPC)", s.getWinner());
        assertEquals(3, s.getMyPlace());
        assertEquals("Bluecrow", s.getMyHouse().getHouseName());

        GameSummary notPlayed = mapper.card(a, null);
        assertNull(notPlayed.getMyPlace());
        assertNull(notPlayed.getMyHouse());
    }

    @Test
    void liveDetail() {
        GameEntity g = new GameEntity("g1", "Game one", GameStatus.RUNNING, "delkelet", 30, 4, "");
        GameSummary card = new GameSummary();
        GameDetail d = mapper.detail(g, card, 7, 12, 5, options);
        assertSame(card, d.getGame());
        assertEquals("delkelet", d.getMapId());
        assertEquals(7, d.getRound());
        assertEquals(GameEntity.maxSettlements(), d.getMaxRounds());
        assertEquals(12, d.getPlayers());
        assertEquals(30, d.getMaxPlayers());
        assertEquals(5, d.getCities());
        assertEquals(4, d.getNpcCount());
        assertEquals(List.of("red"), d.getTinctures());
    }

    @Test
    void archivedDetail() {
        ArchivedGameEntity a = new ArchivedGameEntity(new GameEntity("g2", "Game two", GameStatus.RUNNING, "so", 30, 2, ""), null);
        GameDetail d = mapper.detail(a, new GameSummary(), 9, 2, 5, options);
        assertEquals("so", d.getMapId());
        assertEquals(GameEntity.maxSettlements(), d.getRound());
        assertEquals(GameEntity.maxSettlements(), d.getMaxRounds());
        assertEquals(9, d.getPlayers());
        assertEquals(9, d.getMaxPlayers());
        assertEquals(2, d.getNpcCount());
    }

    @Test
    void ownHouse() {
        PlayerEntity p = new PlayerEntity("g1", UUID.randomUUID(), "Bluecrow", "blue");
        p.background = "merchant";
        MyHouse h = mapper.myHouse(p);
        assertEquals("Bluecrow", h.getHouseName());
        assertEquals("blue", h.getTincture());
        assertEquals(mapper.messages.text("world.background.merchant.name"), h.getBackgroundName());
        p.background = null;
        assertNull(mapper.myHouse(p).getBackgroundName());
    }
}
