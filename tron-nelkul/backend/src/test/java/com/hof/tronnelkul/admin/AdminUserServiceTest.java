package com.hof.tronnelkul.admin;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.user.AppUser;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

class AdminUserServiceTest {
    static AppUser user(String role) {
        AppUser user = new AppUser("Anna", role);
        user.setId(UUID.randomUUID());
        return user;
    }

    @Test
    void rejectsUnknownRole() {
        AppUser player = user("PLAYER");
        for (String role : new String[] { null, "", "admin", "OWNER" }) {
            ApiException ex = assertThrows(ApiException.class, () -> AdminUserService.checkRole(player, role, UUID.randomUUID()));
            assertEquals(HttpStatus.BAD_REQUEST, ex.status);
            assertEquals("server.admin.role_invalid", ex.msg.key());
        }
    }

    @Test
    void ownAdminRoleStays() {
        AppUser me = user("ADMIN");
        ApiException ex = assertThrows(ApiException.class, () -> AdminUserService.checkRole(me, "PLAYER", me.getId()));
        assertEquals(HttpStatus.CONFLICT, ex.status);
        assertEquals("server.admin.own_admin_role", ex.msg.key());
        assertDoesNotThrow(() -> AdminUserService.checkRole(me, "ADMIN", me.getId()));
    }

    @Test
    void othersCanChange() {
        UUID me = UUID.randomUUID();
        assertDoesNotThrow(() -> AdminUserService.checkRole(user("ADMIN"), "PLAYER", me));
        assertDoesNotThrow(() -> AdminUserService.checkRole(user("PLAYER"), "ADMIN", me));
    }
}
