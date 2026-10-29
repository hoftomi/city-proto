package com.hof.tronnelkul.game.model;

/** A live game's report with the name of the house that received it. */
public record ReportHouse(ReportEntity report, String houseName) {}
