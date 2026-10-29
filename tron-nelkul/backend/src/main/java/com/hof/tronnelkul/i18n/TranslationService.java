package com.hof.tronnelkul.i18n;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Service;
import tools.jackson.databind.json.JsonMapper;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Texts of the mobile client and the server (i18n.Messages). Source: resources/i18n/{lang}/{namespace}.json – each file
 * is one namespace (the file name is the key root), so texts can be edited in separate files.
 * An unknown language falls back to Hungarian (default). Cached in memory after the first request.
 */
@Service
public class TranslationService {
    static final String DEFAULT_LANG = "hu";

    private final JsonMapper json;
    private final PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
    private final Map<String, Map<String, Object>> cache = new ConcurrentHashMap<>();

    public TranslationService(JsonMapper json) { this.json = json; }

    public Map<String, Object> translations(String lang) {
        String normalized = lang == null ? DEFAULT_LANG : lang.toLowerCase(Locale.ROOT).replaceAll("[^a-z]", "");
        Map<String, Object> loaded = cache.computeIfAbsent(normalized, this::load);
        return loaded.isEmpty() && !normalized.equals(DEFAULT_LANG) ? translations(DEFAULT_LANG) : loaded;
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> load(String lang) {
        Map<String, Object> out = new TreeMap<>();
        try {
            Resource[] files = resolver.getResources("classpath*:i18n/" + lang + "/*.json");
            Arrays.sort(files, Comparator.comparing(Resource::getFilename));
            for (Resource resource : files) {
                String ns = Objects.requireNonNull(resource.getFilename()).replaceFirst("\\.json$", "");
                try (InputStream in = resource.getInputStream()) {
                    out.put(ns, json.readValue(in, Map.class));
                }
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Cannot read translations: " + lang, ex);
        }
        return Collections.unmodifiableMap(out);
    }
}
