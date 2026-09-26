package hu.webstar.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import java.time.Instant;
import java.util.List;

public interface GameRepository extends JpaRepository<GameEntity, String> {
    List<GameEntity> findByStatus(GameStatus status);
    List<GameEntity> findByStatusAndStartsAtBefore(GameStatus status, Instant time);
    List<GameEntity> findByStatusAndOpensAtBefore(GameStatus status, Instant time);
}
