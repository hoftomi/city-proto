part of 'ranking_bloc.dart';

sealed class RankingEvent extends Equatable {
  const RankingEvent();

  @override
  List<Object?> get props => [];
}

/// Megváltozott a játékállapot (a GameBlocból); a bloc dönti el, kell-e újratölteni a rangsort.
class RankingGameUpdated extends RankingEvent {
  const RankingGameUpdated(this.game);
  final GameState? game;

  @override
  List<Object?> get props => [game];
}

/// Kézi frissítés (lehúzás).
class RankingRefreshRequested extends RankingEvent {
  const RankingRefreshRequested();
}
