package com.hof.tronnelkul.game.model;

import com.hof.tronnelkul.api.model.Background;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.Instant;
import java.util.UUID;

/** A house of a finished game (copy of the players row, with the same id). */
@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "archived_players")
public class ArchivedPlayerEntity {
    @Id private UUID id;
    @Column(name = "game_id", nullable = false) private String gameId;
    @Column(name = "user_id") private UUID userId;
    @Column(name = "house_name", nullable = false) private String houseName;
    private Background background;
    @Column(name = "start_slot") private String startSlot;
    @Column(nullable = false) private boolean npc;
    private String persona;
    @Column(name = "start_good") private String startGood;
    @Column(nullable = false) private int legit;
    /** Final place by Legitimacy (1 = winner), fixed when the game is archived. */
    @Column(nullable = false) private int place;
    @Column(name = "created_at", nullable = false) private Instant createdAt;

    public ArchivedPlayerEntity(PlayerEntity player, int place) {
        this.id = player.getId(); this.gameId = player.getGameId(); this.userId = player.getUserId(); this.houseName = player.getHouseName();
        this.background = player.getBackground(); this.startSlot = player.getStartSlot(); this.npc = player.isNpc(); this.persona = player.getPersona();
        this.startGood = player.getStartGood(); this.legit = player.getLegit(); this.place = place; this.createdAt = player.getCreatedAt();
    }
}
