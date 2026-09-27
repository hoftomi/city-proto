import 'package:equatable/equatable.dart';
import 'package:tron_api/tron_api.dart';

import '../../util/format.dart';
import 'extensions.dart';

/// A játék állapotcímkéje a játékválasztón és a részleteken (a widget ebből választ színt és feliratot).
enum GameBadge { joined, almostFull, runningJoinable, running, open, soon, finished }

/// A játékválasztó fülei.
enum LobbyTab { fresh, mine, finished }

extension GameSummaryLobbyX on GameSummary {
  /// Saját, futó játék: be lehet lépni.
  bool get enterable => joined && running;

  /// A telítettség 0..1 között.
  double get fill => maxPlayers == 0 ? 0 : players / maxPlayers;

  bool get full => players >= maxPlayers;

  /// Jelentkezhet-e még: nyitott, vagy legfeljebb a 3. elszámolásnál tartó futó játék, és van hely.
  bool get canJoin => !joined && (open || (running && round <= 3)) && !full;

  /// Betelt a nyitott játék (nem jelentkeztél).
  bool get closedFull => !joined && open && full;

  /// Jelentkeztél, a játék még nem indult: visszavonható.
  bool get withdrawable => joined && open;

  GameBadge get badge {
    if (joined && open) return GameBadge.joined;
    if (open && fill >= 0.9) return GameBadge.almostFull;
    if (running) return round <= 3 ? GameBadge.runningJoinable : GameBadge.running;
    if (open) return GameBadge.open;
    if (announced) return GameBadge.soon;
    return GameBadge.finished;
  }

  /// Rövid időzítés: hol tart, mikor kezdődik, mikor nyílik.
  String get whenText {
    if (running) return '$round. elszámolás / $maxRounds';
    if (open && startsAt != null) return 'Kezdés ${relativeDays(startsAt!)}';
    if (announced && opensAt != null) return 'Jelentkezés ${relativeDays(opensAt!)} nyílik';
    return 'Lezárult';
  }

  /// A részletek „Kezdés” sora: induló játéknál a pontos dátum.
  String get startText => startsAt != null && !running && !finished ? dateLong(startsAt!) : whenText;

  /// A kezdés dátuma, vagy „hamarosan”.
  String get startsAtText => startsAt != null ? dateLong(startsAt!) : 'hamarosan';

  String get winnerText => 'Győztes: ${winner ?? '–'}';
}

/// A játékok a játékválasztó csoportjaiba sorolva.
class LobbyGroups extends Equatable {
  const LobbyGroups({this.running = const [], this.mine = const [], this.fresh = const [], this.finished = const []});

  factory LobbyGroups.of(List<GameSummary> all) => LobbyGroups(
        running: all.where((g) => g.joined && g.running).toList(),
        mine: all.where((g) => g.joined && !g.finished).toList(),
        fresh: all.where((g) => (g.open || g.announced || g.running) && !g.joined).toList(),
        finished: all.where((g) => g.finished).toList(),
      );

  /// „Folytasd, ahol abbahagytad”: saját, futó játékok.
  final List<GameSummary> running;

  /// Saját, le nem zárult játékok.
  final List<GameSummary> mine;

  /// Új játékok: nyitott, hamarosan induló vagy futó, amelyre még nem jelentkeztél.
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
