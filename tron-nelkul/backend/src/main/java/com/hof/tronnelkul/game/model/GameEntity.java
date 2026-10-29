package com.hof.tronnelkul.game.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "games")
public class GameEntity {
    /** Length of a season: 1 month (single game mode). */
    public static final int SEASON_DAYS = 30;
    /** Settlements per day (8:00 and 20:00, 3.2). */
    public static final int ROUNDS_PER_DAY = 2;
    /** Maturation time in minutes (3.1; Citizen mode). */
    public static final int MATURATION_MINUTES = 120;
    /** Late join: a running game can still be joined up to this many settlements. */
    public static final int LATE_JOIN_SETTLEMENTS = 3;

    @Id private String id;
    @Column(nullable = false) private String name;
    @Enumerated(EnumType.STRING) @Column(nullable = false) private GameStatus status;
    @Column(name = "map_id", nullable = false) private String mapId;
    @Column(name = "opens_at") private Instant opensAt;
    /** Sign-up closes: the game starts at this time. */
    @Column(name = "closes_at") private Instant closesAt;
    @Column(name = "max_players", nullable = false) private int maxPlayers;
    @Column(name = "npc_count", nullable = false) private int npcCount;
    @Column(nullable = false) private String tags = "";
    @Column(nullable = false) private String mode = "citizen";
    /** Rule engine state (engine.EngineState) as JSON; null before start. */
    @JdbcTypeCode(SqlTypes.JSON) @Column(columnDefinition = "jsonb") private String state;
    @Column(name = "created_at", nullable = false) private Instant createdAt = Instant.now();
    /** The admin moved the game clock forward by this much (game clock = real time + offset). */
    @Column(name = "time_offset_minutes", nullable = false) private int timeOffsetMinutes;

    public GameEntity(String id, String name, GameStatus status, String mapId, int maxPlayers, int npcCount, String tags) {
        this.id = id; this.name = name; this.status = status; this.mapId = mapId;
        this.maxPlayers = maxPlayers; this.npcCount = npcCount; this.tags = tags;
    }

    /** The game clock: real time + the admin's time offset. */
    public Instant now() { return clock(Instant.now()); }

    /** The game clock at the given real time. */
    public Instant clock(Instant real) { return real.plus(Duration.ofMinutes(timeOffsetMinutes)); }

    public List<String> tagList() { return tagList(tags); }

    static List<String> tagList(String tags) { return tags.isBlank() ? List.of() : Arrays.stream(tags.split(",")).map(String::trim).toList(); }

    /** Number of settlements in a season. */
    public static int maxSettlements() { return SEASON_DAYS * ROUNDS_PER_DAY; }
}
