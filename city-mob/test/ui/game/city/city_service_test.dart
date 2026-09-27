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

  group('város és fejléc', () {
    test('a kért, a kijelölt, majd az első elérhető város', () {
      expect(service.resolveCity(s, 'delkapu', 'szelmezo'), 'delkapu');
      expect(service.resolveCity(s, 'nincs-ilyen', 'delkapu'), 'delkapu');
      expect(service.resolveCity(s, null, null), 'szelmezo');
    });

    test('ismeretlen negyed: Vásártér', () {
      expect(cityDistrict(null), 'keresk');
      expect(cityDistrict('kem'), 'kem');
      expect(cityDistrict('xyz'), 'keresk');
    });

    test('negyedzászlók: legtöbb részesedés, legtöbb tanácshely, saját kémek', () {
      expect(s.districtDominants(cv), {'keresk': 'arany', 'polit': 'kek', 'kem': 'kek'});
      expect(s.districtDominants(s.city('delkapu'))['kem'], isNull);
    });

    test('chipek: alacsony népszerűség figyelmeztet, választás N elszámolás múlva', () {
      final st = s.cityStats(cv);
      expect(st.length, 3);
      expect(st[0].tone, 'warn');
      expect(st[2], (label: const Tr('city.stat.election'), value: const Tr.raw('6'), suffix: const Tr('city.stat.election_in_suffix'), tone: null, art: 'foundParty'));
      expect(st[0].label, const Tr('city.stat.popularity'));
    });

    test('választás szövege: a következő elszámoláskor, vagy N elszámolás múlva', () {
      expect(electionText(1), const Tr('city.election_next'));
      expect(electionText(4), const Tr('city.election_in', {'n': '4'}));
    });

    test('fenyegetések ebben a városban', () {
      expect(s.threatsIn('szelmezo').map((t) => t.orderId), ['o100']);
      expect(s.defendOnlyInDraft(s.threats.first), isFalse);
    });
  });

  group('Vásártér', () {
    test('vétel a Várostól: ha nincs szabad részesedés, nem vehető', () {
      final p = GoodPlan.of(good('gabona'), s.rules);
      expect(p.canBuy, isFalse);
      expect(p.buyOptions, [1]);
      expect(service.buyShares(cv, p), isNull);
    });

    test('vétel a Várostól: a pontok a megengedett tartományba szorulnak, a költség pontonként', () {
      final p = GoodPlan.of(good('bor'), s.rules, buyPts: 50);
      expect(p.buyPts, 10);
      expect(p.buyCost, 30);
      expect(service.buyShares(cv, p), OrderRequest(type: 'buyShares', city: 'szelmezo', good: 'bor', pts: 10));
    });

    test('kivásárlás: a legnagyobb rivális az alapértelmezett, a költség a prémiummal', () {
      final g = good('gabona');
      final p = GoodPlan.of(g, s.rules);
      expect(p.rivals.map((x) => x.house!.playerId), ['npc0', 'npc2', 'npc3']);
      expect(p.targetId, 'npc0');
      expect(p.boCost, (g.marketValue * 5 * 150 / 100).ceil());
      final q = GoodPlan.of(g, s.rules, target: 'npc2', boPts: 99);
      expect(q.boPts, 10);
      expect(service.buyout(cv, q), OrderRequest(type: 'buyout', city: 'szelmezo', good: 'gabona', target: 'npc2', pts: 10));
    });

    test('védett eladó nem kivásárolható', () {
      final g = good('bor');
      final prot = g.copyWith(sellers: [for (final x in g.sellers) x.copyWith(protectedNow: true)]);
      expect(GoodPlan.of(prot, s.rules).rivals, isEmpty);
      expect(service.buyout(cv, GoodPlan.of(prot, s.rules)), isNull);
    });

    test('védekezés és útvonal', () {
      expect(service.defend(s, cv, 'o100'), OrderRequest(type: 'defend', city: 'szelmezo', lapId: 'L101', orderId: 'o100'));
      expect(service.defend(s, cv, 'x'), isNull);
      expect(service.route(s, s.city('vaskapu'), 'szelmezo'), OrderRequest(type: 'route', from: 'szelmezo', to: 'vaskapu'));
      expect(service.route(s, s.city('vaskapu'), 'delkapu'), isNull);
    });

    test('haszonkulcs csak saját részesedéssel', () {
      final level = s.catalog.margins.first.id;
      expect(service.margin(s, cv, 'gabona', level), OrderRequest(type: 'margin', city: 'szelmezo', good: 'gabona', level: level));
      expect(service.margin(s, cv, 'bor', level), isNull);
    });
  });

  group('Városháza', () {
    test('van párt: program és fesztivál igen, alapítás nem', () {
      expect(service.foundParty(cv), isNull);
      expect(service.festival(cv), OrderRequest(type: 'festival', city: 'szelmezo'));
      expect(service.foundParty(s.city('delkapu')), OrderRequest(type: 'foundParty', city: 'delkapu'));
    });

    test('hírszerkesztő: alapértelmezések és árucikkes állítás', () {
      final p = NewsPlan.of(s.catalog, cv);
      expect(p.template!.id, 'uzsora');
      expect(p.targets.map((h) => h.playerId), ['npc0', 'npc2', 'npc3', 'npc1']);
      expect(p.good!.id, 'gabona');
      expect(service.news(cv, p), OrderRequest(type: 'news', city: 'szelmezo', template: 'uzsora', target: 'npc0', good: 'gabona'));
    });

    test('hírszerkesztő: a célpont itt nem árul semmit', () {
      final p = NewsPlan.of(s.catalog, cv, target: 'npc1');
      expect(p.ok, isFalse);
      expect(p.targetSellsNothing, isTrue);
      expect(service.news(cv, p), isNull);
      final q = NewsPlan.of(s.catalog, cv, template: 'barat', target: 'npc1');
      expect(service.news(cv, q), OrderRequest(type: 'news', city: 'szelmezo', template: 'barat', target: 'npc1'));
      expect(NewsPlan.label('„{t} uzsoraáron árulja: {g}.”'), '„X uzsoraáron árulja: ….”');
    });
  });

  group('Alvilág', () {
    test('szabad kémek, felfogadás, őr', () {
      expect(cv.freeSpies, 2);
      expect(service.hireSpy(s, cv), OrderRequest(type: 'hireSpy', city: 'szelmezo'));
      expect(service.guard(cv), OrderRequest(type: 'guard', city: 'szelmezo'));
      expect(service.guard(s.city('delkapu')), isNull);
      expect(service.hireSpy(s, cv.copyWith(mySpies: 3)), isNull);
    });

    test('kém áthelyezése: csak a hálózat egy másik, nem teli városába', () {
      expect(s.spyDestinations('szelmezo').map((c) => c.id), ['delkapu']);
      expect(service.moveSpy(s, cv, 'delkapu'), OrderRequest(type: 'moveSpy', city: 'szelmezo', to: 'delkapu'));
      expect(service.moveSpy(s, cv, 'vaskapu'), isNull);
      expect(service.moveSpy(s, cv.copyWith(myGuards: 2), 'delkapu'), isNull);
      final full = s.copyWith(cities: [for (final c in s.cities) c.id == 'delkapu' ? c.copyWith(mySpies: 3) : c]);
      expect(service.moveSpy(full, full.city('szelmezo'), 'delkapu'), isNull);
    });

    test('kifürkészés csak érlelő parancslap ellen', () {
      expect(service.spy(s, cv, 'npc3'), OrderRequest(type: 'spy', city: 'szelmezo', target: 'npc3'));
      expect(service.spy(s, cv, 'npc0'), isNull);
    });

    test('hírek ellenőrzése, majd hamis hír leleplezése', () {
      expect(cv.newsCheck(cv.news.first), NewsCheck.verify);
      expect(service.checkNews(cv, 'n75'), OrderRequest(type: 'verify', city: 'szelmezo', newsId: 'n75'));
      final falsy = cv.copyWith(news: [cv.news.first.copyWith(verified: false), ...cv.news.skip(1)]);
      expect(service.checkNews(falsy, 'n75'), OrderRequest(type: 'debunk', city: 'szelmezo', newsId: 'n75'));
      expect(service.checkNews(cv.copyWith(mySpies: 0), 'n75'), isNull);
    });

    test('eladás: vevők, kezdőértékek, ár', () {
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
