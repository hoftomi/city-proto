package hu.webstar.tronnelkul.game.model;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "routes")
public class RouteEntity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    public UUID id;
    @Column(name = "game_id", nullable = false) public String gameId;
    @Column(name = "player_id", nullable = false) public UUID playerId;
    @Column(name = "node_a", nullable = false) public String nodeA;
    @Column(name = "node_b", nullable = false) public String nodeB;

    protected RouteEntity() {}

    public RouteEntity(String gameId, UUID playerId, String nodeA, String nodeB) {
        this.gameId = gameId; this.playerId = playerId; this.nodeA = nodeA; this.nodeB = nodeB;
    }
}
