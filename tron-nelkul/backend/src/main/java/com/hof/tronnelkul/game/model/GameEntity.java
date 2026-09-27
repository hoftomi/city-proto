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
    @Id public String id;
    @Column(nullable = false) public String name;
    @Column(nullable = false) public String season;
    @Enumerated(EnumType.STRING) @Column(nullable = false) public GameStatus status;
    @Column(name = "map_id", nullable = false) public String mapId;
    @Column(name = "starts_at") public Instant startsAt;
    @Column(name = "opens_at") public Instant opensAt;
    @Column(nullable = false) public int days;
    @Column(name = "rounds_per_day", nullable = false) public int roundsPerDay = 2;
    @Column(name = "max_players", nullable = false) public int maxPlayers;
    @Column(name = "npc_count", nullable = false) public int npcCount;
    @Column(nullable = false) public String tags = "";
    /** Eddigi elszámolások (a lobbi ezt mutatja; a pontos érték az állapotban van). */
    @Column(nullable = false) public int settlements;
    /** Érlelési idő percben (3.1; Polgár mód: 120). */
    @Column(name = "maturation_minutes", nullable = false) public int maturationMinutes = 120;
    /** Fejlesztéshez: a játék órája ennyi perccel jár a valódi idő előtt (admin előretekerés). */
    @Column(name = "time_offset_minutes", nullable = false) public int timeOffsetMinutes;
    @Column(nullable = false) public String mode = "polgar";
    /** A szabálymotor állapota (engine.EngineState) JSON-ban; indulás előtt null. */
    @JdbcTypeCode(SqlTypes.JSON) @Column(columnDefinition = "jsonb") public String state;
    public String winner;
    @Column(name = "created_at", nullable = false) public Instant createdAt = Instant.now();

    protected GameEntity() {}

    public GameEntity(String id, String name, String season, GameStatus status, String mapId, int days, int maxPlayers, int npcCount, String tags) {
        this.id = id; this.name = name; this.season = season; this.status = status; this.mapId = mapId;
        this.days = days; this.maxPlayers = maxPlayers; this.npcCount = npcCount; this.tags = tags;
    }

    public List<String> tagList() { return tags.isBlank() ? List.of() : Arrays.stream(tags.split(",")).map(String::trim).toList(); }

    /** A szezon elszámolásainak száma (napi 2). */
    public int maxSettlements() { return days * roundsPerDay; }

    /** A játék órája: a valódi idő plusz a fejlesztői eltolás. */
    public Instant now() { return Instant.now().plusSeconds(timeOffsetMinutes * 60L); }
}
