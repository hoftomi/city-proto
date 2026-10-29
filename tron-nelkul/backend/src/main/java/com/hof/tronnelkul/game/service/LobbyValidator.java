package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.api.model.Background;
import com.hof.tronnelkul.api.model.JoinRequest;
import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.game.model.GameEntity;
import com.hof.tronnelkul.game.model.GameStatus;
import com.hof.tronnelkul.game.model.PlayerRepository;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.game.world.StartSlot;
import com.hof.tronnelkul.i18n.Messages;
import org.springframework.stereotype.Component;

import java.util.UUID;

/** The rules of joining a game (rulebook v0.2, 2.2). Every failure is an ApiException with an i18n key. */
@Component
public class LobbyValidator {
    /** ProblemDetail `code` when the house name is invalid or taken (the client returns to the name field). */
    static final String HOUSE_NAME = "house_name";
    static final int HOUSE_NAME_MIN = 3, HOUSE_NAME_MAX = 24;

    private final PlayerRepository playerRepository;
    private final GameRunner runner;
    private final Messages messages;

    public LobbyValidator(PlayerRepository playerRepository, GameRunner runner, Messages messages) {
        this.playerRepository = playerRepository; this.runner = runner; this.messages = messages;
    }

    /**
     * A valid join. houseName: normalized (stripped, single spaces); startGood: only for a merchant;
     * late: the game is already running (within GameEntity.LATE_JOIN_SETTLEMENTS), the house enters the state at once.
     */
    public record JoinPlan(String houseName, Background background, StartSlot slot, String startGood, boolean late) {}

    public JoinPlan validateJoin(GameEntity game, UUID userId, JoinRequest request) {
        boolean late = game.getStatus() == GameStatus.RUNNING && runner.read(game).settlements <= GameEntity.LATE_JOIN_SETTLEMENTS;
        if (game.getStatus() != GameStatus.OPEN && !late) {
            throw ApiException.conflict("server.join_closed");
        }
        if (playerRepository.findByGameIdAndUserId(game.getId(), userId).isPresent()) {
            throw ApiException.conflict("server.already_joined");
        }
        if (playerRepository.countByGameIdAndNpcFalse(game.getId()) >= game.getMaxPlayers()) {
            throw ApiException.conflict("server.game_full");
        }

        String name = request.getHouseName() == null ? "" : request.getHouseName().strip().replaceAll("\\s+", " ");
        if (name.length() < HOUSE_NAME_MIN) {
            throw ApiException.badRequest("server.house_name_short", "min", HOUSE_NAME_MIN).withCode(HOUSE_NAME);
        }
        if (name.length() > HOUSE_NAME_MAX) {
            throw ApiException.badRequest("server.house_name_long", "max", HOUSE_NAME_MAX).withCode(HOUSE_NAME);
        }
        if (isNpcName(name) || playerRepository.existsByGameIdAndHouseNameIgnoreCase(game.getId(), name)) {
            throw ApiException.conflict("server.house_name_taken").withCode(HOUSE_NAME);
        }
        if (request.getBackground() == null) {
            throw ApiException.badRequest("server.pick_background");
        }
        MapDefinition map = MapRegistry.get(game.getMapId());
        StartSlot slot = map.start(request.getStartSlot()).orElseThrow(() -> ApiException.badRequest("server.pick_start_slot"));
        String startGood = null;
        if (request.getBackground() == Background.MERCHANT) {
            CityDef home = map.city(slot.homeCity()).orElseThrow();
            if (request.getStartGood() == null || home.goods().stream().noneMatch(gd -> gd.id().equals(request.getStartGood()))) {
                throw ApiException.badRequest("server.pick_start_good", "city", home.label());
            }
            startGood = request.getStartGood();
        }
        return new JoinPlan(name, request.getBackground(), slot, startGood, late);
    }

    /** NPC house names are reserved. */
    private boolean isNpcName(String name) { return Npcs.ALL.stream().anyMatch(npc -> messages.text(npc.label()).equalsIgnoreCase(name)); }
}
