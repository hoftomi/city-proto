package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.game.engine.*;
import com.hof.tronnelkul.game.engine.EngineState.*;
import com.hof.tronnelkul.game.engine.Rules.*;
import com.hof.tronnelkul.game.mapper.ReportMapper;
import com.hof.tronnelkul.game.model.*;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.world.GoodDef;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.i18n.Messages;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.*;

/**
 * The player's view (rulebook v0.2). Public: sellers' names, shares and margins (5.2), popularity,
 * parties, council and news. Hidden: others' orders (only via scouting), and others' spy counts (rumour only).
 * Display texts are resolved here (i18n.Messages).
 */
@Service
public class GameViewService {
    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final ReportRepository reportRepository;
    private final GameRunner runner;
    private final Messages messages;
    private final ReportMapper reportMapper;
    private final Catalog catalog;

    public GameViewService(GameRepository gameRepository, PlayerRepository playerRepository, ReportRepository reportRepository, GameRunner runner, Messages messages,
                           ReportMapper reportMapper) {
        this.gameRepository = gameRepository; this.playerRepository = playerRepository; this.reportRepository = reportRepository; this.runner = runner; this.messages = messages;
        this.reportMapper = reportMapper;
        this.catalog = catalog(messages);
    }

    /** Action, margin, program and news template catalog; labels from i18n catalog.*. */
    static Catalog catalog(Messages messages) {
        return new Catalog(
        Arrays.stream(Action.values()).map(action -> new ActionInfo(action.id, messages.text(action.label()), action.branch, action.pp, action.gold)).toList(),
        Arrays.stream(Margin.values()).map(margin -> new LevelInfo(margin.id, messages.text(margin.label()), (int) Math.round(margin.rate * 100), margin.pop)).toList(),
        Arrays.stream(Program.values()).map(program -> new LevelInfo(program.id, messages.text(program.label()), (int) Math.round(program.rate * 100), program.pop)).toList(),
        Arrays.stream(NewsTemplate.values()).map(template -> new NewsTemplateInfo(template.id, messages.text(template.labelKey()), template.effect, template.needsGood)).toList(),
        new RulesInfo(Rules.BASE_PRICE, Rules.CITY_SHARE_COST, Rules.MAX_SHARES_PER_ORDER, (int) Math.round(Rules.BUYOUT_PREMIUM * 100),
            Rules.PARTY_COST, Rules.FESTIVAL_GOLD, (int) Rules.FESTIVAL_POP, Rules.NEWS_GOLD, Rules.SPY_COST, Rules.SPY_UPKEEP,
            Rules.SPIES_PER_CITY, (int) Math.round(Rules.GUARD_CHANCE * 100), (int) Rules.DEBUNK_REWARD_POP, Rules.DEBUNK_REWARD_GOLD,
            Rules.DEBUNK_REWARD_LEGIT, Rules.ROUTE_COST, Rules.ROUTE_UPKEEP, Rules.COUNCIL_SEATS, Rules.INFO_PRICE));
    }

    /** Runs the events due by now first. A finished game is already in the archive, hence 404. */
    public GameState state(String gameId, UUID userId) {
        GameEntity game = gameRepository.findById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        PlayerEntity player = playerRepository.findByGameIdAndUserId(game.getId(), userId).orElseThrow(() -> ApiException.forbidden("server.not_a_member"));
        if (game.getStatus() == GameStatus.OPEN || game.getStatus() == GameStatus.ANNOUNCED) {
            throw ApiException.conflict("server.game_not_started");
        }
        String me = player.getId().toString();
        return runner.mutate(gameId, (lockedGame, engine) -> build(lockedGame, engine, me));
    }

