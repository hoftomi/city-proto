package com.hof.tronnelkul.game.model;

import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import java.time.Instant;
import java.util.List;
import java.util.Optional;

public interface GameRepository extends JpaRepository<GameEntity, String> {
    List<GameEntity> findByStatus(GameStatus status);
    List<GameEntity> findByStatusAndClosesAtBefore(GameStatus status, Instant time);
    List<GameEntity> findByStatusAndOpensAtBefore(GameStatus status, Instant time);

    /** Before writing: so the scheduler and player orders do not overwrite each other's state. */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select g from GameEntity g where g.id = :id")
    Optional<GameEntity> lockById(String id);
}
