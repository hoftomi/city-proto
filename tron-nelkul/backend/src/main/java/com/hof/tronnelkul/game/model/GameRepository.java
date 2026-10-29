package com.hof.tronnelkul.game.model;

import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface GameRepository extends JpaRepository<GameEntity, String> {
    /** Lobby order: running first, then open, then announced; within a status by start time. */
    String LOBBY_ORDER = " order by case g.status when com.hof.tronnelkul.game.model.GameStatus.RUNNING then 0"
        + " when com.hof.tronnelkul.game.model.GameStatus.OPEN then 1 else 2 end, coalesce(g.closesAt, g.createdAt)";

    /** Live games the user has not joined. */
    @Query("select g from GameEntity g where not exists (select p from PlayerEntity p where p.gameId = g.id and p.userId = :userId)" + LOBBY_ORDER)
    List<GameEntity> findNotJoined(UUID userId);

    /** Settlements so far, read from the state document without loading it. */
    @Query(value = "select id as gameId, cast(state ->> 'settlements' as integer) as settlements from games where id in (:ids)", nativeQuery = true)
    List<Progress> findProgress(Collection<String> ids);

    interface Progress {
        String getGameId();
        Integer getSettlements();
    }

    /** Every live game, in lobby order (admin). */
    @Query("select g from GameEntity g" + LOBBY_ORDER)
    List<GameEntity> findAllInLobbyOrder();

    @Query("select g.status as status, count(g) as count from GameEntity g group by g.status")
    List<StatusCount> countByStatus();

    interface StatusCount {
        GameStatus getStatus();
        long getCount();
    }

    List<GameEntity> findByStatus(GameStatus status);
    List<GameEntity> findByStatusAndClosesAtBefore(GameStatus status, Instant time);
    List<GameEntity> findByStatusAndOpensAtBefore(GameStatus status, Instant time);

    /** Before writing: so the scheduler and player orders do not overwrite each other's state. */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select g from GameEntity g where g.id = :id")
    Optional<GameEntity> lockById(String id);
}
