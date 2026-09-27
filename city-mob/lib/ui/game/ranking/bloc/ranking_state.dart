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

  /// A játékállapot kulcsa az utolsó betöltéskor (GameViewX.feedKey).
  final String? key;
  final RankingStatus status;
  final List<RankRow> rows;

  /// A fejléc: hányadik elszámolás után, mikor a választás.
  final Tr caption;
  final List<PopularityRow> popularity;
  final Failure? failure;

  /// Még nincs mit mutatni (az első betöltés fut).
  bool get loading => status == RankingStatus.loading && rows.isEmpty || status == RankingStatus.initial;

  /// A saját ház sorainak indexe a táblában.
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
