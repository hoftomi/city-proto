package com.hof.tronnelkul.admin;

import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.game.engine.EngineState;
import com.hof.tronnelkul.game.engine.Time;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.service.GameRunner;
import com.hof.tronnelkul.game.service.Npcs;
import com.hof.tronnelkul.game.service.SeedData;
import com.hof.tronnelkul.game.world.MapRegistry;
import org.springframework.data.domain.Limit;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/** Admin: games live and archived, creating, seeding, details, reports, deleting, removing a house. */
@Service
public class AdminGameService {
    static final Pattern GAME_ID = Pattern.compile("[a-z0-9-]{3,40}");
    static final int NAME_MAX = 80, TAGS_MAX = 300, MAX_PLAYERS = 200;
    static final int DEFAULT_REPORTS = 100, MAX_REPORTS = 500;

    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final ReportRepository reportRepository;
    private final ArchivedGameRepository archivedGameRepository;
    private final ArchivedPlayerRepository archivedPlayerRepository;
    private final ArchivedReportRepository archivedReportRepository;
    private final GameRunner runner;
    private final SeedData seedData;
    private final AdminMapper adminMapper;

    public AdminGameService(GameRepository gameRepository, PlayerRepository playerRepository, ReportRepository reportRepository,
                            ArchivedGameRepository archivedGameRepository, ArchivedPlayerRepository archivedPlayerRepository,
                            ArchivedReportRepository archivedReportRepository, GameRunner runner, SeedData seedData, AdminMapper adminMapper) {
        this.gameRepository = gameRepository; this.playerRepository = playerRepository; this.reportRepository = reportRepository;
        this.archivedGameRepository = archivedGameRepository; this.archivedPlayerRepository = archivedPlayerRepository;
        this.archivedReportRepository = archivedReportRepository; this.runner = runner; this.seedData = seedData; this.adminMapper = adminMapper;
    }

    public List<AdminMap> maps() { return MapRegistry.all().stream().map(adminMapper::map).toList(); }

    /** Live games in lobby order, then the archived ones, newest first. */
    @Transactional(readOnly = true)
    public List<AdminGame> games() {
        return Stream.concat(live(gameRepository.findAllInLobbyOrder()).stream(), archived(archivedGameRepository.findAllByOrderByCreatedAtDesc()).stream()).toList();
    }

    private List<AdminGame> live(List<GameEntity> games) {
        if (games.isEmpty()) return List.of();
        Map<String, Long> humans = playerRepository.countHumans(games.stream().map(g -> g.id).toList()).stream()
            .collect(Collectors.toMap(PlayerRepository.Headcount::getGameId, PlayerRepository.Headcount::getHumans));
        List<String> running = games.stream().filter(g -> g.status == GameStatus.RUNNING).map(g -> g.id).toList();
        Map<String, Integer> settlements = running.isEmpty() ? Map.of() : gameRepository.findProgress(running).stream()
            .filter(p -> p.getSettlements() != null)
            .collect(Collectors.toMap(GameRepository.Progress::getGameId, GameRepository.Progress::getSettlements));
        Instant real = Instant.now();
        return games.stream().map(g -> {
            boolean run = g.status == GameStatus.RUNNING;
            return adminMapper.game(g, humans.getOrDefault(g.id, 0L).intValue(), run ? settlements.get(g.id) : null, run ? g.clock(real) : null);
        }).toList();
    }

    private List<AdminGame> archived(List<ArchivedGameEntity> games) {
        if (games.isEmpty()) return List.of();
        Map<String, ArchivedPlayerRepository.Headcount> heads = archivedPlayerRepository.countHouses(games.stream().map(g -> g.id).toList()).stream()
            .collect(Collectors.toMap(ArchivedPlayerRepository.Headcount::getGameId, h -> h));
        return games.stream().map(g -> {
            ArchivedPlayerRepository.Headcount h = heads.get(g.id);
            return adminMapper.game(g, h == null ? 0 : (int) h.getHumans(), h == null ? 0 : (int) h.getNpcs());
        }).toList();
    }

    @Transactional
    public AdminGame create(CreateGameRequest r) {
        GameEntity g = newGame(r, Instant.now());
        if (gameRepository.existsById(g.id) || archivedGameRepository.existsById(g.id)) throw ApiException.conflict("server.admin.game_id_taken");
        gameRepository.save(g);
        return adminMapper.game(g, 0, null, null);
    }

