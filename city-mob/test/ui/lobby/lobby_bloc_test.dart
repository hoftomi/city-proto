import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_nelkul/core/failure.dart';
import 'package:tron_nelkul/core/tr.dart';
import 'package:tron_nelkul/domain/model/lobby_extensions.dart';
import 'package:tron_nelkul/domain/service/lobby_service.dart';
import 'package:tron_nelkul/ui/auth/bloc/auth_bloc.dart';
import 'package:tron_nelkul/ui/lobby/bloc/lobby_bloc.dart';

import '../../helpers/l10n.dart';
import 'lobby_fixtures.dart';

class _MockLobby extends Mock implements LobbyService {}

class _MockAuth extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late _MockLobby lobby;
  late _MockAuth auth;

  final runningMine = summary(id: 'r', status: 'running', round: 5, myHouse: house());
  final openMine = summary(id: 'o', myHouse: house());
  final fresh = summary(id: 'n');
  final runningOther = summary(id: 'x', status: 'running', round: 2);
  final soon = summary(id: 's', status: 'announced');
  final done = summary(id: 'd', status: 'finished', myHouse: house());
  final mine = [runningMine, openMine];
  final available = [fresh, runningOther, soon];
  final archived = [done];

  setUpAll(loadTestTranslations);

  setUp(() {
    lobby = _MockLobby();
    auth = _MockAuth();
  });

  group('LobbyGroups', () {
    test('tabs and the continue list', () {
      final g = LobbyGroups(mine: mine, fresh: available);
      expect(g.running, [runningMine]);
      expect(g.tab(LobbyTab.mine), mine);
      expect(g.tab(LobbyTab.fresh), available);
      expect(g.tab(LobbyTab.finished), isEmpty);
      expect(g.copyWith(finished: archived).tab(LobbyTab.finished), archived);
    });

    test('status badge and joinability', () {
      expect(openMine.badge, GameBadge.joined);
      expect(summary(players: 9).badge, GameBadge.almostFull);
      expect(runningOther.badge, GameBadge.runningJoinable);
      expect(runningMine.badge, GameBadge.running);
      expect(soon.badge, GameBadge.soon);
      expect(summary(maxPlayers: 0, players: 0).fill, 0);
      expect(fresh.canJoin, isTrue);
      expect(runningOther.canJoin, isTrue);
      expect(summary(status: 'running', round: 4).canJoin, isFalse);
      expect(summary(players: 10).canJoin, isFalse);
      expect(summary(players: 10).closedFull, isTrue);
      expect(runningMine.enterable, isTrue);
      expect(runningMine.whenText, const Tr('lobby.round_of', {'round': '5', 'max': '20'}));
      expect(done.whenText, const Tr('lobby.when.closed'));
      expect(runningMine.cardWhenText, isNull);
      expect(done.cardWhenText, done.whenText);
      expect(done.resultText, const Tr('lobby.winner', {'winner': '–'}));
      expect(fresh.startsAtText, const Tr('lobby.when.soon'));
    });

    test('labels come from the translations', () {
      expect(runningMine.whenText.text, '5. elszámolás / 20');
      expect(const Tr('lobby.empty_mine').text, startsWith('Még nem jelentkeztél'));
      expect(const Tr('lobby.winner_place', {'winner': 'X', 'place': '2'}).text, 'Győztes: X · a te helyezésed: 2.');
    });
  });

  blocTest<LobbyBloc, LobbyState>(
    'load: own and available games, separately; the archive is not requested',
    setUp: () {
      when(() => lobby.joinedGames()).thenAnswer((_) async => Right(mine));
      when(() => lobby.availableGames()).thenAnswer((_) async => Right(available));
    },
    build: () => LobbyBloc(lobby, auth),
    act: (b) => b.add(const LobbyStarted()),
    expect: () => [
      const LobbyState(loading: true),
      LobbyState(loaded: true, groups: LobbyGroups(mine: mine, fresh: available)),
    ],
    verify: (b) {
      expect(b.state.games, available);
      expect(b.state.mineBadge, '2');
      verifyNever(() => lobby.archivedGames());
    },
  );

  blocTest<LobbyBloc, LobbyState>(
    'the finished tab loads the archive once; a refresh then reloads it too',
    setUp: () {
      when(() => lobby.joinedGames()).thenAnswer((_) async => Right(mine));
      when(() => lobby.availableGames()).thenAnswer((_) async => Right(available));
      when(() => lobby.archivedGames()).thenAnswer((_) async => Right(archived));
    },
    build: () => LobbyBloc(lobby, auth),
    seed: () => LobbyState(loaded: true, groups: LobbyGroups(mine: mine, fresh: available)),
    act: (b) async {
      b.add(const LobbyTabSelected(LobbyTab.finished));
      await Future<void>.delayed(Duration.zero);
      b.add(const LobbyTabSelected(LobbyTab.fresh));
      b.add(const LobbyTabSelected(LobbyTab.finished));
      await Future<void>.delayed(Duration.zero);
      b.add(const LobbyRefreshRequested());
    },
    verify: (b) {
      expect(b.state.tab, LobbyTab.finished);
      expect(b.state.games, archived);
      verify(() => lobby.archivedGames()).called(2);
    },
  );

  blocTest<LobbyBloc, LobbyState>(
    'error, then a successful refresh clears it',
    setUp: () {
      var n = 0;
      when(() => lobby.joinedGames()).thenAnswer((_) async => n++ == 0 ? const Left(Failure(Tr.raw('oops'))) : Right(mine));
      when(() => lobby.availableGames()).thenAnswer((_) async => Right(available));
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
      LobbyState(loaded: true, groups: LobbyGroups(mine: mine, fresh: available)),
    ],
    verify: (b) => expect(b.state.failure, isNull),
  );

  blocTest<LobbyBloc, LobbyState>(
    'tab switch',
    build: () => LobbyBloc(lobby, auth),
    act: (b) => b.add(const LobbyTabSelected(LobbyTab.mine)),
    expect: () => [const LobbyState(tab: LobbyTab.mine)],
    verify: (b) => expect(b.state.emptyText, const Tr('lobby.empty_mine')),
  );

  blocTest<LobbyBloc, LobbyState>(
    'sign-out via AuthBloc',
    build: () => LobbyBloc(lobby, auth),
    act: (b) => b.add(const LobbySignOutRequested()),
    expect: () => <LobbyState>[],
    verify: (_) => verify(() => auth.add(const AuthSignOutRequested())).called(1),
  );
}
