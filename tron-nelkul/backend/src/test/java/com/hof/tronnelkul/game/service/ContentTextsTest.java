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
        for (var background : Backgrounds.dtos(messages)) {
            assertFalse(background.getName().startsWith("world."), background.getId().getValue());
            background.getPerks().forEach(perk -> assertFalse(perk.startsWith("world."), background.getId().getValue()));
        }
        for (var npc : Npcs.ALL) {
            assertTrue(messages.find(npc.label().key()).isPresent(), npc.id());
        }
    }

    @Test
    void catalogLabelsResolve() {
        var catalog = GameViewService.catalog(messages);
        catalog.getActions().forEach(action -> assertFalse(action.getLabel().startsWith("catalog."), action.getId()));
        catalog.getMargins().forEach(margin -> assertFalse(margin.getLabel().startsWith("catalog."), margin.getId()));
        catalog.getPrograms().forEach(program -> assertFalse(program.getLabel().startsWith("catalog."), program.getId()));
        catalog.getNews().forEach(news -> assertTrue(news.getLabel().contains("{t}"), news.getId()));
    }
}
