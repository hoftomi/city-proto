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
 * A mobil kliens feliratai. Forrás: resources/i18n/{nyelv}/{névtér}.json – minden fájl egy névtér
 * (a fájlnév a kulcs gyökere), így a képernyők feliratai külön fájlokban szerkeszthetők.
 * Ismeretlen nyelvnél a magyar (alap) változat jön. Az első kérés után a memóriában marad.
 */
@Service
public class TranslationService {
    static final String DEFAULT_LANG = "hu";

    private final JsonMapper json;
    private final PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
    private final Map<String, Map<String, Object>> cache = new ConcurrentHashMap<>();

    public TranslationService(JsonMapper json) { this.json = json; }

    public Map<String, Object> translations(String lang) {
        String l = lang == null ? DEFAULT_LANG : lang.toLowerCase(Locale.ROOT).replaceAll("[^a-z]", "");
        Map<String, Object> t = cache.computeIfAbsent(l, this::load);
        return t.isEmpty() && !l.equals(DEFAULT_LANG) ? translations(DEFAULT_LANG) : t;
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> load(String lang) {
        Map<String, Object> out = new TreeMap<>();
        try {
            Resource[] files = resolver.getResources("classpath*:i18n/" + lang + "/*.json");
            Arrays.sort(files, Comparator.comparing(Resource::getFilename));
            for (Resource r : files) {
                String ns = Objects.requireNonNull(r.getFilename()).replaceFirst("\\.json$", "");
                try (InputStream in = r.getInputStream()) {
                    out.put(ns, json.readValue(in, Map.class));
                }
            }
        } catch (IOException e) {
            throw new IllegalStateException("A feliratok nem olvashatók: " + lang, e);
        }
        return Collections.unmodifiableMap(out);
    }
}
