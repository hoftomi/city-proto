package hu.webstar.tronnelkul.game.engine;

/** Egy szereplő befolyása egy frakcióban: nyílt és rejtett rész. */
public final class Share {
    public double open;
    public double hidden;

    public Share(double open, double hidden) { this.open = open; this.hidden = hidden; }

    public double total() { return open + hidden; }
}
