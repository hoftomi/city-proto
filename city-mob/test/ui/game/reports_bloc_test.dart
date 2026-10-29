import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tron_api/tron_api.dart';
import 'package:tron_nelkul/core/failure.dart';
import 'package:tron_nelkul/domain/model/game_view_extensions.dart';
import 'package:tron_nelkul/domain/service/game_service.dart';
import 'package:tron_nelkul/ui/game/reports/bloc/reports_bloc.dart';

class _Service extends Mock implements GameService {}

ReportView _report(String id, bool public) =>
    ReportView(id: id, round: 1, kind: 'spy', confidence: null, title: id, text: '', tone: 'info', createdAt: DateTime.utc(2026, 9, 4), isPublic: public);

void main() {
  final game = GameState.fromJson(jsonDecode(File('test/fixtures/game_state.json').readAsStringSync()) as Map<String, dynamic>);
  final reports = [_report('a', true), _report('b', false)];
  late _Service service;

  setUp(() {
    service = _Service();
    when(() => service.reports('delkelet-1')).thenAnswer((_) async => Right(reports));
  });

  blocTest<ReportsBloc, ReportsState>('loads reports on the first game state',
      build: () => ReportsBloc(service),
      act: (b) => b.add(ReportsGameUpdated(game)),
      expect: () => [
            isA<ReportsState>().having((s) => s.key, 'key', game.feedKey).having((s) => s.status, 'status', ReportsStatus.initial),
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.loading),
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.ready).having((s) => s.reports, 'reports', reports),
          ]);

  blocTest<ReportsBloc, ReportsState>('does not reload if the game state has not materially changed (e.g. new draft order)',
      build: () => ReportsBloc(service),
      act: (b) async {
        b.add(ReportsGameUpdated(game));
        await Future<void>.delayed(Duration.zero);
        b.add(ReportsGameUpdated(game.copyWith(draft: const [])));
        b.add(const ReportsGameUpdated(null));
      },
      skip: 3,
      expect: () => const <ReportsState>[],
      verify: (_) => verify(() => service.reports('delkelet-1')).called(1));

  blocTest<ReportsBloc, ReportsState>('reloads after settlement',
      build: () => ReportsBloc(service),
      act: (b) async {
        b.add(ReportsGameUpdated(game));
        await Future<void>.delayed(Duration.zero);
        b.add(ReportsGameUpdated(game.copyWith(clock: game.clock.copyWith(settlements: 7))));
      },
      verify: (_) => verify(() => service.reports('delkelet-1')).called(2));

  blocTest<ReportsBloc, ReportsState>('filtering: visible reports follow the filter',
      build: () => ReportsBloc(service),
      seed: () => ReportsState(gameId: 'delkelet-1', status: ReportsStatus.ready, reports: reports),
      act: (b) => b.add(const ReportsFilterChanged(ReportFilter.own)),
      expect: () => [isA<ReportsState>().having((s) => s.visible.map((r) => r.id), 'visible', ['b'])]);

  blocTest<ReportsBloc, ReportsState>('on error the failure is in the state; cleared after manual refresh',
      build: () {
        var n = 0;
        when(() => service.reports('delkelet-1')).thenAnswer((_) async => n++ == 0 ? const Left(Failure.offline) : Right(reports));
        return ReportsBloc(service);
      },
      act: (b) async {
        b.add(ReportsGameUpdated(game));
        await Future<void>.delayed(Duration.zero);
        b.add(const ReportsRefreshRequested());
      },
      skip: 2,
      expect: () => [
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.failure).having((s) => s.failure, 'failure', Failure.offline),
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.loading),
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.ready).having((s) => s.failure, 'failure', isNull),
          ]);
}
