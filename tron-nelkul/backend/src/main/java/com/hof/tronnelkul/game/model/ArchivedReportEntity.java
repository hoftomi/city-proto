package com.hof.tronnelkul.game.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.Instant;
import java.util.UUID;

/** A report of a finished game (copy of the reports row, with the same id). */
@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "archived_reports")
public class ArchivedReportEntity {
    @Id private UUID id;
    @Column(name = "game_id", nullable = false) private String gameId;
    @Column(name = "player_id", nullable = false) private UUID playerId;
    @Column(nullable = false) private int settlement;
    @Column(nullable = false) private String kind;
    private String confidence;
    @Column(nullable = false) private String title;
    @Column(nullable = false, length = 2000) private String body;
    @Column(nullable = false) private String tone;
    @Column(name = "is_public", nullable = false) private boolean isPublic;
    @Column(name = "created_at", nullable = false) private Instant createdAt;

    public ArchivedReportEntity(ReportEntity report) {
        this.id = report.getId(); this.gameId = report.getGameId(); this.playerId = report.getPlayerId(); this.settlement = report.getSettlement(); this.kind = report.getKind();
        this.confidence = report.getConfidence(); this.title = report.getTitle(); this.body = report.getBody(); this.tone = report.getTone(); this.isPublic = report.isPublic();
        this.createdAt = report.getCreatedAt();
    }
}
