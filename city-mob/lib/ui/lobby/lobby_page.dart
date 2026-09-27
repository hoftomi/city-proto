import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tron_api/tron_api.dart';

import '../../app/di/di.dart';
import '../../app/router/routes.dart';
import '../../domain/model/extensions.dart';
import '../../domain/model/lobby_extensions.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/game_widgets.dart';
import '../../widgets/tn_icon.dart';
import '../auth/bloc/auth_bloc.dart';
import 'bloc/lobby_bloc.dart';
import 'widgets/game_badges.dart';

/// Játékválasztó: folyamatban lévő, új, saját és lezárult játékok.
class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<LobbyBloc>()..add(const LobbyStarted()), child: const _LobbyView());
  }
}

class _LobbyView extends StatelessWidget {
  const _LobbyView();

  /// A részletekre, visszatéréskor frissít.
  Future<void> _open(BuildContext context, GameSummary g) async {
    final bloc = context.read<LobbyBloc>();
    await context.push(Routes.game(g.id));
    bloc.add(const LobbyRefreshRequested());
  }

  Future<void> _refresh(LobbyBloc bloc) {
    bloc.add(const LobbyRefreshRequested());
    return bloc.stream.firstWhere((s) => !s.loading);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final userName = context.select<AuthBloc, String?>((a) => a.state.user?.name);
    return Scaffold(
      body: TnScreen(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TnHeader(
            title: Text('app.title'.tr(), style: woodTitle(c, size: 18)),
            actions: [
              if (userName != null) Flexible(child: Text(userName, overflow: TextOverflow.ellipsis, style: TnText.caption(const Color(0xFFD9C49A)))),
              TnButton(
                  label: 'lobby.sign_out'.tr(), kind: TnButtonKind.quiet, small: true, onPressed: () => context.read<LobbyBloc>().add(const LobbySignOutRequested())),
            ],
          ),
          Expanded(
            child: BlocBuilder<LobbyBloc, LobbyState>(builder: (context, s) {
              final bloc = context.read<LobbyBloc>();
              if (s.failure != null) return _ErrorView(message: s.failure!.message.text, onRetry: () => bloc.add(const LobbyRefreshRequested()));
              if (!s.loaded) return const Center(child: CircularProgressIndicator());
              return RefreshIndicator(
                onRefresh: () => _refresh(bloc),
                child: ListView(padding: const EdgeInsets.all(16), children: [
                  if (s.groups.running.isNotEmpty) ...[
                    Eyebrow('lobby.continue'.tr()),
                    const SizedBox(height: 8),
                    for (final g in s.groups.running) ...[
                      _ContinueCard(g: g, onEnter: () => context.go(Routes.map(g.id))),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 4),
                  ],
                  TnTabs(
                    active: s.tab.name,
                    onChange: (t) => bloc.add(LobbyTabSelected(LobbyTab.values.byName(t))),
                    tabs: [
                      TnTabItem(LobbyTab.fresh.name, 'lobby.tab.fresh'.tr()),
                      TnTabItem(LobbyTab.mine.name, 'lobby.tab.mine'.tr(), badge: s.mineBadge),
                      TnTabItem(LobbyTab.finished.name, 'lobby.tab.finished'.tr()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (s.games.isEmpty) Text(s.emptyText.text, style: TnText.body(c.inkMuted)),
                  for (final g in s.games) ...[_GameCard(g: g, onTap: () => _open(context, g)), const SizedBox(height: 12)],
                ]),
              );
            }),
          ),
        ]),
      ),
    );
  }
}

/// Saját, futó játék kiemelt kártyája a belépés gombjával.
class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.g, required this.onEnter});
  final GameSummary g;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final h = g.myHouse!;
    return TnCard(
      tone: TnCardTone.highlight,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          HouseCrest(tincture: h.tincture, initial: h.houseName.characters.first, size: 26, name: h.houseName),
          const SizedBox(width: 8),
          Expanded(child: Text(g.name, style: TnText.bodyStrong(c.ink))),
          Text('lobby.round_of'.tr(namedArgs: {'round': '${g.round}', 'max': '${g.maxRounds}'}), style: TnText.caption(c.inkMuted)),
        ]),
        const SizedBox(height: 12),
        TnButton(label: 'lobby.enter_game'.tr(), icon: 'terkep', kind: TnButtonKind.primary, onPressed: onEnter),
      ]),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.g, required this.onTap});
  final GameSummary g;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Semantics(
      button: true,
      label: 'lobby.game_semantics'.tr(namedArgs: {'name': g.name, 'season': g.season, 'when': g.whenText.text}),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: TnCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Eyebrow(g.season),
                  const SizedBox(height: 2),
                  Text(g.name, style: TnText.title(c.ink).copyWith(fontSize: 21, height: 26 / 21)),
                ]),
              ),
              const SizedBox(width: 12),
              StatusChip(g),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 16, runSpacing: 4, children: [
              _fact(c, 'clock', g.whenText.text),
              _fact(c, 'terkep', 'lobby.schedule'.tr(namedArgs: {'days': '${g.days}', 'rounds': '${g.roundsPerDay}'})),
            ]),
            const SizedBox(height: 12),
            if (!g.finished)
              Row(children: [
                Expanded(child: TnMeter(value: g.fill, green: true)),
                const SizedBox(width: 12),
                Text('lobby.houses'.tr(namedArgs: {'players': '${g.players}', 'max': '${g.maxPlayers}'}), style: TnText.data(c.ink)),
              ])
            else
              Text(g.resultText.text, style: TnText.caption(c.inkMuted)),
            if (g.myHouse != null) ...[
              const SizedBox(height: 8),
              Row(children: [
                HouseCrest(tincture: g.myHouse!.tincture, size: 16, name: g.myHouse!.houseName),
                const SizedBox(width: 6),
                Text(g.myHouse!.houseName, style: TnText.data(c.ink, size: 13)),
              ]),
            ],
            if (g.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(spacing: 6, runSpacing: 6, children: [for (final t in g.tags) Tag(t)]),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _fact(TnColors c, String icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
        TnIcon(icon, size: 15, color: c.inkMuted),
        const SizedBox(width: 6),
        Text(text, style: TnText.bodyStrong(c.inkMuted).copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
      ]);
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Notice(tone: 'danger', title: 'lobby.load_failed'.tr(), body: message),
            const SizedBox(height: 12),
            TnButton(label: 'common.retry'.tr(), onPressed: onRetry),
          ]),
        ),
      );
}
