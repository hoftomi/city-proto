package hu.webstar.tronnelkul.game.engine;

import hu.webstar.tronnelkul.game.world.MapRegistry;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/** A szabálymotor viselkedése a szabálykönyv v0.1 szerint. Spring nélkül fut. */
class RoundResolverTest {
    EngineState s;
    PlayerState me;

    @BeforeEach
    void setUp() {
        s = new EngineState(MapRegistry.DELKELET, 1);
        me = new PlayerState("me", "Kékholló", "kek", false, null, null, Faction.KERESKEDOK, "birtok:nyugat");
        me.pp = 10; me.arany = 15; me.bp = 5; me.ke = 2;
        s.players.put(me.id, me);
        s.routesOf("me").add(new Edge("birtok:nyugat", "szelmezo"));
        s.routesOf("me").add(new Edge("birtok:nyugat", "delkapu"));
    }

    @Test
    void gainComesFromNeutralWithBackgroundBonus() {
        s.orders.add(OrderSpec.action("me", ActionType.GRANT, "szelmezo", Faction.KERESKEDOK, false, null));
        RoundResolver.resolve(s, 1);
        // 10 × (1 − 0/150) × 1,25 (Kereskedőház) + 2 passzív útvonalhozam, majd romlás: 5% + 2% (Ingatag)
        Share mine = s.fac("szelmezo", Faction.KERESKEDOK).get("me");
        assertEquals((12.5 + 1) * 0.93, mine.open, 0.05);
        assertEquals(2, s.round);
    }

    @Test
    void costsAreDeductedAndIncomeAdded() {
        s.orders.add(OrderSpec.action("me", ActionType.GRANT, "szelmezo", Faction.KERESKEDOK, false, null));
        RoundResolver.resolve(s, 1);
        assertEquals(Math.min(Rules.PP_MAX, 10 - 2 + Rules.PP_PER_ROUND), me.pp);
        // 15 − 8 + 10 bevétel − 2 fenntartás + 2 útvonalhozam
        assertEquals(15 - 8 + 10, me.arany);
    }

    @Test
    void actionOutsideNetworkIsSkipped() {
        s.orders.add(OrderSpec.action("me", ActionType.PATRON, "feketerev", Faction.NEMESSEG, false, null));
        List<ReportOut> out = RoundResolver.resolve(s, 1);
        assertTrue(out.stream().anyMatch(r -> r.title().startsWith("Elmaradt")));
        assertNull(s.fac("feketerev", Faction.NEMESSEG).get("me"));
    }

    @Test
    void takingFromRivalsIsHalfEfficient() {
        s.share("szelmezo", Faction.NEMESSEG, "rival").open = 100;
        s.players.put("rival", new PlayerState("rival", "Rivális", "voros", false, null, null, null, null));
        s.orders.add(OrderSpec.action("me", ActionType.PATRON, "szelmezo", Faction.NEMESSEG, false, null));
        RoundResolver.resolve(s, 1);
        double mine = s.fac("szelmezo", Faction.NEMESSEG).get("me").open;
        assertEquals(4 * 0.5 * 0.93, mine, 0.05);
    }

    @Test
    void routeBecomesActiveAfterResolution() {
        s.orders.add(OrderSpec.route("me", "szelmezo", "feketerev"));
        assertFalse(Network.of(s, "me").containsKey("feketerev"));
        RoundResolver.resolve(s, 1);
        assertEquals(2, Network.of(s, "me").get("feketerev"));
    }

    @Test
    void dominanceNeedsLeadOfFive() {
        var fac = s.fac("delkapu", Faction.KATONASAG);
        fac.put("a", new Share(40, 0));
        fac.put("b", new Share(36, 0));
        assertNull(Levels.dominant(fac));
        fac.get("b").open = 35;
        assertEquals("a", Levels.dominant(fac));
    }

    @Test
    void bigGainRaisesSuspicion() {
        me.arany = 40; me.pp = 20;
        for (int i = 0; i < 3; i++) s.orders.add(OrderSpec.action("me", ActionType.GRANT, "delkapu", Faction.KERESKEDOK, false, null));
        RoundResolver.resolve(s, 1);
        assertEquals(1, s.suspicionOf("me", "delkapu", Faction.KERESKEDOK));
    }

    @Test
    void hiddenCostIsHigher() {
        Cost c = ActionType.GRANT.cost(true);
        assertEquals(3, c.pp());
        assertEquals(12, c.arany());
    }
}
