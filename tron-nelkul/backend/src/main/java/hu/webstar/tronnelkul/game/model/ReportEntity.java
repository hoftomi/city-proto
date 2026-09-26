package hu.webstar.tronnelkul.game.model;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "reports")
public class ReportEntity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    public UUID id;
    @Column(name = "game_id", nullable = false) public String gameId;
    @Column(name = "player_id", nullable = false) public UUID playerId;
    @Column(nullable = false) public int round;
    @Column(nullable = false) public String kind;
    public String confidence;
    @Column(nullable = false) public String title;
    @Column(nullable = false, length = 2000) public String body;
    @Column(nullable = false) public String tone;
    @Column(name = "created_at", nullable = false) public Instant createdAt = Instant.now();

    protected ReportEntity() {}

    public ReportEntity(String gameId, UUID playerId, int round, String kind, String confidence, String title, String body, String tone) {
        this.gameId = gameId; this.playerId = playerId; this.round = round; this.kind = kind; this.confidence = confidence;
        this.title = title; this.body = body; this.tone = tone;
    }
}
