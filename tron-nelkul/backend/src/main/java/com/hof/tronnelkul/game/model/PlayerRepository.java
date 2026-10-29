package com.hof.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PlayerRepository extends JpaRepository<PlayerEntity, UUID> {
    /** The user's houses with their live games, in lobby order. */
    @Query("select new com.hof.tronnelkul.game.model.PlayerGame(g, p) from PlayerEntity p join GameEntity g on g.id = p.gameId"
        + " where p.userId = :userId" + GameRepository.LOBBY_ORDER)
    List<PlayerGame> findGamesOf(UUID userId);

    /** Human houses per game. */
    @Query("select p.gameId as gameId, count(p) as humans from PlayerEntity p where p.npc = false and p.gameId in :gameIds group by p.gameId")
    List<Headcount> countHumans(Collection<String> gameIds);

    interface Headcount {
        String getGameId();
        long getHumans();
    }

    List<PlayerEntity> findByGameId(String gameId);
    Optional<PlayerEntity> findByGameIdAndUserId(String gameId, UUID userId);
    long countByGameIdAndNpcFalse(String gameId);
    boolean existsByGameIdAndHouseNameIgnoreCase(String gameId, String houseName);
    boolean existsByGameIdAndTincture(String gameId, String tincture);
}
