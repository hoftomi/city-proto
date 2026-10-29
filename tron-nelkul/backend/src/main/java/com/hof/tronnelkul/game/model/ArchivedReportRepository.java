package com.hof.tronnelkul.game.model;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface ArchivedReportRepository extends JpaRepository<ArchivedReportEntity, UUID> {}
