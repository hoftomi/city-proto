package hu.webstar.tronnelkul.game.engine;

import java.util.*;
import java.util.random.RandomGenerator;
import java.util.SplittableRandom;

/**
 * Egy kör feldolgozása a szabálykönyv 3. fejezetének sorrendjében.
 * Tiszta függvény az {@link EngineState}-en: módosítja az állapotot, és visszaadja a jelentéseket.
 */
public final class RoundResolver {
    private RoundResolver() {}

    private static final String[] FLAVOR_PATRON = { "A céhmesterek elfogadták az ajándékot, és elismerően bólintottak.", "Egy csendes vacsora, egy jó bor: a támogatók köre bővült." };
    private static final String[] FLAVOR_GRANT = { "A nagy adomány híre bejárta a várost. Az emberek a nevedet emlegetik.", "A tanácsterem új faliszőnyegét a te házad címere díszíti." };
    private static final String[] FLAVOR_COUNCIL = { "Egy tanácstag mostantól a te szavadra figyel.", "A tanácsülésen először szólalt fel valaki a házad nevében." };
    private static final String[] FLAVOR_GUARD = { "A városőrség új vértezetet kapott. A kapitány nem felejt.", "Zsoldot fizettél a helyőrségnek. A katonák tudják, kinek köszönhetik." };

    private record Claim(String player, double gain, boolean hidden, OrderSpec order) {}

