package com.hof.tronnelkul.common;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

import java.util.UUID;

/**
 * A bejelentkezett felhasználó azonosítója. A generált API-interfészek metódusai nem kapják meg a principalt,
 * ezért a vezérlők innen olvassák (a FirebaseUserConverter a token alanyát a saját UUID-nkra cseréli).
 */
public final class CurrentUser {
    private CurrentUser() {}

    public static UUID id() {
        Authentication a = SecurityContextHolder.getContext().getAuthentication();
        if (a instanceof JwtAuthenticationToken t) return UUID.fromString(t.getToken().getSubject());
        throw ApiException.unauthorized("Jelentkezz be.");
    }
}
