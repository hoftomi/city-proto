package com.hof.tronnelkul.config;

import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

/**
 * Game gauges for Prometheus (tron_*). One aggregate query refreshes them periodically,
 * so a scrape only reads the cached values and never touches the database.
 */
@Component
public class GameMetrics {
    private static final Logger log = LoggerFactory.getLogger(GameMetrics.class);

    /** One round trip; the games/players/reports tables hold live games only, finished ones are in archived_*. */
    private static final String SNAPSHOT = """
        select
          (select count(*) from games where status = 'ANNOUNCED') as games_announced,
          (select count(*) from games where status = 'OPEN') as games_open,
          (select count(*) from games where status = 'RUNNING') as games_running,
          (select count(*) from archived_games) as games_archived,
          (select count(*) from users) as users,
          (select count(*) from users where role = 'ADMIN') as admins,
          (select count(*) from players where not npc) as houses_human,
          (select count(*) from players where npc) as houses_npc,
          (select count(*) from reports) as reports,
          (select coalesce(max(cast(version as numeric)), 0) from flyway_schema_history
             where success and version is not null) as schema_version
        """;

    private final JdbcTemplate jdbcTemplate;
    private final Map<String, Double> values = new ConcurrentHashMap<>();

    public GameMetrics(JdbcTemplate jdbcTemplate, MeterRegistry registry) {
        this.jdbcTemplate = jdbcTemplate;
        gauge(registry, "tron.games", "games_announced", "Live games by status", "status", "announced");
        gauge(registry, "tron.games", "games_open", "Live games by status", "status", "open");
        gauge(registry, "tron.games", "games_running", "Live games by status", "status", "running");
        gauge(registry, "tron.games.archived", "games_archived", "Finished (archived) games");
        gauge(registry, "tron.users", "users", "Registered users");
        gauge(registry, "tron.users.admin", "admins", "Users with the ADMIN role");
        gauge(registry, "tron.houses", "houses_human", "Houses in live games", "kind", "human");
        gauge(registry, "tron.houses", "houses_npc", "Houses in live games", "kind", "npc");
        gauge(registry, "tron.reports", "reports", "Reports stored for live games");
        gauge(registry, "tron.schema.version", "schema_version", "Latest applied Flyway migration version");
    }

    private void gauge(MeterRegistry registry, String name, String key, String description, String... tags) {
        Gauge.builder(name, values, v -> v.getOrDefault(key, Double.NaN))
            .description(description).tags(tags).register(registry);
    }

    @Scheduled(fixedDelayString = "${app.metrics-refresh-seconds:30}", initialDelay = 5, timeUnit = TimeUnit.SECONDS)
    public void refresh() {
        try {
            jdbcTemplate.query(SNAPSHOT, rs -> {
                var meta = rs.getMetaData();
                for (int i = 1; i <= meta.getColumnCount(); i++)
                    values.put(meta.getColumnLabel(i), rs.getDouble(i));
            });
        } catch (DataAccessException e) {
            log.warn("Game metrics refresh failed: {}", e.getMessage());
        }
    }
}
