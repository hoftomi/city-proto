package com.hof.tronnelkul.game.mapper;

import com.hof.tronnelkul.api.model.ReportView;
import com.hof.tronnelkul.game.model.ReportEntity;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;

import java.time.Instant;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

class ReportMapperTest {
    final ReportMapper mapper = Mappers.getMapper(ReportMapper.class);

    @Test
    void view() {
        Instant at = Instant.parse("2026-11-01T08:00:00Z");
        ReportEntity report = new ReportEntity("g1", UUID.randomUUID(), 4, "market", "weak", "Title", "Body", "warn", true, at);
        report.setId(UUID.randomUUID());
        ReportView view = mapper.view(report);
        assertEquals(report.getId().toString(), view.getId());
        assertEquals(4, view.getRound());
        assertEquals("market", view.getKind());
        assertEquals("weak", view.getConfidence());
        assertEquals("Title", view.getTitle());
        assertEquals("Body", view.getText());
        assertEquals("warn", view.getTone());
        assertTrue(view.getIsPublic());
        assertEquals(at, view.getCreatedAt());
        report.setPublic(false);
        assertFalse(mapper.view(report).getIsPublic());
    }
}
