part of 'game_detail_bloc.dart';

sealed class GameDetailEvent extends Equatable {
  const GameDetailEvent();

  @override
  List<Object?> get props => [];
}

/// On screen open: load the details and the map.
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

/// Returned from the join after success: message and reload.
class GameDetailJoined extends GameDetailEvent {
  const GameDetailJoined();
}
