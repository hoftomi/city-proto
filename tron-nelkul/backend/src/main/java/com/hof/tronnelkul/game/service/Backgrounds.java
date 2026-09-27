package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.api.model.BackgroundDto;
import java.util.List;
import java.util.Optional;

/** Háttértípusok (szabálykönyv v0.2, 2.2). Csak induló bónuszt adnak, egyik ágba sem zárnak be. */
public final class Backgrounds {
    private Backgrounds() {}

    public static final List<BackgroundDto> ALL = List.of(
        new BackgroundDto("kereskedo", "Kereskedőház", "kereskedok", List.of("20 részesedés a kezdőváros egyik árucikkéből", "Azonnal van eladható árud")),
        new BackgroundDto("nemesi", "Nemesi ház", "nemesseg", List.of("Megalapított párt a kezdővárosban", "+10 népszerűség a kezdővárosban")),
        new BackgroundDto("arnyek", "Árnyékrend", "hidden", List.of("2 felfogadott kém a kezdővárosban", "Az első naptól látsz a rivális parancslapokba")));

    public static final List<String> TINCTURES = List.of("voros", "kek", "zold", "arany", "bibor", "fekete", "narancs", "szeder");

    public static Optional<BackgroundDto> of(String id) { return ALL.stream().filter(b -> b.getId().equals(id)).findFirst(); }
}
