part of 'lobby_bloc.dart';

class LobbyState extends Equatable {
  const LobbyState({this.loading = false, this.loaded = false, this.groups = const LobbyGroups(), this.tab = LobbyTab.fresh, this.failure});

  /// Loading (spinner on the first load; on refresh the list stays).
  final bool loading;

  /// Loaded at least once.
  final bool loaded;
  final LobbyGroups groups;
  final LobbyTab tab;
  final Failure? failure;

  /// Games of the selected tab.
  List<GameSummary> get games => groups.tab(tab);

  /// The "Mine" tab badge.
  String? get mineBadge => groups.mine.isEmpty ? null : '${groups.mine.length}';

  Tr get emptyText => tab == LobbyTab.mine ? const Tr('lobby.empty_mine') : const Tr('lobby.empty');

  LobbyState copyWith({bool? loading, bool? loaded, LobbyGroups? groups, LobbyTab? tab, Failure? failure, bool clearFailure = false}) {
    return LobbyState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      groups: groups ?? this.groups,
      tab: tab ?? this.tab,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [loading, loaded, groups, tab, failure];
}
