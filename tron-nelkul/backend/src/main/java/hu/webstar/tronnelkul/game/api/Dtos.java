package hu.webstar.tronnelkul.game.api;

import java.time.Instant;
import java.util.List;

/** Az API válaszai és kérései. A mobil kliens `lib/api/models.dart` fájlja ezeket tükrözi. */
public final class Dtos {
    private Dtos() {}

    // ---------- Lobbi ----------
    public record MyHouse(String playerId, String houseName, String tincture, String background, String backgroundName, String startSlot) {}

    public record GameSummary(String id, String name, String season, String status, String mapId, Instant startsAt, Instant opensAt,
                              int days, int roundsPerDay, int round, int maxRounds, int players, int maxPlayers, int cities, int npcCount,
                              List<String> tags, String winner, Integer myPlace, MyHouse myHouse) {}

    public record StartSlotDto(String id, String name, int x, int y, List<String> neighbors, List<String> neighborNames, String note) {}

    public record GameDetail(GameSummary game, List<StartSlotDto> starts, List<BackgroundDto> backgrounds, List<String> tinctures) {}

    public record BackgroundDto(String id, String name, String icon, List<String> perks) {}

    public record JoinRequest(String houseName, String tincture, String background, String startSlot) {}

    // ---------- Játékállapot ----------
    public record Cost(int pp, int arany, int bp, int ke) {}

    public record Me(String playerId, String houseName, String tincture, String background, String estate, int pp, int ppMax,
                     int arany, int bp, int ke, int legit, boolean sealed) {}

    public record Segment(String playerId, String name, String tincture, double value, String label, boolean self, boolean npc) {}

    public record Rival(String playerId, String name) {}

    public record FactionView(String faction, String level, String precision, List<Segment> segments, double unknown, String unknownLabel,
                              double ownHidden, double neutral, int suspicion, String dominantTincture, String contestedTincture,
                              List<Rival> rivals) {}

    public record CityView(String id, String name, String stability, String reach, Integer distance, String bestLevel,
                           int decayPercent, List<FactionView> factions) {}

    public record RouteView(String from, String to, String state) {}

    public record Buildable(String from, String to, String fromName, String toName) {}

    public record OrderView(String id, String type, String label, String cityLabel, String faction, boolean hidden, String targetName, Cost cost) {}

    public record ActionInfo(String id, String label, List<String> factions, double power, boolean needsPresence, Cost cost, Cost hiddenCost) {}

    public record GameState(String gameId, String gameName, String mapId, String status, int round, int maxRounds, Instant nextResolutionAt,
                            Me me, Cost pending, List<RouteView> routes, List<Buildable> buildable, List<CityView> cities,
                            List<OrderView> orders, List<ActionInfo> actions) {}

    public record OrderRequest(String type, String city, String faction, Boolean hidden, String targetId, String from, String to) {}

    public record ReportView(String id, int round, String kind, String confidence, String title, String text, String tone, Instant createdAt) {}

    public record RankRow(int rank, String playerId, String name, String tincture, boolean npc, int legit, boolean self) {}
}
