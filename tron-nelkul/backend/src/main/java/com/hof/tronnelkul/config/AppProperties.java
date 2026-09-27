package com.hof.tronnelkul.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app")
public record AppProperties(String zone, Auth auth, Scheduler scheduler) {
    public record Auth(String firebaseProjectId, String discordClientId, String discordClientSecret) {}
    public record Scheduler(boolean enabled) {}
}
