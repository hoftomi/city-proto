import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../api/models.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'tn_icon.dart';

// ---------------------------------------------------------------------------
// Címer
// ---------------------------------------------------------------------------

final Path _shield = parseSvgPathData('M2 2h20v9.5c0 6.5-5 10.5-10 13C7 22 2 18 2 11.5z');

class HouseCrest extends StatelessWidget {
  const HouseCrest({super.key, required this.tincture, this.initial, this.size = 28, this.npc = false, this.name});
  final String tincture;
  final String? initial, name;
  final double size;
  final bool npc;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Semantics(
      label: '${name ?? 'Ház'}${npc ? ' (NPC)' : ''}',
      child: SizedBox(
        width: size,
        height: size * 1.1,
        child: CustomPaint(
          painter: _CrestPainter(c.house(tincture), npc ? c.inkMuted : c.ink, npc),
          child: initial == null
              ? null
              : Align(
                  alignment: const Alignment(0, -0.1),
                  child: Text(initial!, style: TnText.mapLabel(c.paperRaised, major: true).copyWith(fontSize: size * 0.42, letterSpacing: 0)),
                ),
        ),
      ),
    );
  }
}

class _CrestPainter extends CustomPainter {
  _CrestPainter(this.fill, this.stroke, this.dashed);
  final Color fill, stroke;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    canvas.drawPath(_shield, Paint()..color = fill);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = stroke;
    canvas.drawPath(dashed ? dashPath(_shield, dashArray: CircularIntervalList<double>([2.5, 2])) : _shield, p);
  }

  @override
  bool shouldRepaint(_CrestPainter o) => o.fill != fill || o.stroke != stroke || o.dashed != dashed;
}

// ---------------------------------------------------------------------------
// Chipek
// ---------------------------------------------------------------------------

class TnChip extends StatelessWidget {
  const TnChip({super.key, required this.label, this.icon, this.fg, this.bg, this.border});
  final String label;
  final String? icon;
  final Color? fg, bg, border;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final color = fg ?? c.ink;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg ?? c.paperRaised,
        borderRadius: BorderRadius.circular(TnRadius.xs),
        border: Border.all(color: border ?? (bg == null ? c.line : Colors.transparent)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[TnIcon(icon!, size: 14, color: color), const SizedBox(width: 4)],
        Text(label, style: TnText.bodyStrong(color).copyWith(fontSize: 13, height: 20 / 13)),
      ]),
    );
  }
}

class StabilityChip extends StatelessWidget {
  const StabilityChip(this.level, {super.key});
  final String level;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return switch (level) {
      'lazongo' => TnChip(label: 'Lázongó', icon: 'warning', fg: c.danger, bg: c.dangerSoft),
      'ingatag' => TnChip(label: 'Ingatag', icon: 'warning', fg: c.warn, bg: c.warnSoft),
      _ => TnChip(label: 'Stabil', icon: 'check', fg: c.ok, bg: c.okSoft),
    };
  }
}

class FactionTag extends StatelessWidget {
  const FactionTag(this.faction, {super.key});
  final String faction;
  @override
  Widget build(BuildContext context) => TnChip(label: factionName(faction), icon: faction);
}

const _levels = ['jelenlet', 'partner', 'dominans', 'varoskontroll', 'protektoratus'];

class ControlBadge extends StatelessWidget {
  const ControlBadge(this.level, {super.key});
  final String? level;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final idx = level == null ? -1 : _levels.indexOf(level!);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      for (var i = 0; i < 5; i++)
        Container(
          width: 6,
          height: 14,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(color: i <= idx ? c.verdigris : c.line, borderRadius: BorderRadius.circular(1)),
        ),
      const SizedBox(width: 6),
      Text(idx < 0 ? 'Nincs jelenlét' : levelName(level), style: TnText.bodyStrong(idx < 0 ? c.inkMuted : c.ink).copyWith(fontSize: 13)),
    ]);
  }
}

class SuspicionMeter extends StatelessWidget {
  const SuspicionMeter(this.value, {super.key});
  final int value;
  static const _names = ['Nincs gyanú', 'Gyanakvó', 'Bizalmatlan', 'Kiűzetés'];
  static const _effects = ['', 'nyereség ×0,75', 'nyereség ×0,5 · romlás +2%', 'a befolyás fele elveszett'];

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final v = value.clamp(0, 3);
    final col = v == 0 ? c.inkMuted : (v == 3 ? c.danger : c.warn);
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 6, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [for (var i = 0; i < 3; i++) TnIcon('kem', size: 16, color: i < v ? col : c.lineStrong)]),
      Text(_names[v], style: TnText.bodyStrong(col).copyWith(fontSize: 13)),
      if (v > 0) Text(_effects[v], style: TnText.caption(c.inkMuted).copyWith(fontSize: 13)),
    ]);
  }
}

