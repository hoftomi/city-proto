package com.hof.tronnelkul.game.engine;

import java.util.*;

/**
 * A translatable text: an i18n key (resources/i18n/hu, e.g. "engine.report.route.title") and named args for its
 * {name} placeholders. An arg may itself be a Msg or a {@link Join}; both are resolved recursively (i18n.Messages).
 * lowercase: the resolved text is lowercased (good names inside a sentence).
 */
public record Msg(String key, Map<String, Object> args, boolean lowercase) {
    public Msg {
        args = args == null ? Map.of() : Collections.unmodifiableMap(new LinkedHashMap<>(args));
    }

    /** key with arg name/value pairs: Msg.of("engine.report.route.title", "city", cityMsg). */
    public static Msg of(String key, Object... kv) {
        if (kv.length % 2 != 0) {
            throw new IllegalArgumentException("Msg args must be name/value pairs: " + key);
        }
        Map<String, Object> named = new LinkedHashMap<>();
        for (int index = 0; index < kv.length; index += 2) {
            named.put((String) kv[index], kv[index + 1]);
        }
        return new Msg(key, named, false);
    }

    public Msg lower() { return new Msg(key, args, true); }

    /** The parts (texts or Msgs) joined with a separator, e.g. the spied orders with " · ". */
    public record Join(String separator, List<?> parts) {}

    public static Join join(String separator, List<?> parts) { return new Join(separator, List.copyOf(parts)); }
}
