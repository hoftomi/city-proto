package com.hof.tronnelkul.game.api;

import com.hof.tronnelkul.api.LobbyApi;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.common.CurrentUser;
import com.hof.tronnelkul.game.service.LobbyService;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;

/** Játékválasztó és jelentkezés (api/openapi.yaml, `lobby` tag). */
@RestController
public class LobbyController implements LobbyApi {
    private final LobbyService lobby;

    public LobbyController(LobbyService lobby) { this.lobby = lobby; }

    @Override
    public List<GameSummary> listGames() { return lobby.list(CurrentUser.id()); }

    @Override
    public GameDetail getGame(String id) { return lobby.detail(id, CurrentUser.id()); }

    /** A térkép (városok, utak, kezdőhelyek, domborzat). Nyilvános adat, a kliens gyorsítótárazhatja. */
    @Override
    public MapDef getMap(String mapId) { return toDto(MapRegistry.get(mapId)); }

    @Override
    public GameSummary joinGame(String id, JoinRequest r) { return lobby.join(id, CurrentUser.id(), r); }

    @Override
    public void withdrawGame(String id) { lobby.withdraw(id, CurrentUser.id()); }

    static MapDef toDto(MapDefinition m) {
        var t = m.terrain();
        return new MapDef(m.id(), m.name(),
            m.cities().stream().map(c -> new CityDef(c.id(), c.name(), c.x(), c.y(), c.key(), c.coast(), c.profile(),
                c.goods().stream().map(g -> new GoodDef(g.id(), g.name(), g.supply(), g.demand())).toList())).toList(),
            m.cityEdges(),
            m.starts().stream().map(s -> new StartSlot(s.id(), s.name(), s.x(), s.y(), s.neighbors(), s.note())).toList(),
            new TerrainDef(t.sea(), t.rivers(), nums(t.mountains()), nums(t.forests()), nums(t.fields()), nums(t.marsh())));
    }

    private static List<List<Double>> nums(List<double[]> v) { return v.stream().map(a -> Arrays.stream(a).boxed().toList()).toList(); }
}
