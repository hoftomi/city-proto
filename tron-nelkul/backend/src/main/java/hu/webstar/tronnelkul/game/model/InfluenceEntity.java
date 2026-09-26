package hu.webstar.tronnelkul.game.model;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "influence")
public class InfluenceEntity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    public UUID id;
    @Column(name = "game_id", nullable = false) public String gameId;
    @Column(nullable = false) public String city;
    @Column(nullable = false) public String faction;
    @Column(name = "player_id", nullable = false) public UUID playerId;
    @Column(name = "open_value", nullable = false) public double openValue;
    @Column(name = "hidden_value", nullable = false) public double hiddenValue;

    protected InfluenceEntity() {}

    public InfluenceEntity(String gameId, String city, String faction, UUID playerId, double openValue, double hiddenValue) {
        this.gameId = gameId; this.city = city; this.faction = faction; this.playerId = playerId;
        this.openValue = openValue; this.hiddenValue = hiddenValue;
    }
}
