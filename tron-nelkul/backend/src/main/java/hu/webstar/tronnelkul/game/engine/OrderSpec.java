package hu.webstar.tronnelkul.game.engine;

/** Egy parancs a feldolgozáshoz. A `result` a tényleges nyereséget kapja meg. */
public final class OrderSpec {
    public final String playerId;
    public final ActionType type;
    public final String city;       // ROUTE esetén null
    public final Faction faction;   // ROUTE esetén null
    public final boolean hidden;
    public final String targetId;   // SMEAR célpontja
    public final String from, to;   // ROUTE élei
    public double result = Double.NaN;

    public OrderSpec(String playerId, ActionType type, String city, Faction faction, boolean hidden, String targetId, String from, String to) {
        this.playerId = playerId; this.type = type; this.city = city; this.faction = faction; this.hidden = hidden;
        this.targetId = targetId; this.from = from; this.to = to;
    }

    public Cost cost() { return type.cost(hidden); }

    public static OrderSpec action(String playerId, ActionType type, String city, Faction faction, boolean hidden, String targetId) {
        return new OrderSpec(playerId, type, city, faction, hidden, targetId, null, null);
    }

    public static OrderSpec route(String playerId, String from, String to) {
        return new OrderSpec(playerId, ActionType.ROUTE, null, null, false, null, from, to);
    }
}
