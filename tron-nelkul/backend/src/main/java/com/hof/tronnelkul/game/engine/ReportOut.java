package com.hof.tronnelkul.game.engine;

/**
 * Egy jelentés, amit a motor küld. Nyilvános jelentésnél a playerId null, és minden emberi játékos megkapja.
 * at: a játék órája (epoch ms). tone: info | ok | warn | danger
 */
public record ReportOut(String playerId, boolean isPublic, long at, String kind, String confidence, String title, String text, String tone) {}
