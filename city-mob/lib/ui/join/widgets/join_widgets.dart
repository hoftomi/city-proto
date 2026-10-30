import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';
import '../../../widgets/game_widgets.dart';
import '../../../widgets/tn_icon.dart';

/// The join steps on the wooden header: done step green, current one a bronze bar.
class JoinStepper extends StatelessWidget {
  const JoinStepper({super.key, required this.step, required this.steps});
  final int step;
  final List<String> steps;
  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var i = 0; i < steps.length; i++) ...[
        if (i > 0) const SizedBox(width: 6),
        Expanded(
          child: Semantics(
            label: (i == step ? 'join.step_semantics_current' : 'join.step_semantics').tr(namedArgs: {'n': '${i + 1}', 'name': steps[i]}),
            child: ExcludeSemantics(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == step ? c.frameHi : (i < step ? c.btnGreenHi : const Color(0x40000000)),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: const Color(0x66000000)),
                  ),
                ),
                const SizedBox(height: 6),
                Text('${i + 1}', style: TnText.data(i == step ? c.frameHi : c.onWood, size: 11)),
                Text(steps[i],
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TnText.data(i == step ? c.frameHi : c.onWood, size: 11.5).copyWith(height: 14 / 11.5)),
              ]),
            ),
          ),
        ),
      ],
    ]);
  }
}

/// Selectable card (choice): wooden frame, bronze ring when selected; the left icon field is wood, green when selected.
class JoinChoice extends StatelessWidget {
  const JoinChoice({super.key, required this.icon, required this.title, required this.lines, required this.selected, required this.onTap, this.art});
  final String icon, title;
  final String? art;
  final List<String> lines;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Framed(
          width: double.infinity,
          border: c.wood,
          borderWidth: 1.5,
          rings: selected ? [(c.frame, 2)] : const [],
          radius: 8,
          gradient: selected
              ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFBF1D3), Color(0xFFF0DCA3)])
              : c.paperGradient,
          shadows: c.shadowCard,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(TnRadius.sm),
                border: Border.all(color: c.outline),
                gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: selected ? [c.btnGreenHi, c.btnGreen] : [c.woodHi, c.wood]),
              ),
              child: art != null ? GameIcon(art!, size: 28, shadow: true) : TnIcon(icon, size: 22, color: selected ? c.onBtn : c.frameHi),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TnText.title(c.ink).copyWith(fontSize: 16, height: 22 / 16)),
                const SizedBox(height: 2),
                for (final l in lines) UnitText(l, style: TnText.body(c.ink).copyWith(fontSize: 14, height: 20 / 14)),
              ]),
            ),
            SizedBox(width: 22, child: selected ? TnIcon('check', size: 18, color: c.btnGreenLo) : null),
          ]),
        ),
      ),
    );
  }
}

/// Label–value row in the summary.
class JoinKv extends StatelessWidget {
  const JoinKv(this.k, this.v, {super.key});
  final String k, v;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 112, child: Text(k.toUpperCase(), style: TnText.eyebrow(c.inkMuted).copyWith(height: 20 / 11.5))),
        const SizedBox(width: 12),
        Expanded(child: UnitText(v, style: TnText.body(c.ink))),
      ]),
    );
  }
}
