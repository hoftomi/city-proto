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

/// Városháza: a tanács, a saját párt (alapítás, program, fesztivál), hírterjesztés és a terjedő hírek.
class TownHallSection extends StatelessWidget {
  const TownHallSection({super.key, required this.s});
  final CityState s;

  @override
  Widget build(BuildContext context) {
    final c = context.tn, r = s.rules, cat = s.catalog, clock = s.clock, cv = s.city!;
    final bloc = context.read<CityBloc>();
    final parties = cv.partiesByVotes;
    final camp = clock.campaign ? 2 : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TnCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              cardTitle(context, 'city.town_hall.council'.tr(), null, 'varoshaza'),
              gap(4),
              Text(
                [
                  'city.town_hall.election'.tr(namedArgs: {'when': electionText(clock.nextElectionIn).text}),
                  if (clock.campaign) 'city.town_hall.campaign'.tr(),
                ].join(' · '),
                style: TnText.caption(c.inkMuted).copyWith(fontSize: 13),
              ),
              gap(8),
              SeatsBar(parties: cv.parties, total: cv.councilSeats),
              gap(8),
              Text(
                [
                  'city.town_hall.tax'.tr(namedArgs: {'percent': '${cv.taxPercent}'}),
                  if (cv.lastTaxPool != null) 'city.town_hall.tax_pool'.tr(namedArgs: {'gold': numText(cv.lastTaxPool!)}),
                ].join(' · '),
                style: TnText.body(c.inkMuted).copyWith(fontSize: 13),
              ),
              gap(8),
              MiniTable(
                cols: [
                  Col('city.town_hall.col_party'.tr(), flex: 5),
                  Col('city.town_hall.col_program'.tr(), flex: 4),
                  Col('city.town_hall.col_votes'.tr(), flex: 3, right: true),
                  Col('city.town_hall.col_seats'.tr(), flex: 2, right: true),
                ],
                selfRows: {
                  for (var i = 0; i < parties.length; i++)
                    if (parties[i].house.self) i,
                },
                empty: 'city.town_hall.no_parties'.tr(),
                rows: [
                  for (final p in parties)
                    [
                      HouseName(p.house),
                      Text(cat.programLabel(p.program), style: TnText.body(c.ink).copyWith(fontSize: 14)),
                      Text('${p.votes}', style: TnText.data(c.ink)),
                      Text('${p.seats}', style: TnText.data(c.ink)),
                    ],
                ],
              ),
            ],
          ),
        ),
        if (s.can) ...[
          gap(),
          TnCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Eyebrow('city.town_hall.your_party'.tr()),
                gap(8),
                if (cv.myProgram == null) ...[
                  Text('city.town_hall.no_party_body'.tr(), style: TnText.body(c.ink)),
                  gap(8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TnButton(
                      label: 'city.town_hall.found_party'.tr(namedArgs: {'pp': '${cat.pp('foundParty')}', 'gold': '${r.partyCost}'}),
                      art: 'foundParty',
                      kind: TnButtonKind.primary,
                      busy: s.busy,
                      onPressed: () => bloc.add(const CityPartyFounded()),
                    ),
                  ),
                ] else ...[
                  FieldLabel('city.town_hall.program'.tr(namedArgs: {'pp': '${cat.pp('program')}'}), art: 'program'),
                  gap(6),
                  OptionRow(
                    items: [
                      for (final p in cat.programs) OptionItem(p.id, '${p.percent}%', p.label, 'city.pop_delta'.tr(namedArgs: {'delta': popDelta(p.pop)})),
                    ],
                    selected: cv.myProgram,
                    onPick: s.busy ? null : (id) => bloc.add(CityProgramPicked(id)),
                  ),
                  // A fesztivált a párt rendezi (a prototípus és a backend szerint is párt kell hozzá)
                  gap(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TnButton(
                      label: 'city.town_hall.festival'.tr(
                        namedArgs: {'pp': '${cat.pp('festival')}', 'gold': '${r.festivalGold * camp}', 'pop': '${r.festivalPop * camp}'},
                      ),
                      art: 'festival',
                      busy: s.busy,
                      onPressed: () => bloc.add(const CityFestivalRequested()),
                    ),
                  ),
                  gap(4),
                  hint(context, [if (clock.campaign) 'city.town_hall.festival_campaign_hint'.tr(), 'city.town_hall.festival_hint'.tr()].join(' ')),
                ],
              ],
            ),
          ),
        ],
        if (s.canCompose) ...[gap(), _NewsComposer(s: s, p: s.newsPlan)],
        if (cv.news.isNotEmpty) ...[
          gap(),
          TnCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Eyebrow('city.town_hall.news_spreading'.tr()),
                for (final n in cv.news.take(6)) NewsRow(n: n),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _NewsComposer extends StatelessWidget {
  const _NewsComposer({required this.s, required this.p});
  final CityState s;
  final NewsPlan p;

  @override
  Widget build(BuildContext context) {
    final c = context.tn, cat = s.catalog, t = p.template, tgt = p.target;
    final bloc = context.read<CityBloc>();
    return TnCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Eyebrow('city.town_hall.compose_title'.tr(namedArgs: {'pp': '${cat.pp('news')}', 'gold': '${s.rules.newsGold}'}), art: 'news'),
          gap(8),
          TnSelect<String>(
            label: 'city.town_hall.claim'.tr(),
            value: t?.id,
            items: [for (final n in cat.news) (n.id, NewsPlan.label(n.label))],
            onChanged: (v) => bloc.add(CityNewsTemplateChanged(v)),
          ),
          gap(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TnSelect<String>(
                  label: 'city.town_hall.target'.tr(),
                  value: tgt?.playerId,
                  items: [for (final h in p.targets) (h.playerId, h.name)],
                  onChanged: (v) => bloc.add(CityNewsTargetChanged(v)),
                ),
              ),
              if (p.needsGood) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: p.goods.isEmpty
                      ? TnSelect<String>(label: 'city.town_hall.good'.tr(), value: '', items: [('', 'city.town_hall.no_good'.tr())], onChanged: null)
                      : TnSelect<String>(
                          label: 'city.town_hall.good'.tr(),
                          value: p.good?.id,
                          items: [for (final g in p.goods) (g.id, g.name)],
                          onChanged: (v) => bloc.add(CityNewsGoodChanged(v)),
                        ),
                ),
              ],
            ],
          ),
          gap(8),
          hint(context, 'city.town_hall.compose_hint'.tr()),
          gap(8),
          Align(
            alignment: Alignment.centerLeft,
            child: TnButton(
              label: t == null
                  ? 'city.town_hall.submit_plain'.tr(namedArgs: {'target': tgt?.name ?? ''})
                  : 'city.town_hall.submit'.tr(namedArgs: {'effect': '${t.effect > 0 ? '+' : ''}${t.effect}', 'target': tgt?.name ?? ''}),
              kind: p.harmful ? TnButtonKind.danger : TnButtonKind.normal,
              art: 'news',
              small: true,
              busy: s.busy,
              onPressed: p.ok ? () => bloc.add(const CityNewsSubmitted()) : null,
            ),
          ),
          if (p.targetSellsNothing) ...[
            gap(4),
            Text('city.town_hall.sells_nothing'.tr(namedArgs: {'house': tgt!.name}), style: TnText.caption(c.inkMuted)),
          ],
        ],
      ),
    );
  }
}
