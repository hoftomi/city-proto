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
 * Egy ellenőrzött Firebase ID tokenhez megkeresi (első kéréskor létrehozza) a saját felhasználónkat.
 * A végpontok a {@code jwt.getSubject()} értékét a saját felhasználói azonosítónkként olvassák, ezért a
 * továbbadott tokenben az alany a mi UUID-nk, a Firebase uid pedig a {@code uid} claimbe kerül.
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
            // Két egyidejű első kérés: a másik már létrehozta a felhasználót.
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
