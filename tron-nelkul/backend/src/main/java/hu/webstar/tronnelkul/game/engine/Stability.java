package hu.webstar.tronnelkul.game.engine;

/** Városállam stabilitása (7.2). */
public enum Stability {
    STABIL("stabil", 0.0, 1.0, 1.0), INGATAG("ingatag", 0.02, 1.25, 1.0), LAZONGO("lazongo", 0.04, 1.5, 0.75);

    private final String id;
    public final double extraDecay;
    public final double hostileMultiplier;
    public final double gainMultiplier;

    Stability(String id, double extraDecay, double hostileMultiplier, double gainMultiplier) {
        this.id = id; this.extraDecay = extraDecay; this.hostileMultiplier = hostileMultiplier; this.gainMultiplier = gainMultiplier;
    }

    public String id() { return id; }
    public Stability worse() { return this == STABIL ? INGATAG : LAZONGO; }
    public Stability better() { return this == LAZONGO ? INGATAG : STABIL; }
}