    GameState build(GameEntity game, Engine engine, String me) {
        EngineState state = engine.state;
        MapDefinition map = engine.map;
        PlayerSt ps = state.players.get(me);
        if (ps == null) {
            throw ApiException.conflict("server.house_not_in_game");
        }
        Map<String, Integer> net = engine.network(me);
        java.util.function.Function<String, HouseRef> ref = id -> {
            PlayerSt house = state.players.get(id);
            return house == null ? null : new HouseRef(id, house.name, house.npc, id.equals(me));
        };

        // Routes: own ones and those on the draft or the maturing sheet
        List<Order> mine = new ArrayList<>(state.draftOf(me));
        state.sheetOf(me).ifPresent(sheet -> mine.addAll(sheet.orders));
        List<RouteView> routes = new ArrayList<>();
        state.routesOf(me).forEach(route -> routes.add(new RouteView(route.from(), route.to(), "own")));
        mine.stream().filter(order -> "route".equals(order.type)).forEach(order -> routes.add(new RouteView(order.from, order.to, "pending")));
        List<Buildable> buildable = new ArrayList<>();
        for (List<String> edge : map.allEdges()) {
            String first = edge.get(0), second = edge.get(1);
            if (routes.stream().anyMatch(route -> (route.getFrom().equals(first) && route.getTo().equals(second)) || (route.getFrom().equals(second) && route.getTo().equals(first)))) {
                continue;
            }
            String from = net.containsKey(first) ? first : net.containsKey(second) ? second : null;
            if (from == null) {
                continue;
            }
            String to = from.equals(first) ? second : first;
            if (!map.isCity(to) || net.containsKey(to)) {
                continue;
            }
            buildable.add(new Buildable(from, to, messages.resolve(map.nodeName(from)), messages.resolve(map.nodeName(to))));
        }

        List<CityView> cities = new ArrayList<>();
        for (CityDef cd : map.cities()) {
            cities.add(cityView(engine, cd, me, net, ref));
        }

        List<OrderView> draft = state.draftOf(me).stream().map(order -> orderView(engine, me, order, true)).toList();
        Engine.Cost draftCost = engine.draftCost(me);
        SheetView sheet = state.sheetOf(me).map(ownSheet -> new SheetView(ownSheet.id, Instant.ofEpochMilli(ownSheet.sealedAt), Instant.ofEpochMilli(ownSheet.executeAt),
            ownSheet.orders.stream().map(order -> orderView(engine, me, order, false)).toList(), new Cost(ownSheet.pp, ownSheet.gold))).orElse(null);
        List<RivalSheet> rivalSheets = state.sheets.stream().filter(rival -> !rival.player.equals(me)).sorted(Comparator.comparingLong(rival -> rival.executeAt))
            .map(rival -> new RivalSheet(ref.apply(rival.player), Instant.ofEpochMilli(rival.executeAt))).toList();

        Set<String> defending = new HashSet<>();
        mine.stream().filter(order -> "defend".equals(order.type)).forEach(order -> defending.add(order.orderId));
        List<Threat> threats = new ArrayList<>();
        for (Sheet rivalSheet : state.sheets) {
            if (rivalSheet.player.equals(me)) {
                continue;
            }
            for (Order order : rivalSheet.orders) {
                if (!"buyout".equals(order.type) || !me.equals(order.target)) {
                    continue;
                }
                Order defense = new Order();
                defense.type = "defend"; defense.city = order.city; defense.sheetId = rivalSheet.id; defense.orderId = order.id;
                Good good = state.cities.get(order.city).goods.get(order.good);
                threats.add(new Threat(rivalSheet.id, order.id, ref.apply(rivalSheet.player), order.city, messages.resolve(map.nodeName(order.city)), order.good,
                    good == null ? order.good : messages.text(GoodDef.label(order.good)), order.pts,
                    Instant.ofEpochMilli(rivalSheet.executeAt), engine.cost(me, defense).gold(), defending.contains(order.id)));
            }
        }

        List<IntelView> intel = state.intel.stream().filter(item -> item.owner.equals(me)).limit(12)
            .map(item -> new IntelView(item.id, ref.apply(item.of), Instant.ofEpochMilli(item.executeAt), engine.intelLines(item).stream().map(messages::text).toList(),
                item.depth, engine.sheet(item.sheetId).isPresent(), item.offeredTo.stream().map(buyer -> messages.resolve(engine.name(buyer))).toList(), item.bought)).toList();
        List<OfferView> offers = new ArrayList<>();
        for (Offer offer : state.offers) {
            if (!offer.buyer.equals(me)) {
                continue;
            }
            state.intel.stream().filter(item -> item.id.equals(offer.intelId)).findFirst()
                .ifPresent(item -> offers.add(new OfferView(offer.id, ref.apply(offer.seller), ref.apply(item.of), offer.price, Instant.ofEpochMilli(item.executeAt))));
        }
        List<HouseRef> houses = state.players.keySet().stream().map(ref).toList();

        ClockView clock = new ClockView(Instant.ofEpochMilli(state.clock), Instant.ofEpochMilli(Time.nextSettlement(state.clock)), state.settlements,
            GameEntity.maxSettlements(), engine.nextElectionIn(), engine.isCampaign(), GameEntity.MATURATION_MINUTES);
        Me meDto = new Me(me, ps.name, ps.background, ps.estate, ps.pp, Rules.PP_MAX, Math.round(ps.gold * 10) / 10.0, ps.legit);
        return new GameState(game.getId(), game.getName(), game.getMapId(), game.getStatus().apiId, clock, meDto, routes, buildable, cities, draft,
            new Cost(draftCost.pp(), draftCost.gold()), sheet, rivalSheets, threats, intel, offers, houses, catalog);
    }

