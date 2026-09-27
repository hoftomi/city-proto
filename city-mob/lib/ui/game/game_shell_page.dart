import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tron_api/tron_api.dart';

import '../../app/di/di.dart';
import '../../app/router/routes.dart';
import '../../domain/model/game_view_extensions.dart';
import '../../domain/service/game_service.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../../widgets/buttons.dart';
import '../../widgets/game_widgets.dart';
import '../../widgets/tn_icon.dart';
import '../auth/bloc/auth_bloc.dart';
import 'bloc/game_bloc.dart';

/// A futó játék kerete: betöltés és hiba, faragott fejléc (ház, elszámolás-időzítő, erőforrások), fejlesztői óra
/// (csak ADMIN), a fülek (StatefulShellRoute ágai) és az alsó navigáció. A játék egyszeri üzeneteit (toast) is
/// itt mutatjuk, egyetlen helyen.
class GameShellPage extends StatelessWidget {
  const GameShellPage({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameViewState>(
      listenWhen: (a, b) => b.notice != null && a.notice != b.notice,
      listener: (context, s) => showToast(context, s.notice!.title.text, body: s.notice!.body?.text, tone: s.notice!.tone),
      child: BlocBuilder<GameBloc, GameViewState>(
        buildWhen: (a, b) => a.status != b.status || a.ready != b.ready,
        builder: (context, v) {
          if (v.status == GameStatus.failure && v.game == null) return _Failure(message: v.failure?.message.text ?? '', gameId: v.gameId);
          if (!v.ready) return const Scaffold(body: TnScreen(child: Center(child: CircularProgressIndicator())));
          return Scaffold(
            body: TnScreen(
              child: Column(children: [
                const _TopBar(),
                BlocSelector<AuthBloc, AuthState, bool>(
                  selector: (s) => s.admin,
                  builder: (context, admin) => admin ? const _AdminBar() : const SizedBox.shrink(),
                ),
                Expanded(child: shell),
              ]),
            ),
            bottomNavigationBar: _NavBar(shell: shell),
          );
        },
      ),
    );
  }
}

/// A játék nem töltődött be: vissza a játékokhoz, vagy újra.
class _Failure extends StatelessWidget {
  const _Failure({required this.message, required this.gameId});
  final String message;
  final String? gameId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TnScreen(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TnHeader(leading: TnButton(label: 'shell.back_to_lobby'.tr(), kind: TnButtonKind.quiet, small: true, onPressed: () => context.go(Routes.lobby))),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Notice(tone: 'danger', title: 'shell.load_failed'.tr(), body: message),
                  const SizedBox(height: 12),
                  TnButton(label: 'common.retry'.tr(), onPressed: gameId == null ? null : () => context.read<GameBloc>().add(GameStarted(gameId!))),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Faragott fa fejléc: kilépés sáv, ház címere és neve, elszámolás-időzítő, erőforrás-kapszulák.
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return BlocBuilder<GameBloc, GameViewState>(
      buildWhen: (a, b) => a.game != b.game || a.now != b.now,
      builder: (context, v) {
        final s = v.game!, me = s.me, lap = s.lap, next = s.clock.nextSettlementAt;
        return TnHeader(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          top: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Semantics(
                button: true,
                child: InkWell(
                  onTap: () => context.go(Routes.lobby),
                  child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('shell.back_to_lobby'.tr(), style: TnText.data(c.frameHi, size: 12, weight: FontWeight.w900))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(s.gameName,
                      textAlign: TextAlign.right, overflow: TextOverflow.ellipsis, style: TnText.data(c.onWood.withValues(alpha: 0.85), size: 12, weight: FontWeight.w700))),
            ]),
          ),
          bottom: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 8, children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                HouseCrest(tincture: me.tincture, initial: me.houseName.characters.first, size: 24, name: me.houseName),
                const SizedBox(width: 8),
                Text(me.houseName, style: woodTitle(c)),
              ]),
              TickTimer(at: hhmm(next), remaining: durText(v.until(next)), soon: s.settlementSoon(v.now!)),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
              ResourceChip(kind: 'arany', value: me.gold.floor()),
              ResourceChip(kind: 'pp', value: me.pp, max: me.ppMax),
              ResourceChip(kind: 'legit', value: me.legit),
              if (lap != null) Text('shell.lap_live_in'.tr(namedArgs: {'time': durText(v.until(lap.executeAt))}), style: TnText.caption(const Color(0xFFD9C49A))),
            ]),
          ]),
        );
      },
    );
  }
}

/// Fejlesztői óra (csak ADMIN): pergamencsík a fejléc alatt, előretekerés és azonnali elszámolás.
class _AdminBar extends StatelessWidget {
  const _AdminBar();

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return BlocBuilder<GameBloc, GameViewState>(
      buildWhen: (a, b) => a.now != b.now || a.busy != b.busy,
      builder: (context, v) {
        void add(GameEvent e) => context.read<GameBloc>().add(e);
        Widget btn(String l, GameEvent e, {bool on = false}) => TnMiniButton(on: on, onTap: v.busy ? null : () => add(e), child: Text(l));
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 7),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [c.paperRaised, c.paperSunk]),
            border: Border(bottom: BorderSide(color: c.wood, width: 1.5)),
            boxShadow: const [BoxShadow(color: Color(0x4D000000), offset: Offset(0, 2), blurRadius: 4, spreadRadius: -1)],
          ),
          child: Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 6, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              TnIcon('clock', size: 14, color: c.inkMuted),
              const SizedBox(width: 4),
              Text(v.now == null ? '' : shortDateTime(v.now!), style: TnText.data(c.ink)),
            ]),
            Wrap(spacing: 5, runSpacing: 5, children: [
              btn('shell.admin.advance_30m'.tr(), const GameAdminAdvanceRequested(30)),
              btn('shell.admin.advance_2h'.tr(), const GameAdminAdvanceRequested(120)),
              btn('shell.admin.next_event'.tr(), const GameAdminAdvanceRequested(null), on: true),
              btn('shell.admin.settle_now'.tr(), const GameAdminSettleRequested()),
            ]),
          ]),
        );
      },
    );
  }
}

/// Alsó navigáció: a StatefulShellRoute ágai (0 Térkép, 1 Város, 2 Jelentések, 3 Parancslap, 4 Rangsor).
class _NavBar extends StatelessWidget {
  const _NavBar({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GameBloc, GameViewState, int>(
      selector: (v) => v.game == null ? 0 : _badge(v.game!),
      builder: (context, orders) => TnNavBar(
        active: shell.currentIndex,
        onChange: shell.goBranch,
        items: [
          TnNavItem('shell.nav.map'.tr(), icon: 'terkep'),
          TnNavItem('shell.nav.city'.tr(), icon: 'varos'),
          TnNavItem('shell.nav.reports'.tr(), icon: 'kem'),
          TnNavItem('shell.nav.orders'.tr(), icon: 'pp', badge: badgeText(orders)),
          TnNavItem('shell.nav.ranking'.tr(), icon: 'legit'),
        ],
      ),
    );
  }

  static int _badge(GameState s) => getIt<GameService>().ordersBadge(s);
}
