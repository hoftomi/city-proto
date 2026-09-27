import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../../../core/failure.dart';
import '../../../../core/tr.dart';
import '../../../../domain/model/game_view_extensions.dart';
import '../../../../domain/service/game_service.dart';

part 'ranking_event.dart';
part 'ranking_state.dart';

/// A Rangsor fül: a legitimitás-rangsor betöltése és a saját népszerűség városonként. A játékállapot minden
/// változásánál frissül a népszerűségi tábla; a rangsort csak akkor tölti újra, ha változhatott (GameViewX.feedKey).
@injectable
class RankingBloc extends Bloc<RankingEvent, RankingState> {
  RankingBloc(this._service) : super(const RankingState()) {
    on<RankingGameUpdated>(_gameUpdated, transformer: sequential());
    on<RankingRefreshRequested>((e, emit) => _load(emit), transformer: droppable());
  }

  final GameService _service;

  Future<void> _gameUpdated(RankingGameUpdated e, Emitter<RankingState> emit) async {
    final g = e.game;
    if (g == null) return;
    final changed = g.feedKey != state.key;
    emit(state.copyWith(gameId: g.gameId, key: g.feedKey, caption: g.rankingCaption, popularity: g.popularityRows));
    if (changed) await _load(emit);
  }

  Future<void> _load(Emitter<RankingState> emit) async {
    final id = state.gameId;
    if (id == null) return;
    emit(state.copyWith(status: RankingStatus.loading));
    final r = await _service.ranking(id);
    r.fold(
      (f) => emit(state.copyWith(status: RankingStatus.failure, failure: f)),
      (rows) => emit(state.copyWith(status: RankingStatus.ready, rows: rows, clearFailure: true)),
    );
  }
}
