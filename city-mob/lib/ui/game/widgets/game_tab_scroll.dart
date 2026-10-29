import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';

/// A game tab's scrollable content (16 px margin) with pull-to-refresh: refreshes the GameBloc
/// and waits for the new state. `onRefresh` can also reload the tab's own data (reports, ranking).
class GameTabScroll extends StatelessWidget {
  const GameTabScroll({super.key, required this.child, this.onRefresh});
  final Widget child;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() {
      final bloc = context.read<GameBloc>();
      final next = bloc.stream.first.timeout(const Duration(seconds: 15), onTimeout: () => bloc.state);
      bloc.add(const GameRefreshRequested());
      onRefresh?.call();
      return next;
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(padding: const EdgeInsets.all(16), children: [child]),
    );
  }
}
