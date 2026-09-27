package com.hof.tronnelkul.game.world;

/** Egy város árucikke: kínálat és kereslet elszámolásonként (szabálykönyv v0.2, 1. és 5.3). */
public record GoodDef(String id, String name, int supply, int demand) {}
