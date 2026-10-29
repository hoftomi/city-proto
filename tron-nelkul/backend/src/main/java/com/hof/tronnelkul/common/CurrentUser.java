package com.hof.tronnelkul.common;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

import java.util.UUID;

/**
 * Id of the signed-in user. The generated API interface methods do not receive the principal, so controllers
 * read it here (FirebaseUserConverter replaces the token subject with our own UUID).
 */
public final class CurrentUser {
    private CurrentUser() {}

    public static UUID id() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication instanceof JwtAuthenticationToken jwt) {
            return UUID.fromString(jwt.getToken().getSubject());
        }
        throw ApiException.unauthorized("server.auth.sign_in");
    }
}
