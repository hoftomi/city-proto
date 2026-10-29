package com.hof.tronnelkul.game.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.Instant;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "reports")
public class ReportEntity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = "game_id", nullable = false) private String gameId;
    @Column(name = "player_id", nullable = false) private UUID playerId;
    @Column(nullable = false) private int settlement;
    @Column(nullable = false) private String kind;
    private String confidence;
    @Column(nullable = false) private String title;
    @Column(nullable = false, length = 2000) private String body;
    @Column(nullable = false) private String tone;
    @Column(name = "is_public", nullable = false) private boolean isPublic;
    @Column(name = "created_at", nullable = false) private Instant createdAt = Instant.now();

    public ReportEntity(String gameId, UUID playerId, int settlement, String kind, String confidence, String title, String body, String tone,
                        boolean isPublic, Instant createdAt) {
        this.gameId = gameId; this.playerId = playerId; this.settlement = settlement; this.kind = kind; this.confidence = confidence;
        this.title = title; this.body = body; this.tone = tone; this.isPublic = isPublic; this.createdAt = createdAt;
    }
}
