import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/app/di/di.dart';
import 'package:tron_nelkul/domain/service/city_service.dart';
import 'package:tron_nelkul/theme/tokens.dart';
import 'package:tron_nelkul/ui/game/bloc/game_bloc.dart';
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

  Future<_Game> pump(WidgetTester tester, String district) async {
    tester.view.physicalSize = const Size(800, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final game = _Game();
    whenListen(game, const Stream<GameViewState>.empty(),
        initialState: GameViewState(gameId: 'g', status: GameStatus.ready, game: s, selectedCity: 'szelmezo', now: s.clock.now));
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: BlocProvider<GameBloc>.value(value: game, child: CityPage(cityId: 'szelmezo', district: district))),
    ));
    await tester.pump();
    return game;
  }

  for (final (d, marker) in [('keresk', 'VÉTEL A VÁROSTÓL (95 SZABAD)'), ('polit', 'Városi tanács'), ('kem', 'Kémeid itt')]) {
    testWidgets('a(z) $d negyed hiba nélkül megjelenik', (tester) async {
      await pump(tester, d);
      expect(find.text('Szélmező'), findsWidgets);
      expect(find.text('← Térkép'), findsOneWidget);
      expect(find.text(marker), findsOneWidget);
    });
  }

  testWidgets('Kém áthelyezése: párbeszéd, célváros, parancs a GameBlocnak', (tester) async {
    final game = await pump(tester, 'kem');
    await tester.tap(find.textContaining('Kém áthelyezése'));
    await tester.pumpAndSettle();
    expect(find.text('Hová költözzön a kém?'), findsOneWidget);
    await tester.tap(find.textContaining('Délkapu · kémeid ott: 0 / 3'));
    await tester.pumpAndSettle();
    expect(find.text('Hová költözzön a kém?'), findsNothing);
    verify(() => game.add(GameOrderAdded(OrderRequest(type: 'moveSpy', city: 'szelmezo', to: 'delkapu')))).called(1);
  });
}
