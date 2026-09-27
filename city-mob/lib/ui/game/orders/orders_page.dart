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

/// A Parancslap fül: kivásárlási fenyegetések, az érlelődő lap, és a vázlat (törlés, lepecsételés).
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
          final lap = s.lap, maturing = s.maturing(now);
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            CommandPoints(available: s.me.pp, pending: s.draftCost.pp, max: s.me.ppMax),
            const SizedBox(height: 16),
            for (final t in s.threats) ...[
              _ThreatCard(t: t, left: durText(v.until(t.executeAt)), draftOnly: s.defendOnlyInDraft(t), gameId: s.gameId),
              const SizedBox(height: 12),
            ],
            if (lap != null) ...[
              _LapCard(lap: lap, maturing: maturing, left: durText(v.until(lap.executeAt)), progress: s.lapProgress(now)),
              const SizedBox(height: 12),
            ],
            if (s.draft.isEmpty)
              TnCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text('Üres a parancslap', style: TnText.bodyStrong(c.ink)),
                  Text('Nyiss meg egy várost, és a Vásártéren, a Városházán vagy az Alvilágban adj hozzá parancsot. A lepecsételt lap ${s.maturationText} érlelés után lép érvénybe.',
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
                  const TextSpan(text: 'Lefoglalt arany: '),
                  TextSpan(text: '${s.draftCost.gold}', style: TnText.data(s.overGold ? c.danger : c.ink)),
                  TextSpan(text: ' / ${s.me.gold.floor()} A'),
                ])),
                Text('Érlelés: ${s.maturationText}', style: TnText.caption(c.inkMuted)),
              ]),
              if (maturing) ...[
                const SizedBox(height: 12),
                const Notice(tone: 'warn', title: 'Még érlelődik az előző lapod', body: 'A vázlatot megtarthatod, és lepecsételheted, amint az előző lap lefutott.'),
              ],
            ],
            const SizedBox(height: 12),
            Text('A lepecsételt parancslap nem módosítható és nem vonható vissza. A költségek (PP, arany) lepecsételéskor lefoglalódnak.', style: TnText.caption(c.inkMuted)),
          ]);
        },
      ),
    );
  }
}

/// Kivásárlási ajánlat a saját részesedésem ellen; a védekezés a város Vásárterén indítható.
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
        Eyebrow('Kivásárlási ajánlat · lefut $at ($left)'),
        const SizedBox(height: 4),
        Text('${t.by.name} ki akar vásárolni', style: TnText.bodyStrong(c.ink)),
        Text('${t.pts} pontot a(z) ${t.goodName} részesedésedből (${t.cityName}). Védekező vétellel kiválthatod: ${t.defendCost} A.', style: TnText.body(c.inkMuted)),
        const SizedBox(height: 8),
        Row(children: [
          TnButton(
            label: 'Védekezés a Vásártéren',
            icon: 'kereskedok',
            small: true,
            onPressed: () => context.go(Routes.city(gameId, cityId: t.cityId, district: 'keresk')),
          ),
        ]),
        if (t.defending) ...[
          const SizedBox(height: 8),
          Notice(
            tone: 'info',
            title: 'Védekezés folyamatban',
            body: draftOnly ? 'A védekező vétel még csak a vázlaton van: pecsételd le, mielőtt az ajánlat lefut.' : null,
          ),
        ],
        const SizedBox(height: 8),
        Text('A védekező vétel akkor hat, ha lepecsételed, mielőtt az ajánlat lefut (lefut: $at).', style: TnText.caption(c.inkMuted)),
      ]),
    );
  }
}

/// A lepecsételt, érlelődő (vagy épp végrehajtás alatt álló) lap.
class _LapCard extends StatelessWidget {
  const _LapCard({required this.lap, required this.maturing, required this.left, required this.progress});
  final LapView lap;
  final bool maturing;
  final String left;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return TnCard(
      tone: TnCardTone.pending,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Eyebrow('Lepecsételve ${hhmm(lap.sealedAt)}'),
        const SizedBox(height: 4),
        Text(
          maturing ? 'Érlelődik: $left múlva lép érvénybe (${hhmm(lap.executeAt)})' : 'Végrehajtás folyamatban…',
          style: TnText.bodyStrong(c.ink),
        ),
        const SizedBox(height: 8),
        TnMeter(value: progress),
        const SizedBox(height: 10),
        for (final o in lap.orders)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.5),
            child: Row(children: [
              GameIcon.tile(o.type, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(o.lapLabel, style: TnText.body(c.ink).copyWith(fontSize: 14))),
            ]),
          ),
        const SizedBox(height: 8),
        Text('Ez idő alatt a rivális kémek kifürkészhetik. Őrökkel védekezhetsz az Alvilágban. Új lapot a végrehajtás után pecsételhetsz.', style: TnText.caption(c.inkMuted)),
      ]),
    );
  }
}
