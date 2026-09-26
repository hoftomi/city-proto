package hu.webstar.tronnelkul.game.model;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "suspicions")
public class SuspicionEntity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    public UUID id;
    @Column(name = "game_id", nullable = false) public String gameId;
    @Column(name = "player_id", nullable = false) public UUID playerId;
    @Column(nullable = false) public String city;
    @Column(nullable = false) public String faction;
    @Column(nullable = false) public int value;
    @Column(name = "last_round", nullable = false) public int lastRound;

    protected SuspicionEntity() {}

    public SuspicionEntity(String gameId, UUID playerId, String city, String faction, int value, int lastRound) {
        this.gameId = gameId; this.playerId = playerId; this.city = city; this.faction = faction; this.value = value; this.lastRound = lastRound;
    }
}
