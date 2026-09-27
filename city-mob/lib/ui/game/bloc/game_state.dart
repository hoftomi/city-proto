part of 'game_bloc.dart';

enum GameStatus { initial, loading, ready, failure }

/// A GameBloc állapota. (A név azért nem GameState, mert az a generált API-modell.)
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

  /// Épp fut egy művelet (a gombok letiltva, a jelzők pörögnek).
  final bool busy;

  /// Mikor jött az utolsó állapot a készülék órája szerint.
  final DateTime? fetchedAt;

  /// A játék órája most (óraütésenként frissül).
  final DateTime? now;

  /// A térképen kijelölt város.
  final String? selectedCity;

  /// Egyszeri üzenet (toast); a GameListener mutatja.
  final Notice? notice;

  bool get ready => status == GameStatus.ready && game != null && map != null;

  /// Hátralévő idő a játék órájához mérve.
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
