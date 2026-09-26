package hu.webstar.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.UUID;

public interface CityStateRepository extends JpaRepository<CityStateEntity, UUID> {
    List<CityStateEntity> findByGameId(String gameId);
    @Modifying
    @Query("delete from CityStateEntity e where e.gameId = :gameId")
    void deleteAllForGame(@Param("gameId") String gameId);
}
