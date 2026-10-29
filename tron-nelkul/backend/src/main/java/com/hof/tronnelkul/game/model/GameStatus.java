package com.hof.tronnelkul.game.model;

/** States of the games table; a finished game moves to the archived_games table (API: "finished"). */
public enum GameStatus {
    ANNOUNCED("announced"), OPEN("open"), RUNNING("running");
    public static final String FINISHED_API_ID = "finished";
    public final String apiId;
    GameStatus(String apiId) { this.apiId = apiId; }
}
