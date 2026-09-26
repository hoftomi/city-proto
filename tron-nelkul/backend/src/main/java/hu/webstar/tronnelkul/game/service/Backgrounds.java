package hu.webstar.tronnelkul.game.service;

import hu.webstar.tronnelkul.game.api.Dtos.BackgroundDto;
import java.util.List;
import java.util.Optional;

/** Háttértípusok (GDD 6. fejezet). A 0.0.1-ben csak a frakcióbónusz működik. */
public final class Backgrounds {
    private Backgrounds() {}

    public static final List<BackgroundDto> ALL = List.of(
        new BackgroundDto("nemesi", "Nemesi ház", "nemesseg", List.of("+25% nyereség a Nemességnél", "Több Legitimitás politikai akciókból")),
        new BackgroundDto("kereskedo", "Kereskedőház", "kereskedok", List.of("+25% nyereség a Kereskedőknél", "Útvonalanként +1 arany")),
        new BackgroundDto("hadur", "Hadúri klán", "katonasag", List.of("+25% nyereség a Katonaságnál", "Olcsóbb Útzár")),
        new BackgroundDto("vallasi", "Vallási rend", "legit", List.of("Lassabb romlás instabil városban", "A Gyanú gyorsabban csökken")),
        new BackgroundDto("arnyek", "Árnyékrend", "hidden", List.of("Rejtett akció: nincs +1 PP", "Kisebb lebukási esély")));

    public static final List<String> TINCTURES = List.of("voros", "kek", "zold", "arany", "bibor", "fekete", "narancs", "szeder");

    public static Optional<BackgroundDto> of(String id) { return ALL.stream().filter(b -> b.id().equals(id)).findFirst(); }
}
