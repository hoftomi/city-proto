part of 'game_detail_bloc.dart';

class GameDetailState extends Equatable {
  const GameDetailState({this.gameId, this.detail, this.map, this.failure, this.busy = false, this.notice});

  final String? gameId;
  final GameDetail? detail;
  final MapDef? map;
  final Failure? failure;

  /// Épp visszavonja a jelentkezést.
  final bool busy;

  /// Egyszeri üzenet (toast).
  final Notice? notice;

  bool get ready => detail != null && map != null;
  GameSummary? get game => detail?.game;

  GameDetailState copyWith({
    String? gameId,
    GameDetail? detail,
    MapDef? map,
    Failure? failure,
    bool clearFailure = false,
    bool? busy,
    Notice? notice,
  }) {
    return GameDetailState(
      gameId: gameId ?? this.gameId,
      detail: detail ?? this.detail,
      map: map ?? this.map,
      failure: clearFailure ? null : failure ?? this.failure,
      busy: busy ?? this.busy,
      notice: notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [gameId, detail, map, failure, busy, notice];
}
