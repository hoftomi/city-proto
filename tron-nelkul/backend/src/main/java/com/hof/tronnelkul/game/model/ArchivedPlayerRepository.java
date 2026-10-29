package com.hof.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ArchivedPlayerRepository extends JpaRepository<ArchivedPlayerEntity, UUID> {
    /** The finished games the user played in, newest first. */
    @Query("select new com.hof.tronnelkul.game.model.ArchivedPlayerGame(g, p) from ArchivedPlayerEntity p join ArchivedGameEntity g on g.id = p.gameId"
        + " where p.userId = :userId order by g.createdAt desc")
    List<ArchivedPlayerGame> findGamesOf(UUID userId);

    Optional<ArchivedPlayerEntity> findByGameIdAndUserId(String gameId, UUID userId);
    long countByGameIdAndNpcFalse(String gameId);
    long countByGameIdAndNpcTrue(String gameId);
}
