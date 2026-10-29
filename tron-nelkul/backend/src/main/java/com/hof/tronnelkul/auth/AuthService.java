package com.hof.tronnelkul.auth;

import com.hof.tronnelkul.api.model.UserDto;
import com.hof.tronnelkul.i18n.Messages;
import com.hof.tronnelkul.user.*;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class AuthService {
    /** Every account comes through Firebase; the subject is the Firebase uid. */
    static final String FIREBASE = "firebase";

    private final UserRepository users;
    private final UserIdentityRepository identities;
    private final Messages messages;

    public AuthService(UserRepository users, UserIdentityRepository identities, Messages messages) {
        this.users = users; this.identities = identities; this.messages = messages;
    }

    static UserDto dto(AppUser u) { return new UserDto(u.id, u.displayName, u.role); }

    /** The user of a verified Firebase ID token. */
    public AppUser resolve(Jwt token) {
        return findOrCreate(token.getSubject(), token.getClaimAsString("email"), token.getClaimAsString("name"));
    }

    /** Finds the user of the Firebase account, or creates it with the PLAYER role. A missing name gets a default one. */
    @Transactional
    public AppUser findOrCreate(String uid, String email, String name) {
        var existing = identities.findByProviderAndSubject(FIREBASE, uid);
        if (existing.isPresent()) return users.findById(existing.get().userId).orElseThrow();
        String n = name == null || name.isBlank() ? messages.text("server.auth.default_name") : name.strip();
        AppUser user = users.save(new AppUser(n.length() > 80 ? n.substring(0, 80) : n, "PLAYER"));
        identities.saveAndFlush(new UserIdentity(user.id, FIREBASE, uid, email));
        return user;
    }

    public UserDto me(UUID id) { return dto(users.findById(id).orElseThrow()); }
}