    /**
     * A validated new game (the id's uniqueness is checked against the database by the caller). Announced if it opens
     * in the future, otherwise open.
     */
    static GameEntity newGame(CreateGameRequest r, Instant now) {
        if (r.getId() == null || !GAME_ID.matcher(r.getId()).matches()) throw ApiException.badRequest("server.admin.game_id_invalid");
        String name = r.getName() == null ? "" : r.getName().strip();
        if (name.isEmpty()) throw ApiException.badRequest("server.admin.game_name_required");
        if (name.length() > NAME_MAX) throw ApiException.badRequest("server.admin.game_name_long", "max", NAME_MAX);
        if (!MapRegistry.exists(r.getMapId())) throw ApiException.badRequest("server.admin.map_unknown");
        if (r.getMaxPlayers() == null || r.getMaxPlayers() < 1 || r.getMaxPlayers() > MAX_PLAYERS)
            throw ApiException.badRequest("server.admin.max_players_range", "min", 1, "max", MAX_PLAYERS);
        if (r.getNpcCount() == null || r.getNpcCount() < 0 || r.getNpcCount() > Npcs.count())
            throw ApiException.badRequest("server.admin.npc_count_range", "max", Npcs.count());
        if (r.getOpensAt() != null && r.getClosesAt() != null && !r.getClosesAt().isAfter(r.getOpensAt()))
            throw ApiException.badRequest("server.admin.closes_before_opens");
        // Tags are stored comma separated
        String tags = r.getTags() == null ? "" : r.getTags().stream().filter(Objects::nonNull).map(t -> t.replace(',', ' ').strip())
            .filter(t -> !t.isEmpty()).collect(Collectors.joining(","));
        if (tags.length() > TAGS_MAX) throw ApiException.badRequest("server.admin.tags_long", "max", TAGS_MAX);
        GameStatus status = r.getOpensAt() != null && r.getOpensAt().isAfter(now) ? GameStatus.ANNOUNCED : GameStatus.OPEN;
        GameEntity g = new GameEntity(r.getId(), name, status, r.getMapId(), r.getMaxPlayers(), r.getNpcCount(), tags);
        g.opensAt = r.getOpensAt();
        g.closesAt = r.getClosesAt();
        return g;
    }

    /** Recreates the missing sample games (same code as the startup seeding). */
    public AdminResult seed() { return new AdminResult().created(seedData.seedMissing()); }

    @Transactional(readOnly = true)
    public AdminGameDetail detail(String id) {
        Optional<GameEntity> live = gameRepository.findById(id);
        if (live.isPresent()) {
            GameEntity g = live.get();
            EngineState s = g.status == GameStatus.RUNNING ? runner.read(g) : null;
            List<AdminHouse> houses = playerRepository.findHouses(id).stream()
                .map(h -> adminMapper.house(h.player(), h.userName(), s == null ? null : s.players.get(h.player().id.toString()))).toList();
            AdminGame game = adminMapper.game(g, (int) playerRepository.countByGameIdAndNpcFalse(id), s == null ? null : s.settlements, s == null ? null : g.now());
            return new AdminGameDetail(game, houses, kinds(reportRepository.countByKind(id)),
                s == null ? null : Instant.ofEpochMilli(Time.nextSettlement(s.clock)), s == null ? 0 : s.sheets.size());
        }
        ArchivedGameEntity a = archivedGameRepository.findById(id).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        List<AdminHouse> houses = archivedPlayerRepository.findHouses(id).stream().map(h -> adminMapper.house(h.player(), h.userName())).toList();
        AdminGame game = archived(List.of(a)).getFirst();
        return new AdminGameDetail(game, houses, kinds(archivedReportRepository.countByKind(id)), null, 0);
    }

    private static List<KindCount> kinds(List<ReportRepository.KindTotal> rows) {
        return rows.stream().map(k -> new KindCount(k.getKind(), Math.toIntExact(k.getCount()))).toList();
    }

    /** The latest `limit` reports (default 100, at most 500) of every house, newest first. */
    @Transactional(readOnly = true)
    public List<AdminReport> reports(String id, Integer limit) {
        Limit n = Limit.of(reportLimit(limit));
        if (gameRepository.existsById(id))
            return reportRepository.findLatest(id, n).stream().map(r -> adminMapper.report(r.report(), r.houseName())).toList();
        if (archivedGameRepository.existsById(id))
            return archivedReportRepository.findLatest(id, n).stream().map(r -> adminMapper.report(r.report(), r.houseName())).toList();
        throw ApiException.notFound("server.game_not_found");
    }

    static int reportLimit(Integer limit) { return limit == null ? DEFAULT_REPORTS : Math.clamp(limit, 1, MAX_REPORTS); }

    /** Deletes a live or archived game; its houses and reports go with it (on delete cascade). */
    @Transactional
    public void delete(String id) {
        Optional<GameEntity> live = gameRepository.lockById(id);
        if (live.isPresent()) { gameRepository.delete(live.get()); return; }
        if (!archivedGameRepository.existsById(id)) throw ApiException.notFound("server.game_not_found");
        archivedGameRepository.deleteById(id);
    }

    /** Removes a house before the start (announced or open game). */
    @Transactional
    public void removePlayer(String id, String playerId) {
        GameEntity g = gameRepository.lockById(id).orElseThrow(() -> archivedGameRepository.existsById(id)
            ? ApiException.conflict("server.admin.remove_player_started") : ApiException.notFound("server.game_not_found"));
        if (g.status != GameStatus.ANNOUNCED && g.status != GameStatus.OPEN) throw ApiException.conflict("server.admin.remove_player_started");
        PlayerEntity p = uuid(playerId).flatMap(playerRepository::findById).filter(x -> x.gameId.equals(id))
            .orElseThrow(() -> ApiException.notFound("server.admin.player_not_found"));
        playerRepository.delete(p);
    }

    static Optional<UUID> uuid(String s) {
        try {
            return Optional.of(UUID.fromString(s));
        } catch (IllegalArgumentException | NullPointerException e) {
            return Optional.empty();
        }
    }
}
