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

    private final UserRepository userRepository;
    private final UserIdentityRepository userIdentityRepository;
    private final Messages messages;
    private final UserMapper userMapper;

    public AuthService(UserRepository userRepository, UserIdentityRepository userIdentityRepository, Messages messages, UserMapper userMapper) {
        this.userRepository = userRepository; this.userIdentityRepository = userIdentityRepository; this.messages = messages; this.userMapper = userMapper;
    }

    /** The user of a verified Firebase ID token. */
    public AppUser resolve(Jwt token) {
        return findOrCreate(token.getSubject(), token.getClaimAsString("email"), token.getClaimAsString("name"));
    }

    /** Finds the user of the Firebase account, or creates it with the PLAYER role. A missing name gets a default one. */
    @Transactional
    public AppUser findOrCreate(String uid, String email, String name) {
        var existing = userIdentityRepository.findByProviderAndSubject(FIREBASE, uid);
        if (existing.isPresent()) return userRepository.findById(existing.get().userId).orElseThrow();
        String n = name == null || name.isBlank() ? messages.text("server.auth.default_name") : name.strip();
        AppUser user = userRepository.save(new AppUser(n.length() > 80 ? n.substring(0, 80) : n, "PLAYER"));
        userIdentityRepository.saveAndFlush(new UserIdentity(user.id, FIREBASE, uid, email));
        return user;
    }

    public UserDto me(UUID id) { return userMapper.dto(userRepository.findById(id).orElseThrow()); }
}
