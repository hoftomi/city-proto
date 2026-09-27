part of 'lobby_bloc.dart';

class LobbyState extends Equatable {
  const LobbyState({this.loading = false, this.loaded = false, this.groups = const LobbyGroups(), this.tab = LobbyTab.fresh, this.failure});

  /// Épp tölt (az első betöltésnél pörgő jelző, frissítéskor a lista marad).
  final bool loading;

  /// Legalább egyszer betöltött.
  final bool loaded;
  final LobbyGroups groups;
  final LobbyTab tab;
  final Failure? failure;

  /// A kiválasztott fül játékai.
  List<GameSummary> get games => groups.tab(tab);

  /// A „Saját” fül jelvénye.
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
