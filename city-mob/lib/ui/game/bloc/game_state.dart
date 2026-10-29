part of 'game_bloc.dart';

enum GameStatus { initial, loading, ready, failure }

/// The GameBloc state. (Not named GameState because that is the generated API model.)
class GameViewState extends Equatable {
  const GameViewState({
    this.gameId,
    this.status = GameStatus.initial,
    this.game,
    this.map,
    this.failure,
    this.busy = false,
    this.fetchedAt,
    this.now,
    this.selectedCity,
    this.notice,
  });

  final String? gameId;
  final GameStatus status;
  final GameState? game;
  final MapDef? map;
  final Failure? failure;

  /// An action is running (buttons disabled, spinners spinning).
  final bool busy;

  /// When the last state arrived, per the device clock.
  final DateTime? fetchedAt;

  /// The game clock now (updated on every tick).
  final DateTime? now;

  /// The city selected on the map.
  final String? selectedCity;

  /// One-off message (toast); shown by the GameListener.
  final Notice? notice;

  bool get ready => status == GameStatus.ready && game != null && map != null;

  /// Remaining time measured against the game clock.
  Duration until(DateTime? t) => t == null || now == null ? Duration.zero : t.difference(now!);

  GameViewState copyWith({
    String? gameId,
    GameStatus? status,
    GameState? game,
    MapDef? map,
    Failure? failure,
    bool clearFailure = false,
    bool? busy,
    DateTime? fetchedAt,
    DateTime? now,
    String? selectedCity,
    Notice? notice,
  }) {
    return GameViewState(
      gameId: gameId ?? this.gameId,
      status: status ?? this.status,
      game: game ?? this.game,
      map: map ?? this.map,
      failure: clearFailure ? null : failure ?? this.failure,
      busy: busy ?? this.busy,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      now: now ?? this.now,
      selectedCity: selectedCity ?? this.selectedCity,
      notice: notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [gameId, status, game, map, failure, busy, fetchedAt, now, selectedCity, notice];
}
