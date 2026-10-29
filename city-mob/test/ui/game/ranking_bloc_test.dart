import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/core/failure.dart';
import 'package:tron_nelkul/core/tr.dart';
import 'package:tron_nelkul/domain/model/game_view_extensions.dart';
import 'package:tron_nelkul/domain/service/game_service.dart';
import 'package:tron_nelkul/ui/game/ranking/bloc/ranking_bloc.dart';

class _Service extends Mock implements GameService {}

RankRow _row(int rank, String id, bool self) =>
    RankRow(rank: rank, playerId: id, name: id, tincture: 'blue', npc: !self, legit: 10 - rank, shares: 3, seats: 2, self: self);

void main() {
  final game = GameState.fromJson(jsonDecode(File('test/fixtures/game_state.json').readAsStringSync()) as Map<String, dynamic>);
  final rows = [_row(1, 'npc1', false), _row(2, 'me', true)];
  late _Service service;

  setUp(() {
    service = _Service();
    when(() => service.ranking('delkelet-1')).thenAnswer((_) async => Right(rows));
  });

  blocTest<RankingBloc, RankingState>('loads the ranking, and the caption and popularity from the game state',
      build: () => RankingBloc(service),
      act: (b) => b.add(RankingGameUpdated(game)),
      expect: () => [
            isA<RankingState>()
                .having((s) => s.caption, 'caption', const Tr('ranking.caption', {'n': '6', 'm': '6'}))
                .having((s) => s.popularity.length, 'cities', 5)
                .having((s) => s.popularity.first, 'first', const PopularityRow(name: 'Szélmező', pop: 10, seats: 5)),
            isA<RankingState>().having((s) => s.status, 'status', RankingStatus.loading),
            isA<RankingState>().having((s) => s.rows, 'rows', rows).having((s) => s.selfRows, 'selfRows', {1}),
          ]);

  blocTest<RankingBloc, RankingState>('with the same key only popularity updates, the ranking is not reloaded',
      build: () => RankingBloc(service),
      act: (b) async {
        b.add(RankingGameUpdated(game));
        await Future<void>.delayed(Duration.zero);
        final c = game.cities.first;
        b.add(RankingGameUpdated(game.copyWith(cities: [c.copyWith(myPop: 14.4), ...game.cities.skip(1)])));
      },
      skip: 3,
      expect: () => [isA<RankingState>().having((s) => s.popularity.first.pop, 'popularity', 14).having((s) => s.status, 'status', RankingStatus.ready)],
      verify: (_) => verify(() => service.ranking('delkelet-1')).called(1));

  blocTest<RankingBloc, RankingState>('on error the failure is in the state',
      build: () {
        when(() => service.ranking('delkelet-1')).thenAnswer((_) async => const Left(Failure.offline));
        return RankingBloc(service);
      },
      act: (b) => b.add(RankingGameUpdated(game)),
      skip: 2,
      expect: () => [isA<RankingState>().having((s) => s.status, 'status', RankingStatus.failure).having((s) => s.failure, 'failure', Failure.offline)]);
}
