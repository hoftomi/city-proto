import 'package:easy_localization/easy_localization.dart';
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
          listener: (context, s) => showToast(context, s.notice!.title.text, body: s.notice!.body?.text, tone: s.notice!.tone),
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
                    label: s.backLabel.text,
                    kind: TnButtonKind.quiet,
                    small: true,
                    onPressed: () => s.canPop ? _leave(context) : bloc.add(const JoinBackPressed()),
                  ),
                  title: Text(s.game?.name ?? '', textAlign: TextAlign.right, style: TnText.caption(const Color(0xFFD9C49A))),
                  bottom: Padding(padding: const EdgeInsets.only(top: 8), child: JoinStepper(step: s.step, steps: [for (final t in s.steps) t.text])),
                ),
                if (s.failure != null && !s.ready)
                  Expanded(
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(16), child: Notice(tone: 'danger', title: 'lobby.load_failed'.tr(), body: s.failure!.message.text)),
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
                      label: s.nextLabel.text,
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
      _title(c, 'join.house.title'.tr()),
      Row(children: [
        HouseCrest(tincture: s.tincture, initial: _initial(s.trimmedName), size: 64, name: s.name),
        const SizedBox(width: 16),
        Expanded(
            child: Text(s.trimmedName.isEmpty ? 'join.house.name_placeholder'.tr() : s.trimmedName, style: TnText.title(c.ink).copyWith(fontSize: 24, height: 28 / 24))),
      ]),
      const SizedBox(height: 16),
      TextField(
        controller: _name,
        maxLength: 30,
        textCapitalization: TextCapitalization.words,
        onChanged: (v) => bloc.add(JoinNameChanged(v)),
        onSubmitted: (_) => bloc.add(const JoinNameSubmitted()),
        decoration: InputDecoration(
          labelText: 'join.house.name_label'.tr(),
          hintText: 'join.house.name_hint'.tr(),
          border: const OutlineInputBorder(),
          errorText: s.shownNameError?.text,
          helperText: 'join.house.name_helper'.tr(),
          counterText: '',
        ),
      ),
      const SizedBox(height: 16),
      FieldLabel('join.house.tincture_label'.tr()),
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
      Text('join.house.tincture_note'.tr(), style: TnText.caption(c.inkMuted)),
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
      _title(c, 'join.background.title'.tr()),
      Text('join.background.intro'.tr(), style: TnText.body(c.inkMuted)),
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
      _title(c, 'join.start.title'.tr()),
      Text('join.start.intro'.tr(), style: TnText.body(c.inkMuted)),
      const SizedBox(height: 12),
      MapView(map: s.map!, showStarts: true, selectedStart: s.start, onSelectStart: (id) => bloc.add(JoinStartSelected(id))),
      const SizedBox(height: 12),
      for (final st in s.detail!.starts) ...[
        JoinChoice(
          icon: 'route',
          title: st.name,
          lines: [
            'join.start.neighbors'.tr(namedArgs: {'names': st.neighborNames.join(', ')}),
            if (st.homeCityName.isNotEmpty) 'join.start.home_city'.tr(namedArgs: {'name': st.homeCityName}),
            if (st.note.isNotEmpty) st.note,
          ],
          selected: st.id == s.start,
          onTap: () => bloc.add(JoinStartSelected(st.id)),
        ),
        const SizedBox(height: 8),
      ],
      if (s.needsGood && slot != null) ...[
        const SizedBox(height: 8),
        FieldLabel('join.start.good_label'.tr()),
        const SizedBox(height: 4),
        Text(slot.homeCityName.isEmpty ? 'join.start.good_intro_default'.tr() : 'join.start.good_intro'.tr(namedArgs: {'city': slot.homeCityName}), style: TnText.body(c.inkMuted)),
        const SizedBox(height: 8),
        for (final g in slot.homeGoods) ...[
          JoinChoice(
            icon: 'kereskedok',
            art: g.id,
            title: g.name,
            lines: ['join.start.good_line'.tr()],
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
      _title(c, 'join.summary.title'.tr()),
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
          JoinKv('join.summary.game'.tr(), '${g.name} · ${g.season}'),
          JoinKv('join.summary.start'.tr(), s.startText.text),
          if (st != null) ...[
            JoinKv('join.summary.slot'.tr(), 'join.summary.slot_value'.tr(namedArgs: {'name': st.name, 'neighbors': st.neighborNames.join(', ')})),
            if (st.homeCityName.isNotEmpty) JoinKv('join.summary.home_city'.tr(), st.homeCityName),
          ],
          if (good != null) JoinKv('join.summary.good'.tr(), 'join.summary.good_value'.tr(namedArgs: {'good': good.name})),
          JoinKv('join.summary.kit'.tr(), 'join.summary.kit_value'.tr()),
        ]),
      ),
      const SizedBox(height: 12),
      Text('join.summary.note'.tr(), style: TnText.caption(c.inkMuted)),
    ]);
  }
}
