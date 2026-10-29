package com.hof.tronnelkul.game.model;

/** A finished game's house with its user's name (null for an NPC). */
public record ArchivedPlayerUser(ArchivedPlayerEntity player, String userName) {}
