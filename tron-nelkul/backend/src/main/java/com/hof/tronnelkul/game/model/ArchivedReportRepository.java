package com.hof.tronnelkul.game.model;

import org.springframework.data.domain.Limit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public interface ArchivedReportRepository extends JpaRepository<ArchivedReportEntity, UUID> {
    long countByCreatedAtAfter(Instant time);

    /** The latest reports of every house of a finished game, newest first. */
    @Query("select new com.hof.tronnelkul.game.model.ArchivedReportHouse(r, p.houseName) from ArchivedReportEntity r join ArchivedPlayerEntity p on p.id = r.playerId"
        + " where r.gameId = :gameId order by r.createdAt desc, r.id desc")
    List<ArchivedReportHouse> findLatest(String gameId, Limit limit);

    @Query("select r.kind as kind, count(r) as count from ArchivedReportEntity r where r.gameId = :gameId group by r.kind order by r.kind")
    List<ReportRepository.KindTotal> countByKind(String gameId);
}
