package com.hof.tronnelkul.game.engine;

/** Szabálysértés: a játékosnak megjeleníthető, magyar nyelvű üzenettel. */
public class EngineException extends RuntimeException {
    public EngineException(String message) { super(message); }
}
