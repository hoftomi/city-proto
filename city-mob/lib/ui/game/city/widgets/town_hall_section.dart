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
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TnCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          cardTitle(context, 'Városi tanács', null, 'varoshaza'),
          gap(4),
          Text('Választás ${electionText(clock.nextElectionIn)}${clock.campaign ? ' · kampányidőszak' : ''}', style: TnText.caption(c.inkMuted).copyWith(fontSize: 13)),
          gap(8),
          SeatsBar(parties: cv.parties, total: cv.councilSeats),
          gap(8),
          Text('Adókulcs: ${cv.taxPercent}%${cv.lastTaxPool != null ? ' · legutóbb ${numText(cv.lastTaxPool!)} A jutott a pártoknak' : ''}',
              style: TnText.body(c.inkMuted).copyWith(fontSize: 13)),
          gap(8),
          MiniTable(
            cols: const [Col('Párt', flex: 5), Col('Program', flex: 4), Col('Szavazat', flex: 3, right: true), Col('Hely', flex: 2, right: true)],
            selfRows: {for (var i = 0; i < parties.length; i++) if (parties[i].house.self) i},
            empty: 'Még nincs párt a városban.',
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
        ]),
      ),
      if (s.can) ...[
        gap(),
        TnCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Eyebrow('A pártod'),
            gap(8),
            if (cv.myProgram == null) ...[
              Text('Párt nélkül nem jutsz be a tanácsba, és nem kapsz adót. A szavazataid a népszerűségeddel egyenlők.', style: TnText.body(c.ink)),
              gap(8),
              Align(
                alignment: Alignment.centerLeft,
                child: TnButton(
                  label: 'Pártalapítás · ${cat.pp('foundParty')} PP · ${r.partyCost} A',
                  art: 'foundParty',
                  kind: TnButtonKind.primary,
                  busy: s.busy,
                  onPressed: () => bloc.add(const CityPartyFounded()),
                ),
              ),
            ] else ...[
              FieldLabel('Program · ${cat.pp('program')} PP', art: 'program'),
              gap(6),
              OptionRow(
                items: [for (final p in cat.programs) OptionItem(p.id, '${p.percent}%', p.label, '${popDelta(p.pop)} N')],
                selected: cv.myProgram,
                onPick: s.busy ? null : (id) => bloc.add(CityProgramPicked(id)),
              ),
              // A fesztivált a párt rendezi (a prototípus és a backend szerint is párt kell hozzá)
              gap(),
              Align(
                alignment: Alignment.centerLeft,
                child: TnButton(
                  label: 'Fesztivál · ${cat.pp('festival')} PP · ${r.festivalGold * camp} A · +${r.festivalPop * camp} N',
                  art: 'festival',
                  busy: s.busy,
                  onPressed: () => bloc.add(const CityFestivalRequested()),
                ),
              ),
              gap(4),
              hint(context,
                  '${clock.campaign ? 'Kampányidőszak: a fesztivál ára és hatása dupla. ' : ''}Ha ugyanitt 3 elszámoláson belül ismét fesztivált tartasz, csak feleannyi népszerűséget hoz.'),
            ],
          ]),
        ),
      ],
      if (s.canCompose) ...[
        gap(),
        _NewsComposer(s: s, p: s.newsPlan),
      ],
      if (cv.news.isNotEmpty) ...[
        gap(),
        TnCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Eyebrow('A városban terjedő hírek'),
            for (final n in cv.news.take(6)) NewsRow(n: n),
          ]),
        ),
      ],
    ]);
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Eyebrow('Hír terjesztése · ${cat.pp('news')} PP · ${s.rules.newsGold} A', art: 'news'),
        gap(8),
        TnSelect<String>(
          label: 'Állítás',
          value: t?.id,
          items: [for (final n in cat.news) (n.id, NewsPlan.label(n.label))],
          onChanged: (v) => bloc.add(CityNewsTemplateChanged(v)),
        ),
        gap(8),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(
            child: TnSelect<String>(
              label: 'Kiről',
              value: tgt?.playerId,
              items: [for (final h in p.targets) (h.playerId, h.name)],
              onChanged: (v) => bloc.add(CityNewsTargetChanged(v)),
            ),
          ),
          if (p.needsGood) ...[
            const SizedBox(width: 12),
            Expanded(
              child: p.goods.isEmpty
                  ? TnSelect<String>(label: 'Árucikk', value: '', items: const [('', 'nincs árucikke')], onChanged: null)
                  : TnSelect<String>(
                      label: 'Árucikk',
                      value: p.good?.id,
                      items: [for (final g in p.goods) (g.id, g.name)],
                      onChanged: (v) => bloc.add(CityNewsGoodChanged(v)),
                    ),
            ),
          ],
        ]),
        gap(8),
        hint(context,
            'A hatás azonnal érvényes, akár igaz a hír, akár hamis. Ha az állítás most nem igaz, a parancslap figyelmeztet. Leleplezett hamis hírért −10 népszerűséget kapsz, a célpont pedig visszanyeri a veszteségét.'),
        gap(8),
        Align(
          alignment: Alignment.centerLeft,
          child: TnButton(
            label: 'Parancslapra · ${t == null ? '' : '${t.effect > 0 ? '+' : ''}${t.effect} N '}${tgt?.name ?? ''}',
            kind: p.harmful ? TnButtonKind.danger : TnButtonKind.normal,
            art: 'news',
            small: true,
            busy: s.busy,
            onPressed: p.ok ? () => bloc.add(const CityNewsSubmitted()) : null,
          ),
        ),
        if (p.targetSellsNothing) ...[gap(4), Text('${tgt!.name} itt nem árul semmit.', style: TnText.caption(c.inkMuted))],
      ]),
    );
  }
}