class ResourceChip extends StatelessWidget {
  const ResourceChip({super.key, required this.kind, required this.value, this.delta});
  final String kind;
  final int value;
  final int? delta;
  static const _names = {'arany': 'Arany', 'bp': 'Befolyáspont', 'ke': 'Katonai erő', 'legit': 'Legitimitás', 'pp': 'Parancspont'};

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Tooltip(
      message: _names[kind] ?? kind,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: c.paperRaised, border: Border.all(color: c.line), borderRadius: BorderRadius.circular(TnRadius.xs)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          TnIcon(kind, size: 14, color: c.inkMuted, semanticLabel: _names[kind]),
          const SizedBox(width: 4),
          Text('$value', style: TnText.data(c.ink)),
          if (delta != null) ...[
            const SizedBox(width: 4),
            Text(signed(delta!), style: TnText.data(delta! < 0 ? c.danger : c.inkMuted, size: 12)),
          ],
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Parancspont-számláló
// ---------------------------------------------------------------------------

class CommandPoints extends StatelessWidget {
  const CommandPoints({super.key, required this.available, required this.pending, this.max = 20, this.daily = 10});
  final int available, pending, max, daily;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final pend = pending.clamp(0, available);
    return Semantics(
      label: 'Parancspont: ${available - pend} szabad, $pend lefoglalva, legfeljebb $max',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('PARANCSPONT', style: TnText.label(c.inkMuted)),
          const Spacer(),
          Text('${available - pend} / $max', style: TnText.data(c.ink, size: 22, weight: FontWeight.w600)),
        ]),
        const SizedBox(height: 8),
        LayoutBuilder(builder: (ctx, box) {
          final d = ((box.maxWidth.clamp(0, 360) - 3 * (max - 1)) / max).clamp(6.0, 16.0);
          return Wrap(spacing: 3, children: [
            for (var i = 0; i < max; i++)
              Container(
                width: d,
                height: d,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < available - pend ? c.ink : c.paperRaised,
                  border: Border.all(color: i < available - pend ? c.ink : (i < available ? c.seal : c.lineStrong), width: 1.5),
                ),
              ),
          ]);
        }),
        const SizedBox(height: 6),
        Text('${pend > 0 ? '$pend PP lefoglalva a parancslapon · ' : ''}+$daily a következő körben', style: TnText.caption(c.inkMuted)),
      ]),
    );
  }
}

// ---------------------------------------------------------------------------
// Befolyássáv
// ---------------------------------------------------------------------------

class InfluenceBar extends StatelessWidget {
  const InfluenceBar({super.key, required this.view, this.legend = true, this.aside});
  final FactionView view;
  final bool legend;
  final Widget? aside;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final segs = view.segments;
    final used = segs.fold<double>(0, (a, s) => a + s.value) + view.unknown;
    final neutral = (100 - used).clamp(0, 100).toDouble();
    final parts = <(double, Widget)>[
      for (final s in segs)
        (
          s.value,
          Container(
            decoration: BoxDecoration(color: c.house(s.tincture), border: s.self ? Border.all(color: c.verdigris, width: 2) : null),
          )
        ),
      if (view.unknown > 0.05) (view.unknown, CustomPaint(painter: _DotsPainter(c.shareUnknown, c.paperRaised))),
      if (neutral > 0.05) (neutral, CustomPaint(painter: _HatchPainter(c.shareNeutral, c.lineStrong))),
    ];
    final a11y = [
      for (final s in segs) '${s.name} ${s.label}',
      if (view.unknownLabel != null) 'Ismeretlen ${view.unknownLabel}',
      'Semleges ${num1(view.neutral)}',
    ].join(', ');

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        TnIcon(view.faction, size: 18, color: c.ink),
        const SizedBox(width: 6),
        Text(factionName(view.faction), style: TnText.heading(c.ink)),
        const Spacer(),
        if (aside != null) aside!,
      ]),
      const SizedBox(height: 8),
      Semantics(
        label: '${factionName(view.faction)}: $a11y',
        child: SizedBox(
          height: 26,
          child: LayoutBuilder(builder: (ctx, box) {
            final w = box.maxWidth;
            return Stack(clipBehavior: Clip.none, children: [
              Positioned.fill(
                top: 3,
                bottom: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TnRadius.xs),
                  child: Row(children: [
                    for (var i = 0; i < parts.length; i++) ...[
                      if (i > 0) const SizedBox(width: 2),
                      Expanded(flex: (parts[i].$1 * 10).round().clamp(1, 1000), child: parts[i].$2),
                    ],
                  ]),
                ),
              ),
              for (final t in const [10, 25, 35]) Positioned(left: w * t / 100, top: 0, bottom: 0, child: Container(width: 1, color: c.ink)),
            ]);
          }),
        ),
      ),
      SizedBox(
        height: 14,
        child: LayoutBuilder(
          builder: (ctx, box) => Stack(clipBehavior: Clip.none, children: [
            for (final t in const [10, 25, 35])
              Positioned(left: box.maxWidth * t / 100 - 8, child: SizedBox(width: 16, child: Text('$t', textAlign: TextAlign.center, style: TnText.data(c.inkMuted, size: 10)))),
          ]),
        ),
      ),
      if (legend) ...[
        const SizedBox(height: 4),
        Wrap(spacing: 12, runSpacing: 4, children: [
          for (final s in segs) _key(c, c.house(s.tincture), s.name, s.label, bold: s.self),
          if (view.unknownLabel != null) _key(c, c.shareUnknown, 'Ismeretlen', view.unknownLabel!),
          _key(c, c.shareNeutral, 'Semleges', num1(view.neutral)),
        ]),
      ],
    ]);
  }

  Widget _key(TnColors c, Color sw, String name, String value, {bool bold = false}) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 10, height: 10, color: sw),
        const SizedBox(width: 6),
        Text(name, style: bold ? TnText.bodyStrong(c.ink).copyWith(fontSize: 13) : TnText.body(c.ink).copyWith(fontSize: 13)),
        const SizedBox(width: 4),
        Text(value, style: TnText.data(c.inkMuted, size: 12)),
      ]);
}

