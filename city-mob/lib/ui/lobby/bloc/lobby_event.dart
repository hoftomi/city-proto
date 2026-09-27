part of 'lobby_bloc.dart';

sealed class LobbyEvent extends Equatable {
  const LobbyEvent();

  @override
  List<Object?> get props => [];
}

/// A képernyő megnyitásakor: a játékok betöltése.
class LobbyStarted extends LobbyEvent {
  const LobbyStarted();
}

/// Lehúzás vagy visszatérés a részletekről: újratöltés.
class LobbyRefreshRequested extends LobbyEvent {
  const LobbyRefreshRequested();
}

class LobbyTabSelected extends LobbyEvent {
  const LobbyTabSelected(this.tab);
  final LobbyTab tab;

  @override
  List<Object?> get props => [tab];
}

/// Kilépés (az AuthBloc végzi, a router a belépésre visz).
class LobbySignOutRequested extends LobbyEvent {
  const LobbySignOutRequested();
}
