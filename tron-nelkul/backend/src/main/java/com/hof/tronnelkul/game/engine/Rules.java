package com.hof.tronnelkul.game.engine;

import java.util.Arrays;

/** Rulebook v0.2 – tunable parameters (chapter 11). Every number comes from here. Labels: i18n catalog.*. */
public final class Rules {
    private Rules() {}

    public static final int PP_PER_SETTLEMENT = 10, PP_MAX = 20, START_PP = 10;
    public static final int START_GOLD = 30, NPC_GOLD = 80;
    /** Maturation time in minutes (Citizen mode). */
    public static final int MATURATION_MIN = 120;
    /** Base price in gold per unit. The rulebook suggests 1 G; per the prototype the economy is too tight at 1 G. */
    public static final int BASE_PRICE = 3;

    public static final double POP_BASE = 10, POP_DRIFT = 2, POP_SOFT_CAP = 60, POP_HOME = 20;
    /** Below 20 popularity the gold cost of city actions is +50% (4.5). */
    public static final double LOW_POP = 20, LOW_POP_MULTIPLIER = 1.5;

    public static final int CITY_SHARE_COST = 3, MAX_SHARES_PER_ORDER = 10, BUYOUT_PROTECTION = 3;
    public static final double BUYOUT_PREMIUM = 1.5;
    /** Margin (Market) and popularity of the City's own share (5.1). */
    public static final double CITY_MARGIN = 0.3, CITY_POP = 20;
    /** Market value before any settlement, and its lower bound (per point). */
    public static final double MARKET_VALUE_DEFAULT_PROFIT = 0.3, MARKET_VALUE_MIN = 2;

    public static final int PARTY_COST = 40, COUNCIL_SEATS = 9, ELECTION_EVERY = 6;
    public static final double ELECTION_THRESHOLD = 0.05, DEFAULT_TAX = 0.2;

    public static final int FESTIVAL_GOLD = 15, FESTIVAL_COOLDOWN = 3;
    public static final double FESTIVAL_POP = 6;
    public static final int NEWS_GOLD = 5, NEWS_TRUTH_WINDOW = 3;
    public static final double DEBUNK_PENALTY = 10, DEBUNK_REWARD_POP = 3;
    public static final int DEBUNK_REWARD_GOLD = 10, DEBUNK_REWARD_LEGIT = 3;

    public static final int SPY_COST = 20, SPY_UPKEEP = 2, SPIES_PER_CITY = 3;
    public static final double GUARD_CHANCE = 0.25, GUARD_MAX = 0.75, CAUGHT_POP = 3;

    public static final int ROUTE_COST = 3, ROUTE_UPKEEP = 1;
    public static final int INFO_PRICE = 10, INFO_LEGIT = 1, INFO_LEGIT_EVERY = 3;

    public static final int SEAT_LEGIT = 1, MAJORITY_SEATS = 5, MAJORITY_LEGIT = 3, TOP_SELLER_LEGIT = 2, MOST_POPULAR_LEGIT = 2;
    public static final int CORONATION_LEGIT = 10;

    /** Starting bonus of the backgrounds (2.2). */
    public static final int MERCHANT_START_SHARES = 20, SHADOW_START_SPIES = 2;
    public static final double NOBLE_START_POP = 10;

    /** Margin level (5.2). */
    public enum Margin {
        VERY_CHEAP("veryCheap", 0.05, 3), CHEAP("cheap", 0.15, 1), MARKET("market", 0.3, 0),
        EXPENSIVE("expensive", 0.5, -1), USURY("usury", 0.8, -3);
        public final String id;
        public final double rate;
        public final int pop;
        Margin(String id, double rate, int pop) { this.id = id; this.rate = rate; this.pop = pop; }

        public Msg label() { return Msg.of("catalog.margin." + id); }

        public static Margin of(String id) { return Arrays.stream(values()).filter(margin -> margin.id.equals(id)).findFirst().orElse(MARKET); }
        public static boolean valid(String id) { return Arrays.stream(values()).anyMatch(margin -> margin.id.equals(id)); }
    }

    /** Party program (6.1). */
    public enum Program {
        LOW("low", 0.1, 1), MEDIUM("medium", 0.2, 0), HIGH("high", 0.3, -1);
        public final String id;
        public final double rate;
        public final int pop;
        Program(String id, double rate, int pop) { this.id = id; this.rate = rate; this.pop = pop; }

        public Msg label() { return Msg.of("catalog.program." + id); }

        public static Program of(String id) { return Arrays.stream(values()).filter(program -> program.id.equals(id)).findFirst().orElse(MEDIUM); }
        public static boolean valid(String id) { return Arrays.stream(values()).anyMatch(program -> program.id.equals(id)); }
    }

    /** News template (6.5); its text has {t} (target) and {g} (good). Truth is decided by the game state (Engine.newsTruth). */
    public enum NewsTemplate {
        USURY("usury", -5, true),
        BOUGHT_OUT("boughtOut", -4, false),
        TAX_HIKE("taxHike", -5, false),
        SPIES("spies", -4, false),
        FRIEND("friend", 4, false);
        public final String id;
        public final int effect;
        public final boolean needsGood;
        NewsTemplate(String id, int effect, boolean needsGood) { this.id = id; this.effect = effect; this.needsGood = needsGood; }

        public String labelKey() { return "catalog.news." + id; }

        public static NewsTemplate of(String id) {
            return Arrays.stream(values()).filter(template -> template.id.equals(id)).findFirst().orElseThrow(() -> new EngineException("engine.error.unknown_news_template"));
        }
    }

    /** Actions and their base cost (chapter 10). A null gold is computed (shares, buyout, defence). */
    public enum Action {
        ROUTE("route", 1, ROUTE_COST, "common"),
        MARGIN("margin", 1, 0, "trade"),
        BUY_SHARES("buyShares", 1, null, "trade"),
        BUYOUT("buyout", 2, null, "trade"),
        DEFEND("defend", 1, null, "trade"),
        FOUND_PARTY("foundParty", 2, PARTY_COST, "politics"),
        PROGRAM("program", 1, 0, "politics"),
        FESTIVAL("festival", 2, FESTIVAL_GOLD, "politics"),
        NEWS("news", 2, NEWS_GOLD, "politics"),
        HIRE_SPY("hireSpy", 1, SPY_COST, "espionage"),
        MOVE_SPY("moveSpy", 1, 0, "espionage"),
        GUARD("guard", 1, 0, "espionage"),
        SPY("spy", 1, 0, "espionage"),
        VERIFY("verify", 1, 0, "espionage"),
        DEBUNK("debunk", 1, 0, "espionage");
        public final String id, branch;
        public final int pp;
        public final Integer gold;
        Action(String id, int pp, Integer gold, String branch) { this.id = id; this.pp = pp; this.gold = gold; this.branch = branch; }

        public Msg label() { return Msg.of("catalog.action." + id); }

        public static Action of(String id) {
            return Arrays.stream(values()).filter(action -> action.id.equals(id)).findFirst().orElseThrow(() -> new EngineException("engine.error.unknown_action"));
        }
    }
}
