package com.hof.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ArchivedPlayerRepository extends JpaRepository<ArchivedPlayerEntity, UUID> {
    /** The finished games the user played in, newest first. */
    @Query("select new com.hof.tronnelkul.game.model.ArchivedPlayerGame(g, p) from ArchivedPlayerEntity p join ArchivedGameEntity g on g.id = p.gameId"
        + " where p.userId = :userId order by g.createdAt desc")
    List<ArchivedPlayerGame> findGamesOf(UUID userId);

    /** Human and NPC houses per finished game. */
    @Query("select p.gameId as gameId, sum(case when p.npc = false then 1 else 0 end) as humans, sum(case when p.npc = true then 1 else 0 end) as npcs"
        + " from ArchivedPlayerEntity p where p.gameId in :gameIds group by p.gameId")
    List<Headcount> countHouses(Collection<String> gameIds);

    interface Headcount {
        String getGameId();
        long getHumans();
        long getNpcs();
    }

    /** A finished game's houses with their users' names, by final place. */
    @Query("select new com.hof.tronnelkul.game.model.ArchivedPlayerUser(p, u.displayName) from ArchivedPlayerEntity p left join AppUser u on u.id = p.userId"
        + " where p.gameId = :gameId order by p.place, p.houseName")
    List<ArchivedPlayerUser> findHouses(String gameId);

    Optional<ArchivedPlayerEntity> findByGameIdAndUserId(String gameId, UUID userId);
    long countByGameIdAndNpcFalse(String gameId);
    long countByGameIdAndNpcTrue(String gameId);
}
