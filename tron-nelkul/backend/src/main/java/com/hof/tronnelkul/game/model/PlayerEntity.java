package com.hof.tronnelkul.game.model;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "players")
public class PlayerEntity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    public UUID id;
    @Column(name = "game_id", nullable = false) public String gameId;
    @Column(name = "user_id") public UUID userId;
    @Column(name = "house_name", nullable = false) public String houseName;
    @Column(nullable = false) public String tincture;
    public String background;
    @Column(name = "start_slot") public String startSlot;
    @Column(nullable = false) public boolean npc;
    public String persona;
    /** A Kereskedőház induló árucikke a kezdővárosban (2.2). */
    @Column(name = "start_good") public String startGood;
    /** A Legitimitás másolata az állapotból (a lobbi helyezéséhez). */
    @Column(nullable = false) public int legit;
    @Column(name = "created_at", nullable = false) public Instant createdAt = Instant.now();

    protected PlayerEntity() {}

    public PlayerEntity(String gameId, UUID userId, String houseName, String tincture) {
        this.gameId = gameId; this.userId = userId; this.houseName = houseName; this.tincture = tincture;
    }
}
