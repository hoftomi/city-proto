package com.hof.tronnelkul.game.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.Instant;
import java.util.List;

/** Finished game. Its houses and reports are in the archived_players and archived_reports tables. */
@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "archived_games")
public class ArchivedGameEntity {
    @Id private String id;
    @Column(nullable = false) private String name;
    @Column(name = "map_id", nullable = false) private String mapId;
    @Column(name = "opens_at") private Instant opensAt;
    @Column(nullable = false) private String tags = "";
    @Column(nullable = false) private String mode = "citizen";
    private String winner;
    @Column(name = "created_at", nullable = false) private Instant createdAt;

    public ArchivedGameEntity(GameEntity game, String winner) {
        this.id = game.getId(); this.name = game.getName(); this.mapId = game.getMapId(); this.opensAt = game.getOpensAt(); this.tags = game.getTags();
        this.mode = game.getMode(); this.winner = winner; this.createdAt = game.getCreatedAt();
    }

    public List<String> tagList() { return GameEntity.tagList(tags); }
}