    public static List<ReportOut> resolve(EngineState s, long seed) {
        RandomGenerator r = new SplittableRandom(seed);
        List<ReportOut> reports = new ArrayList<>();
        Map<String, Map<String, Levels.Level>> before = snapshot(s);

        // Emberi parancsok: elérhetőség és fedezet ellenőrzése, költség levonása
        List<OrderSpec> all = new ArrayList<>();
        for (OrderSpec o : s.orders) {
            PlayerState p = s.players.get(o.playerId);
            if (p == null) continue;
            if (o.type != ActionType.ROUTE && !Network.reaches(s, p.id, o.city)) {
                reports.add(new ReportOut(p.id, "frakcio", null, "Elmaradt: " + o.type.label, s.map.nodeName(o.city) + " már nincs a hálózatodban, ezért a parancs nem futott le.", "warn"));
                continue;
            }
            Cost c = o.cost();
            if (p.pp < c.pp() || p.arany < c.arany() || p.bp < c.bp() || p.ke < c.ke()) {
                reports.add(new ReportOut(p.id, "frakcio", null, "Elmaradt: " + o.type.label, "Nem volt elég erőforrásod a feldolgozáskor.", "warn"));
                continue;
            }
            p.pp -= c.pp(); p.arany -= c.arany(); p.bp -= c.bp(); p.ke -= c.ke();
            all.add(o);
        }
        all.addAll(NpcBrain.plan(s, r));

        // 4.1 Megszilárdítás
        Set<String> consolidated = new HashSet<>();
        for (OrderSpec o : all) if (o.type == ActionType.CONSOLIDATE) consolidated.add(o.playerId + "@" + o.city + "|" + o.faction.id());

        // 4.3 Lejáratás
        for (OrderSpec o : all) {
            if (o.type != ActionType.SMEAR || o.targetId == null) continue;
            Share tgt = s.fac(o.city, o.faction).get(o.targetId);
            if (tgt == null || o.targetId.equals(o.playerId)) continue;
            double loss = Rules.SMEAR * s.stability.get(o.city).hostileMultiplier;
            boolean guarded = consolidated.contains(o.targetId + "@" + o.city + "|" + o.faction.id());
            if (guarded) loss /= 2;
            tgt.open = Math.max(0, tgt.open - loss);
            int roll = 1 + r.nextInt(6);
            boolean exposed = roll == 1 || (guarded && roll <= 2);
            PlayerState attacker = s.players.get(o.playerId), target = s.players.get(o.targetId);
            String where = s.map.nodeName(o.city) + ", " + o.faction.label();
            if (!attacker.npc) {
                reports.add(new ReportOut(attacker.id, "frakcio", null, "Lejáratás: " + where,
                    target.name + " " + fmt(loss) + " pontot veszített. " + (exposed ? "Ügynökeid lebuktak: a sértett fél megtudta, ki állt a háttérben." : "Senki sem sejti, honnan jött a pletyka."),
                    exposed ? "danger" : "ok"));
                if (exposed) bumpSuspicion(s, attacker.id, o.city, o.faction);
            }
            if (!target.npc) {
                reports.add(new ReportOut(target.id, "kem", exposed ? "eros" : "gyenge", "Rágalmak: " + s.map.nodeName(o.city),
                    exposed ? attacker.name + " emberei rágalmakat terjesztettek rólad a " + o.faction.label() + " körében. Tetten érték őket."
                            : "Valaki rossz hírét kelti a házadnak a " + o.faction.label() + " körében.", "warn"));
            }
        }

        // 4.4 Nyereség (5.2, 5.3)
        Map<String, List<Claim>> claims = new LinkedHashMap<>();
        Map<String, Double> stacked = new HashMap<>(); // ugyanazon frakcióba adott több akció csökkenő hozama egymásra épül
        for (OrderSpec o : all) {
            if (!o.type.isGain()) continue;
            if (o.type.needsPresence) {
                Share own = s.fac(o.city, o.faction).get(o.playerId);
                if (own == null || own.open < Rules.T_JELENLET) continue;
            }
            PlayerState p = s.players.get(o.playerId);
            Share mine = s.fac(o.city, o.faction).get(p.id);
            double mods = 1;
            if (o.faction == p.bonusFaction) mods *= Rules.BACKGROUND_BONUS;
            int sus = s.suspicionOf(p.id, o.city, o.faction);
            mods *= sus == 1 ? 0.75 : sus >= 2 ? 0.5 : 1;
            mods *= s.stability.get(o.city).gainMultiplier;
            String sk = p.id + "|" + o.city + "|" + o.faction.id();
            double already = stacked.getOrDefault(sk, 0.0);
            double g = Rules.gain(o.type.power, (mine == null ? 0 : mine.total()) + already, mods);
            stacked.put(sk, already + g);
            claims.computeIfAbsent(o.city + "|" + o.faction.id(), k -> new ArrayList<>()).add(new Claim(p.id, g, o.hidden, o));
        }
        // Kereskedelmi útvonal passzív hozama (4.7)
        for (PlayerState p : s.players.values()) {
            if (p.npc) continue;
            Map<String, Integer> net = Network.of(s, p.id);
            for (Edge e : s.routesOf(p.id)) for (String n : List.of(e.a(), e.b())) {
                if (s.map.isCity(n) && net.containsKey(n))
                    claims.computeIfAbsent(n + "|" + Faction.KERESKEDOK.id(), k -> new ArrayList<>()).add(new Claim(p.id, 1, false, null));
            }
        }
        Map<String, Double> gainsByPlayerKey = new HashMap<>();
        for (Map.Entry<String, List<Claim>> ce : claims.entrySet()) {
            String[] k = ce.getKey().split("\\|");
            Map<String, Share> fac = s.fac(k[0], Faction.of(k[1]));
            double want = ce.getValue().stream().mapToDouble(Claim::gain).sum();
            double fromNeutral = Math.min(Levels.neutral(fac), want);
            for (Claim c : ce.getValue()) {
                double got = want > 0 ? fromNeutral * (c.gain / want) : 0;
                double rest = c.gain - got;
                if (rest > 0.01) {
                    double rivalTotal = 0;
                    for (Map.Entry<String, Share> e : fac.entrySet()) if (!e.getKey().equals(c.player)) rivalTotal += e.getValue().total();
                    double take = Math.min(rivalTotal, rest * Rules.RIVAL_EFFICIENCY);
                    if (take > 0) for (Map.Entry<String, Share> e : fac.entrySet()) {
                        if (e.getKey().equals(c.player)) continue;
                        Share x = e.getValue(); double t = x.total(); if (t <= 0) continue;
                        double part = take * (t / rivalTotal), fromHidden = Math.min(x.hidden, part * (x.hidden / t));
                        x.hidden -= fromHidden; x.open = Math.max(0, x.open - (part - fromHidden));
                    }
                    got += take;
                }
                Share mine = fac.computeIfAbsent(c.player, x -> new Share(0, 0));
                if (c.hidden) mine.hidden += got; else mine.open += got;
                if (c.order != null) c.order.result = got;
                if (!c.hidden) gainsByPlayerKey.merge(c.player + "|" + ce.getKey(), got, Double::sum);
            }
        }
        for (OrderSpec o : all) {
            if (Double.isNaN(o.result)) continue;
            PlayerState p = s.players.get(o.playerId);
            if (p.npc) continue;
            reports.add(new ReportOut(p.id, "frakcio", null,
                s.map.nodeName(o.city) + ", " + o.faction.label() + ": +" + fmt(o.result) + (o.hidden ? " rejtett" : ""),
                (o.hidden ? "Álnéven, közvetítőkön át. " : "") + flavor(o.type, r), "ok"));
        }

        // 4.9 Útvonalak kiépítése (a kör végén aktiválódik)
        for (OrderSpec o : all) {
            if (o.type != ActionType.ROUTE) continue;
            Map<String, Integer> net = Network.of(s, o.playerId);
            if (Network.owns(s, o.playerId, o.from, o.to) || !(net.containsKey(o.from) || net.containsKey(o.to))) continue;
            s.routesOf(o.playerId).add(new Edge(o.from, o.to));
            reports.add(new ReportOut(o.playerId, "diplomacia", null, "Új útvonal: " + s.map.nodeName(o.from) + " → " + s.map.nodeName(o.to),
                "A karavánút megnyílt. " + s.map.nodeName(o.to) + " mostantól a hálózatod része.", "ok"));
        }

        // 4.6 Romlás (7.1)
        Map<String, Map<String, Integer>> nets = new HashMap<>();
        for (PlayerState p : s.players.values()) if (!p.npc) nets.put(p.id, Network.of(s, p.id));
        for (Map.Entry<String, EnumMap<Faction, Map<String, Share>>> ce : s.influence.entrySet()) {
            String city = ce.getKey();
            Stability st = s.stability.get(city);
            for (Map.Entry<Faction, Map<String, Share>> fe : ce.getValue().entrySet()) {
                for (Map.Entry<String, Share> pe : fe.getValue().entrySet()) {
                    PlayerState p = s.players.get(pe.getKey());
                    Share x = pe.getValue();
                    boolean human = p != null && !p.npc;
                    Integer dist = human ? nets.get(p.id).get(city) : Integer.valueOf(1);
                    double base = Rules.DECAY_PER_DISTANCE * Math.max(0, (dist == null ? 3 : dist) - 1) + st.extraDecay;
                    if (human && s.suspicionOf(p.id, city, fe.getKey()) >= 2) base += Rules.DECAY_SUSPICION2;
                    boolean cut = human && dist == null && x.open > 0;
                    double dOpen = Math.min(Rules.DECAY_CAP, Rules.DECAY_OPEN + base) * (cut ? 2 : 1);
                    double dHidden = Math.min(Rules.DECAY_CAP, Rules.DECAY_HIDDEN + base) * (cut ? 2 : 1);
                    x.open = round2(x.open * (1 - dOpen));
                    x.hidden = round2(x.hidden * (1 - dHidden));
                }
                fe.getValue().values().removeIf(x -> x.total() < 0.05);
            }
        }

        // 4.7 Gyanú (9.3)
        for (Map.Entry<String, Double> g : gainsByPlayerKey.entrySet()) {
            if (g.getValue() < Rules.SUSPICION_GAIN_THRESHOLD) continue;
            String[] k = g.getKey().split("\\|");
            PlayerState p = s.players.get(k[0]);
            if (p == null || p.npc) continue;
            Faction f = Faction.of(k[2]);
            bumpSuspicion(s, p.id, k[1], f);
            reports.add(new ReportOut(p.id, "frakcio", null, "Gyanakodnak rád: " + s.map.nodeName(k[1]) + ", " + f.label(),
                "Túl gyorsan nőtt a befolyásod. A frakció óvatosabban fogadja a közeledésedet.", "warn"));
        }
        for (Suspicion v : s.suspicion.values()) if (v.value > 0 && s.round - v.lastRound >= 2) { v.value -= 1; v.lastRound = s.round; }

        // Szintváltozások
        Map<String, Map<String, Levels.Level>> after = snapshot(s);
        for (Map.Entry<String, Map<String, Levels.Level>> pe : after.entrySet()) {
            for (Map.Entry<String, Levels.Level> le : pe.getValue().entrySet()) {
                Levels.Level was = before.getOrDefault(pe.getKey(), Map.of()).getOrDefault(le.getKey(), Levels.Level.NONE);
                if (was == le.getValue()) continue;
                boolean up = le.getValue().rank > was.rank;
                String[] k = le.getKey().split("\\|");
                reports.add(new ReportOut(pe.getKey(), "frakcio", null,
                    (up ? "Előreléptél: " : "Visszaestél: ") + s.map.nodeName(k[0]) + ", " + Faction.of(k[1]).label(),
                    "Új szinted: " + le.getValue().label() + ".", up ? "ok" : "warn"));
            }
        }

        // 4.8 Jutalmak és bevétel (10. fejezet)
        for (PlayerState p : s.players.values()) {
            int legit = 0, arany = Rules.INCOME_ARANY, bp = Rules.INCOME_BP, ke = Rules.INCOME_KE;
            for (String city : s.influence.keySet()) {
                int doms = 0;
                for (Faction f : Faction.values()) {
                    if (p.id.equals(Levels.dominant(s.fac(city, f)))) {
                        doms++;
                        legit += f == Faction.NEMESSEG ? 3 : 1;
                        if (f == Faction.NEMESSEG) bp += 2;
                        if (f == Faction.KERESKEDOK) arany += 4;
                        if (f == Faction.KATONASAG) ke += 1;
                    } else if (Levels.level(s, city, f, p.id) == Levels.Level.PARTNER) {
                        if (f == Faction.NEMESSEG) bp += 1;
                        if (f == Faction.KERESKEDOK) arany += 2;
                    }
                }
                boolean key = s.map.city(city).map(c -> c.key()).orElse(false);
                if (doms >= 2) legit += (int) Math.ceil((doms == 3 ? 8 : 5) * (key ? 1.5 : 1));
            }
            p.legit += legit;
            if (p.npc) continue;
            int routes = s.routesOf(p.id).size();
            p.arany += arany - routes * Rules.ROUTE_UPKEEP + routes;
            p.bp += bp;
            p.ke = Math.min(Rules.KE_MAX, p.ke + ke);
            p.pp = Math.min(Rules.PP_MAX, p.pp + Rules.PP_PER_ROUND);
            reports.add(new ReportOut(p.id, "esemeny", null, "A " + s.round + ". kör lezárult",
                "Bevétel: +" + arany + " arany (fenntartás −" + routes + ", kereskedelmi hozam +" + routes + "), +" + bp + " BP, +" + ke + " KE, +" + legit + " Legitimitás.", "info"));
        }

        // 4.10 Városi esemény (9.6, egyszerűsítve)
        if (1 + r.nextInt(6) >= 5) {
            List<String> cities = new ArrayList<>(s.influence.keySet());
            String city = cities.get(r.nextInt(cities.size()));
            int ev = 1 + r.nextInt(6);
            Stability st = s.stability.get(city);
            String name = s.map.nodeName(city);
            ReportOut news = null;
            if (ev <= 2 && st != Stability.LAZONGO) {
                s.stability.put(city, st.worse());
                news = new ReportOut(null, "esemeny", null, "Zavargás: " + name, "Az utcákon elégedetlen tömeg gyűlt össze. A város stabilitása romlott.", "warn");
            } else if (ev >= 5 && st != Stability.STABIL) {
                s.stability.put(city, st.better());
                news = new ReportOut(null, "esemeny", null, "Nyugalom: " + name, "A piacok újra megteltek, a város lecsillapodott.", "ok");
            }
            if (news != null) for (PlayerState p : s.players.values()) if (!p.npc) reports.add(new ReportOut(p.id, news.kind(), null, news.title(), news.text(), news.tone()));
        }

        s.orders.clear();
        s.round += 1;
        return reports;
    }

