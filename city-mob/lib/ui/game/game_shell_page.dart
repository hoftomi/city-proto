import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tron_api/tron_api.dart';

import '../../app/di/di.dart';
import '../../app/router/routes.dart';
import '../../domain/model/city_extensions.dart';
import '../../domain/model/extensions.dart';
import '../../domain/model/game_view_extensions.dart';
import '../../domain/service/game_service.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../../widgets/buttons.dart';
import '../../widgets/game_widgets.dart';
import 'bloc/game_bloc.dart';
import 'bloc/shown_city_cubit.dart';

/// The City tab's index among the shell branches (see [_NavBar]).
const cityBranch = 1;

/// The running game's frame: loading and error, carved header (house, settlement timer, resources), dev clock
/// (ADMIN only), the tabs (StatefulShellRoute branches) and the bottom navigation. The game's one-off messages (toast)
/// are also shown here, in one place. While the City tab is active, the open city's header (eyebrow, name, chips)
/// is part of the top bar; the CityPage reports that city through the shell-scoped [ShownCityCubit].
class GameShellPage extends StatelessWidget {
  const GameShellPage({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => ShownCityCubit(), child: _Shell(shell: shell));
}

class _Shell extends StatelessWidget {
  const _Shell({required this.shell});
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
                _TopBar(cityTab: shell.currentIndex == cityBranch),
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

/// The game failed to load: back to the games, or retry.
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

/// Carved wooden header: exit bar, house crest and name, settlement timer, resource capsules; on the City tab
/// ([cityTab]) also the open city's header.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.cityTab});
  final bool cityTab;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final cityId = context.watch<ShownCityCubit>().state;
    return BlocBuilder<GameBloc, GameViewState>(
      buildWhen: (a, b) => a.game != b.game || a.now != b.now,
      builder: (context, v) {
        final s = v.game!, me = s.me, sheet = s.sheet, next = s.clock.nextSettlementAt;
        final city = cityTab ? s.cityOrNull(cityId) : null;
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
                HouseCrest(initial: me.houseName.characters.first, size: 24, name: me.houseName),
                const SizedBox(width: 8),
                Text(me.houseName, style: woodTitle(c)),
              ]),
              TickTimer(at: hhmm(next), remaining: durText(v.until(next)), soon: s.settlementSoon(v.now!)),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
              ResourceChip.money(bronze: me.gold),
              ResourceChip(kind: 'pp', value: me.pp, max: me.ppMax),
              ResourceChip(kind: 'legit', value: me.legit),
              if (sheet != null) Text('shell.sheet_live_in'.tr(namedArgs: {'time': durText(v.until(sheet.executeAt))}), style: TnText.caption(const Color(0xFFD9C49A))),
            ]),
            if (city != null) _CityHeader(s: s, cv: city),
          ]),
        );
      },
    );
  }
}

/// The open city's header in the top bar: eyebrow (profile · key city · distance / unreachable) and name on one
/// wrapping line, the stat chips below.
class _CityHeader extends StatelessWidget {
  const _CityHeader({required this.s, required this.cv});
  final GameState s;
  final CityView cv;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Container(
      key: const ValueKey('shell/city-header'),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: c.frameLo.withValues(alpha: 0.8)))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 6, runSpacing: 6, children: [
          Padding(padding: const EdgeInsets.only(right: 4), child: Text(cv.name, style: woodTitle(c, size: 19))),
          for (final x in s.cityStats(cv))
            StatChip(label: x.label.text, value: x.value.text, suffix: x.suffix?.text, tone: x.tone, art: x.art, info: x.info.text, compact: true),
        ]),
      ]),
    );
  }
}

/// Bottom navigation: the StatefulShellRoute branches (0 Map, 1 City, 2 Reports, 3 Order sheet, 4 Ranking).
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
          TnNavItem('shell.nav.map'.tr(), icon: 'map'),
          TnNavItem('shell.nav.city'.tr(), icon: 'city'),
          TnNavItem('shell.nav.reports'.tr(), icon: 'spy', art: 'navReports'),
          TnNavItem('shell.nav.orders'.tr(), icon: 'pp', badge: badgeText(orders)),
          TnNavItem('shell.nav.ranking'.tr(), icon: 'legit'),
        ],
      ),
    );
  }

  static int _badge(GameState s) => getIt<GameService>().ordersBadge(s);
}
