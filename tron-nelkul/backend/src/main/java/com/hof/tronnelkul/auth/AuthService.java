package com.hof.tronnelkul.auth;

import com.hof.tronnelkul.api.model.UserDto;
import com.hof.tronnelkul.user.*;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class AuthService {
    /** Minden fiók a Firebase-en keresztül érkezik; az alany a Firebase uid. */
    static final String FIREBASE = "firebase";

    private final UserRepository users;
    private final UserIdentityRepository identities;

    public AuthService(UserRepository users, UserIdentityRepository identities) {
        this.users = users; this.identities = identities;
    }

    static UserDto dto(AppUser u) { return new UserDto(u.id, u.displayName, u.role); }

    /** Egy ellenőrzött Firebase ID tokenhez tartozó felhasználó. */
    public AppUser resolve(Jwt token) {
        return findOrCreate(token.getSubject(), token.getClaimAsString("email"), token.getClaimAsString("name"));
    }

    /** Megkeresi a Firebase-fiókhoz tartozó felhasználót, vagy PLAYER szereppel létrehozza. */
    @Transactional
    public AppUser findOrCreate(String uid, String email, String name) {
        var existing = identities.findByProviderAndSubject(FIREBASE, uid);
        if (existing.isPresent()) return users.findById(existing.get().userId).orElseThrow();
        String n = name == null || name.isBlank() ? "Vándor" : name.strip();
        AppUser user = users.save(new AppUser(n.length() > 80 ? n.substring(0, 80) : n, "PLAYER"));
        identities.saveAndFlush(new UserIdentity(user.id, FIREBASE, uid, email));
        return user;
    }

    public UserDto me(UUID id) { return dto(users.findById(id).orElseThrow()); }
}
