package com.hof.tronnelkul.i18n;

import com.hof.tronnelkul.game.engine.Money;
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
 * language. Placeholders are {name}; an arg may be a Msg or Msg.Join, resolved recursively, or a Money amount, written
 * as a coin string with unit markers ("4 [gold] 3 [silver] 5 [bronze]"). A missing key is logged
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

    public String text(Msg message) {
        String template = find(message.key()).orElseGet(() -> {
            log.warn("Missing translation: {}", message.key());
            return message.key();
        });
        if (!message.args().isEmpty()) {
            Matcher matcher = PLACEHOLDER.matcher(template);
            StringBuilder out = new StringBuilder();
            while (matcher.find()) {
                Object value = message.args().get(matcher.group(1));
                matcher.appendReplacement(out, Matcher.quoteReplacement(value == null && !message.args().containsKey(matcher.group(1)) ? matcher.group() : resolve(value)));
            }
            matcher.appendTail(out);
            template = out.toString();
        }
        return message.lowercase() ? template.toLowerCase(LOCALE) : template;
    }

    /** An arg or name as text: Msg and Msg.Join are resolved, Money becomes coins, null is empty, anything else is toString. */
    public String resolve(Object value) {
        if (value == null) {
            return "";
        }
        if (value instanceof Msg msg) {
            return text(msg);
        }
        if (value instanceof Money money) {
            return money.text();
        }
        if (value instanceof Msg.Join join) {
            return join.parts().stream().map(this::resolve).collect(Collectors.joining(join.separator()));
        }
        return value.toString();
    }

    /** The text of a key without placeholders resolved, if it exists. */
    @SuppressWarnings("unchecked")
    public Optional<String> find(String key) {
        Object node = translations.translations(TranslationService.DEFAULT_LANG);
        for (String part : key.split("\\.")) {
            if (!(node instanceof Map<?, ?> map)) {
                return Optional.empty();
            }
            node = ((Map<String, Object>) map).get(part);
        }
        return node instanceof String text ? Optional.of(text) : Optional.empty();
    }
}