    static void bumpSuspicion(EngineState s, String player, String city, Faction f) {
        Suspicion cur = s.suspicion.computeIfAbsent(EngineState.susKey(player, city, f), k -> new Suspicion(0, s.round));
        cur.value += 1;
        cur.lastRound = s.round;
        if (cur.value >= 3) {
            Share x = s.fac(city, f).get(player);
            if (x != null) { x.open /= 2; x.hidden /= 2; }
            cur.value = 1;
        }
    }

    private static Map<String, Map<String, Levels.Level>> snapshot(EngineState s) {
        Map<String, Map<String, Levels.Level>> out = new HashMap<>();
        for (PlayerState p : s.players.values()) {
            if (p.npc) continue;
            Map<String, Levels.Level> m = new HashMap<>();
            for (String city : s.influence.keySet()) for (Faction f : Faction.values()) m.put(city + "|" + f.id(), Levels.level(s, city, f, p.id));
            out.put(p.id, m);
        }
        return out;
    }

    private static String flavor(ActionType t, RandomGenerator r) {
        String[] list = switch (t) { case PATRON -> FLAVOR_PATRON; case GRANT -> FLAVOR_GRANT; case COUNCIL -> FLAVOR_COUNCIL; case GUARD -> FLAVOR_GUARD; default -> new String[] { "Az akció lezárult." }; };
        return list[r.nextInt(list.length)];
    }

    static double round2(double v) { return Math.round(v * 100) / 100.0; }

    public static String fmt(double v) { return String.format(Locale.ROOT, "%.1f", v).replace('.', ','); }
}
