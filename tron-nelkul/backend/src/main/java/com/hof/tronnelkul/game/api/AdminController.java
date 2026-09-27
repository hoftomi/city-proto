package com.hof.tronnelkul.game.api;

import com.hof.tronnelkul.api.AdminApi;
import com.hof.tronnelkul.api.model.AdminResult;
import com.hof.tronnelkul.api.model.AdvanceRequest;
import com.hof.tronnelkul.game.service.GameLifecycleService;
import org.springframework.web.bind.annotation.RestController;

/** Fejlesztői és üzemeltetői végpontok (ADMIN szerep, a SecurityConfig ellenőrzi). */
@RestController
public class AdminController implements AdminApi {
    private final GameLifecycleService lifecycle;

    public AdminController(GameLifecycleService lifecycle) { this.lifecycle = lifecycle; }

    @Override
    public AdminResult adminStart(String id) {
        lifecycle.start(id);
        return new AdminResult().started(id);
    }

    /** Azonnali elszámolás (a 8:00 / 20:00 helyett). */
    @Override
    public AdminResult adminSettle(String id) { return new AdminResult().settlements(lifecycle.settleNow(id)); }

    /** A játék órájának előretekerése; minutes = null: a következő eseményig. */
    @Override
    public AdminResult adminAdvance(String id, AdvanceRequest r) {
        return new AdminResult().advancedMinutes(lifecycle.advance(id, r == null ? null : r.getMinutes()));
    }
}
