part of 'reports_bloc.dart';

enum ReportsStatus { initial, loading, ready, failure }

class ReportsState extends Equatable {
  const ReportsState({
    this.gameId,
    this.key,
    this.status = ReportsStatus.initial,
    this.reports = const [],
    this.filter = ReportFilter.mind,
    this.failure,
  });

  final String? gameId;

  /// A játékállapot kulcsa az utolsó betöltéskor (GameViewX.feedKey).
  final String? key;
  final ReportsStatus status;
  final List<ReportView> reports;
  final ReportFilter filter;
  final Failure? failure;

  /// A szűrőnek megfelelő jelentések.
  List<ReportView> get visible => reports.where(filter.accepts).toList();

  /// Még nincs mit mutatni (az első betöltés fut).
  bool get loading => status == ReportsStatus.loading && reports.isEmpty || status == ReportsStatus.initial;

  ReportsState copyWith({
    String? gameId,
    String? key,
    ReportsStatus? status,
    List<ReportView>? reports,
    ReportFilter? filter,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ReportsState(
      gameId: gameId ?? this.gameId,
      key: key ?? this.key,
      status: status ?? this.status,
      reports: reports ?? this.reports,
      filter: filter ?? this.filter,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [gameId, key, status, reports, filter, failure];
}
