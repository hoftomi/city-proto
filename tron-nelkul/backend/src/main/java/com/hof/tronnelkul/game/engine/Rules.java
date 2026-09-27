package com.hof.tronnelkul.game.engine;

import java.util.Arrays;

/** Szabálykönyv v0.2 – hangolandó paraméterek (11. fejezet). Minden szám innen jön. */
public final class Rules {
    private Rules() {}

    public static final int PP_PER_SETTLEMENT = 10, PP_MAX = 20, START_PP = 10;
    public static final int START_GOLD = 30, NPC_GOLD = 80;
    /** Érlelési idő percben (Polgár mód). */
    public static final int MATURATION_MIN = 120;
    /** Alapár aranyban egységenként. A szabálykönyv 1 A-t javasol; a prototípus szerint 1 A mellett túl szűkös a gazdaság. */
    public static final int BASE_PRICE = 3;

    public static final double POP_BASE = 10, POP_DRIFT = 2, POP_SOFT_CAP = 60, POP_HOME = 20;
    /** 20 népszerűség alatt a városi akciók aranyköltsége +50% (4.5). */
    public static final double LOW_POP = 20, LOW_POP_MULTIPLIER = 1.5;

    public static final int CITY_SHARE_COST = 3, MAX_SHARES_PER_ORDER = 10, BUYOUT_PROTECTION = 3;
    public static final double BUYOUT_PREMIUM = 1.5;
    /** A Város saját részének haszonkulcsa (Piaci) és népszerűsége (5.1). */
    public static final double CITY_MARGIN = 0.3, CITY_POP = 20;
    /** Piaci érték, ha még nincs elszámolás, illetve az alsó korlát (pontonként). */
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

    /** Háttér induló bónusza (2.2). */
    public static final int MERCHANT_START_SHARES = 20, SHADOW_START_SPIES = 2;
    public static final double NOBLE_START_POP = 10;

    /** Haszonkulcs-fokozat (5.2). */
    public enum Margin {
        NAGYONOLCSO("nagyonolcso", "Nagyon olcsó", 0.05, 3), OLCSO("olcso", "Olcsó", 0.15, 1), PIACI("piaci", "Piaci", 0.3, 0),
        DRAGA("draga", "Drága", 0.5, -1), UZSORA("uzsora", "Uzsora", 0.8, -3);
        public final String id, label;
        public final double rate;
        public final int pop;
        Margin(String id, String label, double rate, int pop) { this.id = id; this.label = label; this.rate = rate; this.pop = pop; }

        public static Margin of(String id) { return Arrays.stream(values()).filter(m -> m.id.equals(id)).findFirst().orElse(PIACI); }
        public static boolean valid(String id) { return Arrays.stream(values()).anyMatch(m -> m.id.equals(id)); }
    }

    /** Pártprogram (6.1). */
    public enum Program {
        ALACSONY("alacsony", "Alacsony adó", 0.1, 1), KOZEPES("kozepes", "Közepes adó", 0.2, 0), MAGAS("magas", "Magas adó", 0.3, -1);
        public final String id, label;
        public final double rate;
        public final int pop;
        Program(String id, String label, double rate, int pop) { this.id = id; this.label = label; this.rate = rate; this.pop = pop; }

        public static Program of(String id) { return Arrays.stream(values()).filter(p -> p.id.equals(id)).findFirst().orElse(KOZEPES); }
        public static boolean valid(String id) { return Arrays.stream(values()).anyMatch(p -> p.id.equals(id)); }
    }

    /** Hírsablon (6.5). Az igazságtartalmat a játékállapot dönti el (Engine.newsTruth). */
    public enum NewsTemplate {
        UZSORA("uzsora", "„{t} uzsoraáron árulja: {g}.”", -5, true),
        KIVASAROLT("kivasarolt", "„{t} kivásárolt egy rivális kereskedőt.”", -4, false),
        ADOEMELES("adoemeles", "„{t} pártja adóemelést akar.”", -5, false),
        KEMEK("kemek", "„{t} kémeket tart a városban.”", -4, false),
        BARAT("barat", "„{t} a városlakók barátja.”", 4, false);
        public final String id, label;
        public final int effect;
        public final boolean needsGood;
        NewsTemplate(String id, String label, int effect, boolean needsGood) { this.id = id; this.label = label; this.effect = effect; this.needsGood = needsGood; }

        public static NewsTemplate of(String id) {
            return Arrays.stream(values()).filter(n -> n.id.equals(id)).findFirst().orElseThrow(() -> new EngineException("Ismeretlen hírsablon."));
        }
    }

    /** Akciók és alapköltségük (10. fejezet). A null arany számolt (részesedés, kivásárlás, védekezés). */
    public enum Action {
        ROUTE("route", "Útvonal kiépítése", 1, ROUTE_COST, "kozos"),
        MARGIN("margin", "Fokozatváltás", 1, 0, "keresk"),
        BUY_SHARES("buyShares", "Részesedés vásárlása", 1, null, "keresk"),
        BUYOUT("buyout", "Kivásárlási ajánlat", 2, null, "keresk"),
        DEFEND("defend", "Védekező vétel", 1, null, "keresk"),
        FOUND_PARTY("foundParty", "Pártalapítás", 2, PARTY_COST, "polit"),
        PROGRAM("program", "Programváltás", 1, 0, "polit"),
        FESTIVAL("festival", "Fesztivál", 2, FESTIVAL_GOLD, "polit"),
        NEWS("news", "Hír terjesztése", 2, NEWS_GOLD, "polit"),
        HIRE_SPY("hireSpy", "Kém felfogadása", 1, SPY_COST, "kem"),
        MOVE_SPY("moveSpy", "Kém áthelyezése", 1, 0, "kem"),
        GUARD("guard", "Őr beállítása", 1, 0, "kem"),
        SPY("spy", "Kifürkészés", 1, 0, "kem"),
        VERIFY("verify", "Hír ellenőrzése", 1, 0, "kem"),
        DEBUNK("debunk", "Leleplezés", 1, 0, "kem");
        public final String id, label, branch;
        public final int pp;
        public final Integer gold;
        Action(String id, String label, int pp, Integer gold, String branch) { this.id = id; this.label = label; this.pp = pp; this.gold = gold; this.branch = branch; }

        public static Action of(String id) {
            return Arrays.stream(values()).filter(a -> a.id.equals(id)).findFirst().orElseThrow(() -> new EngineException("Ismeretlen akció."));
        }
    }
}
