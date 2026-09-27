part of 'reports_bloc.dart';

sealed class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

/// Megváltozott a játékállapot (a GameBlocból); a bloc dönti el, kell-e újratölteni.
class ReportsGameUpdated extends ReportsEvent {
  const ReportsGameUpdated(this.game);
  final GameState? game;

  @override
  List<Object?> get props => [game];
}

/// Kézi frissítés (lehúzás).
class ReportsRefreshRequested extends ReportsEvent {
  const ReportsRefreshRequested();
}

class ReportsFilterChanged extends ReportsEvent {
  const ReportsFilterChanged(this.filter);
  final ReportFilter filter;

  @override
  List<Object?> get props => [filter];
}
