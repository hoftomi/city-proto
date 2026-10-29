package com.hof.tronnelkul.auth;

import com.hof.tronnelkul.user.AppUser;
import org.springframework.core.convert.converter.Converter;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Finds (on the first request creates) our own user for a verified Firebase ID token.
 * Endpoints read {@code jwt.getSubject()} as our own user id, so in the passed-on token the subject is
 * our UUID and the Firebase uid goes into the {@code uid} claim.
 */
@Component
public class FirebaseUserConverter implements Converter<Jwt, AbstractAuthenticationToken> {
    private final AuthService auth;

    public FirebaseUserConverter(AuthService auth) { this.auth = auth; }

    @Override
    public AbstractAuthenticationToken convert(Jwt token) {
        AppUser user;
        try {
            user = auth.resolve(token);
        } catch (DataIntegrityViolationException e) {
            // Two concurrent first requests: the other one already created the user.
            user = auth.resolve(token);
        }
        Jwt jwt = Jwt.withTokenValue(token.getTokenValue())
            .headers(h -> h.putAll(token.getHeaders()))
            .claims(c -> c.putAll(token.getClaims()))
            .subject(user.id.toString())
            .claim("uid", token.getSubject())
            .claim("roles", List.of(user.role))
            .build();
        return new JwtAuthenticationToken(jwt, List.of(new SimpleGrantedAuthority("ROLE_" + user.role)), user.displayName);
    }
}
