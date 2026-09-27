part of 'game_detail_bloc.dart';

sealed class GameDetailEvent extends Equatable {
  const GameDetailEvent();

  @override
  List<Object?> get props => [];
}

/// A képernyő megnyitásakor: a részletek és a térkép betöltése.
class GameDetailStarted extends GameDetailEvent {
  const GameDetailStarted(this.gameId);
  final String gameId;

  @override
  List<Object?> get props => [gameId];
}

class GameDetailRefreshRequested extends GameDetailEvent {
  const GameDetailRefreshRequested();
}

class GameDetailWithdrawRequested extends GameDetailEvent {
  const GameDetailWithdrawRequested();
}

/// Sikeres jelentkezés után visszatért a jelentkezésről: üzenet és újratöltés.
class GameDetailJoined extends GameDetailEvent {
  const GameDetailJoined();
}
