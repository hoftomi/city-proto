package hu.webstar.tronnelkul.game.api;

import hu.webstar.tronnelkul.game.service.GameViewService;
import hu.webstar.tronnelkul.game.service.OrderService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/games/{id}")
public class GameController {
    private final GameViewService view;
    private final OrderService orders;

    public GameController(GameViewService view, OrderService orders) { this.view = view; this.orders = orders; }

    @GetMapping("/state")
    Dtos.GameState state(@PathVariable String id, @AuthenticationPrincipal Jwt jwt) { return view.state(id, LobbyController.user(jwt)); }

    @GetMapping("/reports")
    List<Dtos.ReportView> reports(@PathVariable String id, @AuthenticationPrincipal Jwt jwt) { return view.reports(id, LobbyController.user(jwt)); }

    @GetMapping("/ranking")
    List<Dtos.RankRow> ranking(@PathVariable String id, @AuthenticationPrincipal Jwt jwt) { return view.ranking(id, LobbyController.user(jwt)); }

    /** Parancs felvétele. Válaszként a frissített játékállapot jön vissza. */
    @PostMapping("/orders")
    Dtos.GameState addOrder(@PathVariable String id, @RequestBody Dtos.OrderRequest r, @AuthenticationPrincipal Jwt jwt) {
        UUID u = LobbyController.user(jwt);
        orders.add(id, u, r);
        return view.state(id, u);
    }

    @DeleteMapping("/orders/{orderId}")
    Dtos.GameState removeOrder(@PathVariable String id, @PathVariable UUID orderId, @AuthenticationPrincipal Jwt jwt) {
        UUID u = LobbyController.user(jwt);
        orders.remove(id, u, orderId);
        return view.state(id, u);
    }

    @PostMapping("/seal")
    Dtos.GameState seal(@PathVariable String id, @AuthenticationPrincipal Jwt jwt) {
        UUID u = LobbyController.user(jwt);
        orders.seal(id, u, true);
        return view.state(id, u);
    }

    @DeleteMapping("/seal")
    Dtos.GameState unseal(@PathVariable String id, @AuthenticationPrincipal Jwt jwt) {
        UUID u = LobbyController.user(jwt);
        orders.seal(id, u, false);
        return view.state(id, u);
    }
}
