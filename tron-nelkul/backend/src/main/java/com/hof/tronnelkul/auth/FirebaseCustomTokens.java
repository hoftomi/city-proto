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
 * Firebase custom token a beépítetten nem támogatott szolgáltatókhoz (Discord). A kliens ezzel lép be a Firebase-be.
 * Service account kell hozzá (GOOGLE_APPLICATION_CREDENTIALS); csak az első használatkor töltjük be.
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
            throw ApiException.unauthorized("A belépés nem sikerült. Próbáld újra.");
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
                        throw ApiException.badRequest("A Discord-belépés nincs beállítva a szerveren (GOOGLE_APPLICATION_CREDENTIALS).");
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
