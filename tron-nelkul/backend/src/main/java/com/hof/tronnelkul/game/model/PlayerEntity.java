package com.hof.tronnelkul.game.model;

import com.hof.tronnelkul.api.model.Background;
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
@Table(name = "players")
public class PlayerEntity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = "game_id", nullable = false) private String gameId;
    @Column(name = "user_id") private UUID userId;
    @Column(name = "house_name", nullable = false) private String houseName;
    private Background background;
    @Column(name = "start_slot") private String startSlot;
    @Column(nullable = false) private boolean npc;
    private String persona;
    /** The merchant house's starting good in the home city (2.2). */
    @Column(name = "start_good") private String startGood;
    /** Copy of Legitimacy from the state (for the lobby placing). */
    @Column(nullable = false) private int legit;
    @Column(name = "created_at", nullable = false) private Instant createdAt = Instant.now();

    public PlayerEntity(String gameId, UUID userId, String houseName) {
        this.gameId = gameId; this.userId = userId; this.houseName = houseName;
    }
}
