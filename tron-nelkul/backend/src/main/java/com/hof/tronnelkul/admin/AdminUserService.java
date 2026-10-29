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
        AppUser user = AdminGameService.uuid(id).flatMap(userRepository::findById).orElseThrow(() -> ApiException.notFound("server.admin.user_not_found"));
        checkRole(user, role, actingUserId);
        user.setRole(role);
        return dtos(List.of(userRepository.save(user))).getFirst();
    }

    static void checkRole(AppUser user, String role, UUID actingUserId) {
        if (role == null || !ROLES.contains(role)) {
            throw ApiException.badRequest("server.admin.role_invalid");
        }
        if (user.getId().equals(actingUserId) && ADMIN.equals(user.getRole()) && !ADMIN.equals(role)) {
            throw ApiException.conflict("server.admin.own_admin_role");
        }
    }

    private List<AdminUser> dtos(List<AppUser> users) {
        if (users.isEmpty()) {
            return List.of();
        }
        List<UUID> ids = users.stream().map(user -> user.getId()).toList();
        Map<UUID, UserIdentityRepository.IdentitySummary> identities = userIdentityRepository.summarize(ids).stream()
            .collect(Collectors.toMap(UserIdentityRepository.IdentitySummary::getUserId, identity -> identity));
        Map<UUID, Long> games = userRepository.countGames(ids).stream()
            .collect(Collectors.toMap(UserRepository.GameCount::getUserId, UserRepository.GameCount::getGames));
        return users.stream().map(user -> {
            UserIdentityRepository.IdentitySummary identity = identities.get(user.getId());
            List<String> providers = identity == null || identity.getProviders() == null ? List.of() : List.of(identity.getProviders().split(","));
            return adminMapper.user(user, identity == null ? null : identity.getEmail(), providers, games.getOrDefault(user.getId(), 0L).intValue());
        }).toList();
    }
}
