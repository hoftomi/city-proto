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
        if (games.isEmpty()) {
            return List.of();
        }
        Map<String, Long> humans = playerRepository.countHumans(games.stream().map(GameEntity::getId).toList()).stream()
            .collect(Collectors.toMap(PlayerRepository.Headcount::getGameId, PlayerRepository.Headcount::getHumans));
        List<String> running = games.stream().filter(game -> game.getStatus() == GameStatus.RUNNING).map(GameEntity::getId).toList();
        Map<String, Integer> settlements = running.isEmpty() ? Map.of() : gameRepository.findProgress(running).stream()
            .filter(progress -> progress.getSettlements() != null)
            .collect(Collectors.toMap(GameRepository.Progress::getGameId, GameRepository.Progress::getSettlements));
        Instant real = Instant.now();
        return games.stream().map(game -> {
            boolean run = game.getStatus() == GameStatus.RUNNING;
            return adminMapper.game(game, humans.getOrDefault(game.getId(), 0L).intValue(), run ? settlements.get(game.getId()) : null, run ? game.clock(real) : null);
        }).toList();
    }

    private List<AdminGame> archived(List<ArchivedGameEntity> games) {
        if (games.isEmpty()) {
            return List.of();
        }
        Map<String, ArchivedPlayerRepository.Headcount> heads = archivedPlayerRepository.countHouses(games.stream().map(ArchivedGameEntity::getId).toList()).stream()
            .collect(Collectors.toMap(ArchivedPlayerRepository.Headcount::getGameId, headcount -> headcount));
        return games.stream().map(game -> {
            ArchivedPlayerRepository.Headcount headcount = heads.get(game.getId());
            return adminMapper.game(game, headcount == null ? 0 : (int) headcount.getHumans(), headcount == null ? 0 : (int) headcount.getNpcs());
        }).toList();
    }

    @Transactional
    public AdminGame create(CreateGameRequest request) {
        GameEntity game = newGame(request, Instant.now());
        if (gameRepository.existsById(game.getId()) || archivedGameRepository.existsById(game.getId())) {
            throw ApiException.conflict("server.admin.game_id_taken");
        }
        gameRepository.save(game);
        return adminMapper.game(game, 0, null, null);
    }

    /**
     * A validated new game (the id's uniqueness is checked against the database by the caller). Announced if it opens
     * in the future, otherwise open.
     */
    static GameEntity newGame(CreateGameRequest request, Instant now) {
        if (request.getId() == null || !GAME_ID.matcher(request.getId()).matches()) {
            throw ApiException.badRequest("server.admin.game_id_invalid");
        }
        String name = request.getName() == null ? "" : request.getName().strip();
        if (name.isEmpty()) {
            throw ApiException.badRequest("server.admin.game_name_required");
        }
        if (name.length() > NAME_MAX) {
            throw ApiException.badRequest("server.admin.game_name_long", "max", NAME_MAX);
        }
        if (!MapRegistry.exists(request.getMapId())) {
            throw ApiException.badRequest("server.admin.map_unknown");
        }
        if (request.getMaxPlayers() == null || request.getMaxPlayers() < 1 || request.getMaxPlayers() > MAX_PLAYERS) {
            throw ApiException.badRequest("server.admin.max_players_range", "min", 1, "max", MAX_PLAYERS);
        }
        if (request.getNpcCount() == null || request.getNpcCount() < 0 || request.getNpcCount() > Npcs.count()) {
            throw ApiException.badRequest("server.admin.npc_count_range", "max", Npcs.count());
        }
        if (request.getOpensAt() != null && request.getClosesAt() != null && !request.getClosesAt().isAfter(request.getOpensAt())) {
            throw ApiException.badRequest("server.admin.closes_before_opens");
        }
        // Tags are stored comma separated
        String tags = request.getTags() == null ? "" : request.getTags().stream().filter(Objects::nonNull).map(tag -> tag.replace(',', ' ').strip())
            .filter(tag -> !tag.isEmpty()).collect(Collectors.joining(","));
        if (tags.length() > TAGS_MAX) {
            throw ApiException.badRequest("server.admin.tags_long", "max", TAGS_MAX);
        }
        GameStatus status = request.getOpensAt() != null && request.getOpensAt().isAfter(now) ? GameStatus.ANNOUNCED : GameStatus.OPEN;
        GameEntity game = new GameEntity(request.getId(), name, status, request.getMapId(), request.getMaxPlayers(), request.getNpcCount(), tags);
        game.setOpensAt(request.getOpensAt());
        game.setClosesAt(request.getClosesAt());
        return game;
    }

    /** Recreates the missing sample games (same code as the startup seeding). */
    public AdminResult seed() { return new AdminResult().created(seedData.seedMissing()); }

    @Transactional(readOnly = true)
    public AdminGameDetail detail(String id) {
        Optional<GameEntity> live = gameRepository.findById(id);
        if (live.isPresent()) {
            GameEntity liveGame = live.get();
            EngineState state = liveGame.getStatus() == GameStatus.RUNNING ? runner.read(liveGame) : null;
            List<AdminHouse> houses = playerRepository.findHouses(id).stream()
                .map(house -> adminMapper.house(house.player(), house.userName(), state == null ? null : state.players.get(house.player().getId().toString()))).toList();
            AdminGame game = adminMapper.game(liveGame, (int) playerRepository.countByGameIdAndNpcFalse(id), state == null ? null : state.settlements, state == null ? null : liveGame.now());
            return new AdminGameDetail(game, houses, kinds(reportRepository.countByKind(id)),
                state == null ? null : Instant.ofEpochMilli(Time.nextSettlement(state.clock)), state == null ? 0 : state.sheets.size());
        }
        ArchivedGameEntity archivedGame = archivedGameRepository.findById(id).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        List<AdminHouse> houses = archivedPlayerRepository.findHouses(id).stream().map(house -> adminMapper.house(house.player(), house.userName())).toList();
        AdminGame game = archived(List.of(archivedGame)).getFirst();
        return new AdminGameDetail(game, houses, kinds(archivedReportRepository.countByKind(id)), null, 0);
    }

    private static List<KindCount> kinds(List<ReportRepository.KindTotal> rows) {
        return rows.stream().map(total -> new KindCount(total.getKind(), Math.toIntExact(total.getCount()))).toList();
    }

    /** The latest `limit` reports (default 100, at most 500) of every house, newest first. */
    @Transactional(readOnly = true)
    public List<AdminReport> reports(String id, Integer limit) {
        Limit pageLimit = Limit.of(reportLimit(limit));
        if (gameRepository.existsById(id)) {
            return reportRepository.findLatest(id, pageLimit).stream().map(row -> adminMapper.report(row.report(), row.houseName())).toList();
        }
        if (archivedGameRepository.existsById(id)) {
            return archivedReportRepository.findLatest(id, pageLimit).stream().map(row -> adminMapper.report(row.report(), row.houseName())).toList();
        }
        throw ApiException.notFound("server.game_not_found");
    }

    static int reportLimit(Integer limit) { return limit == null ? DEFAULT_REPORTS : Math.clamp(limit, 1, MAX_REPORTS); }

    /** Deletes a live or archived game; its houses and reports go with it (on delete cascade). */
    @Transactional
    public void delete(String id) {
        Optional<GameEntity> live = gameRepository.lockById(id);
        if (live.isPresent()) { gameRepository.delete(live.get()); return; }
        if (!archivedGameRepository.existsById(id)) {
            throw ApiException.notFound("server.game_not_found");
        }
        archivedGameRepository.deleteById(id);
    }

    /** Removes a house before the start (announced or open game). */
    @Transactional
    public void removePlayer(String id, String playerId) {
        GameEntity game = gameRepository.lockById(id).orElseThrow(() -> archivedGameRepository.existsById(id)
            ? ApiException.conflict("server.admin.remove_player_started") : ApiException.notFound("server.game_not_found"));
        if (game.getStatus() != GameStatus.ANNOUNCED && game.getStatus() != GameStatus.OPEN) {
            throw ApiException.conflict("server.admin.remove_player_started");
        }
        PlayerEntity player = uuid(playerId).flatMap(playerRepository::findById).filter(candidate -> candidate.getGameId().equals(id))
            .orElseThrow(() -> ApiException.notFound("server.admin.player_not_found"));
        playerRepository.delete(player);
    }

    static Optional<UUID> uuid(String value) {
        try {
            return Optional.of(UUID.fromString(value));
        } catch (IllegalArgumentException | NullPointerException ex) {
            return Optional.empty();
        }
    }
}
