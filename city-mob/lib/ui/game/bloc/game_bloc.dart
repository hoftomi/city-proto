import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../../core/failure.dart';
import '../../../core/tr.dart';
import '../../../domain/service/game_service.dart';
import '../../../util/format.dart';
import '../../common/notice.dart';

part 'game_event.dart';
part 'game_state.dart';

/// Egy futó játék: az állapot és a térkép betöltése, a játékos műveletei, a játék órája,
/// és az automatikus frissítés, amikor lejár a saját lap vagy elszámolás van.
/// A játék minden képernyője (Térkép, Város, Jelentések, Parancslap, Rangsor) ebből olvas.
@injectable
class GameBloc extends Bloc<GameEvent, GameViewState> {
  GameBloc(this._service) : super(const GameViewState()) {
    on<GameStarted>(_started);
    on<GameRefreshRequested>(_refresh, transformer: droppable());
    on<GameTicked>(_ticked);
    on<GameMapCitySelected>((e, emit) => emit(state.copyWith(selectedCity: e.cityId)));
    on<GameOrderAdded>(_addOrder, transformer: sequential());
    on<GameOrderRemoved>((e, emit) => _act(emit, () => _service.removeOrder(_id, e.orderId)), transformer: sequential());
    on<GameSealRequested>(
        (e, emit) => _act(emit, () => _service.seal(_id), success: (s) => Tr('notice.sealed', {'time': durText(Duration(minutes: s.clock.maturationMinutes))})),
        transformer: droppable());
    on<GameIntelOffered>((e, emit) => _act(emit, () => _service.offerIntel(_id, e.intelId, e.buyerId, e.price), success: (_) => e.success ?? const Tr('notice.offer_sent')),
        transformer: sequential());
    on<GameOfferAccepted>((e, emit) => _act(emit, () => _service.acceptOffer(_id, e.offerId), success: (_) => e.success ?? const Tr('notice.offer_bought')),
        transformer: sequential());
    on<GameOfferDeclined>((e, emit) => _act(emit, () => _service.declineOffer(_id, e.offerId)), transformer: sequential());
    on<GameAdminSettleRequested>((e, emit) => _act(emit, () => _service.adminSettle(_id), success: (_) => const Tr('notice.settled')),
        transformer: droppable());
    on<GameAdminAdvanceRequested>(
        (e, emit) => _act(emit, () => _service.adminAdvance(_id, e.minutes), success: (_) => e.minutes == null ? const Tr('notice.advanced_next') : Tr('notice.advanced_minutes', {'minutes': '${e.minutes}'})),
        transformer: droppable());
  }

  final GameService _service;
  Timer? _timer;
  DateTime _lastAuto = DateTime.fromMillisecondsSinceEpoch(0);

  String get _id => state.gameId!;

  Future<void> _started(GameStarted e, Emitter<GameViewState> emit) async {
    emit(GameViewState(gameId: e.gameId, status: GameStatus.loading));
    final r = await _service.load(e.gameId);
    r.fold(
      (f) => emit(state.copyWith(status: GameStatus.failure, failure: f)),
      (v) {
        final now = DateTime.now();
        emit(state.copyWith(
          status: GameStatus.ready,
          game: v.$1,
          map: v.$2,
          fetchedAt: now,
          now: _service.gameNow(v.$1, now, now),
          selectedCity: _service.defaultCity(v.$1),
        ));
      },
    );
    // A betöltés alatt a játékot elhagyhatták: bezárt blocnak nem indítunk órát.
    if (isClosed) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) { if (!isClosed) add(const GameTicked()); });
  }

  Future<void> _refresh(GameRefreshRequested e, Emitter<GameViewState> emit) async {
    if (state.gameId == null) return;
    final r = await _service.state(_id);
    r.fold((f) => emit(state.copyWith(failure: f, notice: _notice(f.message, tone: 'danger'))), (s) => emit(_withGame(s)));
  }

  /// Óraütés: a visszaszámlálók frissülnek; lejárt saját lap vagy elszámolás után percenként legfeljebb egyszer újratölt.
  void _ticked(GameTicked e, Emitter<GameViewState> emit) {
    final game = state.game, fetchedAt = state.fetchedAt;
    if (game == null || fetchedAt == null) return;
    final now = _service.gameNow(game, fetchedAt, DateTime.now());
    emit(state.copyWith(now: now));
    if (!state.busy && _service.refreshDue(game, now) && DateTime.now().difference(_lastAuto) > const Duration(minutes: 1)) {
      _lastAuto = DateTime.now();
      add(const GameRefreshRequested());
    }
  }

  /// Parancs a vázlatra; siker után jelzi, mi került fel, és ha a parancsnak figyelmeztetése van (például hamis hír).
  Future<void> _addOrder(GameOrderAdded e, Emitter<GameViewState> emit) async {
    final before = state.game;
    emit(state.copyWith(busy: true));
    final r = await _service.addOrder(_id, e.order);
    r.fold(
      (f) => emit(state.copyWith(busy: false, notice: _notice(f.message, tone: 'danger'))),
      (s) {
        final added = before == null ? null : _service.addedOrder(before, s);
        emit(_withGame(s).copyWith(
          busy: false,
          notice: added == null
              ? null
              : added.warning != null
                  ? _notice(Tr('notice.order_added_named', {'label': added.label}), body: Tr.raw(added.warning!), tone: 'warn')
                  : _notice(const Tr('notice.order_added'), body: Tr.raw(added.label)),
        ));
      },
    );
  }

  Future<void> _act(Emitter<GameViewState> emit, Future<Either<Failure, GameState>> Function() call, {Tr Function(GameState)? success}) async {
    emit(state.copyWith(busy: true));
    final r = await call();
    r.fold(
      (f) => emit(state.copyWith(busy: false, notice: _notice(f.message, tone: 'danger'))),
      (s) => emit(_withGame(s).copyWith(busy: false, notice: success == null ? null : _notice(success(s), tone: 'ok'))),
    );
  }

  GameViewState _withGame(GameState s) {
    final now = DateTime.now();
    return state.copyWith(game: s, fetchedAt: now, now: _service.gameNow(s, now, now), status: GameStatus.ready, clearFailure: true);
  }

  Notice _notice(Tr title, {Tr? body, String tone = 'info'}) => Notice((state.notice?.seq ?? 0) + 1, title, body: body, tone: tone);

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
