import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tron_api/tron_api.dart';

import '../../../app/router/routes.dart';
import '../../../domain/model/game_view_extensions.dart';
import '../../../theme/tokens.dart';
import '../../../util/format.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/game_widgets.dart';
import '../bloc/game_bloc.dart';
import '../widgets/game_tab_scroll.dart';

/// The Order sheet tab: buyout threats, the maturing sheet, and the draft (delete, sealing).
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return GameTabScroll(
      child: BlocBuilder<GameBloc, GameViewState>(
        buildWhen: (a, b) => a.game != b.game || a.now != b.now || a.busy != b.busy,
        builder: (context, v) {
          final s = v.game, now = v.now;
          if (s == null || now == null) return const SizedBox.shrink();
          final sheet = s.sheet, maturing = s.maturing(now);
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            CommandPoints(available: s.me.pp, pending: s.draftCost.pp, max: s.me.ppMax),
            const SizedBox(height: 16),
            for (final t in s.threats) ...[
              _ThreatCard(t: t, left: durText(v.until(t.executeAt)), draftOnly: s.defendOnlyInDraft(t), gameId: s.gameId),
              const SizedBox(height: 12),
            ],
            if (sheet != null) ...[
              _SheetCard(sheet: sheet, maturing: maturing, left: durText(v.until(sheet.executeAt)), progress: s.sheetProgress(now)),
              const SizedBox(height: 12),
            ],
            if (s.draft.isEmpty)
              TnCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text('orders.empty_title'.tr(), style: TnText.bodyStrong(c.ink)),
                  Text('orders.empty_body'.tr(namedArgs: {'time': s.maturationText}),
                      style: TnText.body(c.inkMuted)),
                ]),
              )
            else ...[
              OrderSheet(
                total: s.draftCost.pp,
                available: s.me.pp,
                busy: v.busy,
                orders: [
                  for (final o in s.draft) OrderSheetRow(art: o.type, label: o.label, meta: o.meta, cost: o.cost.text, warning: o.warning),
                ],
                onRemove: (i) => context.read<GameBloc>().add(GameOrderRemoved(s.draft[i].id)),
                onSeal: s.canSeal(now) ? () => context.read<GameBloc>().add(const GameSealRequested()) : null,
              ),
              const SizedBox(height: 8),
              Wrap(alignment: WrapAlignment.spaceBetween, spacing: 12, runSpacing: 4, children: [
                Text.rich(TextSpan(style: TnText.caption(c.inkMuted), children: [
                  TextSpan(text: '${'orders.reserved_gold'.tr()} '),
                  ...unitSpans(coinText(s.draftCost.gold), TnText.data(s.overGold ? c.danger : c.ink)),
                  ...unitSpans(' ${'orders.gold_of'.tr(namedArgs: {'total': coinText(s.me.gold)})}', TnText.caption(c.inkMuted)),
                ])),
                Text('orders.maturation'.tr(namedArgs: {'time': s.maturationText}), style: TnText.caption(c.inkMuted)),
              ]),
              if (maturing) ...[
                const SizedBox(height: 12),
                Notice(tone: 'warn', title: 'orders.still_maturing_title'.tr(), body: 'orders.still_maturing_body'.tr()),
              ],
            ],
            const SizedBox(height: 12),
            UnitText('orders.seal_hint'.tr(), style: TnText.caption(c.inkMuted)),
          ]);
        },
      ),
    );
  }
}

/// Buyout offer against my own shares; the defense can be started in the city's Marketplace.
class _ThreatCard extends StatelessWidget {
  const _ThreatCard({required this.t, required this.left, required this.draftOnly, required this.gameId});
  final Threat t;
  final String left, gameId;
  final bool draftOnly;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final at = hhmm(t.executeAt);
    return TnCard(
      tone: TnCardTone.threat,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Eyebrow('orders.threat.eyebrow'.tr(namedArgs: {'at': at, 'left': left})),
        const SizedBox(height: 4),
        Text('orders.threat.title'.tr(namedArgs: {'name': t.by.name}), style: TnText.bodyStrong(c.ink)),
        UnitText('orders.threat.body'.tr(namedArgs: {'pts': '${t.pts}', 'good': t.goodName, 'city': t.cityName, 'cost': coinText(t.defendCost)}), style: TnText.body(c.inkMuted)),
        const SizedBox(height: 8),
        Row(children: [
          TnButton(
            label: 'orders.threat.defend'.tr(),
            icon: 'merchants',
            small: true,
            onPressed: () => context.go(Routes.city(gameId, cityId: t.cityId, district: 'trade')),
          ),
        ]),
        if (t.defending) ...[
          const SizedBox(height: 8),
          Notice(
            tone: 'info',
            title: 'orders.threat.defending'.tr(),
            body: draftOnly ? 'orders.threat.draft_only'.tr() : null,
          ),
        ],
        const SizedBox(height: 8),
        Text('orders.threat.hint'.tr(namedArgs: {'at': at}), style: TnText.caption(c.inkMuted)),
      ]),
    );
  }
}

/// The sealed, maturing (or currently executing) sheet.
class _SheetCard extends StatelessWidget {
  const _SheetCard({required this.sheet, required this.maturing, required this.left, required this.progress});
  final SheetView sheet;
  final bool maturing;
  final String left;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return TnCard(
      tone: TnCardTone.pending,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Eyebrow('orders.sheet.sealed_at'.tr(namedArgs: {'time': hhmm(sheet.sealedAt)})),
        const SizedBox(height: 4),
        Text(
          maturing ? 'orders.sheet.maturing'.tr(namedArgs: {'left': left, 'at': hhmm(sheet.executeAt)}) : 'orders.sheet.executing'.tr(),
          style: TnText.bodyStrong(c.ink),
        ),
        const SizedBox(height: 8),
        TnMeter(value: progress),
        const SizedBox(height: 10),
        for (final o in sheet.orders)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.5),
            child: Row(children: [
              GameIcon.tile(o.type, size: 16),
              const SizedBox(width: 8),
              Expanded(child: UnitText(o.sheetLabel, style: TnText.body(c.ink).copyWith(fontSize: 14))),
            ]),
          ),
        const SizedBox(height: 8),
        Text('orders.sheet.hint'.tr(), style: TnText.caption(c.inkMuted)),
      ]),
    );
  }
}
