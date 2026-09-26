package hu.webstar.tronnelkul.auth;

import hu.webstar.tronnelkul.config.AppProperties;
import hu.webstar.tronnelkul.user.AppUser;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.Instant;
import java.util.List;

@Service
public class TokenService {
    private final JwtEncoder encoder;
    private final AppProperties props;

    public TokenService(JwtEncoder encoder, AppProperties props) { this.encoder = encoder; this.props = props; }

    public String issue(AppUser user) {
        Instant now = Instant.now();
        JwtClaimsSet claims = JwtClaimsSet.builder()
            .issuer("tron-nelkul")
            .issuedAt(now)
            .expiresAt(now.plus(Duration.ofHours(props.jwt().ttlHours())))
            .subject(user.id.toString())
            .claim("name", user.displayName)
            .claim("roles", List.of(user.role))
            .build();
        JwsHeader header = JwsHeader.with(MacAlgorithm.HS256).build();
        return encoder.encode(JwtEncoderParameters.from(header, claims)).getTokenValue();
    }
}
