package hu.webstar.tronnelkul.game.model;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "orders")
public class OrderEntity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    public UUID id;
    @Column(name = "game_id", nullable = false) public String gameId;
    @Column(name = "player_id", nullable = false) public UUID playerId;
    @Column(nullable = false) public int round;
    @Column(nullable = false) public String type;
    public String city;
    public String faction;
    @Column(nullable = false) public boolean hidden;
    @Column(name = "target_id") public UUID targetId;
    @Column(name = "node_from") public String nodeFrom;
    @Column(name = "node_to") public String nodeTo;
    @Column(name = "created_at", nullable = false) public Instant createdAt = Instant.now();

    protected OrderEntity() {}

    public OrderEntity(String gameId, UUID playerId, int round, String type) {
        this.gameId = gameId; this.playerId = playerId; this.round = round; this.type = type;
    }
}
