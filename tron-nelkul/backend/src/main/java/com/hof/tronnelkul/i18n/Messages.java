package com.hof.tronnelkul.i18n;

import com.hof.tronnelkul.game.engine.Msg;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * Server-side text: resolves Msg values (engine, API errors, content names) from the i18n files of the default
 * language. Placeholders are {name}; an arg may be a Msg or Msg.Join, resolved recursively. A missing key is logged
 * and the key itself is returned.
 */
@Component
public class Messages {
    private static final Logger log = LoggerFactory.getLogger(Messages.class);
    private static final Pattern PLACEHOLDER = Pattern.compile("\\{(\\w+)}");
    private static final Locale LOCALE = Locale.forLanguageTag(TranslationService.DEFAULT_LANG);

    private final TranslationService translations;

    public Messages(TranslationService translations) { this.translations = translations; }

    public String text(String key, Object... args) { return text(Msg.of(key, args)); }

    public String text(Msg m) {
        String t = find(m.key()).orElseGet(() -> {
            log.warn("Missing translation: {}", m.key());
            return m.key();
        });
        if (!m.args().isEmpty()) {
            Matcher x = PLACEHOLDER.matcher(t);
            StringBuilder out = new StringBuilder();
            while (x.find()) {
                Object v = m.args().get(x.group(1));
                x.appendReplacement(out, Matcher.quoteReplacement(v == null && !m.args().containsKey(x.group(1)) ? x.group() : resolve(v)));
            }
            x.appendTail(out);
            t = out.toString();
        }
        return m.lowercase() ? t.toLowerCase(LOCALE) : t;
    }

    /** An arg or name as text: Msg and Msg.Join are resolved, null is empty, anything else is toString. */
    public String resolve(Object v) {
        if (v == null) return "";
        if (v instanceof Msg m) return text(m);
        if (v instanceof Msg.Join j) return j.parts().stream().map(this::resolve).collect(Collectors.joining(j.separator()));
        return v.toString();
    }

    /** The text of a key without placeholders resolved, if it exists. */
    @SuppressWarnings("unchecked")
    public Optional<String> find(String key) {
        Object node = translations.translations(TranslationService.DEFAULT_LANG);
        for (String part : key.split("\\.")) {
            if (!(node instanceof Map<?, ?> map)) return Optional.empty();
            node = ((Map<String, Object>) map).get(part);
        }
        return node instanceof String s ? Optional.of(s) : Optional.empty();
    }
}
