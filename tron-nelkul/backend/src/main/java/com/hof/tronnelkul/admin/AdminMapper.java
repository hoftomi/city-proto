package com.hof.tronnelkul.admin;

import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.game.engine.EngineState;
import com.hof.tronnelkul.game.engine.Msg;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.i18n.Messages;
import com.hof.tronnelkul.user.AppUser;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.Instant;
import java.util.List;

/** Admin DTOs. What the services compute (head counts, settlements, the game clock, the user's name) comes in as parameters. */
@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, unmappedTargetPolicy = ReportingPolicy.ERROR, imports = GameEntity.class)
public abstract class AdminMapper {
    @Autowired protected Messages messages;

    /** A live game; settlements and clock: null unless running. */
    @Mapping(target = "id", source = "game.id")
    @Mapping(target = "mapName", source = "game.mapId", qualifiedByName = "mapName")
    @Mapping(target = "tags", expression = "java(game.tagList())")
    @Mapping(target = "humans", source = "humans")
    @Mapping(target = "settlements", source = "settlements")
    @Mapping(target = "maxSettlements", expression = "java(GameEntity.maxSettlements())")
    @Mapping(target = "clock", source = "clock")
    @Mapping(target = "winner", ignore = true)
    public abstract AdminGame game(GameEntity game, int humans, Integer settlements, Instant clock);

    /** A finished game: it keeps no head limit, so maxPlayers is the human head count. */
    @Mapping(target = "id", source = "game.id")
    @Mapping(target = "status", constant = GameStatus.FINISHED_API_ID)
    @Mapping(target = "mapName", source = "game.mapId", qualifiedByName = "mapName")
    @Mapping(target = "tags", expression = "java(game.tagList())")
    @Mapping(target = "closesAt", ignore = true)
    @Mapping(target = "maxPlayers", source = "humans")
    @Mapping(target = "npcCount", source = "npcs")
    @Mapping(target = "humans", source = "humans")
    @Mapping(target = "settlements", ignore = true)
    @Mapping(target = "maxSettlements", expression = "java(GameEntity.maxSettlements())")
    @Mapping(target = "clock", ignore = true)
    @Mapping(target = "timeOffsetMinutes", constant = "0")
    public abstract AdminGame game(ArchivedGameEntity game, int humans, int npcs);

    /** A live game's house; gold and pp from its state entry (null before the start). */
    @Mapping(target = "playerId", source = "player.id")
    @Mapping(target = "userId", source = "player.userId")
    @Mapping(target = "userName", source = "userName")
    @Mapping(target = "houseName", source = "player.houseName")
    @Mapping(target = "background", source = "player.background")
    @Mapping(target = "npc", source = "player.npc")
    @Mapping(target = "persona", source = "player.persona")
    @Mapping(target = "legit", source = "player.legit")
    @Mapping(target = "gold", source = "state.gold")
    @Mapping(target = "pp", source = "state.pp")
    @Mapping(target = "place", ignore = true)
    @Mapping(target = "joinedAt", source = "player.createdAt")
    public abstract AdminHouse house(PlayerEntity player, String userName, EngineState.PlayerSt state);

    @Mapping(target = "playerId", source = "player.id")
    @Mapping(target = "userName", source = "userName")
    @Mapping(target = "gold", ignore = true)
    @Mapping(target = "pp", ignore = true)
    @Mapping(target = "joinedAt", source = "player.createdAt")
    public abstract AdminHouse house(ArchivedPlayerEntity player, String userName);

    @Mapping(target = "id", source = "report.id")
    @Mapping(target = "houseName", source = "houseName")
    @Mapping(target = "isPublic", source = "report.public")
    public abstract AdminReport report(ReportEntity report, String houseName);

    @Mapping(target = "id", source = "report.id")
    @Mapping(target = "houseName", source = "houseName")
    @Mapping(target = "isPublic", source = "report.public")
    public abstract AdminReport report(ArchivedReportEntity report, String houseName);

    @Mapping(target = "name", expression = "java(messages.text(map.label()))")
    @Mapping(target = "cities", expression = "java(map.cities().size())")
    @Mapping(target = "starts", expression = "java(map.starts().size())")
    public abstract AdminMap map(MapDefinition map);

    @Mapping(target = "id", source = "user.id")
    @Mapping(target = "name", source = "user.displayName")
    @Mapping(target = "role", source = "user.role")
    @Mapping(target = "createdAt", source = "user.createdAt")
    @Mapping(target = "email", source = "email")
    @Mapping(target = "providers", source = "providers")
    @Mapping(target = "games", source = "games")
    public abstract AdminUser user(AppUser user, String email, List<String> providers, int games);

    protected String status(GameStatus status) { return status.apiId; }

    @Named("mapName")
    protected String mapName(String mapId) { return messages.text(MapRegistry.exists(mapId) ? MapRegistry.get(mapId).label() : Msg.of("world.map." + mapId)); }
}
