package com.hof.tronnelkul.game.model;

/** A live game's house with its user's name (null for an NPC). */
public record PlayerUser(PlayerEntity player, String userName) {}
