package com.hof.tronnelkul.game.model;

/** A live game together with the user's own house in it. */
public record PlayerGame(GameEntity game, PlayerEntity player) {}
