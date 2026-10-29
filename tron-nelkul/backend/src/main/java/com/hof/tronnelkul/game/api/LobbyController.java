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
    public GameSummary joinGame(String id, JoinRequest r) { return lobby.join(id, CurrentUser.id(), r); }

    @Override
    public void withdrawGame(String id) { lobby.withdraw(id, CurrentUser.id()); }

    MapDef toDto(MapDefinition m) {
        var t = m.terrain();
        return new MapDef(m.id(), messages.text(m.label()),
            m.cities().stream().map(c -> new CityDef(c.id(), messages.text(c.label()), c.x(), c.y(), c.key(), c.coast(), messages.text(c.desc()),
                c.goods().stream().map(g -> new GoodDef(g.id(), messages.text(g.label()), g.supply(), g.demand())).toList())).toList(),
            m.cityEdges(),
            m.starts().stream().map(s -> new StartSlot(s.id(), messages.text(m.startLabel(s)), s.x(), s.y(), s.neighbors(), messages.text(m.startNote(s)))).toList(),
            new TerrainDef(t.sea(), t.rivers(), nums(t.mountains()), nums(t.forests()), nums(t.fields()), nums(t.marsh())));
    }

    private static List<List<Double>> nums(List<double[]> v) { return v.stream().map(a -> Arrays.stream(a).boxed().toList()).toList(); }
}
