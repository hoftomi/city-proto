package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.api.model.Background;
import com.hof.tronnelkul.api.model.JoinRequest;
import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.game.engine.EngineState;
import com.hof.tronnelkul.game.model.GameEntity;
import com.hof.tronnelkul.game.model.GameStatus;
import com.hof.tronnelkul.game.model.PlayerEntity;
import com.hof.tronnelkul.game.model.PlayerRepository;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.i18n.Messages;
import com.hof.tronnelkul.i18n.TranslationService;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import tools.jackson.databind.json.JsonMapper;

import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.function.Consumer;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class LobbyValidatorTest {
    static final UUID USER = UUID.randomUUID();
    final Messages messages = new Messages(new TranslationService(JsonMapper.builder().build()));
    final PlayerRepository playerRepository = mock(PlayerRepository.class);
    final GameRunner runner = mock(GameRunner.class);
    final LobbyValidator validator = new LobbyValidator(playerRepository, runner, messages);
    final GameEntity open = new GameEntity("g1", "Game one", GameStatus.OPEN, "delkelet", 2, 4, "");

    /** A valid merchant join on Delkelet: west's home city is Szélmező (grain, wine). */
    static JoinRequest request() { return new JoinRequest("  Blue   crow ", Background.MERCHANT, "west").startGood("grain"); }

    static GameEntity running(int settlements, GameRunner runner) {
        GameEntity game = new GameEntity("g2", "Game two", GameStatus.RUNNING, "delkelet", 2, 4, "");
        EngineState state = new EngineState();
        state.settlements = settlements;
        when(runner.read(game)).thenReturn(state);
        return game;
    }

    void rejects(GameEntity game, HttpStatus status, String key, String code, Consumer<JoinRequest> change) {
        JoinRequest request = request();
        change.accept(request);
        ApiException ex = assertThrows(ApiException.class, () -> validator.validateJoin(game, USER, request));
        assertEquals(status, ex.status);
        assertEquals(key, ex.msg.key());
        assertEquals(code, ex.code);
    }

    @Test
    void merchantJoinsAnOpenGame() {
        LobbyValidator.JoinPlan plan = validator.validateJoin(open, USER, request());
        assertEquals("Blue crow", plan.houseName());
        assertEquals(Background.MERCHANT, plan.background());
        assertEquals("west", plan.slot().id());
        assertEquals("grain", plan.startGood());
        assertFalse(plan.late());
        verifyNoInteractions(runner);
    }

    @Test
    void startGoodIsOnlyKeptForAMerchant() {
        LobbyValidator.JoinPlan plan = validator.validateJoin(open, USER, request().background(Background.NOBLE).startGood("nonsense"));
        assertEquals(Background.NOBLE, plan.background());
        assertNull(plan.startGood());
        assertNull(validator.validateJoin(open, USER, request().background(Background.SHADOW)).startGood());
    }

    @Test
    void runningGameCanBeJoinedLateOnly() {
        assertTrue(validator.validateJoin(running(GameEntity.LATE_JOIN_SETTLEMENTS, runner), USER, request()).late());
        rejects(running(GameEntity.LATE_JOIN_SETTLEMENTS + 1, runner), HttpStatus.CONFLICT, "server.join_closed", null, request -> {});
        rejects(new GameEntity("g3", "Game three", GameStatus.ANNOUNCED, "delkelet", 2, 4, ""), HttpStatus.CONFLICT, "server.join_closed", null, request -> {});
    }

    @Test
    void userJoinsOnce() {
        when(playerRepository.findByGameIdAndUserId("g1", USER)).thenReturn(Optional.of(mock(PlayerEntity.class)));
        rejects(open, HttpStatus.CONFLICT, "server.already_joined", null, request -> {});
    }

    @Test
    void fullGame() {
        when(playerRepository.countByGameIdAndNpcFalse("g1")).thenReturn(2L);
        rejects(open, HttpStatus.CONFLICT, "server.game_full", null, request -> {});
    }

    @Test
    void houseName() {
        rejects(open, HttpStatus.BAD_REQUEST, "server.house_name_short", LobbyValidator.HOUSE_NAME, request -> request.setHouseName("  ab   "));
        rejects(open, HttpStatus.BAD_REQUEST, "server.house_name_short", LobbyValidator.HOUSE_NAME, request -> request.setHouseName(null));
        rejects(open, HttpStatus.BAD_REQUEST, "server.house_name_long", LobbyValidator.HOUSE_NAME, request -> request.setHouseName("x".repeat(25)));
        assertEquals("x".repeat(24), validator.validateJoin(open, USER, request().houseName("x".repeat(24))).houseName());
        assertEquals(Map.of("min", 3), assertThrows(ApiException.class, () -> validator.validateJoin(open, USER, request().houseName("ab"))).msg.args());
        assertEquals(Map.of("max", 24), assertThrows(ApiException.class, () -> validator.validateJoin(open, USER, request().houseName("x".repeat(25)))).msg.args());
    }

    @Test
    void npcNamesAndTakenNamesAreRefused() {
        String npc = messages.text(Npcs.ALL.get(0).label());
        rejects(open, HttpStatus.CONFLICT, "server.house_name_taken", LobbyValidator.HOUSE_NAME, request -> request.setHouseName(" " + npc.toUpperCase()));
        when(playerRepository.existsByGameIdAndHouseNameIgnoreCase("g1", "Blue crow")).thenReturn(true);
        rejects(open, HttpStatus.CONFLICT, "server.house_name_taken", LobbyValidator.HOUSE_NAME, request -> {});
    }

    @Test
    void backgroundStartSlotAndStartGood() {
        rejects(open, HttpStatus.BAD_REQUEST, "server.pick_background", null, request -> request.setBackground(null));
        rejects(open, HttpStatus.BAD_REQUEST, "server.pick_start_slot", null, request -> request.setStartSlot("nowhere"));
        rejects(open, HttpStatus.BAD_REQUEST, "server.pick_start_slot", null, request -> request.setStartSlot(null));
        rejects(open, HttpStatus.BAD_REQUEST, "server.pick_start_good", null, request -> request.setStartGood(null));
        rejects(open, HttpStatus.BAD_REQUEST, "server.pick_start_good", null, request -> request.setStartGood("salt"));
        ApiException ex = assertThrows(ApiException.class, () -> validator.validateJoin(open, USER, request().startGood(null)));
        assertEquals(Map.of("city", CityDef.label("szelmezo")), ex.msg.args());
    }
}
