import 'package:tron_api/tron_api.dart';

import '../../core/tr.dart';
import 'extensions.dart';

/// Computed values of the city view (pure functions on the generated models). CityState getters and
/// CityService build on these; widgets only display the result.

/// The city view's three districts: Marketplace, Town Hall, Underworld.
const cityDistricts = ['trade', 'politics', 'espionage'];

/// District from the URL; Marketplace if unknown or missing.
String cityDistrict(String? d) => cityDistricts.contains(d) ? d! : 'trade';

/// "In N settlements" or "at the next settlement".
Tr electionText(int n) => n <= 1 ? const Tr('city.election_next') : Tr('city.election_in', {'n': '$n'});

/// Popularity effect with sign: „+3”, „0”, „−1”.
String popDelta(int v) => v > 0 ? '+$v' : (v < 0 ? '−${-v}' : '0');

/// A chip in the city header (StatChip).
typedef CityStat = ({Tr label, Tr value, Tr? suffix, String? tone, String art});

/// What the spy network can do with a news item: nothing, verify it, or (if proven false) debunk it.
enum NewsCheck { none, verify, debunk }

extension CityGameX on GameState {
  /// The city to show: the requested one if it exists; else the one selected on the map; else the first reachable, or the first.
  String? cityFor(String? requested, String? selected) {
    bool has(String? id) => id != null && cities.any((c) => c.id == id);
    if (has(requested)) return requested;
    if (has(selected)) return selected;
    return cities.where((c) => c.reachable).firstOrNull?.id ?? cities.firstOrNull?.id;
  }

  /// Header chips: popularity, tax, election, campaign period.
  List<CityStat> cityStats(CityView cv) => [
        (label: const Tr('city.stat.popularity'), value: Tr.raw('${cv.myPop.round()}'), suffix: null, tone: cv.lowPop(rules) ? 'warn' : null, art: 'popularity'),
        (label: const Tr('city.stat.tax'), value: Tr.raw('${cv.taxPercent}%'), suffix: null, tone: null, art: 'tax'),
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

  /// Tincture of the district banners: Marketplace – most shares, Town Hall – most council seats,
  /// Underworld – your own house, if you have spies here.
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
    return {'trade': topS?.$1.tincture, 'politics': topP?.house.tincture, 'espionage': cv.mySpies > 0 ? me.tincture : null};
  }

  /// Routes buildable to this city.
  List<Buildable> routesTo(String cityId) => buildable.where((b) => b.to == cityId).toList();

  /// Buyout threats against your own goods in the city.
  List<Threat> threatsIn(String cityId) => threats.where((t) => t.cityId == cityId).toList();

  /// True if the defensive buy against the threat is only in the draft (not sealed yet).
  /// OrderView doesn't reference the offer, so we filter by city.
  bool defendOnlyInDraft(Threat t) => draft.any((o) => o.type == 'defend' && o.cityId == t.cityId) && !(sheet?.orders.any((o) => o.type == 'defend' && o.cityId == t.cityId) ?? false);

  /// Where a spy can move from here (7.1): the other cities of your network.
  List<CityView> spyDestinations(String fromCity) => cities.where((x) => x.reachable && x.id != fromCity).toList();

  /// Who an intel can be sold to: not you, and not the one whose plan it is.
  List<HouseRef> intelBuyers(IntelView it) => houses.where((h) => !h.self && h.playerId != it.of_.playerId).toList();
}

extension CityViewCityX on CityView {
  /// Free (not guarding) spies.
  int get freeSpies => (mySpies - myGuards).clamp(0, 99);

  bool lowPop(RulesInfo r) => myPop < r.lowPopThreshold;

  /// Whether the city is full of spies (with respect to your own spies).
  bool spiesFull(RulesInfo r) => mySpies >= r.spiesPerCity;

  /// Parties in descending order of votes.
  List<PartyView> get partiesByVotes => [...parties]..sort((a, b) => b.votes.compareTo(a.votes));

  /// Verifiable news: not your own and not yet debunked (at most 6).
  List<NewsView> get checkable => news.where((n) => !n.mine && !n.debunked).take(6).toList();

  /// What the spy network offers for this news item (in a reachable city, with at least one spy).
  NewsCheck newsCheck(NewsView n) {
    if (!reachable || mySpies < 1 || n.mine || n.debunked) return NewsCheck.none;
    if (n.verified == false) return NewsCheck.debunk;
    return n.verified == null ? NewsCheck.verify : NewsCheck.none;
  }
}

extension GoodViewCityX on GoodView {
  /// Sellers: houses in descending order of shares, then the City (only those with shares).
  List<Seller> get sortedSellers => [
        ...(sellers.where((x) => !x.city && x.shares > 0).toList()..sort((a, b) => b.shares.compareTo(a.shares))),
        ...sellers.where((x) => x.city && x.shares > 0),
      ];
}

/// Computed state of a good's card: sellers, rivals open to buyout, valid points and costs.
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

  /// [buyPts], [boPts], [target]: the user's choice; the plan clamps them to the allowed range.
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

  /// Rivals open to buyout: not you, and not protected.
  final List<Seller> rivals;
  final Seller? target;
  final int buyMax, buyPts, buyCost, boMax, boPts, boCost;

  bool get canBuy => buyMax >= 1;
  String? get targetId => target?.house?.playerId;

  /// Options of the point pickers (at least 1).
  List<int> get buyOptions => [for (var i = 1; i <= (buyMax < 1 ? 1 : buyMax); i++) i];
  List<int> get boOptions => [for (var i = 1; i <= (boMax < 1 ? 1 : boMax); i++) i];

  /// Indexes of your own rows in the sellers table.
  Set<int> get selfRows => {
        for (var i = 0; i < sellers.length; i++)
          if (sellers[i].house?.self == true) i,
      };
}

/// Computed state of the news editor: template, target, the target's goods and whether it can be submitted.
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

  /// Who news can be spread about: the other houses present in the city.
  final List<HouseRef> targets;
  final HouseRef? target;

  /// The target's goods in this city (for good-related claims).
  final List<GoodView> goods;
  final GoodView? good;

  bool get needsGood => template?.needsGood ?? false;
  bool get ok => template != null && target != null && (!needsGood || good != null);

  /// For a good-related claim, the target sells nothing here.
  bool get targetSellsNothing => !ok && needsGood && target != null;

  /// The good to submit (only if the claim needs one).
  String? get goodId => needsGood ? good?.id : null;

  /// The news has a negative effect (the button is destructive).
  bool get harmful => (template?.effect ?? 0) < 0;

  /// The template's label in the picker: „{t}” → X, „{g}” → ….
  static String label(String l) => l.replaceAll('{t}', 'X').replaceAll('{g}', '…');
}
