import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/widgets/game_widgets.dart';
import 'package:tron_nelkul/app/di/di.dart';
import 'package:tron_nelkul/domain/service/city_service.dart';
import 'package:tron_nelkul/domain/service/game_service.dart';
import 'package:tron_nelkul/theme/tokens.dart';
import 'package:tron_nelkul/ui/game/bloc/game_bloc.dart';
import 'package:tron_nelkul/ui/game/city/city_page.dart';
import 'package:tron_nelkul/ui/game/game_shell_page.dart';

import '../../helpers/l10n.dart';
import 'city/city_service_test.dart' show fixtureState;

class _Game extends MockBloc<GameEvent, GameViewState> implements GameBloc {}

class _GameService extends Mock implements GameService {}

void main() {
  final s = fixtureState();
  final map = MapDef.fromJson(jsonDecode(File('test/fixtures/map_delkelet.json').readAsStringSync()) as Map<String, dynamic>);
  final header = find.byKey(const ValueKey('shell/city-header'));

  setUpAll(loadTestTranslations);
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    registerFallbackValue(const GameTicked());
    registerFallbackValue(s);
    if (!getIt.isRegistered<CityService>()) getIt.registerSingleton(CityService());
    final games = _GameService();
    when(() => games.ordersBadge(any())).thenReturn(0);
    if (!getIt.isRegistered<GameService>()) getIt.registerSingleton<GameService>(games);
  });

  Future<GoRouter> pump(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final game = _Game();
    whenListen(game, const Stream<GameViewState>.empty(),
        initialState: GameViewState(gameId: 'g', status: GameStatus.ready, game: s, map: map, selectedCity: 'szelmezo', now: s.clock.now));
    final router = GoRouter(
      initialLocation: location,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => BlocProvider<GameBloc>.value(value: game, child: GameShellPage(shell: shell)),
          branches: [
            StatefulShellBranch(routes: [GoRoute(path: '/map', builder: (_, _) => const Text('map tab'))]),
            StatefulShellBranch(routes: [GoRoute(path: '/city', builder: (_, st) => CityPage(cityId: st.uri.queryParameters['c']))]),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(theme: buildTheme(), routerConfig: router));
    await tester.pump();
    await tester.pump();
    return router;
  }

  testWidgets('the top bar shows the open city\'s header on the City tab only', (tester) async {
    final router = await pump(tester, '/city?c=szelmezo');
    expect(header, findsOneWidget);
    expect(find.descendant(of: header, matching: find.text('Szélmező')), findsOneWidget);
    expect(find.descendant(of: header, matching: find.textContaining('GABONAVIDÉK')), findsNothing, reason: 'no profile / distance line');
    // Compact chips: icon and value only; the label and the explanation come up on tap
    expect(find.descendant(of: header, matching: find.textContaining('Népszerűséged')), findsNothing);
    expect(find.descendant(of: header, matching: find.byType(Tooltip)), findsNWidgets(3));
    await tester.tap(find.descendant(of: header, matching: find.byType(StatChip)).at(1));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('A városi adókulcs'), findsOneWidget);
    await tester.pump(const Duration(seconds: 7));
    expect(find.text('← Térkép'), findsNothing);

    router.go('/map');
    await tester.pump();
    await tester.pump();
    expect(find.text('map tab'), findsOneWidget);
    expect(header, findsNothing);

    router.go('/city?c=szelmezo');
    await tester.pump();
    await tester.pump();
    expect(header, findsOneWidget);
  });

  testWidgets('no city header on the other tabs', (tester) async {
    await pump(tester, '/map');
    expect(find.text('map tab'), findsOneWidget);
    expect(header, findsNothing);
  });

  testWidgets('switching city updates the header', (tester) async {
    final router = await pump(tester, '/city?c=szelmezo');
    router.go('/city?c=delkapu');
    await tester.pump();
    await tester.pump();
    expect(find.descendant(of: header, matching: find.text('Délkapu')), findsOneWidget);
  });
}
