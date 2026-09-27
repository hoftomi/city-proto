import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_nelkul/core/failure.dart';
import 'package:tron_nelkul/domain/service/join_service.dart';
import 'package:tron_nelkul/domain/service/lobby_service.dart';
import 'package:tron_nelkul/ui/common/notice.dart';
import 'package:tron_nelkul/ui/game_detail/bloc/game_detail_bloc.dart';

import '../lobby/lobby_fixtures.dart';

class _MockLobby extends Mock implements LobbyService {}

void main() {
  late _MockLobby lobby;
  final d = detail(game: summary(myHouse: house()));

  setUp(() {
    lobby = _MockLobby();
    when(() => lobby.game('g1')).thenAnswer((_) async => Right(d));
    when(() => lobby.map('m1')).thenAnswer((_) async => Right(mapDef));
  });

  GameDetailBloc build() => GameDetailBloc(lobby, JoinService(lobby));

  blocTest<GameDetailBloc, GameDetailState>(
    'betölti a részleteket és a térképet',
    build: build,
    act: (b) => b.add(const GameDetailStarted('g1')),
    expect: () => [
      const GameDetailState(gameId: 'g1'),
      GameDetailState(gameId: 'g1', detail: d, map: mapDef),
    ],
    verify: (b) => expect(b.state.ready, isTrue),
  );

  blocTest<GameDetailBloc, GameDetailState>(
    'a térkép hibája hiba',
    setUp: () => when(() => lobby.map('m1')).thenAnswer((_) async => const Left(Failure('nincs térkép'))),
    build: build,
    act: (b) => b.add(const GameDetailStarted('g1')),
    expect: () => [const GameDetailState(gameId: 'g1'), const GameDetailState(gameId: 'g1', failure: Failure('nincs térkép'))],
  );

  blocTest<GameDetailBloc, GameDetailState>(
    'visszavonás: üzenet és újratöltés',
    setUp: () => when(() => lobby.withdraw('g1')).thenAnswer((_) async => const Right(null)),
    build: build,
    seed: () => GameDetailState(gameId: 'g1', detail: d, map: mapDef),
    act: (b) => b.add(const GameDetailWithdrawRequested()),
    expect: () => [
      GameDetailState(gameId: 'g1', detail: d, map: mapDef, busy: true),
      GameDetailState(gameId: 'g1', detail: d, map: mapDef, busy: true, notice: const Notice(1, 'Jelentkezés visszavonva.', tone: 'ok')),
      GameDetailState(gameId: 'g1', detail: d, map: mapDef, notice: const Notice(1, 'Jelentkezés visszavonva.', tone: 'ok')),
    ],
    verify: (_) => verify(() => lobby.game('g1')).called(1),
  );

  blocTest<GameDetailBloc, GameDetailState>(
    'sikertelen visszavonás: hibaüzenet',
    setUp: () => when(() => lobby.withdraw('g1')).thenAnswer((_) async => const Left(Failure('már indult'))),
    build: build,
    seed: () => GameDetailState(gameId: 'g1', detail: d, map: mapDef),
    act: (b) => b.add(const GameDetailWithdrawRequested()),
    expect: () => [
      GameDetailState(gameId: 'g1', detail: d, map: mapDef, busy: true),
      GameDetailState(gameId: 'g1', detail: d, map: mapDef, notice: const Notice(1, 'Nem sikerült', body: 'már indult', tone: 'danger')),
    ],
  );

  blocTest<GameDetailBloc, GameDetailState>(
    'jelentkezés után üzen és frissít',
    build: build,
    seed: () => GameDetailState(gameId: 'g1', detail: d, map: mapDef),
    act: (b) => b.add(const GameDetailJoined()),
    expect: () => [
      GameDetailState(gameId: 'g1', detail: d, map: mapDef, notice: const Notice(1, 'Jelentkeztél', body: 'Értesítünk, amikor a játék indul.', tone: 'ok')),
    ],
    verify: (_) => verify(() => lobby.game('g1')).called(1),
  );
}
