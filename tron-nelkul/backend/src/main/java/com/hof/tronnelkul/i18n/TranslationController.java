package com.hof.tronnelkul.i18n;

import com.hof.tronnelkul.api.I18nApi;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/** A mobil kliens feliratai (api/openapi.yaml, `i18n` tag). Bejelentkezés nélkül is elérhető. */
@RestController
public class TranslationController implements I18nApi {
    private final TranslationService translations;

    public TranslationController(TranslationService translations) { this.translations = translations; }

    @Override
    public Map<String, Object> getTranslations(String lang) { return translations.translations(lang); }
}
