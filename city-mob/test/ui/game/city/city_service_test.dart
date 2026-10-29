import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/core/tr.dart';
import 'package:tron_nelkul/domain/model/city_extensions.dart';
import 'package:tron_nelkul/domain/model/extensions.dart';
import 'package:tron_nelkul/domain/service/city_service.dart';

GameState fixtureState() => GameState.fromJson(jsonDecode(File('test/fixtures/game_state.json').readAsStringSync()) as Map<String, dynamic>);

void main() {
  final s = fixtureState();
  final cv = s.city('szelmezo');
  final service = CityService();
  GoodView good(String id) => cv.goods.firstWhere((g) => g.id == id);

  group('city and header', () {
    test('the requested, then the selected, then the first available city', () {
      expect(service.resolveCity(s, 'delkapu', 'szelmezo'), 'delkapu');
      expect(service.resolveCity(s, 'nincs-ilyen', 'delkapu'), 'delkapu');
      expect(service.resolveCity(s, null, null), 'szelmezo');
    });

    test('unknown district: Marketplace', () {
      expect(cityDistrict(null), 'trade');
      expect(cityDistrict('espionage'), 'espionage');
      expect(cityDistrict('xyz'), 'trade');
    });

    test('district flags: most shares, most council seats, own spies', () {
      expect(s.districtDominants(cv), {'trade': 'gold', 'politics': 'blue', 'espionage': 'blue'});
      expect(s.districtDominants(s.city('delkapu'))['espionage'], isNull);
    });

    test('chips: low popularity warns, election in N settlements', () {
      final st = s.cityStats(cv);
      expect(st.length, 3);
      expect(st[0].tone, 'warn');
      expect(st[2], (label: const Tr('city.stat.election'), value: const Tr.raw('6'), suffix: const Tr('city.stat.election_in_suffix'), tone: null, art: 'foundParty'));
      expect(st[0].label, const Tr('city.stat.popularity'));
    });

    test('election text: at the next settlement, or in N settlements', () {
      expect(electionText(1), const Tr('city.election_next'));
      expect(electionText(4), const Tr('city.election_in', {'n': '4'}));
    });

    test('threats in this city', () {
      expect(s.threatsIn('szelmezo').map((t) => t.orderId), ['o100']);
      expect(s.defendOnlyInDraft(s.threats.first), isFalse);
    });
  });

  group('Marketplace', () {
    test('buy from the City: not buyable without free shares', () {
      final p = GoodPlan.of(good('grain'), s.rules);
      expect(p.canBuy, isFalse);
      expect(p.buyOptions, [1]);
      expect(service.buyShares(cv, p), isNull);
    });

    test('buy from the City: points are clamped to the allowed range, cost per point', () {
      final p = GoodPlan.of(good('wine'), s.rules, buyPts: 50);
      expect(p.buyPts, 10);
      expect(p.buyCost, 30);
      expect(service.buyShares(cv, p), OrderRequest(type: 'buyShares', city: 'szelmezo', good: 'wine', pts: 10));
    });

    test('buyout: the largest rival is the default, cost includes the premium', () {
      final g = good('grain');
      final p = GoodPlan.of(g, s.rules);
      expect(p.rivals.map((x) => x.house!.playerId), ['npc0', 'npc2', 'npc3']);
      expect(p.targetId, 'npc0');
      expect(p.boCost, (g.marketValue * 5 * 150 / 100).ceil());
      final q = GoodPlan.of(g, s.rules, target: 'npc2', boPts: 99);
      expect(q.boPts, 10);
      expect(service.buyout(cv, q), OrderRequest(type: 'buyout', city: 'szelmezo', good: 'grain', target: 'npc2', pts: 10));
    });

    test('protected seller cannot be bought out', () {
      final g = good('wine');
      final prot = g.copyWith(sellers: [for (final x in g.sellers) x.copyWith(protectedNow: true)]);
      expect(GoodPlan.of(prot, s.rules).rivals, isEmpty);
      expect(service.buyout(cv, GoodPlan.of(prot, s.rules)), isNull);
    });

    test('defense and route', () {
      expect(service.defend(s, cv, 'o100'), OrderRequest(type: 'defend', city: 'szelmezo', sheetId: 'L101', orderId: 'o100'));
      expect(service.defend(s, cv, 'x'), isNull);
      expect(service.route(s, s.city('vaskapu'), 'szelmezo'), OrderRequest(type: 'route', from: 'szelmezo', to: 'vaskapu'));
      expect(service.route(s, s.city('vaskapu'), 'delkapu'), isNull);
    });

    test('margin only with own shares', () {
      final level = s.catalog.margins.first.id;
      expect(service.margin(s, cv, 'grain', level), OrderRequest(type: 'margin', city: 'szelmezo', good: 'grain', level: level));
      expect(service.margin(s, cv, 'wine', level), isNull);
    });
  });

  group('Town Hall', () {
    test('has a party: program and festival yes, founding no', () {
      expect(service.foundParty(cv), isNull);
      expect(service.festival(cv), OrderRequest(type: 'festival', city: 'szelmezo'));
      expect(service.foundParty(s.city('delkapu')), OrderRequest(type: 'foundParty', city: 'delkapu'));
    });

    test('news editor: defaults and good-specific claim', () {
      final p = NewsPlan.of(s.catalog, cv);
      expect(p.template!.id, 'usury');
      expect(p.targets.map((h) => h.playerId), ['npc0', 'npc2', 'npc3', 'npc1']);
      expect(p.good!.id, 'grain');
      expect(service.news(cv, p), OrderRequest(type: 'news', city: 'szelmezo', template: 'usury', target: 'npc0', good: 'grain'));
    });

    test('news editor: the target sells nothing here', () {
      final p = NewsPlan.of(s.catalog, cv, target: 'npc1');
      expect(p.ok, isFalse);
      expect(p.targetSellsNothing, isTrue);
      expect(service.news(cv, p), isNull);
      final q = NewsPlan.of(s.catalog, cv, template: 'friend', target: 'npc1');
      expect(service.news(cv, q), OrderRequest(type: 'news', city: 'szelmezo', template: 'friend', target: 'npc1'));
      expect(NewsPlan.label('„{t} uzsoraáron árulja: {g}.”'), '„X uzsoraáron árulja: ….”');
    });
  });

  group('Underworld', () {
    test('free spies, hiring, guard', () {
      expect(cv.freeSpies, 2);
      expect(service.hireSpy(s, cv), OrderRequest(type: 'hireSpy', city: 'szelmezo'));
      expect(service.guard(cv), OrderRequest(type: 'guard', city: 'szelmezo'));
      expect(service.guard(s.city('delkapu')), isNull);
      expect(service.hireSpy(s, cv.copyWith(mySpies: 3)), isNull);
    });

    test('moving a spy: only to another, non-full city of the network', () {
      expect(s.spyDestinations('szelmezo').map((c) => c.id), ['delkapu']);
      expect(service.moveSpy(s, cv, 'delkapu'), OrderRequest(type: 'moveSpy', city: 'szelmezo', to: 'delkapu'));
      expect(service.moveSpy(s, cv, 'vaskapu'), isNull);
      expect(service.moveSpy(s, cv.copyWith(myGuards: 2), 'delkapu'), isNull);
      final full = s.copyWith(cities: [for (final c in s.cities) c.id == 'delkapu' ? c.copyWith(mySpies: 3) : c]);
      expect(service.moveSpy(full, full.city('szelmezo'), 'delkapu'), isNull);
    });

    test('spying only against a maturing order sheet', () {
      expect(service.spy(s, cv, 'npc3'), OrderRequest(type: 'spy', city: 'szelmezo', target: 'npc3'));
      expect(service.spy(s, cv, 'npc0'), isNull);
    });

    test('verifying news, then debunking fake news', () {
      expect(cv.newsCheck(cv.news.first), NewsCheck.verify);
      expect(service.checkNews(cv, 'n75'), OrderRequest(type: 'verify', city: 'szelmezo', newsId: 'n75'));
      final falsy = cv.copyWith(news: [cv.news.first.copyWith(verified: false), ...cv.news.skip(1)]);
      expect(service.checkNews(falsy, 'n75'), OrderRequest(type: 'debunk', city: 'szelmezo', newsId: 'n75'));
      expect(service.checkNews(cv.copyWith(mySpies: 0), 'n75'), isNull);
    });

    test('sale: buyers, defaults, price', () {
      final it = IntelView(id: 'i1', of_: s.houses.first, executeAt: s.clock.now, lines: const [], depth: 1, live: true, offeredTo: const [], bought: false);
      final s2 = s.copyWith(intel: [it]);
      expect(s2.intelBuyers(it).map((h) => h.playerId), ['npc1', 'npc2', 'npc3']);
      expect(service.saleDefaults(s2, 'i1'), ('npc1', '10'));
      expect(service.saleDefaults(s2.copyWith(intel: [it.copyWith(live: false)]), 'i1'), isNull);
      expect(service.salePrice(s2, '25'), 25);
      expect(service.salePrice(s2, ''), 10);
      expect(service.validBuyer(s2, 'i1', 'npc0'), isFalse);
      expect(service.validBuyer(s2, 'i1', 'npc2'), isTrue);
    });
  });
}
