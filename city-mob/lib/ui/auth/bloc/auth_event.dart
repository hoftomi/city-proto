part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// On startup: restore the saved session.
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Login with a provider: google | apple | discord.
class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested(this.provider);
  final String provider;

  @override
  List<Object?> get props => [provider];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// The server returned 401.
class _AuthSessionExpired extends AuthEvent {
  const _AuthSessionExpired();
}
