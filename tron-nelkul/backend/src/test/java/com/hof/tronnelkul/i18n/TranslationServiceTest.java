package com.hof.tronnelkul.i18n;

import org.junit.jupiter.api.Test;
import tools.jackson.databind.json.JsonMapper;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class TranslationServiceTest {
    final TranslationService service = new TranslationService(JsonMapper.builder().build());

    @Test
    @SuppressWarnings("unchecked")
    void namespacesAreFileNames() {
        Map<String, Object> hu = service.translations("hu");
        assertTrue(hu.containsKey("common") && hu.containsKey("error") && hu.containsKey("format"));
        assertEquals("Újra", ((Map<String, Object>) hu.get("common")).get("retry"));
    }

    @Test
    void unknownLanguageFallsBackToHungarian() {
        assertEquals(service.translations("hu"), service.translations("xx"));
        assertEquals(service.translations("hu"), service.translations("HU"));
    }
}
