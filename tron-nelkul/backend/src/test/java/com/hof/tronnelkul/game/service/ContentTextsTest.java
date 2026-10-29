package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.i18n.Messages;
import com.hof.tronnelkul.i18n.TranslationService;
import org.junit.jupiter.api.Test;
import tools.jackson.databind.json.JsonMapper;

import static org.junit.jupiter.api.Assertions.*;

class ContentTextsTest {
    final Messages messages = new Messages(new TranslationService(JsonMapper.builder().build()));

    @Test
    void backgroundsAndNpcsHaveTexts() {
        for (var b : Backgrounds.dtos(messages)) {
            assertFalse(b.getName().startsWith("world."), b.getId());
            b.getPerks().forEach(p -> assertFalse(p.startsWith("world."), b.getId()));
        }
        for (var t : Npcs.ALL) assertTrue(messages.find(t.label().key()).isPresent(), t.id());
    }

    @Test
    void catalogLabelsResolve() {
        var c = GameViewService.catalog(messages);
        c.getActions().forEach(a -> assertFalse(a.getLabel().startsWith("catalog."), a.getId()));
        c.getMargins().forEach(m -> assertFalse(m.getLabel().startsWith("catalog."), m.getId()));
        c.getPrograms().forEach(p -> assertFalse(p.getLabel().startsWith("catalog."), p.getId()));
        c.getNews().forEach(n -> assertTrue(n.getLabel().contains("{t}"), n.getId()));
    }
}
