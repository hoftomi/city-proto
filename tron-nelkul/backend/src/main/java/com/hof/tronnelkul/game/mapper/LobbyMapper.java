package com.hof.tronnelkul.game.mapper;

import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.service.Backgrounds;
import com.hof.tronnelkul.i18n.Messages;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * Lobby DTOs from the game and player rows. What the service computes (whether you can join, settlements so far,
 * head counts, the join options) comes in as parameters.
 */
@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, unmappedTargetPolicy = ReportingPolicy.ERROR, imports = GameEntity.class)
public abstract class LobbyMapper {
    @Autowired protected Messages messages;

    /** A live game's card; the own house comes from the user's player row (null if not joined). */
    @Mapping(target = "id", source = "game.id")
    @Mapping(target = "tags", expression = "java(game.tagList())")
    @Mapping(target = "canJoin", source = "canJoin")
    @Mapping(target = "myHouse", source = "player")
    @Mapping(target = "winner", ignore = true)
    @Mapping(target = "myPlace", ignore = true)
    public abstract GameSummary card(GameEntity game, PlayerEntity player, boolean canJoin);

    /** A finished game's card: the winner and, if you played, your house and final place. */
    @Mapping(target = "id", source = "game.id")
    @Mapping(target = "status", constant = GameStatus.FINISHED_API_ID)
    @Mapping(target = "closesAt", ignore = true)
    @Mapping(target = "tags", expression = "java(game.tagList())")
    @Mapping(target = "canJoin", constant = "false")
    @Mapping(target = "myPlace", source = "player.place")
    @Mapping(target = "myHouse", source = "player")
    public abstract GameSummary card(ArchivedGameEntity game, ArchivedPlayerEntity player);

    /** A live game's details. */
    @Mapping(target = "game", source = "card")
    @Mapping(target = "round", source = "round")
    @Mapping(target = "maxRounds", expression = "java(GameEntity.maxSettlements())")
    @Mapping(target = "players", source = "players")
    @Mapping(target = "cities", source = "cities")
    @Mapping(target = "starts", source = "options.starts")
    @Mapping(target = "backgrounds", source = "options.backgrounds")
    public abstract GameDetail detail(GameEntity game, GameSummary card, int round, int players, int cities, JoinOptions options);

    /** A finished game's details: it ran all its settlements; the archive keeps no head limit, so maxPlayers is the head count. */
    @Mapping(target = "game", source = "card")
    @Mapping(target = "round", expression = "java(GameEntity.maxSettlements())")
    @Mapping(target = "maxRounds", expression = "java(GameEntity.maxSettlements())")
    @Mapping(target = "players", source = "players")
    @Mapping(target = "maxPlayers", source = "players")
    @Mapping(target = "cities", source = "cities")
    @Mapping(target = "npcCount", source = "npcCount")
    @Mapping(target = "starts", source = "options.starts")
    @Mapping(target = "backgrounds", source = "options.backgrounds")
    public abstract GameDetail detail(ArchivedGameEntity game, GameSummary card, int players, int npcCount, int cities, JoinOptions options);

    @Mapping(target = "backgroundName", source = "background", qualifiedByName = "backgroundName")
    public abstract MyHouse myHouse(PlayerEntity player);

    @Mapping(target = "backgroundName", source = "background", qualifiedByName = "backgroundName")
    public abstract MyHouse myHouse(ArchivedPlayerEntity player);

    protected String status(GameStatus status) { return status.apiId; }

    @Named("backgroundName")
    protected String backgroundName(Background background) { return background == null ? null : Backgrounds.name(messages, background); }

    /** The choices of the join form: start slots of the map, backgrounds. */
    public record JoinOptions(List<StartSlotDto> starts, List<BackgroundDto> backgrounds) {}
}
