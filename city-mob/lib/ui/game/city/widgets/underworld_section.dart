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

/// Alvilág: saját kémek (felfogadás, őr, áthelyezés), érlelő parancslapok kifürkészése, kifürkészett tervek
/// eladása, felkínált információ, hírek ellenőrzése.
class UnderworldSection extends StatelessWidget {
  const UnderworldSection({super.key, required this.s});
  final CityState s;

  @override
  Widget build(BuildContext context) {
    final c = context.tn, r = s.rules, cat = s.catalog, cv = s.city!, g = s.game!;
    final bloc = context.read<CityBloc>();
    final free = s.freeSpies;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TnCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          cardTitle(context, 'Kémeid itt', '${cv.mySpies} / ${r.spiesPerCity}', 'hireSpy'),
          gap(4),
          Text('$free szabad ügynök, ${cv.myGuards} őr · fenntartás ${r.spyUpkeep} A kémenként elszámolásonként', style: TnText.body(c.inkMuted).copyWith(fontSize: 13)),
          Text('Pletykák szerint idegen kémek is vannak itt: ${cv.foreignSpies.isEmpty ? 'senkiről sem tudni' : cv.foreignSpies.map((h) => h.name).join(', ')}.',
              style: TnText.body(c.inkMuted).copyWith(fontSize: 13)),
          if (s.can) ...[
            gap(8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              TnButton(
                label: 'Kém felfogadása · ${cat.pp('hireSpy')} PP · ${r.spyCost} A',
                art: 'hireSpy',
                busy: s.busy,
                onPressed: s.spiesFull ? null : () => bloc.add(const CitySpyHired()),
              ),
              TnButton(label: 'Őr beállítása · ${cat.pp('guard')} PP', art: 'guard', busy: s.busy, onPressed: free < 1 ? null : () => bloc.add(const CityGuardPosted())),
              TnButton(
                label: 'Kém áthelyezése · ${cat.pp('moveSpy')} PP',
                icon: 'route',
                busy: s.busy,
                onPressed: free < 1 ? null : () => bloc.add(const CityMoveSpyOpened()),
              ),
            ]),
          ],
          gap(8),
          hint(context,
              'Egy szabad kém az akciók típusát, kettő a célpontot is, három a költséget is kifürkészi. Minden őr ${r.guardChancePercent}% eséllyel buktatja le az ellened indított kémakciót.'),
        ]),
      ),
      gap(),
      TnCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Eyebrow('Érlelő parancslapok', art: 'spy'),
          if (g.rivalLaps.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Most senkinek sincs érlelő parancslapja.', style: TnText.body(c.inkMuted))),
          for (final l in g.rivalLaps)
            CityLine(
              body: Row(children: [
                HouseCrest(tincture: l.house.tincture, size: 18, npc: l.house.npc, name: l.house.name),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(TextSpan(style: TnText.body(c.ink).copyWith(fontSize: 14), children: [
                    TextSpan(text: l.house.name, style: TnText.bodyStrong(c.ink).copyWith(fontSize: 14)),
                    TextSpan(text: ' · lefut ${at(l.executeAt)} '),
                    TextSpan(text: '(${durText(s.until(l.executeAt))} múlva)', style: TnText.body(c.inkMuted).copyWith(fontSize: 14)),
                  ])),
                ),
              ]),
              action: s.can
                  ? TnButton(
                      label: 'Kifürkészés · ${cat.pp('spy')} PP',
                      art: 'spy',
                      small: true,
                      busy: s.busy,
                      onPressed: free < 1 ? null : () => bloc.add(CitySpyRequested(l.house.playerId)),
                    )
                  : null,
            ),
          gap(8),
          hint(context,
              'A jelentés a saját parancslapod lefutásakor érkezik (${durText(Duration(minutes: s.clock.maturationMinutes))} érlelés). Csak akkor ér valamit, ha a célpont később fut le, mint a tiéd.'),
        ]),
      ),
      if (g.intel.isNotEmpty) ...[
        gap(),
        TnCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Eyebrow('Kifürkészett tervek'),
            for (final it in g.intel.take(8))
              CityLine(
                body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text.rich(TextSpan(style: TnText.body(c.ink).copyWith(fontSize: 14), children: [
                    TextSpan(text: it.of_.name, style: TnText.bodyStrong(c.ink).copyWith(fontSize: 14)),
                    TextSpan(text: ' · lefut ${at(it.executeAt)}${it.live ? '' : ' · már lefutott'}'),
                  ])),
                  Text(it.lines.isEmpty ? 'Nincs részlet.' : it.lines.join(' · '), style: TnText.body(c.inkMuted).copyWith(fontSize: 13)),
                  if (it.offeredTo.isNotEmpty) Text('Felkínálva: ${it.offeredTo.map(s.houseName).join(', ')}', style: TnText.caption(c.inkMuted)),
                  if (it.bought) Text('Megvásárolt információ', style: TnText.caption(c.inkMuted)),
                ]),
                action: it.live && !it.bought
                    ? TnButton(label: 'Eladás', art: 'arany', small: true, busy: s.busy, onPressed: () => bloc.add(CityIntelSaleOpened(it.id)))
                    : null,
              ),
            gap(8),
            hint(context, 'Az információ romlandó: az érlelő parancs végrehajtásával értéktelenné válik. Eladásonként +1 Legitimitás (legfeljebb 3 elszámolásonként egyszer).'),
          ]),
        ),
      ],
      if (g.offers.isNotEmpty) ...[
        gap(),
        TnCard(
          borderColor: c.verdigris,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Eyebrow('Neked felkínált információ', art: 'arany'),
            for (final o in g.offers)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text.rich(TextSpan(style: TnText.body(c.ink).copyWith(fontSize: 14), children: [
                    TextSpan(text: o.seller.name, style: TnText.bodyStrong(c.ink).copyWith(fontSize: 14)),
                    TextSpan(text: ' eladná ${o.of_.name} terveit · ${o.price} A · lefut ${at(o.executeAt)} (${durText(s.until(o.executeAt))} múlva)'),
                  ])),
                  gap(6),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    TnButton(
                      label: 'Elfogadás · ${o.price} A',
                      art: 'arany',
                      small: true,
                      kind: TnButtonKind.primary,
                      busy: s.busy,
                      onPressed: () => bloc.add(CityOfferAccepted(o.id)),
                    ),
                    TnButton(label: 'Elutasítás', small: true, kind: TnButtonKind.quiet, busy: s.busy, onPressed: () => bloc.add(CityOfferDeclined(o.id))),
                  ]),
                ]),
              ),
            gap(8),
            hint(context, 'Letét: elfogadáskor fizetsz, és azonnal megkapod a jelentést.'),
          ]),
        ),
      ],
      gap(),
      TnCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Eyebrow('Hírek ellenőrzése', art: 'verify'),
          if (s.checkable.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Nincs ellenőrizhető hír a városban.', style: TnText.body(c.inkMuted))),
          for (final n in s.checkable)
            NewsRow(
              n: n,
              action: switch (s.newsCheck(n)) {
                NewsCheck.debunk => TnButton(
                    label: 'Leleplezés · ${cat.pp('debunk')} PP',
                    art: 'debunk',
                    small: true,
                    kind: TnButtonKind.danger,
                    busy: s.busy,
                    onPressed: () => bloc.add(CityNewsChecked(n.id)),
                  ),
                NewsCheck.verify => TnButton(
                    label: 'Ellenőrzés · ${cat.pp('verify')} PP', art: 'verify', small: true, busy: s.busy, onPressed: () => bloc.add(CityNewsChecked(n.id))),
                NewsCheck.none => null,
              },
            ),
          gap(8),
          hint(context, 'Hamis hír leleplezéséért: +${r.debunkRewardPop} N, +${r.debunkRewardGold} A, +${r.debunkRewardLegit} Legitimitás.'),
        ]),
      ),
    ]);
  }
}
