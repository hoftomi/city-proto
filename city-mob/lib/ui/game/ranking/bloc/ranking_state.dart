part of 'ranking_bloc.dart';

enum RankingStatus { initial, loading, ready, failure }

class RankingState extends Equatable {
  const RankingState({
    this.gameId,
    this.key,
    this.status = RankingStatus.initial,
    this.rows = const [],
    this.caption = const Tr.raw(''),
    this.popularity = const [],
    this.failure,
  });

  final String? gameId;

  /// The game state key at the last load (GameViewX.feedKey).
  final String? key;
  final RankingStatus status;
  final List<RankRow> rows;

  /// The header: after which settlement, when the election is.
  final Tr caption;
  final List<PopularityRow> popularity;
  final Failure? failure;

  /// Nothing to show yet (the first load is running).
  bool get loading => status == RankingStatus.loading && rows.isEmpty || status == RankingStatus.initial;

  /// Indexes of the own house's rows in the table.
  Set<int> get selfRows => {for (var i = 0; i < rows.length; i++) if (rows[i].self) i};

  RankingState copyWith({
    String? gameId,
    String? key,
    RankingStatus? status,
    List<RankRow>? rows,
    Tr? caption,
    List<PopularityRow>? popularity,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return RankingState(
      gameId: gameId ?? this.gameId,
      key: key ?? this.key,
      status: status ?? this.status,
      rows: rows ?? this.rows,
      caption: caption ?? this.caption,
      popularity: popularity ?? this.popularity,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [gameId, key, status, rows, caption, popularity, failure];
}
