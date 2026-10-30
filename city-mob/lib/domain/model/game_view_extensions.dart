import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/tr.dart';
import '../../util/format.dart';
import 'extensions.dart';

/// Computed values of the game tabs (frame, Map, Order sheet, Reports, Ranking). Widgets
/// display these; `now` is always the game clock (GameViewState.now).

/// A row in the Ranking's "Your popularity" table.
class PopularityRow extends Equatable {
  const PopularityRow({required this.name, required this.pop, required this.seats});
  final String name;
  final int pop, seats;

  @override
  List<Object?> get props => [name, pop, seats];
}

/// Filter of the report cards.
enum ReportFilter {
  all,
  own,
  public;

  /// Label of the filter button.
  String get label => 'reports.filter.$name'.tr();

  bool accepts(ReportView r) => switch (this) {
        ReportFilter.all => true,
        ReportFilter.own => !r.isPublic,
        ReportFilter.public => r.isPublic,
      };
}

/// Order sheet badge: „9+” above 9, none at 0.
String? badgeText(int n) => n <= 0 ? null : (n > 9 ? '9+' : '$n');

extension GameViewX on GameState {
  /// Maturation time as text („1 ó 30 p”).
  String get maturationText => durText(Duration(minutes: clock.maturationMinutes));

  /// Whether the sealed sheet is still maturing.
  bool maturing(DateTime now) => sheet != null && now.isBefore(sheet!.executeAt);

  /// Maturation progress of the sealed sheet, 0..1.
  double sheetProgress(DateTime now) {
    final l = sheet;
    if (l == null) return 1;
    final a = l.sealedAt, b = l.executeAt;
    if (!b.isAfter(a)) return 1;
    return (now.difference(a).inSeconds / b.difference(a).inSeconds).clamp(0.0, 1.0);
  }

  /// The draft needs more PP than available.
  bool get overBudget => draftCost.pp > me.pp;

  /// The draft needs more gold than the treasury holds.
  bool get overGold => draftCost.gold > me.gold;

  /// Whether the draft can be sealed: fits the PP, and no previous sheet is maturing.
  bool canSeal(DateTime now) => draft.isNotEmpty && !overBudget && !maturing(now);

  /// Whether the settlement is within an hour (the header timer is highlighted).
  bool settlementSoon(DateTime now) => clock.nextSettlementAt.difference(now).inMinutes <= 60;

  /// The defensive buy against the threat is only in the draft (not sealed yet).
  /// OrderView doesn't reference the offer, so we filter by city.
  bool defendOnlyInDraft(Threat t) =>
      draft.any((o) => o.type == 'defend' && o.cityId == t.cityId) && !(sheet?.orders.any((o) => o.type == 'defend' && o.cityId == t.cityId) ?? false);

  /// Routes buildable to the selected city.
  List<Buildable> buildableTo(String cityId) => buildable.where((b) => b.to == cityId).toList();

  /// Ranking header: "after settlement 3 · election in 2 settlements".
  Tr get rankingCaption => clock.nextElectionIn <= 1
      ? Tr('ranking.caption_next', {'n': '${clock.settlements}'})
      : Tr('ranking.caption', {'n': '${clock.settlements}', 'm': '${clock.nextElectionIn}'});

  /// Rows of the "Your popularity" table, per city.
  List<PopularityRow> get popularityRows => [for (final c in cities) PopularityRow(name: c.name, pop: c.myPop.round(), seats: c.mySeats)];

  /// When this changes, there may be new reports and a new ranking (settlement, executed sheet, new intel or offer);
  /// Reports and Ranking reload then.
  String get feedKey => '$gameId|${clock.settlements}|${sheet?.id}|${intel.length}|${offers.length}';
}

extension CityCardX on CityView {
  /// Label of the map's city card: profile, key city, distance.
  String get cardEyebrow => [profile, if (key) 'map.key_city'.tr(), if (reachable && distance != null) 'map.distance'.tr(namedArgs: {'n': '$distance'})].join(' · ');
}

extension BuildableX on Buildable {
  /// Route-building order.
  OrderRequest get order => OrderRequest(type: 'route', from: from, to: to);
}

extension OrderViewX on OrderView {
  /// Bottom line of an order sheet row: city · branch.
  String get meta => [?cityName, branchName(branch)].join(' · ');

  /// Label of a sheet row: label · city.
  String get sheetLabel => '$label${cityName != null ? ' · $cityName' : ''}';
}

extension CostX on Cost {
  /// „2 [pp] · 30 [gold]” (unit markers, rendered as icons by UnitText).
  String get text => [if (pp > 0) 'orders.cost_pp'.tr(namedArgs: {'pp': '$pp'}), if (gold > 0) 'orders.cost_gold'.tr(namedArgs: {'gold': '$gold'})].join(' · ');
}

/// "In N settlements" or "at the next settlement".
String electionText(int n) => n <= 1 ? 'ranking.election_next'.tr() : 'ranking.election_in'.tr(namedArgs: {'n': '$n'});
