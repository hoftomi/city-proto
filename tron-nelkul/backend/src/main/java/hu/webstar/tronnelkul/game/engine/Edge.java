package hu.webstar.tronnelkul.game.engine;

/** Irányítatlan él a térképen. */
public record Edge(String a, String b) {
    public boolean touches(String n) { return a.equals(n) || b.equals(n); }
    public String other(String n) { return a.equals(n) ? b : a; }
    public boolean same(String x, String y) { return (a.equals(x) && b.equals(y)) || (a.equals(y) && b.equals(x)); }
}
