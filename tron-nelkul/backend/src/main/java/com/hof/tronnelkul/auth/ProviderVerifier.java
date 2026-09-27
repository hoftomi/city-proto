package com.hof.tronnelkul.auth;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.config.AppProperties;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import java.util.Map;

/**
 * A Firebase által beépítetten nem támogatott szolgáltatók ellenőrzése.
 * Discord: OAuth 2.0 authorization code + PKCE csere, majd a felhasználói profil lekérése.
 */
@Component
public class ProviderVerifier {
    private final AppProperties props;
    private final RestClient http = RestClient.create();

    public ProviderVerifier(AppProperties props) { this.props = props; }

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
}
