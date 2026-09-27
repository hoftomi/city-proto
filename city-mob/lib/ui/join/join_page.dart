import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/di/di.dart';
import '../../app/router/routes.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../../widgets/buttons.dart';
import '../../widgets/game_widgets.dart';
import '../../widgets/map_view.dart';
import 'bloc/join_bloc.dart';
import 'widgets/join_widgets.dart';

/// Jelentkezés négy lépésben: ház, háttér, kezdőhely, összegzés. Siker után futó játéknál be a játékba,
/// különben vissza a részletekre (`true` eredménnyel, azok frissülnek).
class JoinPage extends StatelessWidget {
  const JoinPage({super.key, required this.gameId});
  final String gameId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<JoinBloc>()..add(JoinStarted(gameId)), child: const _JoinView());
  }
}

class _JoinView extends StatelessWidget {
  const _JoinView();

  void _leave(BuildContext context) => context.canPop() ? context.pop() : context.go(Routes.lobby);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<JoinBloc, JoinState>(
          listenWhen: (a, b) => b.notice != null && a.notice != b.notice,
          listener: (context, s) => showToast(context, s.notice!.title, body: s.notice!.body, tone: s.notice!.tone),
        ),
        BlocListener<JoinBloc, JoinState>(
          listenWhen: (a, b) => a.outcome == null && b.outcome != null,
          listener: (context, s) => switch (s.outcome!) {
            JoinOutcome.enterGame => context.go(Routes.map(s.gameId!)),
            JoinOutcome.backToDetail => context.canPop() ? context.pop(true) : context.go(Routes.game(s.gameId!)),
          },
        ),
      ],
      child: BlocBuilder<JoinBloc, JoinState>(builder: (context, s) {
        final bloc = context.read<JoinBloc>();
        return PopScope(
          canPop: s.canPop,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) bloc.add(const JoinBackPressed());
          },
          child: Scaffold(
            body: TnScreen(
              child: Column(children: [
                TnHeader(
                  leading: TnButton(
                    label: s.backLabel,
                    kind: TnButtonKind.quiet,
                    small: true,
                    onPressed: () => s.canPop ? _leave(context) : bloc.add(const JoinBackPressed()),
                  ),
                  title: Text(s.game?.name ?? '', textAlign: TextAlign.right, style: TnText.caption(const Color(0xFFD9C49A))),
                  bottom: Padding(padding: const EdgeInsets.only(top: 8), child: JoinStepper(step: s.step, steps: s.steps)),
                ),
                if (s.failure != null && !s.ready)
                  Expanded(
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(16), child: Notice(tone: 'danger', title: 'Nem sikerült betölteni', body: s.failure!.message)),
                    ),
                  )
                else if (!s.ready)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else ...[
                  Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [_body(context, s)])),
                  SafeArea(
                    top: false,
                    minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: TnButton(
                      label: s.nextLabel,
                      kind: TnButtonKind.primary,
                      expand: true,
                      busy: s.busy,
                      onPressed: s.canContinue ? () => bloc.add(const JoinNextPressed()) : null,
                    ),
                  ),
                ],
              ]),
            ),
          ),
        );
      }),
    );
  }

  Widget _body(BuildContext context, JoinState s) => switch (s.step) {
        0 => _HouseStep(s: s),
        1 => _BackgroundStep(s: s),
        2 => _StartStep(s: s),
        _ => _SummaryStep(s: s),
      };
}

Widget _title(TnColors c, String t) =>
    Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(t, style: TnText.display(c.ink).copyWith(fontSize: 26, height: 30 / 26)));

String _initial(String name) => name.isEmpty ? '?' : name.characters.first.toUpperCase();

/// 1. lépés: a ház neve és tinktúrája.
class _HouseStep extends StatefulWidget {
  const _HouseStep({required this.s});
  final JoinState s;
  @override
  State<_HouseStep> createState() => _HouseStepState();
}

class _HouseStepState extends State<_HouseStep> {
  late final _name = TextEditingController(text: widget.s.name);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final s = widget.s;
    final bloc = context.read<JoinBloc>();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _title(c, 'Alapítsd meg a házad'),
      Row(children: [
        HouseCrest(tincture: s.tincture, initial: _initial(s.trimmedName), size: 64, name: s.name),
        const SizedBox(width: 16),
        Expanded(
            child: Text(s.trimmedName.isEmpty ? 'Házad neve' : s.trimmedName, style: TnText.title(c.ink).copyWith(fontSize: 24, height: 28 / 24))),
      ]),
      const SizedBox(height: 16),
      TextField(
        controller: _name,
        maxLength: 30,
        textCapitalization: TextCapitalization.words,
        onChanged: (v) => bloc.add(JoinNameChanged(v)),
        onSubmitted: (_) => bloc.add(const JoinNameSubmitted()),
        decoration: InputDecoration(
          labelText: 'A ház neve',
          hintText: 'például Kékholló',
          border: const OutlineInputBorder(),
          errorText: s.shownNameError,
          helperText: 'Így látnak a többiek a térképen és a ranglistán.',
          counterText: '',
        ),
      ),
      const SizedBox(height: 16),
      const FieldLabel('Tinktúra (a házad színe)'),
      const SizedBox(height: 8),
      GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.1,
        children: [
          for (final t in s.detail!.tinctures)
            TinctureTile(tincture: t, selected: t == s.tincture, onTap: () => bloc.add(JoinTinctureSelected(t))),
        ],
      ),
      const SizedBox(height: 8),
      Text('Egy tinktúrát több ház is választhat; a nevek egyediek.', style: TnText.caption(c.inkMuted)),
    ]);
  }
}

