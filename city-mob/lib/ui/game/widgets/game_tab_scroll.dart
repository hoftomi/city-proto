import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';

/// Egy játékfül görgethető tartalma (16 px margó) lehúzásos frissítéssel: a GameBlocot frissíti,
/// és megvárja az új állapotot. Az `onRefresh` a fül saját adatait is újratöltheti (jelentések, rangsor).
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
