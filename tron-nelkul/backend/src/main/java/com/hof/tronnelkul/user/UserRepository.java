package com.hof.tronnelkul.user;

import com.hof.tronnelkul.common.DayCount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

public interface UserRepository extends JpaRepository<AppUser, UUID> {
    List<AppUser> findAllByOrderByCreatedAtDesc();
    long countByRole(String role);
    long countByCreatedAtGreaterThanEqual(Instant time);

    /** Registrations since `from`, per day in `zone`. */
    @Query(value = "select to_char(created_at at time zone :zone, 'YYYY-MM-DD') as day, count(*) as count from users"
        + " where created_at >= :from group by 1 order by 1", nativeQuery = true)
    List<DayCount> countRegistrationsPerDay(Instant from, String zone);

    /** Live and archived games joined, per user (users without a game are missing). */
    @Query(value = "select user_id as userId, count(*) as games from ("
        + " select user_id from players where user_id in (:userIds)"
        + " union all select user_id from archived_players where user_id in (:userIds)) j group by user_id", nativeQuery = true)
    List<GameCount> countGames(Collection<UUID> userIds);

    interface GameCount {
        UUID getUserId();
        long getGames();
    }
}
