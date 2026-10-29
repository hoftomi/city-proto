package com.hof.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ArchivedGameRepository extends JpaRepository<ArchivedGameEntity, String> {
    List<ArchivedGameEntity> findAllByOrderByCreatedAtDesc();
}
