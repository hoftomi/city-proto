package hu.webstar.tronnelkul.game.engine;

public record Cost(int pp, int arany, int bp, int ke) {
    public static final Cost ZERO = new Cost(0, 0, 0, 0);

    public Cost plus(Cost o) { return new Cost(pp + o.pp, arany + o.arany, bp + o.bp, ke + o.ke); }

    /** Rejtett változat (8.1): +1 PP és +50% a többi költségből, felfelé kerekítve. */
    public Cost hidden() {
        return new Cost(pp + Rules.HIDDEN_EXTRA_PP, up(arany), up(bp), up(ke));
    }

    private static int up(int v) { return (int) Math.ceil(v * Rules.HIDDEN_COST_MULTIPLIER); }
}
