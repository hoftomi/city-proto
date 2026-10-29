package com.hof.tronnelkul.game.model;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

/** A report of a finished game (copy of the reports row, with the same id). */
@Entity
@Table(name = "archived_reports")
public class ArchivedReportEntity {
    @Id public UUID id;
    @Column(name = "game_id", nullable = false) public String gameId;
    @Column(name = "player_id", nullable = false) public UUID playerId;
    @Column(nullable = false) public int settlement;
    @Column(nullable = false) public String kind;
    public String confidence;
    @Column(nullable = false) public String title;
    @Column(nullable = false, length = 2000) public String body;
    @Column(nullable = false) public String tone;
    @Column(name = "is_public", nullable = false) public boolean isPublic;
    @Column(name = "created_at", nullable = false) public Instant createdAt;

    protected ArchivedReportEntity() {}

    public ArchivedReportEntity(ReportEntity r) {
        this.id = r.id; this.gameId = r.gameId; this.playerId = r.playerId; this.settlement = r.settlement; this.kind = r.kind;
        this.confidence = r.confidence; this.title = r.title; this.body = r.body; this.tone = r.tone; this.isPublic = r.isPublic;
        this.createdAt = r.createdAt;
    }
}
