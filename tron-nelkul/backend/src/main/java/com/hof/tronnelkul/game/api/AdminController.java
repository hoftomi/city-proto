package com.hof.tronnelkul.game.api;

import com.hof.tronnelkul.admin.AdminGameService;
import com.hof.tronnelkul.admin.AdminStatsService;
import com.hof.tronnelkul.admin.AdminUserService;
import com.hof.tronnelkul.api.AdminApi;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.common.CurrentUser;
import com.hof.tronnelkul.game.service.GameLifecycleService;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/** Admin web app endpoints (ADMIN role, checked by SecurityConfig). */
@RestController
public class AdminController implements AdminApi {
    private final GameLifecycleService lifecycle;
    private final AdminStatsService adminStatsService;
    private final AdminGameService adminGameService;
    private final AdminUserService adminUserService;

    public AdminController(GameLifecycleService lifecycle, AdminStatsService adminStatsService, AdminGameService adminGameService,
                           AdminUserService adminUserService) {
        this.lifecycle = lifecycle; this.adminStatsService = adminStatsService; this.adminGameService = adminGameService;
        this.adminUserService = adminUserService;
    }

    @Override
    public AdminOverview adminOverview() { return adminStatsService.overview(); }

    @Override
    public List<AdminMap> adminMaps() { return adminGameService.maps(); }

    @Override
    public List<AdminGame> adminGames() { return adminGameService.games(); }

    @Override
    public AdminGame adminCreateGame(CreateGameRequest r) { return adminGameService.create(r); }

    @Override
    public AdminResult adminSeed() { return adminGameService.seed(); }

    @Override
    public AdminGameDetail adminGame(String id) { return adminGameService.detail(id); }

    @Override
    public void adminDeleteGame(String id) { adminGameService.delete(id); }

    @Override
    public List<AdminReport> adminGameReports(String id, Integer limit) { return adminGameService.reports(id, limit); }

    @Override
    public void adminRemovePlayer(String id, String playerId) { adminGameService.removePlayer(id, playerId); }

    @Override
    public AdminResult adminStart(String id) {
        lifecycle.start(id);
        return new AdminResult().started(id);
    }

    /** Immediate settlement (instead of 8:00 / 20:00). */
    @Override
    public AdminResult adminSettle(String id) { return new AdminResult().settlements(lifecycle.settleNow(id)); }

    @Override
    public AdminResult adminAdvance(String id, AdvanceRequest r) { return new AdminResult().advancedMinutes(lifecycle.advance(id, r.getMinutes())); }

    /** Ends the season now; settlements: how many the season had. */
    @Override
    public AdminResult adminFinish(String id) { return new AdminResult().settlements(lifecycle.finish(id)); }

    @Override
    public List<AdminUser> adminUsers() { return adminUserService.users(); }

    @Override
    public AdminUser adminSetRole(String id, RoleRequest r) { return adminUserService.setRole(id, r.getRole(), CurrentUser.id()); }
}
