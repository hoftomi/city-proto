package com.hof.tronnelkul.config;

import com.hof.tronnelkul.auth.FirebaseUserConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.jwt.JwtClaimNames;
import org.springframework.security.oauth2.jwt.JwtClaimValidator;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;

import java.util.List;

/**
 * Stateless API. The client authenticates with its Firebase ID token (Authorization: Bearer).
 * {@link FirebaseUserConverter} maps the token subject (Firebase uid) to our own user.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    private static final String FIREBASE_JWKS = "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com";

    @Bean
    SecurityFilterChain api(HttpSecurity http, JwtDecoder decoder, FirebaseUserConverter users) throws Exception {
        http.csrf(c -> c.disable())
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(a -> a
                .requestMatchers("/api/auth/**", "/api/i18n/**", "/error").permitAll()
                // Actuator runs on the management port (8091), which must not be public; Prometheus scrapes it without auth
                .requestMatchers("/actuator/health", "/actuator/health/**", "/actuator/info", "/actuator/prometheus").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated())
            .oauth2ResourceServer(o -> o.jwt(j -> j.decoder(decoder).jwtAuthenticationConverter(users)));
        return http.build();
    }

    /** Firebase ID token: signed with Google's keys, issuer and audience are the Firebase project. */
    @Bean
    JwtDecoder jwtDecoder(AppProperties props) {
        String project = props.auth().firebaseProjectId();
        if (project == null || project.isBlank())
            throw new IllegalStateException("Missing Firebase project id (FIREBASE_PROJECT_ID).");
        NimbusJwtDecoder d = NimbusJwtDecoder.withJwkSetUri(FIREBASE_JWKS).build();
        d.setJwtValidator(new DelegatingOAuth2TokenValidator<>(
            JwtValidators.createDefaultWithIssuer("https://securetoken.google.com/" + project),
            new JwtClaimValidator<List<String>>(JwtClaimNames.AUD, aud -> aud != null && aud.contains(project)),
            new JwtClaimValidator<String>(JwtClaimNames.SUB, sub -> sub != null && !sub.isBlank())));
        return d;
    }
}
