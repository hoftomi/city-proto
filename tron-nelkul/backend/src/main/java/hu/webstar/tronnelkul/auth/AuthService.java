package hu.webstar.tronnelkul.auth;

import hu.webstar.tronnelkul.user.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class AuthService {
    private final UserRepository users;
    private final UserIdentityRepository identities;
    private final TokenService tokens;

    public AuthService(UserRepository users, UserIdentityRepository identities, TokenService tokens) {
        this.users = users; this.identities = identities; this.tokens = tokens;
    }

    public record UserDto(UUID id, String name, String role) {
        static UserDto of(AppUser u) { return new UserDto(u.id, u.displayName, u.role); }
    }

    public record AuthResponse(String token, UserDto user, boolean newUser) {}

    /** Belépteti vagy regisztrálja a felhasználót egy ellenőrzött külső azonosítóval. */
    @Transactional
    public AuthResponse login(ExternalIdentity ext, String role) {
        var existing = identities.findByProviderAndSubject(ext.provider(), ext.subject());
        AppUser user;
        boolean created = false;
        if (existing.isPresent()) {
            user = users.findById(existing.get().userId).orElseThrow();
        } else {
            String name = ext.name() == null || ext.name().isBlank() ? "Vándor" : ext.name().strip();
            user = users.save(new AppUser(name.length() > 80 ? name.substring(0, 80) : name, role));
            identities.save(new UserIdentity(user.id, ext.provider(), ext.subject(), ext.email()));
            created = true;
        }
        return new AuthResponse(tokens.issue(user), UserDto.of(user), created);
    }

    public UserDto me(UUID id) { return UserDto.of(users.findById(id).orElseThrow()); }
}
