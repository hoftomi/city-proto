package com.hof.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import com.hof.tronnelkul.common.DayCount;
import java.time.Instant;
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

    /** A live game's houses with their users' names, by Legitimacy. */
    @Query("select new com.hof.tronnelkul.game.model.PlayerUser(p, u.displayName) from PlayerEntity p left join AppUser u on u.id = p.userId"
        + " where p.gameId = :gameId order by p.legit desc, p.createdAt")
    List<PlayerUser> findHouses(String gameId);

    /** Houses of live games, split into human and NPC. */
    @Query("select p.npc as npc, count(p) as count from PlayerEntity p group by p.npc")
    List<NpcCount> countByNpc();

    interface NpcCount {
        boolean getNpc();
        long getCount();
    }

    /** Human houses of live and archived games created since `from`, per day in `zone`. */
    @Query(value = "select to_char(created_at at time zone :zone, 'YYYY-MM-DD') as day, count(*) as count from ("
        + " select created_at from players where not npc and created_at >= :from"
        + " union all select created_at from archived_players where not npc and created_at >= :from) j group by 1 order by 1", nativeQuery = true)
    List<DayCount> countJoinsPerDay(Instant from, String zone);

    List<PlayerEntity> findByGameId(String gameId);
    Optional<PlayerEntity> findByGameIdAndUserId(String gameId, UUID userId);
    long countByGameIdAndNpcFalse(String gameId);
    boolean existsByGameIdAndHouseNameIgnoreCase(String gameId, String houseName);
}
