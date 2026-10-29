import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../../core/failure.dart';
import '../../../core/tr.dart';
import '../../../domain/model/lobby_extensions.dart';
import '../../../domain/service/lobby_service.dart';
import '../../auth/bloc/auth_bloc.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

/// Lobby: loading and refreshing the game lists, tab switching (the archive loads on first open), logout.
@injectable
class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  LobbyBloc(this._service, this._auth) : super(const LobbyState()) {
    on<LobbyStarted>(_load, transformer: droppable());
    on<LobbyRefreshRequested>(_load, transformer: droppable());
    on<LobbyTabSelected>(_select);
    on<LobbySignOutRequested>((e, emit) => _auth.add(const AuthSignOutRequested()));
  }

  final LobbyService _service;
  final AuthBloc _auth;

  /// Own and available games in parallel; the archive too if it has been opened already.
  Future<void> _load(LobbyEvent e, Emitter<LobbyState> emit) async {
    emit(state.copyWith(loading: true, clearFailure: true));
    final archive = state.tab == LobbyTab.finished || state.groups.finished != null;
    final r = await Future.wait([_service.joinedGames(), _service.availableGames(), if (archive) _service.archivedGames()]);
    final failed = r.where((x) => x.isLeft).firstOrNull;
    if (failed != null) return emit(state.copyWith(loading: false, failure: failed.left));
    emit(state.copyWith(
      loading: false,
      loaded: true,
      groups: LobbyGroups(mine: r[0].right, fresh: r[1].right, finished: archive ? r[2].right : null),
    ));
  }

  Future<void> _select(LobbyTabSelected e, Emitter<LobbyState> emit) async {
    emit(state.copyWith(tab: e.tab));
    if (e.tab != LobbyTab.finished || state.groups.finished != null) return;
    emit(state.copyWith(loading: true, clearFailure: true));
    final r = await _service.archivedGames();
    r.fold(
      (f) => emit(state.copyWith(loading: false, failure: f)),
      (games) => emit(state.copyWith(loading: false, groups: state.groups.copyWith(finished: games))),
    );
  }
}
