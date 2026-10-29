part of 'ranking_bloc.dart';

sealed class RankingEvent extends Equatable {
  const RankingEvent();

  @override
  List<Object?> get props => [];
}

/// The game state changed (from the GameBloc); the bloc decides whether to reload the ranking.
class RankingGameUpdated extends RankingEvent {
  const RankingGameUpdated(this.game);
  final GameState? game;

  @override
  List<Object?> get props => [game];
}

/// Manual refresh (pull-to-refresh).
class RankingRefreshRequested extends RankingEvent {
  const RankingRefreshRequested();
}
