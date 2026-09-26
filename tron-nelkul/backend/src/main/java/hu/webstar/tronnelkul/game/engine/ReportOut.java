package hu.webstar.tronnelkul.game.engine;

/** Egy jelentés, amit a kör feldolgozása egy játékosnak küld. tone: info | ok | warn | danger */
public record ReportOut(String playerId, String kind, String confidence, String title, String text, String tone) {}
