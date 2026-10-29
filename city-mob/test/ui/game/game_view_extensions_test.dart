import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/core/tr.dart';
import 'package:tron_nelkul/domain/model/game_view_extensions.dart';

import '../../helpers/l10n.dart';

GameState _state() => GameState.fromJson(jsonDecode(File('test/fixtures/game_state.json').readAsStringSync()) as Map<String, dynamic>);

void main() {
  setUpAll(loadTestTranslations);
  final s = _state();
  final sealed = DateTime.utc(2026, 9, 4, 9, 30), exec = DateTime.utc(2026, 9, 4, 11, 30);

  test('sheet maturing: progress and state', () {
    expect(s.maturing(sealed), isTrue);
    expect(s.sheetProgress(sealed), 0);
    expect(s.sheetProgress(DateTime.utc(2026, 9, 4, 10, 30)), closeTo(0.5, 1e-9));
    expect(s.sheetProgress(DateTime.utc(2026, 9, 4, 13)), 1);
    expect(s.maturing(exec), isFalse);
  });

  test('sealable: only if no sheet is maturing and it fits the PP', () {
    expect(s.canSeal(sealed), isFalse);
    expect(s.canSeal(exec), isTrue);
    final poor = s.copyWith(me: s.me.copyWith(pp: 3));
    expect(poor.overBudget, isTrue);
    expect(poor.canSeal(exec), isFalse);
    expect(s.overGold, isFalse);
  });

  test('texts: maturation, ranking caption, card label, cost, row meta', () {
    expect(s.maturationText, '2 ó');
    expect(s.rankingCaption, const Tr('ranking.caption', {'n': '6', 'm': '6'}));
    expect(s.rankingCaption.text, '6. elszámolás után · választás 6 elszámolás múlva');
    expect(s.copyWith(clock: s.clock.copyWith(nextElectionIn: 1)).rankingCaption, const Tr('ranking.caption_next', {'n': '6'}));
    expect(s.cities.first.cardEyebrow, 'Gabonavidék · 1 lépés');
    expect(s.cities[2].cardEyebrow, 'Kikötőváros · kulcsváros');
    expect(Cost(pp: 2, gold: 0).text, '2 PP');
    expect(Cost(pp: 1, gold: 3).text, '1 PP · 3 A');
    expect(s.draft.first.meta, 'Szélmező · Városháza');
    expect(s.sheet!.orders.first.meta, 'Közös');
    expect(s.sheet!.orders.first.sheetLabel, 'Útvonal kiépítése: Szélmező → Feketerév');
    expect(electionText(1), 'a következő elszámoláskor');
    expect(electionText(3), '3 elszámolás múlva');
  });

  test('badge, route order, popularity, filter', () {
    expect(badgeText(0), isNull);
    expect(badgeText(3), '3');
    expect(badgeText(12), '9+');
    final b = s.buildableTo('vaskapu');
    expect(b.map((e) => e.from), ['szelmezo']);
    final o = b.single.order;
    expect((o.type, o.from, o.to), ('route', 'szelmezo', 'vaskapu'));
    expect(s.popularityRows.first, const PopularityRow(name: 'Szélmező', pop: 10, seats: 5));
    final pub = ReportView(id: '1', round: 1, kind: 'spy', confidence: null, title: 't', text: 'x', tone: 'info', createdAt: sealed, isPublic: true);
    expect(ReportFilter.public.accepts(pub), isTrue);
    expect(ReportFilter.own.accepts(pub), isFalse);
    expect(ReportFilter.all.accepts(pub), isTrue);
    expect(ReportFilter.values.map((f) => f.label), ['Mind', 'Saját', 'Nyilvános']);
  });

  test('defense only in the draft', () {
    final t = s.threats.single;
    expect(s.defendOnlyInDraft(t), isFalse);
    final d = s.copyWith(draft: [
      ...s.draft,
      OrderView(id: 'd', type: 'defend', branch: 'trade', label: 'Védekezés', cityId: 'szelmezo', cityName: 'Szélmező', cost: Cost(pp: 1, gold: 62), warning: null),
    ]);
    expect(d.defendOnlyInDraft(t), isTrue);
  });

  test('feedKey changes only on settlement, sheet change, new intel or offer', () {
    expect(s.copyWith(draft: const []).feedKey, s.feedKey);
    expect(s.copyWith(clock: s.clock.copyWith(settlements: 7)).feedKey, isNot(s.feedKey));
  });
}
