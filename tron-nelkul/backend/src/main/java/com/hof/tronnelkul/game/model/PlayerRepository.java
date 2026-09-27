package com.hof.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PlayerRepository extends JpaRepository<PlayerEntity, UUID> {
    List<PlayerEntity> findByGameId(String gameId);
    List<PlayerEntity> findByUserId(UUID userId);
    Optional<PlayerEntity> findByGameIdAndUserId(String gameId, UUID userId);
    long countByGameIdAndNpcFalse(String gameId);
    boolean existsByGameIdAndHouseNameIgnoreCase(String gameId, String houseName);
    boolean existsByGameIdAndTincture(String gameId, String tincture);
}
