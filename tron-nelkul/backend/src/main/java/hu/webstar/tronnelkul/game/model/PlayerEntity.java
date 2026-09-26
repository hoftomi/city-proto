package hu.webstar.tronnelkul.game.model;

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
    public String favorite;
    @Column(nullable = false) public int pp;
    @Column(nullable = false) public int arany;
    @Column(nullable = false) public int bp;
    @Column(nullable = false) public int ke;
    @Column(nullable = false) public int legit;
    @Column(name = "npc_cooldown", nullable = false) public int npcCooldown;
    @Column(name = "sealed_round", nullable = false) public int sealedRound;
    @Column(name = "created_at", nullable = false) public Instant createdAt = Instant.now();

    protected PlayerEntity() {}

    public PlayerEntity(String gameId, UUID userId, String houseName, String tincture) {
        this.gameId = gameId; this.userId = userId; this.houseName = houseName; this.tincture = tincture;
    }
}
