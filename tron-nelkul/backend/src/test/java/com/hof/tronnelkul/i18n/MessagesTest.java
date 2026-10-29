package com.hof.tronnelkul.i18n;

import com.hof.tronnelkul.game.engine.Msg;
import com.hof.tronnelkul.game.engine.Rules;
import com.hof.tronnelkul.game.world.CityDef;
import com.hof.tronnelkul.game.world.GoodDef;
import com.hof.tronnelkul.game.world.MapDefinition;
import com.hof.tronnelkul.game.world.MapRegistry;
import com.hof.tronnelkul.game.world.StartSlot;
import org.junit.jupiter.api.Test;
import tools.jackson.databind.json.JsonMapper;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;

class MessagesTest {
    final Messages messages = new Messages(new TranslationService(JsonMapper.builder().build()));

    @Test
    void placeholdersNestedMessagesJoinAndLowercase() {
        String good = messages.text("world.good.grain");
        String city = messages.text("world.city.szelmezo.name");
        Msg m = Msg.of("engine.report.buyout_threat.text", "pts", 5, "good", GoodDef.label("grain").lower(), "city", CityDef.label("szelmezo"), "time", "09. 01. 20:00");
        String t = messages.text(m);
        assertTrue(t.startsWith("5 ") && t.contains(good.toLowerCase(Locale.ROOT)) && t.contains(city) && t.contains("09. 01. 20:00") && !t.contains("{"), t);
        assertEquals("a, " + city, messages.resolve(Msg.join(", ", List.of("a", CityDef.label("szelmezo")))));
    }

    @Test
    void missingKeyReturnsTheKey() {
        assertEquals("engine.no_such_key", messages.text("engine.no_such_key"));
        assertTrue(messages.find("engine.report").isEmpty(), "a namespace node is not a text");
    }

    @Test
    void unknownPlaceholderStays() {
        assertTrue(messages.text("engine.error.price_range", "min", 1).contains("{max}"));
    }

    @Test
    void worldAndCatalogTextsExist() {
        List<String> keys = new ArrayList<>();
        for (MapDefinition m : List.of(MapRegistry.DELKELET, MapRegistry.KODOS, MapRegistry.SO)) {
            keys.add(m.label().key());
            for (CityDef c : m.cities()) {
                keys.add(c.label().key()); keys.add(c.desc().key());
                c.goods().forEach(g -> keys.add(g.label().key()));
            }
            for (StartSlot s : m.starts()) { keys.add(m.startLabel(s).key()); keys.add(m.startNote(s).key()); }
        }
        for (Rules.Action a : Rules.Action.values()) keys.add(a.label().key());
        for (Rules.Margin x : Rules.Margin.values()) keys.add(x.label().key());
        for (Rules.Program p : Rules.Program.values()) keys.add(p.label().key());
        for (Rules.NewsTemplate n : Rules.NewsTemplate.values()) keys.add(n.labelKey());
        keys.forEach(k -> assertTrue(messages.find(k).isPresent(), k));
    }

    /** Every server-side key the code names literally (or via the Engine's err/title/text helpers) has a text. */
    @Test
    void keysUsedInTheCodeExist() throws IOException {
        Pattern literal = Pattern.compile("\"((?:engine|server|world|catalog)\\.[A-Za-z0-9_.]*[A-Za-z0-9_])\"");
        Pattern helper = Pattern.compile("\\b(err|title|text)\\(\"(\\w+)\"");
        Set<String> keys = new TreeSet<>();
        try (Stream<Path> files = Files.walk(Path.of("src/main/java"))) {
            for (Path f : files.filter(p -> p.toString().endsWith(".java")).toList()) {
                String src = Files.readString(f);
                Matcher m = literal.matcher(src);
                while (m.find()) keys.add(m.group(1));
                if (!f.endsWith("Engine.java")) continue;
                m = helper.matcher(src);
                while (m.find()) keys.add(switch (m.group(1)) {
                    case "err" -> "engine.error." + m.group(2);
                    case "title" -> "engine.report." + m.group(2) + ".title";
                    default -> "engine.report." + m.group(2) + ".text";
                });
            }
        }
        assertTrue(keys.size() > 100, "found " + keys.size());
        List<String> missing = keys.stream().filter(k -> messages.find(k).isEmpty()).toList();
        assertEquals(List.of(), missing);
    }
}
