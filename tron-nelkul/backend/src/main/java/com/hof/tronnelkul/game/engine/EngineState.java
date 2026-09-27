package com.hof.tronnelkul.game.engine;

import java.util.*;

/**
 * Egy játék teljes állapota (szabálykönyv v0.2). Nincs benne Spring vagy JPA: a szolgáltatási réteg
 * JSON-dokumentumként menti a `games.state` oszlopba. Az időpontok a játék órája szerinti epoch ms.
 */
public final class EngineState {
    /** A feldolgozott idő: eddig futottak le az érlelő lapok és az elszámolások. */
    public long clock;
    public int settlements;
    public long seq = 1;
    public Map<String, PlayerSt> players = new LinkedHashMap<>();
    public Map<String, CitySt> cities = new LinkedHashMap<>();
    /** játékos → saját útvonalai */
    public Map<String, List<Edge>> routes = new LinkedHashMap<>();
    /** játékos → lepecsételetlen vázlat */
    public Map<String, List<Order>> drafts = new LinkedHashMap<>();
    /** Érlelő parancslapok (3.1). */
    public List<Lap> laps = new ArrayList<>();
    public List<News> news = new ArrayList<>();
    /** Kivásárlások és védekező vételek (a hírek igazságához és a védekezéshez). */
    public List<MarketEvent> events = new ArrayList<>();
    /** "város|játékos" → a legutóbbi fesztivál elszámolása */
    public Map<String, Integer> festivals = new LinkedHashMap<>();
    /** "város|árucikk|játékos" → eddig az elszámolásig nem vásárolható ki */
    public Map<String, Integer> protection = new LinkedHashMap<>();
    public List<Intel> intel = new ArrayList<>();
    public List<Offer> offers = new ArrayList<>();

    public String nextId(String prefix) { return prefix + seq++; }

    public List<Edge> routesOf(String player) { return routes.computeIfAbsent(player, k -> new ArrayList<>()); }

    public List<Order> draftOf(String player) { return drafts.computeIfAbsent(player, k -> new ArrayList<>()); }

    public Optional<Lap> lapOf(String player) { return laps.stream().filter(l -> l.player.equals(player)).findFirst(); }

    public static final class PlayerSt {
        public String id, name, tincture, persona, background;
        public boolean npc;
        /** "birtok:<id>", vagy null (az NPC-k hálózata nem korlátozott). */
        public String estate;
        public double gold;
        public int pp, legit;
        public int lastInfoSale = -99;
        /** NPC: ekkor pecsétel legközelebb (epoch ms, 0 = nincs betervezve). */
        public long nextPlanAt;
        /** hír → igaz volt-e a terjesztéskor (a saját ellenőrzéseid) */
        public Map<String, Boolean> verified = new LinkedHashMap<>();
    }

    public static final class CitySt {
        public Map<String, Good> goods = new LinkedHashMap<>();
        /** Népszerűség 0–100; aki nincs benne, annak 10 (4.5). */
        public Map<String, Double> pop = new LinkedHashMap<>();
        /** játékos → pártprogram */
        public Map<String, String> parties = new LinkedHashMap<>();
        public Map<String, Integer> council = new LinkedHashMap<>();
        public Map<String, Integer> spies = new LinkedHashMap<>();
        public Map<String, Integer> guards = new LinkedHashMap<>();
        public Double lastTaxPool;
    }

    public static final class Good {
        public String name;
        public int supply, demand;
        public Map<String, Integer> shares = new LinkedHashMap<>();
        public Map<String, String> margins = new LinkedHashMap<>();
        /** Az utolsó elszámolás eladásai; a Város kulcsa "_varos". */
        public Map<String, Double> sold = new LinkedHashMap<>();
        /** Az utolsó 3 elszámolás átlagos haszna pontonként (a piaci értékhez). */
        public List<Double> history = new ArrayList<>();
    }

    /** Egy parancs. Csak a típushoz tartozó mezők töltöttek. gold: lepecsételéskor lefoglalt arany. */
    public static final class Order {
        public String id, type, city, good, level, target, template, newsId, lapId, orderId, from, to;
        public int pts, gold;
    }

    public static final class Lap {
        public String id, player;
        public List<Order> orders = new ArrayList<>();
        public long sealedAt, executeAt;
        public int pp, gold;
    }

    public static final class News {
        public String id, city, author, target, template, good, goodName;
        public int effect;
        public boolean trueAtCreation, debunked;
        public long createdAt;
    }

    /** type: buyout | defend | defendUsed (egy még érlelő védekező vétel hiúsította meg az ajánlatot). */
    public static final class MarketEvent {
        public String type, city, good, by, target, lapId, orderId;
        public int settlement;
    }

    /** Kifürkészett parancslap, a tulajdonos tudása. */
    public static final class Intel {
        public String id, owner, lapId, of;
        public long executeAt;
        public List<String> lines = new ArrayList<>();
        public int depth;
        public boolean bought;
        public List<String> offeredTo = new ArrayList<>();
    }

    /** Információs piac (7.5): letét, a vevő elfogadáskor fizet. */
    public static final class Offer {
        public String id, intelId, seller, buyer;
        public int price;
    }
}
