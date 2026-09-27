import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../../core/failure.dart';
import '../../../core/tr.dart';
import '../../../domain/model/extensions.dart';
import '../../../domain/model/join_extensions.dart';
import '../../../domain/model/lobby_extensions.dart';
import '../../../domain/service/join_service.dart';
import '../../common/notice.dart';

part 'join_event.dart';
part 'join_state.dart';

/// Jelentkezés négy lépésben (ház, háttér, kezdőhely, összegzés): az űrlap állapota, ellenőrzése,
/// a lépések közti mozgás és a beküldés.
@injectable
class JoinBloc extends Bloc<JoinEvent, JoinState> {
  JoinBloc(this._service) : super(const JoinState()) {
    on<JoinStarted>(_started);
    on<JoinNameChanged>((e, emit) => emit(state.copyWith(name: e.name, nameError: _service.nameError(e.name), clearNameError: true)));
    on<JoinNameSubmitted>((e, emit) => emit(state.copyWith(touched: true)));
    on<JoinTinctureSelected>((e, emit) => emit(state.copyWith(tincture: e.tincture)));
    on<JoinBackgroundSelected>((e, emit) => emit(state.copyWith(background: e.background)));
    on<JoinStartSelected>((e, emit) => emit(state.copyWith(start: e.start)));
    on<JoinStartGoodSelected>((e, emit) => emit(state.copyWith(startGood: e.good)));
    on<JoinBackPressed>((e, emit) {
      if (state.step > 0 && !state.busy) emit(state.copyWith(step: state.step - 1));
    });
    on<JoinNextPressed>(_next, transformer: droppable());
  }

  final JoinService _service;

  Future<void> _started(JoinStarted e, Emitter<JoinState> emit) async {
    emit(JoinState(gameId: e.gameId, nameError: _service.nameError('')));
    final r = await _service.detail(e.gameId);
    r.fold(
      (f) => emit(state.copyWith(failure: f)),
      (v) => emit(state.copyWith(
        detail: v.$1,
        map: v.$2,
        clearFailure: true,
        tincture: v.$1.defaultTincture,
        background: v.$1.defaultBackground,
        start: v.$1.defaultStart,
      )),
    );
  }

  Future<void> _next(JoinNextPressed e, Emitter<JoinState> emit) async {
    final d = state.detail;
    if (d == null || state.busy) return;
    if (state.step == 0) {
      emit(state.copyWith(touched: true));
      if (state.nameError != null) return;
    }
    if (!state.lastStep) {
      emit(state.copyWith(step: state.step + 1));
      return;
    }
    emit(state.copyWith(busy: true));
    final r = await _service.join(d, state.form);
    r.fold(
      (f) => emit(state.copyWith(
        busy: false,
        step: _service.nameRejected(f) ? 0 : null,
        notice: Notice((state.notice?.seq ?? 0) + 1, const Tr('join.failed'), body: f.message, tone: 'danger'),
      )),
      (g) => emit(state.copyWith(busy: false, outcome: g.running || d.game.running ? JoinOutcome.enterGame : JoinOutcome.backToDetail)),
    );
  }
}
