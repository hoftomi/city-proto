package com.hof.tronnelkul.game.model;

/** A finished game together with the user's own house in it. */
public record ArchivedPlayerGame(ArchivedGameEntity game, ArchivedPlayerEntity player) {}
