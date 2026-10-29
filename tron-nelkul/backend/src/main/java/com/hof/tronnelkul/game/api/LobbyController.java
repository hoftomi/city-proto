package com.hof.tronnelkul.game.api;

import com.hof.tronnelkul.api.LobbyApi;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.common.CurrentUser;
import com.hof.tronnelkul.game.service.LobbyService;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.i18n.Messages;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;

/** Game browser and joining (api/openapi.yaml, `lobby` tag). */
@RestController
public class LobbyController implements LobbyApi {
    private final LobbyService lobby;
    private final Messages messages;

    public LobbyController(LobbyService lobby, Messages messages) { this.lobby = lobby; this.messages = messages; }

    @Override
    public List<GameSummary> listJoinedGames() { return lobby.joined(CurrentUser.id()); }

    @Override
    public List<GameSummary> listAvailableGames() { return lobby.available(CurrentUser.id()); }

    @Override
    public List<GameSummary> listArchivedGames() { return lobby.archived(CurrentUser.id()); }

    @Override
    public GameDetail getGame(String id) { return lobby.detail(id, CurrentUser.id()); }

    /** The map (cities, roads, start slots, terrain). Public data, the client may cache it. */
    @Override
    public MapDef getMap(String mapId) { return toDto(MapRegistry.get(mapId)); }

    @Override
    public void joinGame(String id, JoinRequest request) { lobby.join(id, CurrentUser.id(), request); }

    @Override
    public void withdrawGame(String id) { lobby.withdraw(id, CurrentUser.id()); }

    MapDef toDto(MapDefinition map) {
        var terrain = map.terrain();
        return new MapDef(map.id(), messages.text(map.label()),
            map.cities().stream().map(city -> new CityDef(city.id(), messages.text(city.label()), city.x(), city.y(), city.key(), city.coast(), messages.text(city.desc()),
                city.goods().stream().map(good -> new GoodDef(good.id(), messages.text(good.label()), good.supply(), good.demand())).toList())).toList(),
            map.cityEdges(),
            map.starts().stream().map(start -> new StartSlot(start.id(), messages.text(map.startLabel(start)), start.x(), start.y(), start.neighbors(), messages.text(map.startNote(start)))).toList(),
            new TerrainDef(terrain.sea(), terrain.rivers(), nums(terrain.mountains()), nums(terrain.forests()), nums(terrain.fields()), nums(terrain.marsh())));
    }

    private static List<List<Double>> nums(List<double[]> shapes) { return shapes.stream().map(points -> Arrays.stream(points).boxed().toList()).toList(); }
}
