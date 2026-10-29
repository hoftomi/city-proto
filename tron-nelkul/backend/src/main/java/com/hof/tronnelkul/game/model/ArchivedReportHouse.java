package com.hof.tronnelkul.game.model;

/** A finished game's report with the name of the house that received it. */
public record ArchivedReportHouse(ArchivedReportEntity report, String houseName) {}
