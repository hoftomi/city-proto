import 'package:tron_api/tron_api.dart';

import '../../core/tr.dart';
import 'extensions.dart';

/// A városnézet számolt értékei (tiszta függvények a generált modelleken). A CityState getterei és a
/// CityService ezekből dolgozik, a widgetek csak megjelenítik az eredményt.

/// A városnézet három negyede: Vásártér, Városháza, Alvilág.
const cityDistricts = ['keresk', 'polit', 'kem'];

/// Az URL-ből jött negyed; ismeretlen vagy hiányzó negyed esetén a Vásártér.
String cityDistrict(String? d) => cityDistricts.contains(d) ? d! : 'keresk';

/// „N elszámolás múlva” vagy „a következő elszámoláskor”.
Tr electionText(int n) => n <= 1 ? const Tr('city.election_next') : Tr('city.election_in', {'n': '$n'});

/// Népszerűségi hatás előjellel: „+3”, „0”, „−1”.
String popDelta(int v) => v > 0 ? '+$v' : (v < 0 ? '−${-v}' : '0');

/// Egy chip a város fejlécében (StatChip).
typedef CityStat = ({Tr label, Tr value, Tr? suffix, String? tone, String art});

/// Mit tehet a kémhálózat egy hírrel: semmit, ellenőrizheti, vagy (ha hamisnak bizonyult) leleplezheti.
enum NewsCheck { none, verify, debunk }

extension CityGameX on GameState {
  /// A megjelenítendő város: a kért, ha létezik; különben a térképen kijelölt; különben az első elérhető, vagy az első.
  String? cityFor(String? requested, String? selected) {
    bool has(String? id) => id != null && cities.any((c) => c.id == id);
    if (has(requested)) return requested;
    if (has(selected)) return selected;
    return cities.where((c) => c.reachable).firstOrNull?.id ?? cities.firstOrNull?.id;
  }

  /// A fejléc chipjei: népszerűség, adó, választás, kampányidőszak.
  List<CityStat> cityStats(CityView cv) => [
        (label: const Tr('city.stat.popularity'), value: Tr.raw('${cv.myPop.round()}'), suffix: null, tone: cv.lowPop(rules) ? 'warn' : null, art: 'nep'),
        (label: const Tr('city.stat.tax'), value: Tr.raw('${cv.taxPercent}%'), suffix: null, tone: null, art: 'ado'),
        clock.nextElectionIn <= 1
            ? (
                label: const Tr('city.stat.election'),
                value: const Tr('city.stat.election_next'),
                suffix: const Tr('city.stat.election_next_suffix'),
                tone: null,
                art: 'foundParty',
              )
            : (
                label: const Tr('city.stat.election'),
                value: Tr.raw('${clock.nextElectionIn}'),
                suffix: const Tr('city.stat.election_in_suffix'),
                tone: null,
                art: 'foundParty',
              ),
        if (clock.campaign) (label: const Tr('city.stat.campaign'), value: const Tr.raw('×2'), suffix: const Tr('city.stat.campaign_suffix'), tone: 'warn', art: 'festival'),
      ];

  /// A negyedek zászlóinak tinktúrája: Vásártér – legtöbb részesedés, Városháza – legtöbb tanácshely,
  /// Alvilág – a saját házad, ha vannak itt kémeid.
  Map<String, String?> districtDominants(CityView cv) {
    final shares = <String, (HouseRef, int)>{};
    for (final g in cv.goods) {
      for (final x in g.sellers.where((x) => x.house != null)) {
        final prev = shares[x.house!.playerId];
        shares[x.house!.playerId] = (x.house!, (prev?.$2 ?? 0) + x.shares);
      }
    }
    final topS = (shares.values.toList()..sort((a, b) => b.$2.compareTo(a.$2))).firstOrNull;
    final topP = (cv.parties.where((p) => p.seats > 0).toList()..sort((a, b) => b.seats.compareTo(a.seats))).firstOrNull;
    return {'keresk': topS?.$1.tincture, 'polit': topP?.house.tincture, 'kem': cv.mySpies > 0 ? me.tincture : null};
  }

  /// Építhető útvonalak ebbe a városba.
  List<Buildable> routesTo(String cityId) => buildable.where((b) => b.to == cityId).toList();

  /// A városban lévő saját árucikkek elleni kivásárlási fenyegetések.
  List<Threat> threatsIn(String cityId) => threats.where((t) => t.cityId == cityId).toList();

  /// Igaz, ha a fenyegetés elleni védekező vétel csak a vázlaton van (még nincs lepecsételve).
  /// Az OrderView nem hivatkozik az ajánlatra, ezért városra szűrünk.
  bool defendOnlyInDraft(Threat t) => draft.any((o) => o.type == 'defend' && o.cityId == t.cityId) && !(lap?.orders.any((o) => o.type == 'defend' && o.cityId == t.cityId) ?? false);

  /// Ahová kém költözhet innen (7.1): a hálózatod többi városa.
  List<CityView> spyDestinations(String fromCity) => cities.where((x) => x.reachable && x.id != fromCity).toList();

  /// Akiknek egy kifürkészett terv eladható: nem te, és nem az, akinek a terve.
  List<HouseRef> intelBuyers(IntelView it) => houses.where((h) => !h.self && h.playerId != it.of_.playerId).toList();
}

extension CityViewCityX on CityView {
  /// Szabad (nem őrködő) kémek.
  int get freeSpies => (mySpies - myGuards).clamp(0, 99);

  bool lowPop(RulesInfo r) => myPop < r.lowPopThreshold;

  /// Tele van-e a város kémekkel (a saját kémeidre nézve).
  bool spiesFull(RulesInfo r) => mySpies >= r.spiesPerCity;

