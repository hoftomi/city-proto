package hu.webstar.tronnelkul.game.model;

public enum GameStatus {
    ANNOUNCED("hamarosan"), OPEN("nyitott"), RUNNING("fut"), FINISHED("lezarult");
    public final String apiId;
    GameStatus(String apiId) { this.apiId = apiId; }
}
