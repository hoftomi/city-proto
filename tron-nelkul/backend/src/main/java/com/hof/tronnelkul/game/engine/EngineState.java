package com.hof.tronnelkul.game.engine;

import java.util.*;

/**
 * The full state of a game (rulebook v0.2). No Spring or JPA: the service layer stores it as a JSON document
 * in the `games.state` column. Timestamps are epoch ms on the game clock. Holds ids only, no display text.
 */
public final class EngineState {
    /** Processed time: maturing sheets and settlements have run up to here. */
    public long clock;
    public int settlements;
    public long seq = 1;
    public Map<String, PlayerSt> players = new LinkedHashMap<>();
    public Map<String, CitySt> cities = new LinkedHashMap<>();
    /** player → own routes */
    public Map<String, List<Edge>> routes = new LinkedHashMap<>();
    /** player → unsealed draft */
    public Map<String, List<Order>> drafts = new LinkedHashMap<>();
    /** Maturing order sheets (3.1). */
    public List<Sheet> sheets = new ArrayList<>();
    public List<News> news = new ArrayList<>();
    /** Buyouts and defensive purchases (for news truth and defence). */
    public List<MarketEvent> events = new ArrayList<>();
    /** "city|player" → settlement of the latest festival */
    public Map<String, Integer> festivals = new LinkedHashMap<>();
    /** "city|good|player" → cannot be bought out until this settlement */
    public Map<String, Integer> protection = new LinkedHashMap<>();
    public List<Intel> intel = new ArrayList<>();
    public List<Offer> offers = new ArrayList<>();

    public String nextId(String prefix) { return prefix + seq++; }

    public List<Edge> routesOf(String player) { return routes.computeIfAbsent(player, k -> new ArrayList<>()); }

    public List<Order> draftOf(String player) { return drafts.computeIfAbsent(player, k -> new ArrayList<>()); }

    public Optional<Sheet> sheetOf(String player) { return sheets.stream().filter(l -> l.player.equals(player)).findFirst(); }

    public static final class PlayerSt {
        public String id, name, tincture, persona, background;
        public boolean npc;
        /** "estate:<id>", or null (NPC networks are unrestricted). */
        public String estate;
        public double gold;
        public int pp, legit;
        public int lastInfoSale = -99;
        /** NPC: next sealing time (epoch ms, 0 = not planned). */
        public long nextPlanAt;
        /** news → whether it was true when spread (own verifications) */
        public Map<String, Boolean> verified = new LinkedHashMap<>();
    }

    public static final class CitySt {
        public Map<String, Good> goods = new LinkedHashMap<>();
        /** Popularity 0–100; 10 for anyone missing (4.5). */
        public Map<String, Double> pop = new LinkedHashMap<>();
        /** player → party program */
        public Map<String, String> parties = new LinkedHashMap<>();
        public Map<String, Integer> council = new LinkedHashMap<>();
        public Map<String, Integer> spies = new LinkedHashMap<>();
        public Map<String, Integer> guards = new LinkedHashMap<>();
        public Double lastTaxPool;
    }

    public static final class Good {
        public int supply, demand;
        public Map<String, Integer> shares = new LinkedHashMap<>();
        public Map<String, String> margins = new LinkedHashMap<>();
        /** Sales of the last settlement; the City's key is "_city". */
        public Map<String, Double> sold = new LinkedHashMap<>();
        /** Average profit per point over the last 3 settlements (for market value). */
        public List<Double> history = new ArrayList<>();
    }

    /** An order. Only the fields of its type are set. gold: gold reserved at sealing. */
    public static final class Order {
        public String id, type, city, good, level, target, template, newsId, sheetId, orderId, from, to;
        public int pts, gold;

        public Order copy() {
            Order o = new Order();
            o.id = id; o.type = type; o.city = city; o.good = good; o.level = level; o.target = target; o.template = template;
            o.newsId = newsId; o.sheetId = sheetId; o.orderId = orderId; o.from = from; o.to = to; o.pts = pts; o.gold = gold;
            return o;
        }
    }

    public static final class Sheet {
        public String id, player;
        public List<Order> orders = new ArrayList<>();
        public long sealedAt, executeAt;
        public int pp, gold;
    }

    public static final class News {
        public String id, city, author, target, template, good;
        public int effect;
        public boolean trueAtCreation, debunked;
        public long createdAt;
    }

    /** type: buyout | defend | defendUsed (a still maturing defensive purchase foiled the offer). */
    public static final class MarketEvent {
        public String type, city, good, by, target, sheetId, orderId;
        public int settlement;
    }

    /** A scouted order sheet, the owner's knowledge. orders: the visible orders, shown at the given depth (7.2). */
    public static final class Intel {
        public String id, owner, sheetId, of;
        public long executeAt;
        public List<Order> orders = new ArrayList<>();
        public int depth;
        public boolean bought;
        public List<String> offeredTo = new ArrayList<>();
    }

    /** Information market (7.5): escrow, the buyer pays on acceptance. */
    public static final class Offer {
        public String id, intelId, seller, buyer;
        public int price;
    }
}
