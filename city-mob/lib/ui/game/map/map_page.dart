import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tron_api/tron_api.dart';

import '../../../app/router/routes.dart';
import '../../../domain/model/extensions.dart';
import '../../../domain/model/game_view_extensions.dart';
import '../../../theme/tokens.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/game_widgets.dart';
import '../../../widgets/map_view.dart';
import '../bloc/game_bloc.dart';
import '../widgets/game_tab_scroll.dart';

/// A Térkép fül: parancspontok, a térkép, és a kijelölt város kártyája (áruk, tanács, útvonalépítés, megnyitás).
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return GameTabScroll(
      child: BlocBuilder<GameBloc, GameViewState>(
        buildWhen: (a, b) => a.game != b.game || a.map != b.map || a.selectedCity != b.selectedCity || a.busy != b.busy,
        builder: (context, v) {
          final s = v.game, m = v.map;
          if (s == null || m == null) return const SizedBox.shrink();
          final sel = s.cityOrNull(v.selectedCity);
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            CommandPoints(available: s.me.pp, pending: s.draftCost.pp, max: s.me.ppMax),
            const SizedBox(height: 16),
            MapView(map: m, state: s, selected: v.selectedCity, onSelect: (id) => context.read<GameBloc>().add(GameMapCitySelected(id))),
            const SizedBox(height: 16),
            if (sel == null)
              Text('Koppints egy városra a térképen.', style: TnText.body(c.inkMuted))
            else
              _CityCard(game: s, city: sel, busy: v.busy),
          ]);
        },
      ),
    );
  }
}

/// A kijelölt város kártyája.
class _CityCard extends StatelessWidget {
  const _CityCard({required this.game, required this.city, required this.busy});
  final GameState game;
  final CityView city;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final sel = city;
    return TnCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 6, children: [
          Eyebrow(sel.cardEyebrow),
          StatChip(label: 'Népszerűséged', value: '${sel.myPop.round()}', art: 'nep'),
        ]),
        const SizedBox(height: 4),
        Text(sel.name, style: TnText.display(c.ink).copyWith(fontSize: 26, height: 30 / 26)),
        const SizedBox(height: 12),
        if (!sel.reachable) ...[
          const Notice(tone: 'warn', title: 'Nem vezet ide útvonalad', body: 'Akciót csak a hálózatodban lévő városban indíthatsz. Építs útvonalat egy szomszédos városból.'),
          const SizedBox(height: 12),
        ],
        if (sel.goods.isNotEmpty) ...[
          LayoutBuilder(builder: (ctx, box) {
            final cols = ((box.maxWidth + 8) / 148).floor().clamp(1, 4);
            final w = (box.maxWidth - 8 * (cols - 1)) / cols;
            return Wrap(spacing: 8, runSpacing: 8, children: [
              for (final g in sel.goods) SizedBox(width: w, child: _MiniGood(g: g, marginLabel: game.catalog.marginLabel(g.myMargin))),
            ]);
          }),
          const SizedBox(height: 12),
        ],
        SeatsBar(parties: sel.parties, total: sel.councilSeats),
        const SizedBox(height: 12),
        Wrap(alignment: WrapAlignment.end, spacing: 8, runSpacing: 8, children: [
          for (final b in game.buildableTo(sel.id))
            TnButton(label: 'Útvonal innen: ${b.fromName}', art: 'route', busy: busy, onPressed: () => context.read<GameBloc>().add(GameOrderAdded(b.order))),
          TnButton(label: 'Város megnyitása', icon: 'varos', kind: TnButtonKind.primary, onPressed: () => context.go(Routes.city(game.gameId, cityId: sel.id))),
        ]),
      ]),
    );
  }
}

/// Egy árucikk a térkép városkártyáján (mini-good): játékikon, Cinzel név, kínálat/kereslet, saját részesedés.
class _MiniGood extends StatelessWidget {
  const _MiniGood({required this.g, required this.marginLabel});
  final GoodView g;
  final String marginLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      // inset 0 -2px 0 var(--line): alsó belső perem a lap aljára festett átmenettel
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TnRadius.sm),
        border: Border.all(color: c.lineStrong),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.field, c.field, c.line, c.line],
          stops: const [0, 0.97, 0.97, 1],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ArtTitle(g.name, art: g.id, artSize: 24, size: 15),
        const SizedBox(height: 2),
        Text('${g.supply} / ${g.demand}', style: TnText.data(c.inkMuted, size: 12)),
        const SizedBox(height: 2),
        g.myShares > 0
            ? Text.rich(TextSpan(style: TnText.body(c.ink).copyWith(fontSize: 13, height: 18 / 13), children: [
                const TextSpan(text: 'Részesedésed '),
                TextSpan(text: '${g.myShares}', style: TnText.data(c.ink, weight: FontWeight.w900)),
                TextSpan(text: ' · $marginLabel'),
              ]))
            : Text('Nincs részesedésed · Város: ${g.cityShares}', style: TnText.body(c.inkMuted).copyWith(fontSize: 13, height: 18 / 13)),
      ]),
    );
  }
}
