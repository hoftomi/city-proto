import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/core/failure.dart';
import 'package:tron_nelkul/core/tr.dart';
import 'package:tron_nelkul/domain/model/join_extensions.dart';
import 'package:tron_nelkul/domain/service/join_service.dart';
import 'package:tron_nelkul/domain/service/lobby_service.dart';
import 'package:tron_nelkul/ui/join/bloc/join_bloc.dart';

import '../../helpers/l10n.dart';
import '../lobby/lobby_fixtures.dart';

class _MockLobby extends Mock implements LobbyService {}

void main() {
  late _MockLobby lobby;
  late JoinService service;
  final d = detail();

  setUpAll(loadTestTranslations);
  setUpAll(() => registerFallbackValue(JoinRequest(houseName: '', background: Background.merchant, startSlot: '')));

  setUp(() {
    lobby = _MockLobby();
    service = JoinService(lobby);
    when(() => lobby.game('g1')).thenAnswer((_) async => Right(d));
    when(() => lobby.map('m1')).thenAnswer((_) async => Right(mapDef));
  });

  /// Loaded form with the defaults.
  JoinState ready({int step = 0, String name = '', GameDetail? detail}) => JoinState(
        gameId: 'g1',
        detail: detail ?? d,
        map: mapDef,
        step: step,
        name: name,
        nameError: service.nameError(name),
        background: Background.merchant,
        start: 's1',
      );

  group('JoinService', () {
    test('name validation', () {
      expect(service.nameError(' ab '), const Tr('join.name_too_short', {'min': '3'}));
      expect(service.nameError('a' * 25), const Tr('join.name_too_long', {'max': '24'}));
      expect(service.nameError(' Kékholló '), isNull);
      expect(service.nameError('ab')!.text, 'Legalább 3 betű kell.');
      expect(service.nameError('a' * 25)!.text, 'Legfeljebb 24 betű lehet.');
      expect([for (final s in JoinService.steps) s.text], ['Ház', 'Háttér', 'Kezdőhely', 'Összegzés']);
    });

    test('request: starting good only for the merchant house', () {
      final f = (name: ' Kékholló ', background: Background.merchant, start: 's1', startGood: null);
      expect(service.request(d, f), JoinRequest(houseName: 'Kékholló', background: Background.merchant, startSlot: 's1', startGood: 'wine'));
      expect(service.request(d, (name: 'X', background: Background.merchant, start: 's1', startGood: 'salt')).startGood, 'salt');
      expect(service.request(d, (name: 'X', background: Background.noble, start: 's1', startGood: 'salt')).startGood, isNull);
      expect(service.request(d, (name: 'X', background: Background.merchant, start: 's2', startGood: 'salt')).startGood, isNull);
    });

    test('default background: the merchant house if offered, otherwise the first one', () {
      expect(d.defaultBackground, Background.merchant);
      final noMerchant = detail().copyWith(backgrounds: [BackgroundDto(id: Background.shadow, name: 'Árnyékház', icon: 'spy', perks: const [])]);
      expect(noMerchant.defaultBackground, Background.shadow);
      expect(noMerchant.needsGood(Background.shadow, 's1'), isFalse);
    });
  });

  blocTest<JoinBloc, JoinState>(
    'loads with the defaults',
    build: () => JoinBloc(service),
    act: (b) => b.add(const JoinStarted('g1')),
    expect: () => [JoinState(gameId: 'g1', nameError: service.nameError('')), ready()],
    verify: (b) {
      expect(b.state.needsGood, isTrue);
      expect(b.state.good?.id, 'wine');
      expect(b.state.nextLabel, const Tr('join.next'));
      expect(b.state.canPop, isTrue);
    },
  );

  blocTest<JoinBloc, JoinState>(
    'short name does not advance, error shown, button disabled',
    build: () => JoinBloc(service),
    seed: () => ready(),
    act: (b) => b
      ..add(const JoinNameChanged('ab'))
      ..add(const JoinNextPressed()),
    verify: (b) {
      expect(b.state.step, 0);
      expect(b.state.shownNameError, const Tr('join.name_too_short', {'min': '3'}));
      expect(b.state.canContinue, isFalse);
    },
  );

  blocTest<JoinBloc, JoinState>(
    'steps forward and back, selections',
    build: () => JoinBloc(service),
    seed: () => ready(),
    act: (b) async {
      b
        ..add(const JoinNameChanged('Kékholló'))
        ..add(const JoinNextPressed());
      await Future<void>.delayed(Duration.zero);
      b
        ..add(const JoinBackgroundSelected(Background.noble))
        ..add(const JoinNextPressed());
      await Future<void>.delayed(Duration.zero);
      b
        ..add(const JoinStartSelected('s2'))
        ..add(const JoinNextPressed());
      await Future<void>.delayed(Duration.zero);
      b.add(const JoinBackPressed());
    },
    verify: (b) {
      expect(b.state.step, 2);
      expect(b.state.background, Background.noble);
      expect(b.state.start, 's2');
      expect(b.state.needsGood, isFalse);
      expect(b.state.canPop, isFalse);
      expect(b.state.backLabel, const Tr('join.back'));
    },
  );

  blocTest<JoinBloc, JoinState>(
    'submit: open game goes back to the details',
    setUp: () => when(() => lobby.join('g1', any())).thenAnswer((_) async => const Right<Failure, void>(null)),
    build: () => JoinBloc(service),
    seed: () => ready(step: 3, name: 'Kékholló').copyWith(touched: true, startGood: 'salt'),
    act: (b) => b.add(const JoinNextPressed()),
    expect: () => [
      ready(step: 3, name: 'Kékholló').copyWith(touched: true, startGood: 'salt', busy: true),
      ready(step: 3, name: 'Kékholló').copyWith(touched: true, startGood: 'salt', outcome: JoinOutcome.backToDetail),
    ],
    verify: (_) => verify(() => lobby.join('g1',
        JoinRequest(houseName: 'Kékholló', background: Background.merchant, startSlot: 's1', startGood: 'salt'))).called(1),
  );

  blocTest<JoinBloc, JoinState>(
    'submit: running game enters the game (decided from the shown details; the join has no body)',
    setUp: () => when(() => lobby.join('g1', any())).thenAnswer((_) async => const Right<Failure, void>(null)),
    build: () => JoinBloc(service),
    seed: () => ready(step: 3, name: 'Kékholló', detail: detail(game: summary(status: 'running'))),
    act: (b) => b.add(const JoinNextPressed()),
    verify: (b) => expect(b.state.outcome, JoinOutcome.enterGame),
  );

  blocTest<JoinBloc, JoinState>(
    'taken name: error message and back to the first step',
    setUp: () => when(() => lobby.join('g1', any())).thenAnswer((_) async => const Left(Failure(Tr.raw('Ez a név ebben a játékban már foglalt.'), status: 409, code: 'house_name'))),
    build: () => JoinBloc(service),
    seed: () => ready(step: 3, name: 'Kékholló'),
    act: (b) => b.add(const JoinNextPressed()),
    verify: (b) {
      expect(b.state.step, 0);
      expect(b.state.busy, isFalse);
      expect(b.state.outcome, isNull);
      expect(b.state.notice?.title, const Tr('join.failed'));
      expect(b.state.notice?.body, const Tr.raw('Ez a név ebben a játékban már foglalt.'));
      expect(b.state.notice?.tone, 'danger');
    },
  );

  blocTest<JoinBloc, JoinState>(
    'other error: stays on the summary',
    setUp: () => when(() => lobby.join('g1', any())).thenAnswer((_) async => const Left(Failure(Tr.raw('A játék betelt.')))),
    build: () => JoinBloc(service),
    seed: () => ready(step: 3, name: 'Kékholló'),
    act: (b) => b.add(const JoinNextPressed()),
    verify: (b) => expect(b.state.step, 3),
  );
}
