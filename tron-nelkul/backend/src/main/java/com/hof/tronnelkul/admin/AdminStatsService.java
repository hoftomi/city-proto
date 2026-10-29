package com.hof.tronnelkul.admin;

import com.hof.tronnelkul.api.model.AdminOverview;
import com.hof.tronnelkul.api.model.DailyCount;
import com.hof.tronnelkul.common.DayCount;
import com.hof.tronnelkul.game.engine.Time;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.user.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/** Admin dashboard figures, from aggregate queries. */
@Service
public class AdminStatsService {
    /** Days of the registration and join charts. */
    static final int DAYS = 14;
    static final ZoneId ZONE = Time.ZONE;

    private final UserRepository userRepository;
    private final GameRepository gameRepository;
    private final ArchivedGameRepository archivedGameRepository;
    private final PlayerRepository playerRepository;
    private final ReportRepository reportRepository;
    private final ArchivedReportRepository archivedReportRepository;

    public AdminStatsService(UserRepository userRepository, GameRepository gameRepository, ArchivedGameRepository archivedGameRepository,
                             PlayerRepository playerRepository, ReportRepository reportRepository, ArchivedReportRepository archivedReportRepository) {
        this.userRepository = userRepository; this.gameRepository = gameRepository; this.archivedGameRepository = archivedGameRepository;
        this.playerRepository = playerRepository; this.reportRepository = reportRepository; this.archivedReportRepository = archivedReportRepository;
    }

    @Transactional(readOnly = true)
    public AdminOverview overview() {
        Instant now = Instant.now();
        LocalDate today = LocalDate.ofInstant(now, ZONE);
        Instant from = firstDay(today).atStartOfDay(ZONE).toInstant();
        Map<GameStatus, Long> byStatus = gameRepository.countByStatus().stream()
            .collect(Collectors.toMap(GameRepository.StatusCount::getStatus, GameRepository.StatusCount::getCount));
        Map<Boolean, Long> houses = playerRepository.countByNpc().stream()
            .collect(Collectors.toMap(PlayerRepository.NpcCount::getNpc, PlayerRepository.NpcCount::getCount));
        Instant dayAgo = now.minus(Duration.ofHours(24));
        return new AdminOverview()
            .users(Math.toIntExact(userRepository.count()))
            .admins(Math.toIntExact(userRepository.countByRole(AdminUserService.ADMIN)))
            .newUsers7d(Math.toIntExact(userRepository.countByCreatedAtGreaterThanEqual(now.minus(Duration.ofDays(7)))))
            .announced(byStatus.getOrDefault(GameStatus.ANNOUNCED, 0L).intValue())
            .open(byStatus.getOrDefault(GameStatus.OPEN, 0L).intValue())
            .running(byStatus.getOrDefault(GameStatus.RUNNING, 0L).intValue())
            .finished(Math.toIntExact(archivedGameRepository.count()))
            .humanHouses(houses.getOrDefault(false, 0L).intValue())
            .npcHouses(houses.getOrDefault(true, 0L).intValue())
            .reports24h(Math.toIntExact(reportRepository.countByCreatedAtAfter(dayAgo) + archivedReportRepository.countByCreatedAtAfter(dayAgo)))
            .registrations(fillDays(today, userRepository.countRegistrationsPerDay(from, ZONE.getId())))
            .joins(fillDays(today, playerRepository.countJoinsPerDay(from, ZONE.getId())));
    }

    static LocalDate firstDay(LocalDate today) { return today.minusDays(DAYS - 1); }

    /** One entry for each of the last DAYS days up to today, oldest first; days without a row count 0. */
    static List<DailyCount> fillDays(LocalDate today, List<DayCount> rows) {
        Map<LocalDate, Long> counts = rows.stream().collect(Collectors.toMap(row -> LocalDate.parse(row.getDay()), DayCount::getCount, Long::sum));
        List<DailyCount> out = new ArrayList<>(DAYS);
        for (LocalDate day = firstDay(today); !day.isAfter(today); day = day.plusDays(1)) {
            out.add(new DailyCount(day, counts.getOrDefault(day, 0L).intValue()));
        }
        return out;
    }
}
