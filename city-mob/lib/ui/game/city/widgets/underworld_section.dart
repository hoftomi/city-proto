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

/// Underworld: own spies (hiring, guard, relocation), spying on maturing order sheets, selling intel,
/// offered information, verifying news.
class UnderworldSection extends StatelessWidget {
  const UnderworldSection({super.key, required this.s});
  final CityState s;

  @override
  Widget build(BuildContext context) {
    final c = context.tn, r = s.rules, cat = s.catalog, cv = s.city!, g = s.game!;
    final bloc = context.read<CityBloc>();
    final free = s.freeSpies;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TnCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              cardTitle(context, 'city.underworld.spies'.tr(), '${cv.mySpies} / ${r.spiesPerCity}', 'hireSpy'),
              gap(4),
              UnitText(
                'city.underworld.spies_status'.tr(namedArgs: {'free': '$free', 'guards': '${cv.myGuards}', 'upkeep': coinText(r.spyUpkeep)}),
                style: TnText.body(c.inkMuted).copyWith(fontSize: 13),
              ),
              Text(
                'city.underworld.foreign'.tr(
                  namedArgs: {'names': cv.foreignSpies.isEmpty ? 'city.underworld.foreign_none'.tr() : cv.foreignSpies.map((h) => h.name).join(', ')},
                ),
                style: TnText.body(c.inkMuted).copyWith(fontSize: 13),
              ),
              if (s.can) ...[
                gap(8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TnButton(
                      label: 'city.underworld.hire'.tr(namedArgs: {'pp': '${cat.pp('hireSpy')}', 'gold': coinText(r.spyCost)}),
                      art: 'hireSpy',
                      busy: s.busy,
                      onPressed: s.spiesFull ? null : () => bloc.add(const CitySpyHired()),
                    ),
                    TnButton(
                      label: 'city.underworld.guard'.tr(namedArgs: {'pp': '${cat.pp('guard')}'}),
                      art: 'guard',
                      busy: s.busy,
                      onPressed: free < 1 ? null : () => bloc.add(const CityGuardPosted()),
                    ),
                    TnButton(
                      label: 'city.underworld.move'.tr(namedArgs: {'pp': '${cat.pp('moveSpy')}'}),
                      icon: 'route',
                      busy: s.busy,
                      onPressed: free < 1 ? null : () => bloc.add(const CityMoveSpyOpened()),
                    ),
                  ],
                ),
              ],
              gap(8),
              hint(context, 'city.underworld.spy_hint'.tr(namedArgs: {'percent': '${r.guardChancePercent}'})),
            ],
          ),
        ),
        gap(),
        TnCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Eyebrow('city.underworld.sheets'.tr(), art: 'spy'),
              if (g.rivalSheets.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('city.underworld.no_sheets'.tr(), style: TnText.body(c.inkMuted)),
                ),
              for (final l in g.rivalSheets)
                CityLine(
                  body: Row(
                    children: [
                      HouseCrest(size: 18, npc: l.house.npc, name: l.house.name),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: TnText.body(c.ink).copyWith(fontSize: 14),
                            children: [
                              TextSpan(text: l.house.name, style: TnText.bodyStrong(c.ink).copyWith(fontSize: 14)),
                              TextSpan(text: ' · ${'city.underworld.runs'.tr(namedArgs: {'time': at(l.executeAt)})} '),
                              TextSpan(
                                text: 'city.underworld.left'.tr(namedArgs: {'left': durText(s.until(l.executeAt))}),
                                style: TnText.body(c.inkMuted).copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  action: s.can
                      ? TnButton(
                          label: 'city.underworld.spy'.tr(namedArgs: {'pp': '${cat.pp('spy')}'}),
                          art: 'spy',
                          small: true,
                          busy: s.busy,
                          onPressed: free < 1 ? null : () => bloc.add(CitySpyRequested(l.house.playerId)),
                        )
                      : null,
                ),
              gap(8),
              hint(context, 'city.underworld.sheets_hint'.tr(namedArgs: {'maturation': durText(Duration(minutes: s.clock.maturationMinutes))})),
            ],
          ),
        ),
        if (g.intel.isNotEmpty) ...[
          gap(),
          TnCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Eyebrow('city.underworld.intel'.tr()),
                for (final it in g.intel.take(8))
                  CityLine(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TnText.body(c.ink).copyWith(fontSize: 14),
                            children: [
                              TextSpan(text: it.of_.name, style: TnText.bodyStrong(c.ink).copyWith(fontSize: 14)),
                              TextSpan(
                                text: ' · ${'city.underworld.runs'.tr(namedArgs: {'time': at(it.executeAt)})}${it.live ? '' : ' · ${'city.underworld.already_ran'.tr()}'}',
                              ),
                            ],
                          ),
                        ),
                        UnitText(
                          it.lines.isEmpty ? 'city.underworld.no_details'.tr() : it.lines.join(' · '),
                          style: TnText.body(c.inkMuted).copyWith(fontSize: 13),
                        ),
                        if (it.offeredTo.isNotEmpty)
                          Text(
                            'city.underworld.offered_to'.tr(namedArgs: {'names': it.offeredTo.map(s.houseName).join(', ')}),
                            style: TnText.caption(c.inkMuted),
                          ),
                        if (it.bought) Text('city.underworld.bought'.tr(), style: TnText.caption(c.inkMuted)),
                      ],
                    ),
                    action: it.live && !it.bought
                        ? TnButton(
                            label: 'city.underworld.sell'.tr(),
                            art: 'gold',
                            small: true,
                            busy: s.busy,
                            onPressed: () => bloc.add(CityIntelSaleOpened(it.id)),
                          )
                        : null,
                  ),
                gap(8),
                hint(context, 'city.underworld.intel_hint'.tr()),
              ],
            ),
          ),
        ],
        if (g.offers.isNotEmpty) ...[
          gap(),
          TnCard(
            borderColor: c.verdigris,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Eyebrow('city.underworld.offers'.tr(), art: 'gold'),
                for (final o in g.offers)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: c.line)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TnText.body(c.ink).copyWith(fontSize: 14),
                            children: [
                              TextSpan(text: o.seller.name, style: TnText.bodyStrong(c.ink).copyWith(fontSize: 14)),
                              ...unitSpans(
                                ' ${'city.underworld.offer_text'.tr(namedArgs: {'house': o.of_.name, 'price': coinText(o.price), 'time': at(o.executeAt), 'left': durText(s.until(o.executeAt))})}',
                                TnText.body(c.ink).copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        gap(6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TnButton(
                              label: 'city.underworld.accept'.tr(namedArgs: {'price': coinText(o.price)}),
                              art: 'gold',
                              small: true,
                              kind: TnButtonKind.primary,
                              busy: s.busy,
                              onPressed: () => bloc.add(CityOfferAccepted(o.id)),
                            ),
                            TnButton(
                              label: 'city.underworld.decline'.tr(),
                              small: true,
                              kind: TnButtonKind.quiet,
                              busy: s.busy,
                              onPressed: () => bloc.add(CityOfferDeclined(o.id)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                gap(8),
                hint(context, 'city.underworld.offers_hint'.tr()),
              ],
            ),
          ),
        ],
        gap(),
        TnCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Eyebrow('city.underworld.check'.tr(), art: 'verify'),
              if (s.checkable.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('city.underworld.no_checkable'.tr(), style: TnText.body(c.inkMuted)),
                ),
              for (final n in s.checkable)
                NewsRow(
                  n: n,
                  action: switch (s.newsCheck(n)) {
                    NewsCheck.debunk => TnButton(
                        label: 'city.underworld.debunk'.tr(namedArgs: {'pp': '${cat.pp('debunk')}'}),
                        art: 'debunk',
                        small: true,
                        kind: TnButtonKind.danger,
                        busy: s.busy,
                        onPressed: () => bloc.add(CityNewsChecked(n.id)),
                      ),
                    NewsCheck.verify => TnButton(
                        label: 'city.underworld.verify'.tr(namedArgs: {'pp': '${cat.pp('verify')}'}),
                        art: 'verify',
                        small: true,
                        busy: s.busy,
                        onPressed: () => bloc.add(CityNewsChecked(n.id)),
                      ),
                    NewsCheck.none => null,
                  },
                ),
              gap(8),
              hint(
                context,
                'city.underworld.debunk_hint'.tr(
                  namedArgs: {'pop': '${r.debunkRewardPop}', 'gold': coinText(r.debunkRewardGold), 'legit': '${r.debunkRewardLegit}'},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