class _HatchPainter extends CustomPainter {
  _HatchPainter(this.bg, this.line);
  final Color bg, line;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = bg);
    final p = Paint()
      ..color = line
      ..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 5) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), p);
    }
  }

  @override
  bool shouldRepaint(_HatchPainter o) => o.bg != bg || o.line != line;
}

class _DotsPainter extends CustomPainter {
  _DotsPainter(this.bg, this.dot);
  final Color bg, dot;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = bg);
    final p = Paint()..color = dot;
    for (double y = 2.5; y < size.height; y += 5) {
      for (double x = 2.5; x < size.width; x += 5) {
        canvas.drawCircle(Offset(x, y), 1, p);
      }
    }
  }

  @override
  bool shouldRepaint(_DotsPainter o) => o.bg != bg || o.dot != dot;
}

// ---------------------------------------------------------------------------
// Jelentéskártya, kártya, értesítés
// ---------------------------------------------------------------------------

class TnCard extends StatelessWidget {
  const TnCard({super.key, required this.child, this.borderColor, this.dashed = false, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final Color? borderColor;
  final bool dashed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: c.paperRaised,
        borderRadius: BorderRadius.circular(TnRadius.sm),
        border: Border.all(color: borderColor ?? c.line),
      ),
      child: child,
    );
  }
}

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report});
  final ReportView report;
  static const _kinds = {
    'kem': ('kem', 'KÉMJELENTÉS'),
    'katonai': ('katonai', 'KATONAI'),
    'frakcio': ('frakcio', 'FRAKCIÓ'),
    'diplomacia': ('diplomacia', 'DIPLOMÁCIA'),
    'esemeny': ('esemeny', 'ESEMÉNY'),
  };
  static const _conf = {'gyenge': (1, 'Gyenge forrás'), 'kozepes': (2, 'Közepes forrás'), 'eros': (3, 'Megbízható forrás')};

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final k = _kinds[report.kind] ?? _kinds['esemeny']!;
    final conf = _conf[report.confidence];
    final toneColor = switch (report.tone) { 'danger' => c.danger, 'warn' => c.warn, 'ok' => c.ok, _ => null };
    return TnCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          TnIcon(k.$1, size: 15, color: toneColor ?? c.inkMuted),
          const SizedBox(width: 4),
          Text(k.$2, style: TnText.label(toneColor ?? c.inkMuted)),
          Text(' · ${report.round}. kör', style: TnText.caption(c.inkMuted)),
          const Spacer(),
          if (conf != null) ...[
            for (var i = 0; i < 3; i++)
              Container(width: 4, height: 5.0 + i * 4, margin: const EdgeInsets.only(right: 2), color: i < conf.$1 ? c.ink : c.line),
            const SizedBox(width: 4),
            Text(conf.$2, style: TnText.caption(c.inkMuted)),
          ],
        ]),
        const SizedBox(height: 8),
        Text(report.title, style: TnText.heading(c.ink)),
        const SizedBox(height: 4),
        Text(report.text, style: TnText.chronicle(c.ink)),
      ]),
    );
  }
}

class Notice extends StatelessWidget {
  const Notice({super.key, required this.tone, required this.title, this.body});
  final String tone, title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final (fg, bg, icon) = switch (tone) {
      'danger' => (c.danger, c.dangerSoft, 'warning'),
      'warn' => (c.warn, c.warnSoft, 'warning'),
      'ok' => (c.ok, c.okSoft, 'check'),
      _ => (c.verdigris, c.paperRaised, 'info'),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(TnRadius.sm), border: tone == 'info' ? Border.all(color: c.line) : null),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.only(top: 2), child: TnIcon(icon, color: fg)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TnText.bodyStrong(fg)),
            if (body != null) Text(body!, style: TnText.body(c.ink).copyWith(fontSize: 14, height: 20 / 14)),
          ]),
        ),
      ]),
    );
  }
}

/// Egységes hibaüzenet és betöltés-kezelés.
void showError(BuildContext context, Object e) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: TnText.label(context.tn.inkMuted));
}
