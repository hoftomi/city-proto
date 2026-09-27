import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../../domain/model/extensions.dart';
import '../../../domain/service/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Az app munkamenete: induláskor visszaállítja a mentett belépést, kezeli a szolgáltatói belépést és a kilépést.
/// A router ennek az állapota szerint irányít (bejelentkezés vagy játékválasztó).
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._service) : super(const AuthState()) {
    on<AuthStarted>(_started);
    on<AuthSignInRequested>(_signIn, transformer: droppable());
    on<AuthSignOutRequested>(_signOut);
    on<_AuthSessionExpired>(_expired);
    _expiredSub = _service.sessionExpired.listen((_) => add(const _AuthSessionExpired()));
  }

  final AuthService _service;
  late final StreamSubscription<void> _expiredSub;

  Future<void> _started(AuthStarted event, Emitter<AuthState> emit) async {
    final user = await _service.restore();
    emit(state.copyWith(status: user == null ? AuthStatus.signedOut : AuthStatus.signedIn, user: user));
    if (user != null) {
      // A szerep (ADMIN) közben változhatott: háttérben frissítjük.
      final fresh = await _service.refresh();
      if (fresh.isRight) emit(state.copyWith(user: fresh.right));
    }
  }

  Future<void> _signIn(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(busyProvider: event.provider, clearError: true));
    final r = await _service.signIn(event.provider);
    r.fold(
      (f) => emit(state.copyWith(clearBusy: true, error: f.message)),
      (user) => emit(user == null
          ? state.copyWith(clearBusy: true)
          : state.copyWith(status: AuthStatus.signedIn, user: user, clearBusy: true)),
    );
  }

  Future<void> _signOut(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    await _service.signOut();
    emit(const AuthState(status: AuthStatus.signedOut));
  }

  Future<void> _expired(_AuthSessionExpired event, Emitter<AuthState> emit) async {
    if (state.status != AuthStatus.signedIn) return;
    await _service.signOut();
    emit(const AuthState(status: AuthStatus.signedOut, error: 'A munkamenet lejárt. Jelentkezz be újra.'));
  }

  @override
  Future<void> close() {
    _expiredSub.cancel();
    return super.close();
  }
}
