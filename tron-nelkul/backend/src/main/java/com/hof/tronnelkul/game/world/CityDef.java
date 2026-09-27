package com.hof.tronnelkul.game.world;

import java.util.List;

/** Egy városállam a térképen. A koordináták a 360×260-as térképvászonra vonatkoznak. */
public record CityDef(String id, String name, int x, int y, boolean key, boolean coast, String profile, List<GoodDef> goods) {}
