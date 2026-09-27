import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/domain/model/city_extensions.dart';
import 'package:tron_nelkul/domain/model/extensions.dart';
import 'package:tron_nelkul/domain/service/city_service.dart';
import 'package:tron_nelkul/ui/game/bloc/game_bloc.dart';
import 'package:tron_nelkul/ui/game/city/bloc/city_bloc.dart';

import 'city_service_test.dart' show fixtureState;

class _Game extends MockBloc<GameEvent, GameViewState> implements GameBloc {}

class _Service extends Mock implements CityService {}

void main() {
  final s = fixtureState();
  final order = OrderRequest(type: 'x', city: 'szelmezo');
  late _Game game;
  late _Service service;
  late StreamController<GameViewState> games;

  GameViewState view(GameState g, {String? selected = 'szelmezo'}) =>
      GameViewState(gameId: 'g', status: GameStatus.ready, game: g, selectedCity: selected, now: g.clock.now);

  setUpAll(() {
    registerFallbackValue(s);
    registerFallbackValue(s.cities.first);
    registerFallbackValue(GoodPlan.of(s.cities.first.goods.first, s.rules));
    registerFallbackValue(NewsPlan.of(s.catalog, s.cities.first));
    registerFallbackValue(const GameTicked());
  });

  setUp(() {
    game = _Game();
    service = _Service();
    games = StreamController<GameViewState>();
    whenListen(game, games.stream, initialState: view(s));
    when(() => service.resolveCity(any(), any(), any())).thenAnswer((i) => i.positionalArguments[1] as String? ?? 'szelmezo');
  });
  tearDown(() => games.close());

  CityBloc build() => CityBloc(game, service);

  group('indulás', () {
    blocTest<CityBloc, CityState>('a kért várost mutatja, és a térképen is kijelöli',
        build: build,
        act: (b) => b.add(const CityStarted('delkapu')),
        verify: (b) {
          expect(b.state.cityId, 'delkapu');
          expect(b.state.ready, isTrue);
          expect(b.state.can, isTrue);
          verify(() => game.add(const GameMapCitySelected('delkapu'))).called(1);
        });

    blocTest<CityBloc, CityState>('URL-város nélkül a service választ; ha már ki van jelölve, nem jelöl újra',
        build: build,
        act: (b) => b.add(const CityStarted(null)),
        verify: (b) {
          expect(b.state.cityId, 'szelmezo');
          verify(() => service.resolveCity(s, null, 'szelmezo')).called(1);
          verifyNever(() => game.add(any()));
        });

    blocTest<CityBloc, CityState>('követi a GameBloc új állapotát (busy, játék)',
        build: build,
        act: (b) async {
          b.add(const CityStarted('szelmezo'));
          await Future<void>.delayed(Duration.zero);
          games.add(view(s).copyWith(busy: true));
        },
        wait: const Duration(milliseconds: 10),
        verify: (b) => expect(b.state.busy, isTrue));
  });

  group('Vásártér', () {
    blocTest<CityBloc, CityState>('a választott pontokkal épít parancsot, és a GameBlocnak adja',
        setUp: () => when(() => service.buyShares(any(), any())).thenReturn(order),
        build: build,
        act: (b) => b
          ..add(const CityStarted('szelmezo'))
          ..add(const CityBuyPointsChanged('bor', 7))
          ..add(const CityBuySubmitted('bor')),
        verify: (b) {
          expect(b.state.goods['bor'], const GoodForm(buyPts: 7));
          final p = verify(() => service.buyShares(any(), captureAny())).captured.single as GoodPlan;
          expect(p.buyPts, 7);
          verify(() => game.add(GameOrderAdded(order))).called(1);
        });

    blocTest<CityBloc, CityState>('kivásárlás: célpont és pont az árucikk űrlapján',
        setUp: () => when(() => service.buyout(any(), any())).thenReturn(order),
        build: build,
        act: (b) => b
          ..add(const CityStarted('szelmezo'))
          ..add(const CityBuyoutTargetChanged('gabona', 'npc2'))
          ..add(const CityBuyoutPointsChanged('gabona', 3))
          ..add(const CityBuyoutSubmitted('gabona')),
        verify: (b) {
          expect(b.state.goods['gabona'], const GoodForm(boPts: 3, target: 'npc2'));
          final p = verify(() => service.buyout(any(), captureAny())).captured.single as GoodPlan;
          expect((p.targetId, p.boPts), ('npc2', 3));
          verify(() => game.add(GameOrderAdded(order))).called(1);
        });

    blocTest<CityBloc, CityState>('érvénytelen parancs (null) nem megy a GameBlocnak',
        setUp: () => when(() => service.defend(any(), any(), any())).thenReturn(null),
        build: build,
        act: (b) => b
          ..add(const CityStarted('szelmezo'))
          ..add(const CityDefendRequested('o100')),
        verify: (_) => verifyNever(() => game.add(any(that: isA<GameOrderAdded>()))));
  });

  group('Városháza', () {
    blocTest<CityBloc, CityState>('hírszerkesztő: a választások a tervbe kerülnek',
        setUp: () => when(() => service.news(any(), any())).thenReturn(order),
        build: build,
        act: (b) => b
          ..add(const CityStarted('szelmezo'))
          ..add(const CityNewsTemplateChanged('barat'))
          ..add(const CityNewsTargetChanged('npc1'))
          ..add(const CityNewsSubmitted()),
        verify: (b) {
          expect(b.state.news, const NewsForm(template: 'barat', target: 'npc1'));
          final p = verify(() => service.news(any(), captureAny())).captured.single as NewsPlan;
          expect((p.template!.id, p.target!.playerId), ('barat', 'npc1'));
          verify(() => game.add(GameOrderAdded(order))).called(1);
        });
  });

  group('Alvilág', () {
    blocTest<CityBloc, CityState>('kém áthelyezése: párbeszéd, célváros, parancs',
        setUp: () => when(() => service.moveSpy(any(), any(), 'delkapu')).thenReturn(OrderRequest(type: 'moveSpy', city: 'szelmezo', to: 'delkapu')),
        build: build,
        act: (b) async {
          b.add(const CityStarted('szelmezo'));
          b.add(const CityMoveSpyOpened());
          await Future<void>.delayed(Duration.zero);
          expect(b.state.moveSpyOpen, isTrue);
          expect(b.state.spyDestinations.map((d) => d.$1.id), ['delkapu']);
          b.add(const CityMoveSpyPicked('delkapu'));
        },
        verify: (b) {
          expect(b.state.moveSpyOpen, isFalse);
          expect(b.state.moveSpyTarget, 'delkapu');
          verify(() => game.add(GameOrderAdded(OrderRequest(type: 'moveSpy', city: 'szelmezo', to: 'delkapu')))).called(1);
        });

    blocTest<CityBloc, CityState>('szabad kém nélkül nem nyílik meg az áthelyezés',
        build: build,
        act: (b) => b
          ..add(const CityStarted('delkapu'))
          ..add(const CityMoveSpyOpened()),
        verify: (b) => expect(b.state.moveSpyOpen, isFalse));

    blocTest<CityBloc, CityState>('eladás: ha nincs kinek, értesítés',
        setUp: () => when(() => service.saleDefaults(any(), 'i1')).thenReturn(null),
        build: build,
        act: (b) => b
          ..add(const CityStarted('szelmezo'))
          ..add(const CityIntelSaleOpened('i1')),
        verify: (b) {
          expect(b.state.sale, isNull);
          expect((b.state.notice?.title, b.state.notice?.body, b.state.notice?.tone), ('Nem sikerült', 'Nincs kinek eladni.', 'danger'));
        });

    blocTest<CityBloc, CityState>('eladás: vevő és ár a párbeszédből, felkínálás a GameBlocon át',
        setUp: () {
          when(() => service.saleDefaults(any(), 'i1')).thenReturn(('npc1', '10'));
          when(() => service.validBuyer(any(), 'i1', 'npc2')).thenReturn(true);
          when(() => service.salePrice(any(), '25')).thenReturn(25);
        },
        build: build,
        act: (b) async {
          b
            ..add(const CityStarted('szelmezo'))
            ..add(const CityIntelSaleOpened('i1'));
          await Future<void>.delayed(Duration.zero);
          expect(b.state.sale, const IntelSaleForm(intelId: 'i1', buyer: 'npc1', price: '10'));
          b
            ..add(const CityIntelBuyerChanged('npc2'))
            ..add(const CityIntelPriceChanged('25'))
            ..add(const CityIntelSaleSubmitted());
        },
        verify: (b) {
          expect(b.state.sale, isNull);
          verify(() => game.add(any(that: isA<GameIntelOffered>()
              .having((e) => [e.intelId, e.buyerId, e.price], 'ajánlat', ['i1', 'npc2', 25])
              .having((e) => e.success, 'üzenet', startsWith('Felkínálva: '))))).called(1);
        });

    blocTest<CityBloc, CityState>('felkínált információ elfogadása és elutasítása',
        build: () {
          final o = OfferView(id: 'of1', seller: s.houses[0], of_: s.houses[1], price: 12, executeAt: s.clock.now);
          whenListen(game, games.stream, initialState: view(s.copyWith(offers: [o])));
          return build();
        },
        act: (b) => b
          ..add(const CityStarted('szelmezo'))
          ..add(const CityOfferAccepted('of1'))
          ..add(const CityOfferDeclined('of1'))
          ..add(const CityOfferAccepted('nincs')),
        verify: (_) {
          verify(() => game.add(any(that: isA<GameOfferAccepted>().having((e) => e.offerId, 'ajánlat', 'of1').having((e) => e.success, 'üzenet', endsWith(' tervei.'))))).called(1);
          verify(() => game.add(const GameOfferDeclined('of1'))).called(1);
          verifyNever(() => game.add(any(that: isA<GameOfferAccepted>().having((e) => e.offerId, 'ajánlat', 'nincs'))));
        });
  });

  test('a számolt értékek a CityState getterein', () async {
    final b = build()..add(const CityStarted('szelmezo'));
    await Future<void>.delayed(Duration.zero);
    final st = b.state;
    expect(st.dominants['keresk'], 'arany');
    expect(st.threats.single.orderId, 'o100');
    expect(st.lowPop, isTrue);
    expect(st.freeSpies, 2);
    expect(st.checkable.length, s.city('szelmezo').checkable.length);
    expect(st.newsCheck(st.checkable.first), NewsCheck.verify);
    await b.close();
  });
}
