package com.hof.tronnelkul.game.api;

import com.hof.tronnelkul.api.AdminApi;
import com.hof.tronnelkul.api.model.AdminResult;
import com.hof.tronnelkul.game.service.GameLifecycleService;
import org.springframework.web.bind.annotation.RestController;

/** Development and operations endpoints (ADMIN role, checked by SecurityConfig). */
@RestController
public class AdminController implements AdminApi {
    private final GameLifecycleService lifecycle;

    public AdminController(GameLifecycleService lifecycle) { this.lifecycle = lifecycle; }

    @Override
    public AdminResult adminStart(String id) {
        lifecycle.start(id);
        return new AdminResult().started(id);
    }

    /** Immediate settlement (instead of 8:00 / 20:00). */
    @Override
    public AdminResult adminSettle(String id) { return new AdminResult().settlements(lifecycle.settleNow(id)); }
}
