package com.hof.tronnelkul.admin;

import com.hof.tronnelkul.api.model.DailyCount;
import com.hof.tronnelkul.common.DayCount;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class AdminStatsServiceTest {
    record Row(String getDay, long getCount) implements DayCount {}

    @Test
    void fillsMissingDaysOldestFirst() {
        LocalDate today = LocalDate.of(2026, 3, 30); // DST change on 03-29 in Budapest
        List<DailyCount> days = AdminStatsService.fillDays(today, List.of(new Row("2026-03-17", 2), new Row("2026-03-29", 5), new Row("2026-03-30", 1)));
        assertEquals(14, days.size());
        assertEquals(LocalDate.of(2026, 3, 17), days.getFirst().getDate());
        assertEquals(today, days.getLast().getDate());
        for (int i = 1; i < days.size(); i++) assertEquals(days.get(i - 1).getDate().plusDays(1), days.get(i).getDate());
        assertEquals(2, days.getFirst().getCount());
        assertEquals(5, days.get(12).getCount());
        assertEquals(1, days.getLast().getCount());
        assertEquals(8, days.stream().mapToInt(DailyCount::getCount).sum());
    }

    @Test
    void emptyIsAllZero() {
        List<DailyCount> days = AdminStatsService.fillDays(LocalDate.of(2026, 1, 5), List.of());
        assertEquals(14, days.size());
        assertEquals(LocalDate.of(2025, 12, 23), days.getFirst().getDate());
        assertTrue(days.stream().allMatch(d -> d.getCount() == 0));
    }
}