/// 2. lépés: a ház háttere.
class _BackgroundStep extends StatelessWidget {
  const _BackgroundStep({required this.s});
  final JoinState s;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final bloc = context.read<JoinBloc>();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _title(c, 'Honnan jön a házad?'),
      Text('A háttér csak induló bónuszt ad, egyik ágba sem zár be. Mindhárom ágban játszhatsz: Vásártér, Városháza, Alvilág.',
          style: TnText.body(c.inkMuted)),
      const SizedBox(height: 12),
      for (final b in s.detail!.backgrounds) ...[
        JoinChoice(icon: b.icon, title: b.name, lines: b.perks, selected: b.id == s.background, onTap: () => bloc.add(JoinBackgroundSelected(b.id))),
        const SizedBox(height: 8),
      ],
    ]);
  }
}

/// 3. lépés: a kezdőhely (és a Kereskedőház induló árucikke).
class _StartStep extends StatelessWidget {
  const _StartStep({required this.s});
  final JoinState s;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final bloc = context.read<JoinBloc>();
    final slot = s.slot;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _title(c, 'Hol áll a birtokod?'),
      Text('A birtokodból két szomszédos városba indulsz ingyenes útvonallal. Akciót csak a hálózatodban lévő városban indíthatsz.',
          style: TnText.body(c.inkMuted)),
      const SizedBox(height: 12),
      MapView(map: s.map!, showStarts: true, selectedStart: s.start, onSelectStart: (id) => bloc.add(JoinStartSelected(id))),
      const SizedBox(height: 12),
      for (final st in s.detail!.starts) ...[
        JoinChoice(
          icon: 'route',
          title: st.name,
          lines: ['Szomszédos: ${st.neighborNames.join(', ')}', if (st.homeCityName.isNotEmpty) 'Kezdőváros: ${st.homeCityName}', if (st.note.isNotEmpty) st.note],
          selected: st.id == s.start,
          onTap: () => bloc.add(JoinStartSelected(st.id)),
        ),
        const SizedBox(height: 8),
      ],
      if (s.needsGood && slot != null) ...[
        const SizedBox(height: 8),
        const FieldLabel('Induló árucikk'),
        const SizedBox(height: 4),
        Text('A Kereskedőház 20 részesedést kap ${slot.homeCityName.isEmpty ? 'a kezdőváros' : slot.homeCityName} egyik árucikkéből. Melyikből?', style: TnText.body(c.inkMuted)),
        const SizedBox(height: 8),
        for (final g in slot.homeGoods) ...[
          JoinChoice(
            icon: 'kereskedok',
            art: g.id,
            title: g.name,
            lines: const ['20 részesedés · azonnal van eladható árud'],
            selected: g.id == s.good?.id,
            onTap: () => bloc.add(JoinStartGoodSelected(g.id)),
          ),
          const SizedBox(height: 8),
        ],
      ],
    ]);
  }
}

/// 4. lépés: összegzés.
class _SummaryStep extends StatelessWidget {
  const _SummaryStep({required this.s});
  final JoinState s;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final g = s.game!;
    final st = s.slot;
    final good = s.good;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _title(c, 'Minden készen áll'),
      TnCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            HouseCrest(tincture: s.tincture, initial: _initial(s.trimmedName), size: 56, name: s.name),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.trimmedName, style: TnText.title(c.ink).copyWith(fontSize: 24, height: 28 / 24)),
                Text('${s.backgroundDto?.name ?? ''} · ${tinctureName(s.tincture)}', style: TnText.body(c.inkMuted)),
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          JoinKv('Játék', '${g.name} · ${g.season}'),
          JoinKv('Kezdés', s.startText),
          if (st != null) ...[
            JoinKv('Kezdőhely', '${st.name} (${st.neighborNames.join(', ')})'),
            if (st.homeCityName.isNotEmpty) JoinKv('Kezdőváros', st.homeCityName),
          ],
          if (good != null) JoinKv('Induló árucikk', '20 részesedés · ${good.name}'),
          const JoinKv('Induló készlet', '10 PP · 30 arany · 20 népszerűség a kezdővárosban · 2 útvonal'),
        ]),
      ),
      const SizedBox(height: 12),
      Text('A kezdésig bármikor visszavonhatod a jelentkezést. A ház neve és tinktúrája a kezdés után már nem változtatható.',
          style: TnText.caption(c.inkMuted)),
    ]);
  }
}
