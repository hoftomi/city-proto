import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/widgets/unit_text.dart';
import 'package:tron_nelkul/app/di/di.dart';
import 'package:tron_nelkul/domain/service/city_service.dart';
import 'package:tron_nelkul/theme/tokens.dart';
import 'package:tron_nelkul/widgets/city_view.dart';
import 'package:tron_nelkul/ui/game/bloc/game_bloc.dart';
import 'package:tron_nelkul/ui/game/bloc/shown_city_cubit.dart';
import 'package:tron_nelkul/ui/game/city/city_page.dart';

import '../../../helpers/l10n.dart';
import 'city_service_test.dart' show fixtureState;

class _Game extends MockBloc<GameEvent, GameViewState> implements GameBloc {}

void main() {
  final s = fixtureState();

  setUpAll(loadTestTranslations);
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    registerFallbackValue(const GameTicked());
    if (!getIt.isRegistered<CityService>()) getIt.registerSingleton(CityService());
  });

  late ShownCityCubit shown;

  Future<_Game> pump(WidgetTester tester, String district, {String cityId = 'szelmezo'}) async {
    tester.view.physicalSize = const Size(800, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final game = _Game();
    whenListen(game, const Stream<GameViewState>.empty(),
        initialState: GameViewState(gameId: 'g', status: GameStatus.ready, game: s, selectedCity: 'szelmezo', now: s.clock.now));
    shown = ShownCityCubit();
    addTearDown(shown.close);
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [BlocProvider<GameBloc>.value(value: game), BlocProvider.value(value: shown)],
          child: CityPage(cityId: cityId, district: district),
        ),
      ),
    ));
    await tester.pump();
    return game;
  }

  for (final (d, marker) in [('trade', 'VÉTEL A VÁROSTÓL (95% SZABAD)'), ('politics', 'Városi tanács'), ('espionage', 'Kémeid itt')]) {
    testWidgets('the $d district renders without errors', (tester) async {
      await pump(tester, d);
      expect(find.text(marker), findsOneWidget);
      // The header (chips, back button) lives in the shell's top bar now.
      expect(find.text('← Térkép'), findsNothing);
      expect(find.textContaining('Népszerűséged'), findsNothing);
    });
  }

  testWidgets('reports the resolved city to the shell', (tester) async {
    await pump(tester, 'trade');
    expect(shown.state, 'szelmezo');
  });

  testWidgets('the Marketplace shows the expected income on top, without the formula hints', (tester) async {
    await pump(tester, 'trade');
    final income = find.byKey(const ValueKey('city/expected-income'));
    expect(income, findsOneWidget);
    expect(find.descendant(of: income, matching: find.text('Várható bevétel a következő elszámoláskor')), findsOneWidget);
    expect(find.descendant(of: income, matching: find.byWidgetPredicate((w) => w is UnitText && w.text == '+12 [gold] 5 [silver]')), findsOneWidget);
    expect(tester.getTopLeft(income).dy, lessThan(tester.getTopLeft(find.text('VÉTEL A VÁROSTÓL (95% SZABAD)')).dy));
    expect(find.textContaining('Haszon ='), findsNothing);
    expect(find.textContaining('Kivásárlás:'), findsNothing);
  });

  testWidgets('the expected income sits above the city view, on every district', (tester) async {
    for (final district in ['trade', 'politics', 'espionage']) {
      await pump(tester, district);
      final income = find.byKey(const ValueKey('city/expected-income'));
      expect(income, findsOneWidget, reason: district);
      expect(tester.getTopLeft(income).dy, lessThan(tester.getTopLeft(find.byType(CityViewWidget)).dy), reason: district);
    }
  });

  testWidgets('no expected income line when the city has none', (tester) async {
    await pump(tester, 'trade', cityId: 'delkapu');
    expect(shown.state, 'delkapu');
    expect(find.byKey(const ValueKey('city/expected-income')), findsNothing);
  });

  testWidgets('moving a spy: dialog, destination city, order to the GameBloc', (tester) async {
    final game = await pump(tester, 'espionage');
    await tester.tap(find.textContaining('Kém áthelyezése'));
    await tester.pumpAndSettle();
    expect(find.text('Hová költözzön a kém?'), findsOneWidget);
    await tester.tap(find.textContaining('Délkapu · kémeid ott: 0 / 3'));
    await tester.pumpAndSettle();
    expect(find.text('Hová költözzön a kém?'), findsNothing);
    verify(() => game.add(GameOrderAdded(OrderRequest(type: 'moveSpy', city: 'szelmezo', to: 'delkapu')))).called(1);
  });
}
