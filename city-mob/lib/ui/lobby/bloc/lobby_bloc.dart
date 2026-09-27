import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../../core/failure.dart';
import '../../../domain/model/lobby_extensions.dart';
import '../../../domain/service/lobby_service.dart';
import '../../auth/bloc/auth_bloc.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

/// Játékválasztó: a játékok betöltése és frissítése, csoportosítás a fülekre, fülváltás, kilépés.
@injectable
class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  LobbyBloc(this._service, this._auth) : super(const LobbyState()) {
    on<LobbyStarted>(_load, transformer: droppable());
    on<LobbyRefreshRequested>(_load, transformer: droppable());
    on<LobbyTabSelected>((e, emit) => emit(state.copyWith(tab: e.tab)));
    on<LobbySignOutRequested>((e, emit) => _auth.add(const AuthSignOutRequested()));
  }

  final LobbyService _service;
  final AuthBloc _auth;

  Future<void> _load(LobbyEvent e, Emitter<LobbyState> emit) async {
    emit(state.copyWith(loading: true, clearFailure: true));
    final r = await _service.games();
    r.fold(
      (f) => emit(state.copyWith(loading: false, failure: f)),
      (games) => emit(state.copyWith(loading: false, loaded: true, groups: LobbyGroups.of(games))),
    );
  }
}
