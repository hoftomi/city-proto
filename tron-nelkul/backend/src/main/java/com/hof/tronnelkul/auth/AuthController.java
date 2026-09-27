package com.hof.tronnelkul.auth;

import com.hof.tronnelkul.api.AuthApi;
import com.hof.tronnelkul.api.model.CustomTokenResponse;
import com.hof.tronnelkul.api.model.DiscordRequest;
import com.hof.tronnelkul.api.model.UserDto;
import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.common.CurrentUser;
import org.springframework.web.bind.annotation.RestController;

/**
 * A Google- és az Apple-belépést a kliens közvetlenül a Firebase-szel végzi. Ide csak a Discord jön:
 * a kódot ellenőrizzük, majd Firebase custom tokent adunk, amellyel a kliens belép a Firebase-be.
 */
@RestController
public class AuthController implements AuthApi {
    private final ProviderVerifier verifier;
    private final AuthService auth;
    private final FirebaseCustomTokens customTokens;

    public AuthController(ProviderVerifier verifier, AuthService auth, FirebaseCustomTokens customTokens) {
        this.verifier = verifier; this.auth = auth; this.customTokens = customTokens;
    }

    @Override
    public CustomTokenResponse discordLogin(DiscordRequest r) {
        if (blank(r.getCode())) throw ApiException.badRequest("Hiányzik a Discord-kód.");
        if (blank(r.getCodeVerifier())) throw ApiException.badRequest("Hiányzik a PKCE-ellenőrző.");
        if (blank(r.getRedirectUri())) throw ApiException.badRequest("Hiányzik az átirányítási cím.");
        ExternalIdentity ext = verifier.discord(r.getCode(), r.getCodeVerifier(), r.getRedirectUri());
        String uid = "discord:" + ext.subject();
        // A Discord-nevet itt mentjük el, mert a custom tokenes Firebase-fióknak nincs neve.
        auth.findOrCreate(uid, ext.email(), ext.name());
        return new CustomTokenResponse(customTokens.create(uid));
    }

    @Override
    public UserDto getMe() { return auth.me(CurrentUser.id()); }

    private static boolean blank(String s) { return s == null || s.isBlank(); }
}
