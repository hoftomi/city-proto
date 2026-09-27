import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/city_extensions.dart';
import '../../../../domain/model/extensions.dart';
import '../../../../theme/tokens.dart';
import '../../../../util/format.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/game_widgets.dart';
import '../bloc/city_bloc.dart';
import 'city_common.dart';

/// Vásártér: kivásárlási fenyegetések, árucikkek, haszonkulcs, vétel a Várostól és kivásárlás.
class MarketSection extends StatelessWidget {
  const MarketSection({super.key, required this.s});
  final CityState s;

  @override
  Widget build(BuildContext context) {
    final c = context.tn, r = s.rules, cv = s.city!;
    final bloc = context.read<CityBloc>();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final t in s.threats) ...[
        TnCard(
          tone: TnCardTone.threat,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Notice(
              tone: 'danger',
              title: '${t.by.name} ki akar vásárolni',
              body: '${t.pts} pont ${t.goodName} · lefut: ${at(t.executeAt)} (${durText(s.until(t.executeAt))} múlva)',
            ),
            gap(8),
            if (t.defending)
              Notice(
                tone: 'info',
                title: 'Védekezés folyamatban',
                body: s.defendOnlyInDraft(t) ? 'A védekező vétel még csak a vázlaton van: pecsételd le, mielőtt az ajánlat lefut.' : null,
              )
            else if (s.can)
              Align(
                alignment: Alignment.centerLeft,
                child: TnButton(
                  label: 'Védekező vétel · ${s.catalog.pp('defend')} PP · ${t.defendCost} A',
                  art: 'defend',
                  kind: TnButtonKind.danger,
                  busy: s.busy,
                  onPressed: () => bloc.add(CityDefendRequested(t.orderId)),
                ),
              ),
            gap(8),
            hint(context, 'A védekező vétel akkor hat, ha lepecsételed, mielőtt az ajánlat lefut (lefut: ${at(t.executeAt)}).'),
          ]),
        ),
        gap(),
      ],
      if (s.lowPop) ...[
        Notice(tone: 'warn', title: 'Alacsony népszerűség', body: 'Itt ${r.lowPopThreshold} alatt van a népszerűséged, ezért minden aranyköltség +50%.'),
        gap(),
      ],
      if (cv.goods.isEmpty) Text('Ebben a városban nincs árucikk.', style: TnText.body(c.inkMuted)),
      for (final g in cv.goods) ...[
        _GoodCard(key: ValueKey('${cv.id}/${g.id}'), s: s, p: s.goodPlan(g)),
        gap(),
      ],
      hint(context,
          'Haszon = eladott egység × ${r.basePrice} A alapár × haszonkulcs. Az olcsóbb és népszerűbb eladó többet ad el; az olcsóság népszerűséget hoz, a drágaság aranyat.'),
    ]);
  }
}

class _GoodCard extends StatelessWidget {
  const _GoodCard({super.key, required this.s, required this.p});
  final CityState s;
  final GoodPlan p;

  @override
  Widget build(BuildContext context) {
    final c = context.tn, r = s.rules, cat = s.catalog, g = p.good;
    final bloc = context.read<CityBloc>();
    return TnCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 4, children: [
          ArtTitle(g.name, art: g.id, artSize: 30),
          Text('kínálat ${g.supply} · kereslet ${g.demand} · érték ${numText(g.marketValue)} A/pont', style: TnText.data(c.inkMuted, size: 12)),
        ]),
        gap(8),
        ShareBar(good: g),
        gap(8),
        MiniTable(
          cols: const [Col('Eladó', flex: 5), Col('Rész.', flex: 2, right: true), Col('Fokozat', flex: 5), Col('Eladott', flex: 3, right: true)],
          selfRows: p.selfRows,
          empty: 'Még senki sem árulja.',
          rows: [
            for (final x in p.sellers)
              [
                x.house == null ? Text('Város', style: TnText.body(c.inkMuted).copyWith(fontSize: 14)) : HouseName(x.house!),
                Text('${x.shares}', style: TnText.data(c.ink)),
                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Text(cat.marginLabel(x.margin), style: TnText.body(c.ink).copyWith(fontSize: 14)),
                  if (x.cheapest) const TinyTag('legolcsóbb'),
                  if (x.protectedNow) const TinyTag('védett', tone: 'muted'),
                ]),
                Text(x.sold == null ? '–' : numText(x.sold!), style: TnText.data(c.ink)),
              ],
          ],
        ),
        if (s.can && g.myShares > 0) ...[
          gap(),
          FieldLabel('Haszonkulcsod · ${cat.pp('margin')} PP', art: 'margin'),
          gap(6),
          OptionRow(
            items: [for (final m in cat.margins) OptionItem(m.id, '${m.percent}%', m.label, '${popDelta(m.pop)} N')],
            selected: g.myMargin,
            onPick: s.busy ? null : (id) => bloc.add(CityMarginPicked(g.id, id)),
          ),
        ],
        if (s.can) ...[
          gap(),
          Wrap(spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.end, children: [
            SizedBox(
              width: 150,
              child: TnSelect<int>(
                label: 'Vétel a Várostól (${g.cityShares} szabad)',
                value: p.buyPts,
                items: [for (final i in p.buyOptions) (i, '$i pont')],
                onChanged: p.canBuy ? (v) => bloc.add(CityBuyPointsChanged(g.id, v)) : null,
              ),
            ),
            TnButton(
              label: 'Vétel · ${cat.pp('buyShares')} PP · ${p.buyCost} A',
              art: 'buyShares',
              small: true,
              busy: s.busy,
              onPressed: p.canBuy ? () => bloc.add(CityBuySubmitted(g.id)) : null,
            ),
          ]),
          if (p.rivals.isNotEmpty) ...[
            gap(),
            Wrap(spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.end, children: [
              SizedBox(
                width: 170,
                child: TnSelect<String>(
                  label: 'Kivásárlás',
                  value: p.targetId,
                  items: [for (final x in p.rivals) (x.house!.playerId, '${x.house!.name} (${x.shares})')],
                  onChanged: (v) => bloc.add(CityBuyoutTargetChanged(g.id, v)),
                ),
              ),
              SizedBox(
                width: 90,
                child: TnSelect<int>(
                  label: 'Pont',
                  value: p.boPts,
                  items: [for (final i in p.boOptions) (i, '$i')],
                  onChanged: (v) => bloc.add(CityBuyoutPointsChanged(g.id, v)),
                ),
              ),
              TnButton(
                label: 'Ajánlat · ${cat.pp('buyout')} PP · ${p.boCost} A',
                art: 'buyout',
                small: true,
                kind: TnButtonKind.danger,
                busy: s.busy,
                onPressed: p.target == null ? null : () => bloc.add(CityBuyoutSubmitted(g.id)),
              ),
            ]),
            gap(4),
            hint(context, 'Kivásárlás: a piaci érték ${r.buyoutPremiumPercent}%-áért, a pénzt a rivális kapja. Érlelés alatt védekező vétellel kiválthatja.'),
          ],
        ],
      ]),
    );
  }
}
