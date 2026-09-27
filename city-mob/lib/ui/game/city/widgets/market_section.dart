import 'package:easy_localization/easy_localization.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final t in s.threats) ...[
          TnCard(
            tone: TnCardTone.threat,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Notice(
                  tone: 'danger',
                  title: 'city.market.threat_title'.tr(namedArgs: {'house': t.by.name}),
                  body: 'city.market.threat_body'.tr(
                    namedArgs: {'pts': '${t.pts}', 'good': t.goodName, 'time': at(t.executeAt), 'left': durText(s.until(t.executeAt))},
                  ),
                ),
                gap(8),
                if (t.defending)
                  Notice(tone: 'info', title: 'city.market.defending'.tr(), body: s.defendOnlyInDraft(t) ? 'city.market.defend_draft'.tr() : null)
                else if (s.can)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TnButton(
                      label: 'city.market.defend'.tr(namedArgs: {'pp': '${s.catalog.pp('defend')}', 'gold': '${t.defendCost}'}),
                      art: 'defend',
                      kind: TnButtonKind.danger,
                      busy: s.busy,
                      onPressed: () => bloc.add(CityDefendRequested(t.orderId)),
                    ),
                  ),
                gap(8),
                hint(context, 'city.market.defend_hint'.tr(namedArgs: {'time': at(t.executeAt)})),
              ],
            ),
          ),
          gap(),
        ],
        if (s.lowPop) ...[
          Notice(
            tone: 'warn',
            title: 'city.market.low_pop_title'.tr(),
            body: 'city.market.low_pop_body'.tr(namedArgs: {'threshold': '${r.lowPopThreshold}'}),
          ),
          gap(),
        ],
        if (cv.goods.isEmpty) Text('city.market.no_goods'.tr(), style: TnText.body(c.inkMuted)),
        for (final g in cv.goods) ...[_GoodCard(key: ValueKey('${cv.id}/${g.id}'), s: s, p: s.goodPlan(g)), gap()],
        hint(context, 'city.market.profit_hint'.tr(namedArgs: {'base': '${r.basePrice}'})),
      ],
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              ArtTitle(g.name, art: g.id, artSize: 30),
              Text(
                'city.market.good_stats'.tr(namedArgs: {'supply': '${g.supply}', 'demand': '${g.demand}', 'value': numText(g.marketValue)}),
                style: TnText.data(c.inkMuted, size: 12),
              ),
            ],
          ),
          gap(8),
          ShareBar(good: g),
          gap(8),
          MiniTable(
            cols: [
              Col('city.market.col_seller'.tr(), flex: 5),
              Col('city.market.col_shares'.tr(), flex: 2, right: true),
              Col('city.market.col_margin'.tr(), flex: 5),
              Col('city.market.col_sold'.tr(), flex: 3, right: true),
            ],
            selfRows: p.selfRows,
            empty: 'city.market.no_sellers'.tr(),
            rows: [
              for (final x in p.sellers)
                [
                  x.house == null ? Text('city.market.city_seller'.tr(), style: TnText.body(c.inkMuted).copyWith(fontSize: 14)) : HouseName(x.house!),
                  Text('${x.shares}', style: TnText.data(c.ink)),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(cat.marginLabel(x.margin), style: TnText.body(c.ink).copyWith(fontSize: 14)),
                      if (x.cheapest) TinyTag('city.market.cheapest'.tr()),
                      if (x.protectedNow) TinyTag('city.market.protected'.tr(), tone: 'muted'),
                    ],
                  ),
                  Text(x.sold == null ? '–' : numText(x.sold!), style: TnText.data(c.ink)),
                ],
            ],
          ),
          if (s.can && g.myShares > 0) ...[
            gap(),
            FieldLabel('city.market.my_margin'.tr(namedArgs: {'pp': '${cat.pp('margin')}'}), art: 'margin'),
            gap(6),
            OptionRow(
              items: [
                for (final m in cat.margins) OptionItem(m.id, '${m.percent}%', m.label, 'city.pop_delta'.tr(namedArgs: {'delta': popDelta(m.pop)})),
              ],
              selected: g.myMargin,
              onPick: s.busy ? null : (id) => bloc.add(CityMarginPicked(g.id, id)),
            ),
          ],
          if (s.can) ...[
            gap(),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                SizedBox(
                  width: 150,
                  child: TnSelect<int>(
                    label: 'city.market.buy_label'.tr(namedArgs: {'free': '${g.cityShares}'}),
                    value: p.buyPts,
                    items: [
                      for (final i in p.buyOptions) (i, 'city.market.points'.tr(namedArgs: {'n': '$i'})),
                    ],
                    onChanged: p.canBuy ? (v) => bloc.add(CityBuyPointsChanged(g.id, v)) : null,
                  ),
                ),
                TnButton(
                  label: 'city.market.buy'.tr(namedArgs: {'pp': '${cat.pp('buyShares')}', 'gold': '${p.buyCost}'}),
                  art: 'buyShares',
                  small: true,
                  busy: s.busy,
                  onPressed: p.canBuy ? () => bloc.add(CityBuySubmitted(g.id)) : null,
                ),
              ],
            ),
            if (p.rivals.isNotEmpty) ...[
              gap(),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  SizedBox(
                    width: 170,
                    child: TnSelect<String>(
                      label: 'city.market.buyout_label'.tr(),
                      value: p.targetId,
                      items: [for (final x in p.rivals) (x.house!.playerId, '${x.house!.name} (${x.shares})')],
                      onChanged: (v) => bloc.add(CityBuyoutTargetChanged(g.id, v)),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TnSelect<int>(
                      label: 'city.market.points_label'.tr(),
                      value: p.boPts,
                      items: [for (final i in p.boOptions) (i, '$i')],
                      onChanged: (v) => bloc.add(CityBuyoutPointsChanged(g.id, v)),
                    ),
                  ),
                  TnButton(
                    label: 'city.market.buyout'.tr(namedArgs: {'pp': '${cat.pp('buyout')}', 'gold': '${p.boCost}'}),
                    art: 'buyout',
                    small: true,
                    kind: TnButtonKind.danger,
                    busy: s.busy,
                    onPressed: p.target == null ? null : () => bloc.add(CityBuyoutSubmitted(g.id)),
                  ),
                ],
              ),
              gap(4),
              hint(context, 'city.market.buyout_hint'.tr(namedArgs: {'percent': '${r.buyoutPremiumPercent}'})),
            ],
          ],
        ],
      ),
    );
  }
}
