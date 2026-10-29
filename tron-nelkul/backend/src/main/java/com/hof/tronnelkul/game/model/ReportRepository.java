package com.hof.tronnelkul.game.model;

import org.springframework.data.domain.Limit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public interface ReportRepository extends JpaRepository<ReportEntity, UUID> {
    List<ReportEntity> findByGameId(String gameId);
    List<ReportEntity> findTop100ByGameIdAndPlayerIdOrderByCreatedAtDesc(String gameId, UUID playerId);
    long countByCreatedAtAfter(Instant time);

    /** The latest reports of every house of a game, newest first. */
    @Query("select new com.hof.tronnelkul.game.model.ReportHouse(r, p.houseName) from ReportEntity r join PlayerEntity p on p.id = r.playerId"
        + " where r.gameId = :gameId order by r.createdAt desc, r.id desc")
    List<ReportHouse> findLatest(String gameId, Limit limit);

    @Query("select r.kind as kind, count(r) as count from ReportEntity r where r.gameId = :gameId group by r.kind order by r.kind")
    List<KindTotal> countByKind(String gameId);

    interface KindTotal {
        String getKind();
        long getCount();
    }
}
