package hu.webstar.tronnelkul.game.api;

import hu.webstar.tronnelkul.game.service.GameLifecycleService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/** Fejlesztői és üzemeltetői végpontok (ADMIN szerep). */
@RestController
@RequestMapping("/api/admin/games/{id}")
public class AdminController {
    private final GameLifecycleService lifecycle;

    public AdminController(GameLifecycleService lifecycle) { this.lifecycle = lifecycle; }

    @PostMapping("/start")
    Map<String, Object> start(@PathVariable String id) { lifecycle.start(id); return Map.of("started", id); }

    /** Azonnal lefuttat egy kört (az ütemezett 8:00 / 20:00 helyett). */
    @PostMapping("/resolve")
    Map<String, Object> resolve(@PathVariable String id) { return Map.of("resolvedRound", lifecycle.resolve(id)); }
}
