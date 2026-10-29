package com.hof.tronnelkul.game.mapper;

import com.hof.tronnelkul.api.model.Background;
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

    final LobbyMapper.JoinOptions options = new LobbyMapper.JoinOptions(List.of(), List.of());

    @Test
    void liveCard() {
        GameEntity game = new GameEntity("g1", "Game one", GameStatus.RUNNING, "delkelet", 30, 4, "A, B");
        game.setClosesAt(Instant.parse("2026-11-01T07:00:00Z"));
        PlayerEntity player = new PlayerEntity("g1", UUID.randomUUID(), "Bluecrow");
        player.setId(UUID.randomUUID());
        GameSummary summary = mapper.card(game, player, false);
        assertEquals("g1", summary.getId());
        assertEquals("Game one", summary.getName());
        assertEquals("running", summary.getStatus());
        assertEquals(game.getClosesAt(), summary.getClosesAt());
        assertEquals(List.of("A", "B"), summary.getTags());
        assertFalse(summary.getCanJoin());
        assertEquals("Bluecrow", summary.getMyHouse().getHouseName());
        assertNull(summary.getWinner());
        assertNull(summary.getMyPlace());

        GameSummary other = mapper.card(game, null, true);
        assertTrue(other.getCanJoin());
        assertNull(other.getMyHouse());
    }

    @Test
    void archivedCard() {
        GameEntity live = new GameEntity("g2", "Game two", GameStatus.RUNNING, "so", 30, 2, "");
        ArchivedGameEntity archived = new ArchivedGameEntity(live, "Ravenhold (NPC)");
        PlayerEntity player = new PlayerEntity("g2", UUID.randomUUID(), "Bluecrow");
        player.setId(UUID.randomUUID());
        GameSummary summary = mapper.card(archived, new ArchivedPlayerEntity(player, 3));
        assertEquals("g2", summary.getId());
        assertEquals("finished", summary.getStatus());
        assertNull(summary.getClosesAt());
        assertEquals(List.of(), summary.getTags());
        assertFalse(summary.getCanJoin());
        assertEquals("Ravenhold (NPC)", summary.getWinner());
        assertEquals(3, summary.getMyPlace());
        assertEquals("Bluecrow", summary.getMyHouse().getHouseName());

        GameSummary notPlayed = mapper.card(archived, null);
        assertNull(notPlayed.getMyPlace());
        assertNull(notPlayed.getMyHouse());
    }

    @Test
    void liveDetail() {
        GameEntity game = new GameEntity("g1", "Game one", GameStatus.RUNNING, "delkelet", 30, 4, "");
        GameSummary card = new GameSummary();
        GameDetail detail = mapper.detail(game, card, 7, 12, 5, options);
        assertSame(card, detail.getGame());
        assertEquals("delkelet", detail.getMapId());
        assertEquals(7, detail.getRound());
        assertEquals(GameEntity.maxSettlements(), detail.getMaxRounds());
        assertEquals(12, detail.getPlayers());
        assertEquals(30, detail.getMaxPlayers());
        assertEquals(5, detail.getCities());
        assertEquals(4, detail.getNpcCount());
    }

    @Test
    void archivedDetail() {
        ArchivedGameEntity archived = new ArchivedGameEntity(new GameEntity("g2", "Game two", GameStatus.RUNNING, "so", 30, 2, ""), null);
        GameDetail detail = mapper.detail(archived, new GameSummary(), 9, 2, 5, options);
        assertEquals("so", detail.getMapId());
        assertEquals(GameEntity.maxSettlements(), detail.getRound());
        assertEquals(GameEntity.maxSettlements(), detail.getMaxRounds());
        assertEquals(9, detail.getPlayers());
        assertEquals(9, detail.getMaxPlayers());
        assertEquals(2, detail.getNpcCount());
    }

    @Test
    void ownHouse() {
        PlayerEntity player = new PlayerEntity("g1", UUID.randomUUID(), "Bluecrow");
        player.setBackground(Background.MERCHANT);
        MyHouse house = mapper.myHouse(player);
        assertEquals("Bluecrow", house.getHouseName());
        assertEquals(mapper.messages.text("world.background.merchant.name"), house.getBackgroundName());
        player.setBackground(null);
        assertNull(mapper.myHouse(player).getBackgroundName());
    }
}
