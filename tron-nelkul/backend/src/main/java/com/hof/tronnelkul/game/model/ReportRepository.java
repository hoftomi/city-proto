package com.hof.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface ReportRepository extends JpaRepository<ReportEntity, UUID> {
    List<ReportEntity> findTop100ByGameIdAndPlayerIdOrderByCreatedAtDesc(String gameId, UUID playerId);
}
