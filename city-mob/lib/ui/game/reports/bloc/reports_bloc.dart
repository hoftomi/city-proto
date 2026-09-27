import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../../../core/failure.dart';
import '../../../../domain/model/game_view_extensions.dart';
import '../../../../domain/service/game_service.dart';

part 'reports_event.dart';
part 'reports_state.dart';

/// A Jelentések fül: a jelentések betöltése és szűrése. A játékállapot minden változásáról értesül
/// (ReportsGameUpdated), de csak akkor tölt újra, ha új jelentés lehet (GameViewX.feedKey).
@injectable
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc(this._service) : super(const ReportsState()) {
    on<ReportsGameUpdated>(_gameUpdated, transformer: sequential());
    on<ReportsRefreshRequested>((e, emit) => _load(emit), transformer: droppable());
    on<ReportsFilterChanged>((e, emit) => emit(state.copyWith(filter: e.filter)));
  }

  final GameService _service;

  Future<void> _gameUpdated(ReportsGameUpdated e, Emitter<ReportsState> emit) async {
    final g = e.game;
    if (g == null || g.feedKey == state.key) return;
    emit(state.copyWith(gameId: g.gameId, key: g.feedKey));
    await _load(emit);
  }

  Future<void> _load(Emitter<ReportsState> emit) async {
    final id = state.gameId;
    if (id == null) return;
    emit(state.copyWith(status: ReportsStatus.loading));
    final r = await _service.reports(id);
    r.fold(
      (f) => emit(state.copyWith(status: ReportsStatus.failure, failure: f)),
      (list) => emit(state.copyWith(status: ReportsStatus.ready, reports: list, clearFailure: true)),
    );
  }
}
