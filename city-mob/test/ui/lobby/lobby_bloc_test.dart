import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_nelkul/core/failure.dart';
import 'package:tron_nelkul/domain/model/lobby_extensions.dart';
import 'package:tron_nelkul/domain/service/lobby_service.dart';
import 'package:tron_nelkul/ui/auth/bloc/auth_bloc.dart';
import 'package:tron_nelkul/ui/lobby/bloc/lobby_bloc.dart';

import 'lobby_fixtures.dart';

class _MockLobby extends Mock implements LobbyService {}

class _MockAuth extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late _MockLobby lobby;
  late _MockAuth auth;

  final runningMine = summary(id: 'r', status: 'fut', round: 5, myHouse: house());
  final openMine = summary(id: 'o', myHouse: house());
  final fresh = summary(id: 'n');
  final runningOther = summary(id: 'x', status: 'fut', round: 2);
  final soon = summary(id: 's', status: 'hamarosan');
  final done = summary(id: 'd', status: 'lezarult', myHouse: house());
  final all = [runningMine, openMine, fresh, runningOther, soon, done];

  setUp(() {
    lobby = _MockLobby();
    auth = _MockAuth();
  });

  group('LobbyGroups', () {
    test('a fülekre sorol', () {
      final g = LobbyGroups.of(all);
      expect(g.running, [runningMine]);
      expect(g.mine, [runningMine, openMine]);
      expect(g.fresh, [fresh, runningOther, soon]);
      expect(g.finished, [done]);
      expect(g.tab(LobbyTab.mine), g.mine);
    });

    test('állapotcímke és jelentkezhetőség', () {
      expect(openMine.badge, GameBadge.joined);
      expect(summary(players: 9).badge, GameBadge.almostFull);
      expect(runningOther.badge, GameBadge.runningJoinable);
      expect(runningMine.badge, GameBadge.running);
      expect(soon.badge, GameBadge.soon);
      expect(summary(maxPlayers: 0, players: 0).fill, 0);
      expect(fresh.canJoin, isTrue);
      expect(runningOther.canJoin, isTrue);
      expect(summary(status: 'fut', round: 4).canJoin, isFalse);
      expect(summary(players: 10).canJoin, isFalse);
      expect(summary(players: 10).closedFull, isTrue);
      expect(runningMine.enterable, isTrue);
      expect(runningMine.whenText, '5. elszámolás / 20');
    });
  });

  blocTest<LobbyBloc, LobbyState>(
    'betöltés: csoportosítva',
    setUp: () => when(() => lobby.games()).thenAnswer((_) async => Right(all)),
    build: () => LobbyBloc(lobby, auth),
    act: (b) => b.add(const LobbyStarted()),
    expect: () => [
      const LobbyState(loading: true),
      LobbyState(loaded: true, groups: LobbyGroups.of(all)),
    ],
    verify: (b) {
      expect(b.state.games, [fresh, runningOther, soon]);
      expect(b.state.mineBadge, '2');
    },
  );

  blocTest<LobbyBloc, LobbyState>(
    'hiba, majd sikeres frissítés törli',
    setUp: () {
      var n = 0;
      when(() => lobby.games()).thenAnswer((_) async => n++ == 0 ? const Left(Failure('baj')) : Right(all));
    },
    build: () => LobbyBloc(lobby, auth),
    act: (b) async {
      b.add(const LobbyStarted());
      await Future<void>.delayed(Duration.zero);
      b.add(const LobbyRefreshRequested());
    },
    skip: 2,
    expect: () => [
      const LobbyState(loading: true),
      LobbyState(loaded: true, groups: LobbyGroups.of(all)),
    ],
    verify: (b) => expect(b.state.failure, isNull),
  );

  blocTest<LobbyBloc, LobbyState>(
    'fülváltás',
    build: () => LobbyBloc(lobby, auth),
    act: (b) => b.add(const LobbyTabSelected(LobbyTab.mine)),
    expect: () => [const LobbyState(tab: LobbyTab.mine)],
    verify: (b) => expect(b.state.emptyText, startsWith('Még nem jelentkeztél')),
  );

  blocTest<LobbyBloc, LobbyState>(
    'kilépés az AuthBlocon át',
    build: () => LobbyBloc(lobby, auth),
    act: (b) => b.add(const LobbySignOutRequested()),
    expect: () => <LobbyState>[],
    verify: (_) => verify(() => auth.add(const AuthSignOutRequested())).called(1),
  );
}
