package com.hof.tronnelkul.game.engine;

/**
 * A report sent by the engine. A public report has a null playerId and goes to every human player.
 * at: game clock (epoch ms). tone: info | ok | warn | danger. title and text are resolved when stored.
 */
public record ReportOut(String playerId, boolean isPublic, long at, String kind, String confidence, Msg title, Msg text, String tone) {}
