import 'package:equatable/equatable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/tr.dart';
import '../../util/format.dart';
import 'extensions.dart';

/// The game's status tag in the game picker and details (the widget picks color and label from it).
enum GameBadge { joined, almostFull, runningJoinable, running, open, soon, finished }

/// Tabs of the game picker.
enum LobbyTab { fresh, mine, finished }

extension GameSummaryLobbyX on GameSummary {
  /// Your own running game: can be entered.
  bool get enterable => joined && running;

  /// Fill ratio, 0..1.
  double get fill => maxPlayers == 0 ? 0 : players / maxPlayers;

  bool get full => players >= maxPlayers;

  /// Whether you can still join: open, or running and at most at settlement 3, and there's room.
  bool get canJoin => !joined && (open || (running && round <= 3)) && !full;

  /// The open game is full (you haven't joined).
  bool get closedFull => !joined && open && full;

  /// You joined and the game hasn't started yet: can be withdrawn.
  bool get withdrawable => joined && open;

  GameBadge get badge {
    if (joined && open) return GameBadge.joined;
    if (open && fill >= 0.9) return GameBadge.almostFull;
    if (running) return round <= 3 ? GameBadge.runningJoinable : GameBadge.running;
    if (open) return GameBadge.open;
    if (announced) return GameBadge.soon;
    return GameBadge.finished;
  }

  /// Short timing: where it's at, when it starts, when it opens.
  Tr get whenText {
    if (running) return Tr('lobby.round_of', {'round': '$round', 'max': '$maxRounds'});
    if (open && closesAt != null) return Tr('lobby.when.starts', {'when': relativeDays(closesAt!)});
    if (announced && opensAt != null) return Tr('lobby.when.opens', {'when': relativeDays(opensAt!)});
    return const Tr('lobby.when.closed');
  }

  /// Timing on the lobby card: like [whenText], but a running game shows no settlement count.
  Tr? get cardWhenText => running ? null : whenText;

  /// The details' "Start" row: the exact date for a starting game.
  Tr get startText => closesAt != null && !running && !finished ? Tr.raw(dateLong(closesAt!)) : whenText;

  /// Start date (when joining closes), or "soon".
  Tr get startsAtText => closesAt != null ? Tr.raw(dateLong(closesAt!)) : const Tr('lobby.when.soon');

  Tr get winnerText => Tr('lobby.winner', {'winner': winner ?? '–'});

  /// Row of a finished game: the winner and, if you played, your place.
  Tr get resultText => myPlace == null ? winnerText : Tr('lobby.winner_place', {'winner': winner ?? '–', 'place': '$myPlace'});
}

/// Games sorted into the game picker's groups.
class LobbyGroups extends Equatable {
  const LobbyGroups({this.running = const [], this.mine = const [], this.fresh = const [], this.finished = const []});

  factory LobbyGroups.of(List<GameSummary> all) => LobbyGroups(
        running: all.where((g) => g.joined && g.running).toList(),
        mine: all.where((g) => g.joined && !g.finished).toList(),
        fresh: all.where((g) => (g.open || g.announced || g.running) && !g.joined).toList(),
        finished: all.where((g) => g.finished).toList(),
      );

  /// "Continue where you left off": your own running games.
  final List<GameSummary> running;

  /// Your own unfinished games.
  final List<GameSummary> mine;

  /// New games: open, announced or running, that you haven't joined yet.
  final List<GameSummary> fresh;
  final List<GameSummary> finished;

  List<GameSummary> tab(LobbyTab t) => switch (t) {
        LobbyTab.fresh => fresh,
        LobbyTab.mine => mine,
        LobbyTab.finished => finished,
      };

  @override
  List<Object?> get props => [running, mine, fresh, finished];
}
