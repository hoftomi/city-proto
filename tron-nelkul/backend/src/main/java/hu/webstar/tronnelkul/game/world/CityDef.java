package hu.webstar.tronnelkul.game.world;

/** Egy városállam a térképen. A koordináták a 360×260-as térképvászonra vonatkoznak. */
public record CityDef(String id, String name, int x, int y, boolean key, boolean coast, String profile, String initialStability) {}
