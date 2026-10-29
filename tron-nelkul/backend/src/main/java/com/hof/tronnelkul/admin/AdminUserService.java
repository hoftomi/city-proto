package com.hof.tronnelkul.admin;

import com.hof.tronnelkul.api.model.AdminUser;
import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.user.AppUser;
import com.hof.tronnelkul.user.UserIdentityRepository;
import com.hof.tronnelkul.user.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/** Admin: the users with their sign-in providers and game counts, and granting or revoking the ADMIN role. */
@Service
public class AdminUserService {
    public static final String PLAYER = "PLAYER", ADMIN = "ADMIN";
    static final Set<String> ROLES = Set.of(PLAYER, ADMIN);

    private final UserRepository userRepository;
    private final UserIdentityRepository userIdentityRepository;
    private final AdminMapper adminMapper;

    public AdminUserService(UserRepository userRepository, UserIdentityRepository userIdentityRepository, AdminMapper adminMapper) {
        this.userRepository = userRepository; this.userIdentityRepository = userIdentityRepository; this.adminMapper = adminMapper;
    }

    /** Every user, newest first. */
    @Transactional(readOnly = true)
    public List<AdminUser> users() { return dtos(userRepository.findAllByOrderByCreatedAtDesc()); }

    /** Sets the role (PLAYER or ADMIN). An admin cannot revoke their own ADMIN role. */
    @Transactional
    public AdminUser setRole(String id, String role, UUID actingUserId) {
        AppUser u = AdminGameService.uuid(id).flatMap(userRepository::findById).orElseThrow(() -> ApiException.notFound("server.admin.user_not_found"));
        checkRole(u, role, actingUserId);
        u.role = role;
        return dtos(List.of(userRepository.save(u))).getFirst();
    }

    static void checkRole(AppUser u, String role, UUID actingUserId) {
        if (role == null || !ROLES.contains(role)) throw ApiException.badRequest("server.admin.role_invalid");
        if (u.id.equals(actingUserId) && ADMIN.equals(u.role) && !ADMIN.equals(role)) throw ApiException.conflict("server.admin.own_admin_role");
    }

    private List<AdminUser> dtos(List<AppUser> users) {
        if (users.isEmpty()) return List.of();
        List<UUID> ids = users.stream().map(u -> u.id).toList();
        Map<UUID, UserIdentityRepository.IdentitySummary> identities = userIdentityRepository.summarize(ids).stream()
            .collect(Collectors.toMap(UserIdentityRepository.IdentitySummary::getUserId, i -> i));
        Map<UUID, Long> games = userRepository.countGames(ids).stream()
            .collect(Collectors.toMap(UserRepository.GameCount::getUserId, UserRepository.GameCount::getGames));
        return users.stream().map(u -> {
            UserIdentityRepository.IdentitySummary i = identities.get(u.id);
            List<String> providers = i == null || i.getProviders() == null ? List.of() : List.of(i.getProviders().split(","));
            return adminMapper.user(u, i == null ? null : i.getEmail(), providers, games.getOrDefault(u.id, 0L).intValue());
        }).toList();
    }
}