    private CityView cityView(Engine engine, CityDef cd, String me, Map<String, Integer> net, java.util.function.Function<String, HouseRef> ref) {
        EngineState state = engine.state;
        CitySt cs = state.cities.get(cd.id());
        String city = cd.id();
        List<GoodView> goods = new ArrayList<>();
        for (var goodEntry : cs.goods.entrySet()) {
            Good good = goodEntry.getValue();
            // Only who holds how much: the other houses' margins and sales stay secret.
            List<Seller> sellers = new ArrayList<>();
            good.shares.entrySet().stream().filter(entry -> entry.getValue() > 0).sorted(Map.Entry.<String, Integer>comparingByValue().reversed()).forEach(entry ->
                sellers.add(new Seller(ref.apply(entry.getKey()), false, entry.getValue(), engine.isProtected(city, goodEntry.getKey(), entry.getKey()))));
            int cityPts = Engine.cityShare(good);
            if (cityPts > 0) {
                sellers.add(new Seller(null, true, cityPts, false));
            }
            goods.add(new GoodView(goodEntry.getKey(), messages.text(GoodDef.label(goodEntry.getKey())), good.supply, good.demand, cityPts, Engine.marketValue(good), good.shares.getOrDefault(me, 0),
                good.shares.containsKey(me) ? good.margins.getOrDefault(me, Margin.MARKET.id) : null, sellers));
        }
        List<PopRow> pop = cs.pop.entrySet().stream().sorted(Map.Entry.<String, Double>comparingByValue().reversed())
            .map(entry -> new PopRow(ref.apply(entry.getKey()), entry.getValue())).filter(row -> row.getHouse() != null).toList();
        List<PartyView> parties = cs.parties.entrySet().stream()
            .map(entry -> new PartyView(ref.apply(entry.getKey()), entry.getValue(), (int) Math.round(engine.popOf(city, entry.getKey())), cs.council.getOrDefault(entry.getKey(), 0)))
            .sorted(Comparator.comparingInt(PartyView::getVotes).reversed()).toList();
        List<HouseRef> foreignSpies = cs.spies.entrySet().stream().filter(entry -> !entry.getKey().equals(me) && entry.getValue() > 0).map(entry -> ref.apply(entry.getKey())).toList();
        Set<String> presentIds = new LinkedHashSet<>(cs.pop.keySet());
        presentIds.addAll(cs.parties.keySet());
        cs.goods.values().forEach(good -> good.shares.forEach((player, pts) -> {
            if (pts > 0) {
                presentIds.add(player);
            }
        }));
        presentIds.remove(me);
        List<HouseRef> present = presentIds.stream().map(ref).filter(Objects::nonNull).toList();
        PlayerSt ps = state.players.get(me);
        List<NewsView> news = state.news.stream().filter(story -> story.city.equals(city)).limit(8)
            .map(story -> new NewsView(story.id, messages.text(engine.newsText(story)), story.template, story.effect, ref.apply(story.author), ref.apply(story.target), Instant.ofEpochMilli(story.createdAt),
                story.debunked, ps.verified.get(story.id), story.author.equals(me))).toList();
        Integer dist = net.get(city);
        return new CityView(city, messages.text(cd.label()), messages.text(cd.desc()), cd.key(), cd.coast(), dist != null ? "reachable" : "unreachable", dist,
            engine.popOf(city, me), Math.round(engine.taxRate(city) * 1000) / 1000.0, cs.lastTaxPool, Rules.COUNCIL_SEATS, engine.expectedIncome(city, me), goods, pop, parties,
            cs.parties.get(me), cs.spies.getOrDefault(me, 0), cs.guards.getOrDefault(me, 0), foreignSpies, present, news);
    }

