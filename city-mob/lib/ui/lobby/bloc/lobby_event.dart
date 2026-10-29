part of 'lobby_bloc.dart';

sealed class LobbyEvent extends Equatable {
  const LobbyEvent();

  @override
  List<Object?> get props => [];
}

/// On screen open: load the games.
class LobbyStarted extends LobbyEvent {
  const LobbyStarted();
}

/// Pull-to-refresh or return from the details: reload.
class LobbyRefreshRequested extends LobbyEvent {
  const LobbyRefreshRequested();
}

class LobbyTabSelected extends LobbyEvent {
  const LobbyTabSelected(this.tab);
  final LobbyTab tab;

  @override
  List<Object?> get props => [tab];
}

/// Logout (done by the AuthBloc; the router goes to login).
class LobbySignOutRequested extends LobbyEvent {
  const LobbySignOutRequested();
}