  /// A pártok szavazat szerint csökkenő sorrendben.
  List<PartyView> get partiesByVotes => [...parties]..sort((a, b) => b.votes.compareTo(a.votes));

  /// Ellenőrizhető hírek: nem a sajátod és még nincs leleplezve (legfeljebb 6).
  List<NewsView> get checkable => news.where((n) => !n.mine && !n.debunked).take(6).toList();

  /// Mit kínál a kémhálózat ehhez a hírhez (elérhető városban, legalább egy kémmel).
  NewsCheck newsCheck(NewsView n) {
    if (!reachable || mySpies < 1 || n.mine || n.debunked) return NewsCheck.none;
    if (n.verified == false) return NewsCheck.debunk;
    return n.verified == null ? NewsCheck.verify : NewsCheck.none;
  }
}

extension GoodViewCityX on GoodView {
  /// Az eladók: a házak részesedés szerint csökkenő sorrendben, végül a Város (csak akiknek van részesedése).
  List<Seller> get sortedSellers => [
        ...(sellers.where((x) => !x.city && x.shares > 0).toList()..sort((a, b) => b.shares.compareTo(a.shares))),
        ...sellers.where((x) => x.city && x.shares > 0),
      ];
}

/// Egy árucikk kártyájának számolt állapota: eladók, kivásárolható riválisok, érvényes pontok és költségek.
class GoodPlan {
  const GoodPlan._({
    required this.good,
    required this.sellers,
    required this.rivals,
    required this.target,
    required this.buyMax,
    required this.buyPts,
    required this.buyCost,
    required this.boMax,
    required this.boPts,
    required this.boCost,
  });

  /// [buyPts], [boPts], [target]: a felhasználó választása; a terv a megengedett tartományba szorítja őket.
  factory GoodPlan.of(GoodView g, RulesInfo r, {int buyPts = 5, int boPts = 5, String? target}) {
    final sellers = g.sortedSellers;
    final rivals = sellers.where((x) => x.house != null && !x.house!.self && !x.protectedNow).toList();
    final tgt = rivals.where((x) => x.house!.playerId == target).firstOrNull ?? rivals.firstOrNull;
    final buyMax = g.cityShares.clamp(0, r.maxSharesPerOrder);
    final buy = buyPts.clamp(1, buyMax < 1 ? 1 : buyMax);
    final boMax = tgt == null ? 0 : tgt.shares.clamp(0, r.maxSharesPerOrder);
    final bo = boPts.clamp(1, boMax < 1 ? 1 : boMax);
    return GoodPlan._(
      good: g,
      sellers: sellers,
      rivals: rivals,
      target: tgt,
      buyMax: buyMax,
      buyPts: buy,
      buyCost: r.cityShareCost * buy,
      boMax: boMax,
      boPts: bo,
      boCost: (g.marketValue * bo * r.buyoutPremiumPercent / 100).ceil(),
    );
  }

  final GoodView good;
  final List<Seller> sellers;

  /// Kivásárolható riválisok: nem te, és nem védett.
  final List<Seller> rivals;
  final Seller? target;
  final int buyMax, buyPts, buyCost, boMax, boPts, boCost;

  bool get canBuy => buyMax >= 1;
  String? get targetId => target?.house?.playerId;

  /// A pontválasztók lehetőségei (legalább 1).
  List<int> get buyOptions => [for (var i = 1; i <= (buyMax < 1 ? 1 : buyMax); i++) i];
  List<int> get boOptions => [for (var i = 1; i <= (boMax < 1 ? 1 : boMax); i++) i];

  /// A saját sorok indexei az eladók táblázatában.
  Set<int> get selfRows => {
        for (var i = 0; i < sellers.length; i++)
          if (sellers[i].house?.self == true) i,
      };
}

/// A hírszerkesztő számolt állapota: sablon, célpont, a célpont árucikkei és hogy beküldhető-e.
class NewsPlan {
  const NewsPlan._({required this.template, required this.targets, required this.target, required this.goods, required this.good});

  factory NewsPlan.of(Catalog cat, CityView cv, {String? template, String? target, String? good}) {
    final t = cat.template(template) ?? cat.news.firstOrNull;
    final targets = cv.present.where((h) => !h.self).toList();
    final tgt = targets.where((h) => h.playerId == target).firstOrNull ?? targets.firstOrNull;
    final goods = tgt == null ? <GoodView>[] : cv.goods.where((g) => g.sellers.any((x) => x.house?.playerId == tgt.playerId)).toList();
    final gsel = goods.where((g) => g.id == good).firstOrNull ?? goods.firstOrNull;
    return NewsPlan._(template: t, targets: targets, target: tgt, goods: goods, good: gsel);
  }

  final NewsTemplateInfo? template;

  /// Akikről hír terjeszthető: a városban jelen lévő többi ház.
  final List<HouseRef> targets;
  final HouseRef? target;

  /// A célpont árucikkei ebben a városban (az árucikkes állításokhoz).
  final List<GoodView> goods;
  final GoodView? good;

  bool get needsGood => template?.needsGood ?? false;
  bool get ok => template != null && target != null && (!needsGood || good != null);

  /// Árucikkes állításnál a célpont itt nem árul semmit.
  bool get targetSellsNothing => !ok && needsGood && target != null;

  /// A beküldendő árucikk (csak ha az állításhoz kell).
  String? get goodId => needsGood ? good?.id : null;

  /// Negatív hatású a hír (a gomb vészjelző).
  bool get harmful => (template?.effect ?? 0) < 0;

  /// A sablon felirata a választóban: „{t}” → X, „{g}” → ….
  static String label(String l) => l.replaceAll('{t}', 'X').replaceAll('{g}', '…');
}
