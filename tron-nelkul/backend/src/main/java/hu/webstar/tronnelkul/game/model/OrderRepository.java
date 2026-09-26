package hu.webstar.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface OrderRepository extends JpaRepository<OrderEntity, UUID> {
    List<OrderEntity> findByGameId(String gameId);
    List<OrderEntity> findByGameIdAndPlayerIdOrderByCreatedAtAsc(String gameId, UUID playerId);
    Optional<OrderEntity> findByIdAndPlayerId(UUID id, UUID playerId);
    @Modifying
    @Query("delete from OrderEntity e where e.gameId = :gameId")
    void deleteAllForGame(@Param("gameId") String gameId);
}
