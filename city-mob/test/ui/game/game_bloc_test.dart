import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_nelkul/core/failure.dart';
import 'package:tron_nelkul/core/tr.dart';
import 'package:tron_nelkul/data/repository/repositories.dart';
import 'package:tron_nelkul/domain/service/game_service.dart';
import 'package:tron_nelkul/ui/game/bloc/game_bloc.dart';
import 'package:tron_api/tron_api.dart';

class _Games extends Mock implements GameRepository {}

class _Maps extends Mock implements MapRepository {}

Map<String, dynamic> _fixture(String name) => jsonDecode(File('test/fixtures/$name').readAsStringSync()) as Map<String, dynamic>;

void main() {
  final state = GameState.fromJson(_fixture('game_state.json'));
  final map = MapDef.fromJson(_fixture('map_delkelet.json'));
  late _Games games;
  late GameService service;

  setUpAll(() => registerFallbackValue(OrderRequest(type: 'route')));
  setUp(() {
    games = _Games();
    final maps = _Maps();
    when(() => maps.map('delkelet')).thenAnswer((_) async => Right(map));
    when(() => games.state('g')).thenAnswer((_) async => Right(state));
    service = GameService(games, maps);
  });

  blocTest<GameBloc, GameViewState>('loads the state and the map, and selects an available city',
      build: () => GameBloc(service),
      act: (b) => b.add(const GameStarted('g')),
      expect: () => [
            isA<GameViewState>().having((s) => s.status, 'status', GameStatus.loading),
            isA<GameViewState>()
                .having((s) => s.ready, 'ready', true)
                .having((s) => s.map, 'map', map)
                .having((s) => s.selectedCity, 'city', 'szelmezo'),
          ]);

  blocTest<GameBloc, GameViewState>('on failed load the failure is in the state',
      build: () {
        when(() => games.state('g')).thenAnswer((_) async => const Left(Failure.offline));
        return GameBloc(service);
      },
      act: (b) => b.add(const GameStarted('g')),
      skip: 1,
      expect: () => [isA<GameViewState>().having((s) => s.status, 'status', GameStatus.failure).having((s) => s.failure, 'failure', Failure.offline)]);

  blocTest<GameBloc, GameViewState>('added order: the new draft and a notice about the added order',
      build: () {
        final after = state.copyWith(draft: [
          ...state.draft,
          OrderView(id: 'new', type: 'festival', branch: 'politics', label: 'Fesztivál · Szélmező', cityId: 'szelmezo', cityName: 'Szélmező',
              cost: Cost(pp: 2, gold: 15), warning: null),
        ]);
        when(() => games.addOrder('g', any())).thenAnswer((_) async => Right(after));
        return GameBloc(service);
      },
      act: (b) async {
        b.add(const GameStarted('g'));
        await Future<void>.delayed(Duration.zero);
        b.add(GameOrderAdded(OrderRequest(type: 'festival', city: 'szelmezo')));
      },
      skip: 2,
      expect: () => [
            isA<GameViewState>().having((s) => s.busy, 'busy', true),
            isA<GameViewState>()
                .having((s) => s.busy, 'busy', false)
                .having((s) => s.game!.draft.last.id, 'new order', 'new')
                .having((s) => s.notice?.body, 'notice', const Tr.raw('Fesztivál · Szélmező')),
          ]);

  blocTest<GameBloc, GameViewState>('rejected order: danger notice with the server message',
      build: () {
        when(() => games.addOrder('g', any())).thenAnswer((_) async => const Left(Failure(Tr.raw('Nincs elég arany.'), status: 400)));
        return GameBloc(service);
      },
      act: (b) async {
        b.add(const GameStarted('g'));
        await Future<void>.delayed(Duration.zero);
        b.add(GameOrderAdded(OrderRequest(type: 'hireSpy', city: 'szelmezo')));
      },
      skip: 3,
      expect: () => [isA<GameViewState>().having((s) => s.notice?.title, 'message', const Tr.raw('Nincs elég arany.')).having((s) => s.notice?.tone, 'tone', 'danger')]);

  test('refresh is due after own sheet expires', () {
    final sheetAt = state.sheet!.executeAt;
    expect(service.refreshDue(state, sheetAt.subtract(const Duration(minutes: 1))), isFalse);
    expect(service.refreshDue(state, sheetAt.add(const Duration(seconds: 6))), isTrue);
  });

  test('game clock advances by the time elapsed since fetch', () {
    final fetched = DateTime(2026, 9, 27, 12);
    expect(service.gameNow(state, fetched, fetched.add(const Duration(minutes: 5))), state.clock.now.add(const Duration(minutes: 5)));
  });
}
