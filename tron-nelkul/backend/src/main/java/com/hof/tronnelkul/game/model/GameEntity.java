package com.hof.tronnelkul.game.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.Arrays;
import java.util.List;

@Entity
@Table(name = "games")
public class GameEntity {
    /** Length of a season: 1 month (single game mode). */
    public static final int SEASON_DAYS = 30;
    /** Settlements per day (8:00 and 20:00, 3.2). */
    public static final int ROUNDS_PER_DAY = 2;
    /** Maturation time in minutes (3.1; Citizen mode). */
    public static final int MATURATION_MINUTES = 120;

    @Id public String id;
    @Column(nullable = false) public String name;
    @Enumerated(EnumType.STRING) @Column(nullable = false) public GameStatus status;
    @Column(name = "map_id", nullable = false) public String mapId;
    @Column(name = "opens_at") public Instant opensAt;
    /** Sign-up closes: the game starts at this time. */
    @Column(name = "closes_at") public Instant closesAt;
    @Column(name = "max_players", nullable = false) public int maxPlayers;
    @Column(name = "npc_count", nullable = false) public int npcCount;
    @Column(nullable = false) public String tags = "";
    @Column(nullable = false) public String mode = "citizen";
    /** Rule engine state (engine.EngineState) as JSON; null before start. */
    @JdbcTypeCode(SqlTypes.JSON) @Column(columnDefinition = "jsonb") public String state;
    @Column(name = "created_at", nullable = false) public Instant createdAt = Instant.now();

    protected GameEntity() {}

    public GameEntity(String id, String name, GameStatus status, String mapId, int maxPlayers, int npcCount, String tags) {
        this.id = id; this.name = name; this.status = status; this.mapId = mapId;
        this.maxPlayers = maxPlayers; this.npcCount = npcCount; this.tags = tags;
    }

    public List<String> tagList() { return tagList(tags); }

    static List<String> tagList(String tags) { return tags.isBlank() ? List.of() : Arrays.stream(tags.split(",")).map(String::trim).toList(); }

    /** Number of settlements in a season. */
    public static int maxSettlements() { return SEASON_DAYS * ROUNDS_PER_DAY; }
}
