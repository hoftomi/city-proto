package hu.webstar.tronnelkul.auth;

import hu.webstar.tronnelkul.common.ApiException;
import hu.webstar.tronnelkul.config.AppProperties;
import org.springframework.http.MediaType;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * A mobil kliens által hozott szolgáltatói azonosítók ellenőrzése.
 * Google és Apple: ID token (JWT) aláírás, kiadó és célközönség ellenőrzése a szolgáltató kulcsaival.
 * Discord: OAuth 2.0 authorization code + PKCE csere, majd a felhasználói profil lekérése.
 */
@Component
public class ProviderVerifier {
    private final AppProperties props;
    private final RestClient http = RestClient.create();
    private volatile JwtDecoder google;
    private volatile JwtDecoder apple;

    public ProviderVerifier(AppProperties props) { this.props = props; }

    public ExternalIdentity google(String idToken) {
        List<String> aud = props.auth().googleClientIds();
        if (aud == null || aud.isEmpty()) throw ApiException.badRequest("A Google-belépés nincs beállítva a szerveren (GOOGLE_CLIENT_IDS).");
        if (google == null) google = decoder("https://www.googleapis.com/oauth2/v3/certs", Set.of("https://accounts.google.com", "accounts.google.com"), aud);
        Jwt jwt = decode(google, idToken);
        return new ExternalIdentity("google", jwt.getSubject(), jwt.getClaimAsString("email"), jwt.getClaimAsString("name"));
    }

    public ExternalIdentity apple(String idToken, String name) {
        List<String> aud = props.auth().appleAudiences();
        if (aud == null || aud.isEmpty()) throw ApiException.badRequest("Az Apple-belépés nincs beállítva a szerveren (APPLE_AUDIENCES).");
        if (apple == null) apple = decoder("https://appleid.apple.com/auth/keys", Set.of("https://appleid.apple.com"), aud);
        Jwt jwt = decode(apple, idToken);
        // Az Apple a nevet csak az első belépéskor adja át, és akkor is csak a kliensnek.
        return new ExternalIdentity("apple", jwt.getSubject(), jwt.getClaimAsString("email"), name);
    }

    @SuppressWarnings("unchecked")
    public ExternalIdentity discord(String code, String codeVerifier, String redirectUri) {
        var a = props.auth();
        if (a.discordClientId() == null || a.discordClientId().isBlank())
            throw ApiException.badRequest("A Discord-belépés nincs beállítva a szerveren (DISCORD_CLIENT_ID).");
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("client_id", a.discordClientId());
        if (a.discordClientSecret() != null && !a.discordClientSecret().isBlank()) form.add("client_secret", a.discordClientSecret());
        form.add("grant_type", "authorization_code");
        form.add("code", code);
        form.add("redirect_uri", redirectUri);
        form.add("code_verifier", codeVerifier);
        try {
            Map<String, Object> token = http.post().uri("https://discord.com/api/oauth2/token")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED).body(form).retrieve().body(Map.class);
            String access = token == null ? null : (String) token.get("access_token");
            if (access == null) throw ApiException.unauthorized("A Discord nem adott hozzáférési tokent.");
            Map<String, Object> me = http.get().uri("https://discord.com/api/users/@me")
                .header("Authorization", "Bearer " + access).retrieve().body(Map.class);
            if (me == null || me.get("id") == null) throw ApiException.unauthorized("A Discord-profil nem kérhető le.");
            Object global = me.get("global_name");
            String name = global != null ? global.toString() : String.valueOf(me.get("username"));
            return new ExternalIdentity("discord", me.get("id").toString(), (String) me.get("email"), name);
        } catch (RestClientException e) {
            throw ApiException.unauthorized("A Discord-belépés nem sikerült. Próbáld újra.");
        }
    }

    private static Jwt decode(JwtDecoder d, String token) {
        try {
            return d.decode(token);
        } catch (JwtException e) {
            throw ApiException.unauthorized("A bejelentkezési token érvénytelen vagy lejárt.");
        }
    }

    private static JwtDecoder decoder(String jwks, Set<String> issuers, List<String> audiences) {
        NimbusJwtDecoder d = NimbusJwtDecoder.withJwkSetUri(jwks).build();
        OAuth2TokenValidator<Jwt> iss = jwt -> issuers.contains(jwt.getClaimAsString("iss")) ? OAuth2TokenValidatorResult.success()
            : OAuth2TokenValidatorResult.failure(new OAuth2Error("invalid_token", "Rossz kiadó", null));
        OAuth2TokenValidator<Jwt> aud = jwt -> jwt.getAudience() != null && jwt.getAudience().stream().anyMatch(audiences::contains)
            ? OAuth2TokenValidatorResult.success()
            : OAuth2TokenValidatorResult.failure(new OAuth2Error("invalid_token", "Rossz célközönség", null));
        d.setJwtValidator(new DelegatingOAuth2TokenValidator<>(new JwtTimestampValidator(), iss, aud));
        return d;
    }
}
