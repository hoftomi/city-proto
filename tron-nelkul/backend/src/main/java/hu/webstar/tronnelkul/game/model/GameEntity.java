package hu.webstar.tronnelkul.game.model;

import jakarta.persistence.*;
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
    @Column(nullable = false) public int round;
    public String winner;
    @Column(name = "created_at", nullable = false) public Instant createdAt = Instant.now();

    protected GameEntity() {}

    public GameEntity(String id, String name, String season, GameStatus status, String mapId, int days, int maxPlayers, int npcCount, String tags) {
        this.id = id; this.name = name; this.season = season; this.status = status; this.mapId = mapId;
        this.days = days; this.maxPlayers = maxPlayers; this.npcCount = npcCount; this.tags = tags;
    }

    public List<String> tagList() { return tags.isBlank() ? List.of() : Arrays.stream(tags.split(",")).map(String::trim).toList(); }

    public int maxRounds() { return days * roundsPerDay; }
}
