import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/tr.dart';
import '../../util/format.dart';
import 'extensions.dart';

/// A játék füleinek (keret, Térkép, Parancslap, Jelentések, Rangsor) számolt értékei. A widgetek ezeket
/// jelenítik meg; a `now` mindig a játék órája (GameViewState.now).

/// Egy sor a Rangsor „Népszerűséged” táblájában.
class PopularityRow extends Equatable {
  const PopularityRow({required this.name, required this.pop, required this.seats});
  final String name;
  final int pop, seats;

  @override
  List<Object?> get props => [name, pop, seats];
}

/// A jelentéskártyák szűrője.
enum ReportFilter {
  mind,
  sajat,
  nyilvanos;

  /// A szűrő gombjának felirata.
  String get label => 'reports.filter.$name'.tr();

  bool accepts(ReportView r) => switch (this) {
        ReportFilter.mind => true,
        ReportFilter.sajat => !r.isPublic,
        ReportFilter.nyilvanos => r.isPublic,
      };
}

/// A Parancslap jelvénye: „9+” fölött, 0-nál nincs.
String? badgeText(int n) => n <= 0 ? null : (n > 9 ? '9+' : '$n');

extension GameViewX on GameState {
  /// Az érlelési idő szövegesen („1 ó 30 p”).
  String get maturationText => durText(Duration(minutes: clock.maturationMinutes));

  /// Érlelődik-e még a lepecsételt lap.
  bool maturing(DateTime now) => lap != null && now.isBefore(lap!.executeAt);

  /// A lepecsételt lap érlelésének készültsége 0..1 között.
  double lapProgress(DateTime now) {
    final l = lap;
    if (l == null) return 1;
    final a = l.sealedAt, b = l.executeAt;
    if (!b.isAfter(a)) return 1;
    return (now.difference(a).inSeconds / b.difference(a).inSeconds).clamp(0.0, 1.0);
  }

  /// A vázlat PP-igénye több a rendelkezésre állónál.
  bool get overBudget => draftCost.pp > me.pp;

  /// A vázlat aranyigénye több a kasszánál.
  bool get overGold => draftCost.gold > me.gold;

  /// Lepecsételhető-e a vázlat: belefér a PP-be, és nem érlelődik előző lap.
  bool canSeal(DateTime now) => draft.isNotEmpty && !overBudget && !maturing(now);

  /// Egy órán belül jön-e az elszámolás (a fejléc időzítője kiemelt).
  bool settlementSoon(DateTime now) => clock.nextSettlementAt.difference(now).inMinutes <= 60;

  /// A fenyegetés elleni védekező vétel csak a vázlaton van (még nincs lepecsételve).
  /// Az OrderView nem hivatkozik az ajánlatra, ezért városra szűrünk.
  bool defendOnlyInDraft(Threat t) =>
      draft.any((o) => o.type == 'defend' && o.cityId == t.cityId) && !(lap?.orders.any((o) => o.type == 'defend' && o.cityId == t.cityId) ?? false);

  /// A kijelölt városba építhető útvonalak.
  List<Buildable> buildableTo(String cityId) => buildable.where((b) => b.to == cityId).toList();

  /// A Rangsor fejléce: „3. elszámolás után · választás 2 elszámolás múlva”.
  Tr get rankingCaption => clock.nextElectionIn <= 1
      ? Tr('ranking.caption_next', {'n': '${clock.settlements}'})
      : Tr('ranking.caption', {'n': '${clock.settlements}', 'm': '${clock.nextElectionIn}'});

  /// A „Népszerűséged” tábla sorai városonként.
  List<PopularityRow> get popularityRows => [for (final c in cities) PopularityRow(name: c.name, pop: c.myPop.round(), seats: c.mySeats)];

  /// Amikor ez változik, új jelentések és új rangsor lehet (elszámolás, lefutott lap, új hírszerzés vagy ajánlat);
  /// a Jelentések és a Rangsor ekkor tölt újra.
  String get feedKey => '$gameId|${clock.settlements}|${lap?.id}|${intel.length}|${offers.length}';
}

extension CityCardX on CityView {
  /// A térkép városkártyájának felirata: profil, kulcsváros, távolság.
  String get cardEyebrow => [profile, if (key) 'map.key_city'.tr(), if (reachable && distance != null) 'map.distance'.tr(namedArgs: {'n': '$distance'})].join(' · ');
}

extension BuildableX on Buildable {
  /// Útvonalépítés parancsa.
  OrderRequest get order => OrderRequest(type: 'route', from: from, to: to);
}

extension OrderViewX on OrderView {
  /// A parancslap sorának alsó sora: város · ág.
  String get meta => [?cityName, branchName(branch)].join(' · ');

  /// A lap sorának felirata: címke · város.
  String get lapLabel => '$label${cityName != null ? ' · $cityName' : ''}';
}

extension CostX on Cost {
  /// „2 PP · 30 A”.
  String get text => [if (pp > 0) 'orders.cost_pp'.tr(namedArgs: {'pp': '$pp'}), if (gold > 0) 'orders.cost_gold'.tr(namedArgs: {'gold': '$gold'})].join(' · ');
}

/// „N elszámolás múlva” vagy „a következő elszámoláskor”.
String electionText(int n) => n <= 1 ? 'ranking.election_next'.tr() : 'ranking.election_in'.tr(namedArgs: {'n': '$n'});
