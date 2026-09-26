package hu.webstar.tronnelkul.game.model;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "city_states")
public class CityStateEntity {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    public UUID id;
    @Column(name = "game_id", nullable = false) public String gameId;
    @Column(nullable = false) public String city;
    @Column(nullable = false) public String stability;

    protected CityStateEntity() {}

    public CityStateEntity(String gameId, String city, String stability) { this.gameId = gameId; this.city = city; this.stability = stability; }
}
