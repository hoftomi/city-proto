part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Induláskor: a mentett munkamenet visszaállítása.
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Belépés egy szolgáltatóval: google | apple | discord.
class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested(this.provider);
  final String provider;

  @override
  List<Object?> get props => [provider];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// A szerver 401-et adott.
class _AuthSessionExpired extends AuthEvent {
  const _AuthSessionExpired();
}
