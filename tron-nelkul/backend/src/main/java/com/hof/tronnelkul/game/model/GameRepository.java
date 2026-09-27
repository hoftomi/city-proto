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
    List<GameEntity> findByStatusAndStartsAtBefore(GameStatus status, Instant time);
    List<GameEntity> findByStatusAndOpensAtBefore(GameStatus status, Instant time);

    /** Írás előtt: az ütemező és a játékosok parancsai így nem írják felül egymás állapotát. */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select g from GameEntity g where g.id = :id")
    Optional<GameEntity> lockById(String id);
}
