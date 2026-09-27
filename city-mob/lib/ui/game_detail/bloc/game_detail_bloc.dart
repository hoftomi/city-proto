import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../../core/failure.dart';
import '../../../core/tr.dart';
import '../../../domain/service/join_service.dart';
import '../../../domain/service/lobby_service.dart';
import '../../common/notice.dart';

part 'game_detail_event.dart';
part 'game_detail_state.dart';

/// Egy játék részletei a térképpel; a jelentkezés visszavonása.
@injectable
class GameDetailBloc extends Bloc<GameDetailEvent, GameDetailState> {
  GameDetailBloc(this._lobby, this._join) : super(const GameDetailState()) {
    on<GameDetailStarted>((e, emit) async {
      emit(GameDetailState(gameId: e.gameId));
      await _load(emit);
    });
    on<GameDetailRefreshRequested>((e, emit) => _load(emit), transformer: droppable());
    on<GameDetailWithdrawRequested>(_withdraw, transformer: droppable());
    on<GameDetailJoined>((e, emit) async {
      emit(state.copyWith(notice: _notice(const Tr('detail.joined'), body: const Tr('detail.joined_body'), tone: 'ok')));
      await _load(emit);
    });
  }

  final LobbyService _lobby;
  final JoinService _join;

  Future<void> _load(Emitter<GameDetailState> emit) async {
    final id = state.gameId;
    if (id == null) return;
    final r = await _join.detail(id);
    r.fold(
      (f) => emit(state.copyWith(failure: f)),
      (v) => emit(state.copyWith(detail: v.$1, map: v.$2, clearFailure: true)),
    );
  }

  Future<void> _withdraw(GameDetailWithdrawRequested e, Emitter<GameDetailState> emit) async {
    final id = state.gameId;
    if (id == null) return;
    emit(state.copyWith(busy: true));
    final r = await _lobby.withdraw(id);
    if (r.isLeft) {
      emit(state.copyWith(busy: false, notice: _notice(const Tr('detail.failed'), body: r.left.message, tone: 'danger')));
      return;
    }
    emit(state.copyWith(notice: _notice(const Tr('detail.withdrawn'), tone: 'ok')));
    await _load(emit);
    emit(state.copyWith(busy: false));
  }

  Notice _notice(Tr title, {Tr? body, String tone = 'info'}) => Notice((state.notice?.seq ?? 0) + 1, title, body: body, tone: tone);
}
