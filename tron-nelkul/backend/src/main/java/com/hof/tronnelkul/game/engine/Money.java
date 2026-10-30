package com.hof.tronnelkul.game.engine;

/**
 * An amount of money in whole bronze (1 gold = 10 silver = 100 bronze) used as a text arg. Messages renders it as a
 * coin string with the unit markers: 435 → "4 [gold] 3 [silver] 5 [bronze]", 400 → "4 [gold]", 0 → "0 [gold]",
 * −30 → "−3 [silver]". signed: a non-negative amount gets a leading "+" (income).
 */
public record Money(long bronze, boolean signed) {
    public static final long BRONZE_PER_SILVER = 10, BRONZE_PER_GOLD = 100;
    /** The minus sign before a negative amount (U+2212). */
    public static final String MINUS = "−";

    public static Money of(long bronze) { return new Money(bronze, false); }

    /** An income or change: "+4 [gold] 5 [bronze]", "−3 [silver]". */
    public static Money signed(long bronze) { return new Money(bronze, true); }

    /** The coin string of an amount: only the non-zero denominations, biggest first; zero is "0 [gold]". */
    public static String coins(long bronze) {
        if (bronze == 0) {
            return "0 [gold]";
        }
        long abs = Math.abs(bronze);
        long gold = abs / BRONZE_PER_GOLD, silver = abs % BRONZE_PER_GOLD / BRONZE_PER_SILVER, rest = abs % BRONZE_PER_SILVER;
        StringBuilder out = new StringBuilder(bronze < 0 ? MINUS : "");
        append(out, gold, "[gold]");
        append(out, silver, "[silver]");
        append(out, rest, "[bronze]");
        return out.toString();
    }

    private static void append(StringBuilder out, long count, String marker) {
        if (count == 0) {
            return;
        }
        if (!out.isEmpty() && !MINUS.contentEquals(out)) {
            out.append(' ');
        }
        out.append(count).append(' ').append(marker);
    }

    public String text() { return (signed && bronze >= 0 ? "+" : "") + coins(bronze); }

    @Override
    public String toString() { return text(); }
}
