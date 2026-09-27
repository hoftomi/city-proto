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
    ReportView(id: id, round: 1, kind: 'kem', confidence: null, title: id, text: '', tone: 'info', createdAt: DateTime.utc(2026, 9, 4), isPublic: public);

void main() {
  final game = GameState.fromJson(jsonDecode(File('test/fixtures/game_state.json').readAsStringSync()) as Map<String, dynamic>);
  final reports = [_report('a', true), _report('b', false)];
  late _Service service;

  setUp(() {
    service = _Service();
    when(() => service.reports('delkelet-1')).thenAnswer((_) async => Right(reports));
  });

  blocTest<ReportsBloc, ReportsState>('az első játékállapotnál betölti a jelentéseket',
      build: () => ReportsBloc(service),
      act: (b) => b.add(ReportsGameUpdated(game)),
      expect: () => [
            isA<ReportsState>().having((s) => s.key, 'key', game.feedKey).having((s) => s.status, 'status', ReportsStatus.initial),
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.loading),
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.ready).having((s) => s.reports, 'jelentések', reports),
          ]);

  blocTest<ReportsBloc, ReportsState>('nem tölt újra, ha a játékállapot lényegében nem változott (például új vázlatparancs)',
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

  blocTest<ReportsBloc, ReportsState>('elszámolás után újratölt',
      build: () => ReportsBloc(service),
      act: (b) async {
        b.add(ReportsGameUpdated(game));
        await Future<void>.delayed(Duration.zero);
        b.add(ReportsGameUpdated(game.copyWith(clock: game.clock.copyWith(settlements: 7))));
      },
      verify: (_) => verify(() => service.reports('delkelet-1')).called(2));

  blocTest<ReportsBloc, ReportsState>('szűrés: a látható jelentések a szűrő szerint',
      build: () => ReportsBloc(service),
      seed: () => ReportsState(gameId: 'delkelet-1', status: ReportsStatus.ready, reports: reports),
      act: (b) => b.add(const ReportsFilterChanged(ReportFilter.sajat)),
      expect: () => [isA<ReportsState>().having((s) => s.visible.map((r) => r.id), 'látható', ['b'])]);

  blocTest<ReportsBloc, ReportsState>('hibánál a hiba az állapotban; kézi frissítés után eltűnik',
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
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.failure).having((s) => s.failure, 'hiba', Failure.offline),
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.loading),
            isA<ReportsState>().having((s) => s.status, 'status', ReportsStatus.ready).having((s) => s.failure, 'hiba', isNull),
          ]);
}