    /** View of an own order. On the draft it warns if the order would not run now, or the news is false (6.5). */
    private OrderView orderView(Engine engine, String me, Order order, boolean draft) {
        Action action = Action.of(order.type);
        Msg warning = null;
        if (draft) {
            warning = engine.validate(me, order);
            if (warning == null && action == Action.NEWS && !engine.newsTruth(order.city, order.template, order.target, order.good)) {
                warning = Msg.of("server.news_untrue");
            }
        }
        return new OrderView(order.id, order.type, action.branch, messages.text(engine.orderLabel(order, 2)), order.city, order.city == null ? null : messages.resolve(engine.cityName(order.city)),
            action == Action.MARGIN ? order.good : null, action == Action.MARGIN ? order.level : null,
            new Cost(action.pp, order.gold), warning == null ? null : messages.text(warning));
    }

    @Transactional(readOnly = true)
    public List<ReportView> reports(String gameId, UUID userId) {
        GameEntity game = gameRepository.findById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        PlayerEntity player = playerRepository.findByGameIdAndUserId(game.getId(), userId).orElseThrow(() -> ApiException.forbidden("server.not_a_member"));
        return reportRepository.findTop100ByGameIdAndPlayerIdOrderByCreatedAtDesc(game.getId(), player.getId()).stream()
            .map(reportMapper::view).toList();
    }

    @Transactional(readOnly = true)
    public List<RankRow> ranking(String gameId, UUID userId) {
        GameEntity game = gameRepository.findById(gameId).orElseThrow(() -> ApiException.notFound("server.game_not_found"));
        String me = playerRepository.findByGameIdAndUserId(game.getId(), userId).map(player -> player.getId().toString()).orElse(null);
        if (game.getState() == null) {
            List<PlayerEntity> all = new ArrayList<>(playerRepository.findByGameId(game.getId()));
            all.sort(Comparator.comparing(player -> player.getHouseName()));
            List<RankRow> out = new ArrayList<>();
            for (int index = 0; index < all.size(); index++) {
                PlayerEntity player = all.get(index);
                out.add(new RankRow(index + 1, player.getId().toString(), player.getHouseName(), player.isNpc(), 0, 0, 0, player.getId().toString().equals(me)));
            }
            return out;
        }
        EngineState state = runner.read(game);
        List<PlayerSt> all = new ArrayList<>(state.players.values());
        all.sort(Comparator.comparingInt((PlayerSt player) -> player.legit).reversed().thenComparing(player -> player.name));
        List<RankRow> out = new ArrayList<>();
        for (int index = 0; index < all.size(); index++) {
            PlayerSt player = all.get(index);
            int shares = 0, seats = 0;
            for (CitySt cs : state.cities.values()) {
                seats += cs.council.getOrDefault(player.id, 0);
                for (Good good : cs.goods.values()) {
                    shares += good.shares.getOrDefault(player.id, 0);
                }
            }
            out.add(new RankRow(index + 1, player.id, player.name, player.npc, player.legit, shares, seats, player.id.equals(me)));
        }
        return out;
    }
}
