package hu.webstar.tronnelkul.game.engine;

/** A szabálykönyv v0.1 hangolandó paraméterei (14. fejezet). */
public final class Rules {
    private Rules() {}

    public static final int PP_PER_ROUND = 10;
    public static final int PP_MAX = 20;
    public static final int INCOME_ARANY = 10;
    public static final int INCOME_BP = 3;
    public static final int INCOME_KE = 1;
    public static final int KE_MAX = 6;

    public static final double DIMINISHING_DIVISOR = 150.0;
    public static final double RIVAL_EFFICIENCY = 0.5;
    public static final double BACKGROUND_BONUS = 1.25;

    public static final double DECAY_OPEN = 0.05;
    public static final double DECAY_HIDDEN = 0.08;
    public static final double DECAY_PER_DISTANCE = 0.01;
    public static final double DECAY_SUSPICION2 = 0.02;
    public static final double DECAY_CAP = 0.12;

    public static final double T_JELENLET = 10;
    public static final double T_PARTNER = 25;
    public static final double T_DOMINANS = 35;
    public static final double T_LEAD = 5;

    public static final int HIDDEN_EXTRA_PP = 1;
    public static final double HIDDEN_COST_MULTIPLIER = 1.5;

    public static final int ROUTE_PP = 1;
    public static final int ROUTE_ARANY = 3;
    public static final int ROUTE_UPKEEP = 1;
    public static final int ROUTE_MAX = 4;

    public static final double SMEAR = 8;
    public static final double SUSPICION_GAIN_THRESHOLD = 15;
    public static final int NPC_PP = 8;

    // Induló készlet (13.3)
    public static final int START_PP = 10, START_ARANY = 15, START_BP = 5, START_KE = 2;

    public static double gain(double base, double total, double mods) {
        return base * (1 - total / DIMINISHING_DIVISOR) * mods;
    }
}
