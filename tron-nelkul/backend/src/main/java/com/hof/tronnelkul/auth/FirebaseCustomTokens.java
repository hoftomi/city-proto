package com.hof.tronnelkul.auth;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.config.AppProperties;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * Firebase custom token for providers without built-in support (Discord). The client signs in to Firebase with it.
 * Needs a service account (GOOGLE_APPLICATION_CREDENTIALS); loaded on first use only.
 */
@Component
public class FirebaseCustomTokens {
    private final AppProperties props;
    private volatile FirebaseAuth auth;

    public FirebaseCustomTokens(AppProperties props) { this.props = props; }

    public String create(String uid) {
        try {
            return auth().createCustomToken(uid);
        } catch (FirebaseAuthException e) {
            throw ApiException.unauthorized("server.auth.login_failed");
        }
    }

    private FirebaseAuth auth() {
        if (auth == null) {
            synchronized (this) {
                if (auth == null) {
                    GoogleCredentials cred;
                    try {
                        cred = GoogleCredentials.getApplicationDefault();
                    } catch (IOException e) {
                        throw ApiException.badRequest("server.auth.discord_no_credentials");
                    }
                    FirebaseApp app = FirebaseApp.initializeApp(FirebaseOptions.builder()
                        .setCredentials(cred).setProjectId(props.auth().firebaseProjectId()).build());
                    auth = FirebaseAuth.getInstance(app);
                }
            }
        }
        return auth;
    }
}
