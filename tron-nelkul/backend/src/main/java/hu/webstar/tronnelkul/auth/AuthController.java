package hu.webstar.tronnelkul.auth;

import hu.webstar.tronnelkul.common.ApiException;
import hu.webstar.tronnelkul.config.AppProperties;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
public class AuthController {
    private final ProviderVerifier verifier;
    private final AuthService auth;
    private final AppProperties props;

    public AuthController(ProviderVerifier verifier, AuthService auth, AppProperties props) {
        this.verifier = verifier; this.auth = auth; this.props = props;
    }

    public record IdTokenRequest(@NotBlank(message = "Hiányzik az azonosító token.") String idToken, String name) {}
    public record DiscordRequest(@NotBlank(message = "Hiányzik a Discord-kód.") String code,
                                 @NotBlank(message = "Hiányzik a PKCE-ellenőrző.") String codeVerifier,
                                 @NotBlank(message = "Hiányzik az átirányítási cím.") String redirectUri) {}
    public record DevRequest(@NotBlank(message = "Adj meg egy nevet.") @Size(max = 40, message = "Legfeljebb 40 karakter.") String name) {}

    @PostMapping("/api/auth/google")
    AuthService.AuthResponse google(@Valid @RequestBody IdTokenRequest r) { return auth.login(verifier.google(r.idToken()), "PLAYER"); }

    @PostMapping("/api/auth/apple")
    AuthService.AuthResponse apple(@Valid @RequestBody IdTokenRequest r) { return auth.login(verifier.apple(r.idToken(), r.name()), "PLAYER"); }

    @PostMapping("/api/auth/discord")
    AuthService.AuthResponse discord(@Valid @RequestBody DiscordRequest r) {
        return auth.login(verifier.discord(r.code(), r.codeVerifier(), r.redirectUri()), "PLAYER");
    }

    /** Csak fejlesztéshez: szolgáltató nélküli belépés, ADMIN szereppel. DEV_LOGIN=false kikapcsolja. */
    @PostMapping("/api/auth/dev")
    AuthService.AuthResponse dev(@Valid @RequestBody DevRequest r) {
        if (!props.auth().devLogin()) throw ApiException.notFound("Nincs ilyen végpont.");
        return auth.login(new ExternalIdentity("dev", r.name().strip().toLowerCase(), null, r.name().strip()), "ADMIN");
    }

    @GetMapping("/api/me")
    AuthService.UserDto me(@AuthenticationPrincipal Jwt jwt) { return auth.me(UUID.fromString(jwt.getSubject())); }
}
