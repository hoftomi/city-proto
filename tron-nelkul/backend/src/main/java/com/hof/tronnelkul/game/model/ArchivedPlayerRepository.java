package com.hof.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ArchivedPlayerRepository extends JpaRepository<ArchivedPlayerEntity, UUID> {
    List<ArchivedPlayerEntity> findByGameId(String gameId);
    Optional<ArchivedPlayerEntity> findByGameIdAndUserId(String gameId, UUID userId);
    long countByGameIdAndNpcFalse(String gameId);
    long countByGameIdAndNpcTrue(String gameId);
}
