package com.hof.tronnelkul.game.engine;

/** Rule violation, with a message the player can be shown (resolved by i18n.Messages). */
public class EngineException extends RuntimeException {
    private final Msg msg;

    public EngineException(Msg msg) { super(msg.key()); this.msg = msg; }

    public EngineException(String key, Object... args) { this(Msg.of(key, args)); }

    public Msg msg() { return msg; }
}
