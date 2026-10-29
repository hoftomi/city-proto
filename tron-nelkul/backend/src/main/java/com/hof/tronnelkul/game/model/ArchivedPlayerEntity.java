package com.hof.tronnelkul.game.model;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

/** A house of a finished game (copy of the players row, with the same id). */
@Entity
@Table(name = "archived_players")
public class ArchivedPlayerEntity {
    @Id public UUID id;
    @Column(name = "game_id", nullable = false) public String gameId;
    @Column(name = "user_id") public UUID userId;
    @Column(name = "house_name", nullable = false) public String houseName;
    @Column(nullable = false) public String tincture;
    public String background;
    @Column(name = "start_slot") public String startSlot;
    @Column(nullable = false) public boolean npc;
    public String persona;
    @Column(name = "start_good") public String startGood;
    @Column(nullable = false) public int legit;
    /** Final place by Legitimacy (1 = winner), fixed when the game is archived. */
    @Column(nullable = false) public int place;
    @Column(name = "created_at", nullable = false) public Instant createdAt;

    protected ArchivedPlayerEntity() {}

    public ArchivedPlayerEntity(PlayerEntity p, int place) {
        this.id = p.id; this.gameId = p.gameId; this.userId = p.userId; this.houseName = p.houseName; this.tincture = p.tincture;
        this.background = p.background; this.startSlot = p.startSlot; this.npc = p.npc; this.persona = p.persona;
        this.startGood = p.startGood; this.legit = p.legit; this.place = place; this.createdAt = p.createdAt;
    }
}
