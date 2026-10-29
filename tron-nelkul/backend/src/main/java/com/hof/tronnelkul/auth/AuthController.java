package com.hof.tronnelkul.auth;

import com.hof.tronnelkul.api.AuthApi;
import com.hof.tronnelkul.api.model.CustomTokenResponse;
import com.hof.tronnelkul.api.model.DiscordRequest;
import com.hof.tronnelkul.api.model.UserDto;
import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.common.CurrentUser;
import org.springframework.web.bind.annotation.RestController;

/**
 * Google and Apple sign-in is done by the client directly with Firebase. Only Discord comes here:
 * we verify the code, then issue a Firebase custom token the client signs in to Firebase with.
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
    public CustomTokenResponse discordLogin(DiscordRequest request) {
        if (blank(request.getCode())) {
            throw ApiException.badRequest("server.auth.discord_code_missing");
        }
        if (blank(request.getCodeVerifier())) {
            throw ApiException.badRequest("server.auth.pkce_missing");
        }
        if (blank(request.getRedirectUri())) {
            throw ApiException.badRequest("server.auth.redirect_missing");
        }
        ExternalIdentity ext = verifier.discord(request.getCode(), request.getCodeVerifier(), request.getRedirectUri());
        String uid = "discord:" + ext.subject();
        // The Discord name is saved here, because a custom-token Firebase account has no name.
        auth.findOrCreate(uid, ext.email(), ext.name());
        return new CustomTokenResponse(customTokens.create(uid));
    }

    @Override
    public UserDto getMe() { return auth.me(CurrentUser.id()); }

    private static boolean blank(String value) { return value == null || value.isBlank(); }
}
