part of 'reports_bloc.dart';

sealed class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

/// The game state changed (from the GameBloc); the bloc decides whether to reload.
class ReportsGameUpdated extends ReportsEvent {
  const ReportsGameUpdated(this.game);
  final GameState? game;

  @override
  List<Object?> get props => [game];
}

/// Manual refresh (pull-to-refresh).
class ReportsRefreshRequested extends ReportsEvent {
  const ReportsRefreshRequested();
}

class ReportsFilterChanged extends ReportsEvent {
  const ReportsFilterChanged(this.filter);
  final ReportFilter filter;

  @override
  List<Object?> get props => [filter];
}
