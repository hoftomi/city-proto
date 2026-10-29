package com.hof.tronnelkul.game.model;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.List;

/** Finished game. Its houses and reports are in the archived_players and archived_reports tables. */
@Entity
@Table(name = "archived_games")
public class ArchivedGameEntity {
    @Id public String id;
    @Column(nullable = false) public String name;
    @Column(name = "map_id", nullable = false) public String mapId;
    @Column(name = "opens_at") public Instant opensAt;
    @Column(nullable = false) public String tags = "";
    @Column(nullable = false) public String mode = "citizen";
    public String winner;
    @Column(name = "created_at", nullable = false) public Instant createdAt;

    protected ArchivedGameEntity() {}

    public ArchivedGameEntity(GameEntity g, String winner) {
        this.id = g.id; this.name = g.name; this.mapId = g.mapId; this.opensAt = g.opensAt; this.tags = g.tags; this.mode = g.mode;
        this.winner = winner; this.createdAt = g.createdAt;
    }

    public List<String> tagList() { return GameEntity.tagList(tags); }
}
