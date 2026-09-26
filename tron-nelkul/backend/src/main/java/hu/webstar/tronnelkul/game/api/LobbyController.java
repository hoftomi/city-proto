package hu.webstar.tronnelkul.game.api;

import hu.webstar.tronnelkul.game.service.LobbyService;
import hu.webstar.tronnelkul.game.world.MapDefinition;
import hu.webstar.tronnelkul.game.world.MapRegistry;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/games")
public class LobbyController {
    private final LobbyService lobby;

    public LobbyController(LobbyService lobby) { this.lobby = lobby; }

    static UUID user(Jwt jwt) { return UUID.fromString(jwt.getSubject()); }

    @GetMapping
    List<Dtos.GameSummary> list(@AuthenticationPrincipal Jwt jwt) { return lobby.list(user(jwt)); }

    @GetMapping("/{id}")
    Dtos.GameDetail detail(@PathVariable String id, @AuthenticationPrincipal Jwt jwt) { return lobby.detail(id, user(jwt)); }

    /** A térkép (városok, utak, kezdőhelyek, domborzat). Nyilvános adat, a kliens gyorsítótárazhatja. */
    @GetMapping("/maps/{mapId}")
    MapDefinition map(@PathVariable String mapId) { return MapRegistry.get(mapId); }

    @PostMapping("/{id}/join")
    @ResponseStatus(HttpStatus.CREATED)
    Dtos.GameSummary join(@PathVariable String id, @RequestBody Dtos.JoinRequest r, @AuthenticationPrincipal Jwt jwt) {
        return lobby.join(id, user(jwt), r);
    }

    @DeleteMapping("/{id}/join")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    void withdraw(@PathVariable String id, @AuthenticationPrincipal Jwt jwt) { lobby.withdraw(id, user(jwt)); }
}
