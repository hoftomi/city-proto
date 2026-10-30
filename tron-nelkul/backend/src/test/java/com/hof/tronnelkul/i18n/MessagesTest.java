package com.hof.tronnelkul.i18n;

import com.hof.tronnelkul.game.engine.Money;
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
        Msg msg = Msg.of("engine.report.buyout_threat.text", "pts", 5, "good", GoodDef.label("grain").lower(), "city", CityDef.label("szelmezo"), "time", "09. 01. 20:00");
        String text = messages.text(msg);
        assertTrue(text.startsWith("5%-ot ") && text.contains(good.toLowerCase(Locale.ROOT)) && text.contains(city) && text.contains("09. 01. 20:00") && !text.contains("{"), text);
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
    void moneyArgsBecomeCoinStrings() {
        assertEquals("Az ár 1 [gold] és 500 [gold] között lehet.", messages.text("engine.error.price_range", "min", Money.of(100), "max", Money.of(50_000)));
        assertEquals("+4 [gold] 3 [silver] 5 [bronze]", messages.resolve(Money.signed(435)));
    }

    /** Money placeholders get a coin string with its own markers: no " [gold]" or "arany" right after a placeholder. */
    @Test
    void serverTextsDoNotAppendAUnitToMoney() throws IOException {
        Pattern unitAfterPlaceholder = Pattern.compile("\\{\\w+}\\s*(\\[(gold|silver|bronze)]|arany)");
        for (String namespace : List.of("engine", "server", "catalog", "world")) {
            String text = Files.readString(Path.of("src/main/resources/i18n/hu/" + namespace + ".json"));
            Matcher matcher = unitAfterPlaceholder.matcher(text);
            boolean found = matcher.find();
            assertFalse(found, namespace + ": " + (found ? matcher.group() : ""));
        }
    }

    @Test
    void worldAndCatalogTextsExist() {
        List<String> keys = new ArrayList<>();
        for (MapDefinition map : List.of(MapRegistry.DELKELET, MapRegistry.KODOS, MapRegistry.SO)) {
            keys.add(map.label().key());
            for (CityDef cityDef : map.cities()) {
                keys.add(cityDef.label().key()); keys.add(cityDef.desc().key());
                cityDef.goods().forEach(good -> keys.add(good.label().key()));
            }
            for (StartSlot slot : map.starts()) { keys.add(map.startLabel(slot).key()); keys.add(map.startNote(slot).key()); }
        }
        for (Rules.Action action : Rules.Action.values()) {
            keys.add(action.label().key());
        }
        for (Rules.Margin margin : Rules.Margin.values()) {
            keys.add(margin.label().key());
        }
        for (Rules.Program program : Rules.Program.values()) {
            keys.add(program.label().key());
        }
        for (Rules.NewsTemplate news : Rules.NewsTemplate.values()) {
            keys.add(news.labelKey());
        }
        keys.forEach(key -> assertTrue(messages.find(key).isPresent(), key));
    }

    /** Every server-side key the code names literally (or via the Engine's err/title/text helpers) has a text. */
    @Test
    void keysUsedInTheCodeExist() throws IOException {
        Pattern literal = Pattern.compile("\"((?:engine|server|world|catalog)\\.[A-Za-z0-9_.]*[A-Za-z0-9_])\"");
        Pattern helper = Pattern.compile("\\b(err|title|text)\\(\"(\\w+)\"");
        Set<String> keys = new TreeSet<>();
        try (Stream<Path> files = Files.walk(Path.of("src/main/java"))) {
            for (Path file : files.filter(path -> path.toString().endsWith(".java")).toList()) {
                String src = Files.readString(file);
                Matcher matcher = literal.matcher(src);
                while (matcher.find()) {
                    keys.add(matcher.group(1));
                }
                if (!file.endsWith("Engine.java")) {
                    continue;
                }
                matcher = helper.matcher(src);
                while (matcher.find()) {
                    keys.add(switch (matcher.group(1)) {
                        case "err" -> "engine.error." + matcher.group(2);
                        case "title" -> "engine.report." + matcher.group(2) + ".title";
                        default -> "engine.report." + matcher.group(2) + ".text";
                    });
                }
            }
        }
        assertTrue(keys.size() > 100, "found " + keys.size());
        List<String> missing = keys.stream().filter(key -> messages.find(key).isEmpty()).toList();
        assertEquals(List.of(), missing);
    }
}
