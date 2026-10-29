package com.hof.tronnelkul.admin;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.user.AppUser;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

class AdminUserServiceTest {
    static AppUser user(String role) {
        AppUser u = new AppUser("Anna", role);
        u.id = UUID.randomUUID();
        return u;
    }

    @Test
    void rejectsUnknownRole() {
        AppUser u = user("PLAYER");
        for (String role : new String[] { null, "", "admin", "OWNER" }) {
            ApiException e = assertThrows(ApiException.class, () -> AdminUserService.checkRole(u, role, UUID.randomUUID()));
            assertEquals(HttpStatus.BAD_REQUEST, e.status);
            assertEquals("server.admin.role_invalid", e.msg.key());
        }
    }

    @Test
    void ownAdminRoleStays() {
        AppUser me = user("ADMIN");
        ApiException e = assertThrows(ApiException.class, () -> AdminUserService.checkRole(me, "PLAYER", me.id));
        assertEquals(HttpStatus.CONFLICT, e.status);
        assertEquals("server.admin.own_admin_role", e.msg.key());
        assertDoesNotThrow(() -> AdminUserService.checkRole(me, "ADMIN", me.id));
    }

    @Test
    void othersCanChange() {
        UUID me = UUID.randomUUID();
        assertDoesNotThrow(() -> AdminUserService.checkRole(user("ADMIN"), "PLAYER", me));
        assertDoesNotThrow(() -> AdminUserService.checkRole(user("PLAYER"), "ADMIN", me));
    }
}
