package hu.webstar.tronnelkul.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import java.util.List;

@ConfigurationProperties(prefix = "app")
public record AppProperties(String zone, Jwt jwt, Auth auth, Scheduler scheduler) {
    public record Jwt(String secret, int ttlHours) {}
    public record Auth(List<String> googleClientIds, List<String> appleAudiences, String discordClientId,
                       String discordClientSecret, boolean devLogin) {}
    public record Scheduler(boolean enabled) {}
}
