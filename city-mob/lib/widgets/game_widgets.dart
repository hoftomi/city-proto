import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'package:tron_api/tron_api.dart';

import '../theme/tokens.dart';
import '../util/format.dart';
import 'buttons.dart';
import 'game_icon.dart';
import 'tn_icon.dart';

export 'game_icon.dart';
export 'surfaces.dart';

// ---------------------------------------------------------------------------
// Keretek
// ---------------------------------------------------------------------------

EdgeInsets _shrink(EdgeInsets p, double d) =>
    EdgeInsets.fromLTRB(math.max(0, p.left - d), math.max(0, p.top - d), math.max(0, p.right - d), math.max(0, p.bottom - d));

/// Keretes felület: külső szegély, majd belső „inset” gyűrűk (a CSS `inset box-shadow` közelítése
/// egymásba ágyazott szegélyekkel), pergamen átmenet és vetett árnyék.
class Framed extends StatelessWidget {
  const Framed({
    super.key,
    required this.child,
    required this.border,
    this.borderWidth = 2,
    this.rings = const [],
    this.radius = TnRadius.md,
    this.gradient,
    this.color,
    this.shadows,
    this.padding = EdgeInsets.zero,
    this.width,
  });
  final Widget child;
  final Color border;
  final double borderWidth, radius;
  final List<(Color, double)> rings;
  final Gradient? gradient;
  final Color? color;
  final List<BoxShadow>? shadows;
  final EdgeInsets padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final inset = rings.fold<double>(0, (a, r) => a + r.$2);
    Widget body = Padding(padding: _shrink(padding, inset), child: child);
    var r = radius - borderWidth;
    final nested = <(Color, double, double)>[];
    for (final ring in rings) {
      nested.add((ring.$1, ring.$2, math.max(0, r)));
      r -= ring.$2;
    }
    for (final ring in nested.reversed) {
      body = Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(ring.$3), border: Border.all(color: ring.$1, width: ring.$2)),
        child: body,
      );
    }
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: borderWidth),
        boxShadow: shadows,
      ),
      child: body,
    );
  }
}

enum TnCardTone { normal, threat, pending, highlight, note }

/// Pergamen kártya (tn-card): sötét fa keret, belső bronz vonal, 3 px-es tintaperem és lágy árnyék.
///
/// * [tone]: `threat` (kivásárlási fenyegetés, téglavörös gyűrű), `pending` (érlelő lap, bronz),
///   `highlight` (folytatható játék, zöld), `note` (szaggatott hatású, halvány).
/// * [borderColor]: a belső gyűrű színe egyedi kiemeléshez.
class TnCard extends StatelessWidget {
  const TnCard({super.key, required this.child, this.borderColor, this.dashed = false, this.padding = const EdgeInsets.all(16), this.tone = TnCardTone.normal});
  final Widget child;
  final Color? borderColor;
  final bool dashed;
  final EdgeInsets padding;
  final TnCardTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final ring = borderColor ??
        switch (dashed ? TnCardTone.note : tone) {
          TnCardTone.threat => c.btnRed,
          TnCardTone.pending => c.btnGold,
          TnCardTone.highlight => c.btnGreen,
          TnCardTone.note => c.lineStrong,
          TnCardTone.normal => c.frame,
        };
    final gradient = tone == TnCardTone.threat
        ? LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xFFF8E6DE), c.dangerSoft])
        : c.paperGradient;
    return Framed(
      width: double.infinity,
      border: c.wood,
      borderWidth: 2,
      rings: [(ring, 1.5), if (tone != TnCardTone.threat) (const Color(0x80FFF5DC), 1.5)],
      radius: TnRadius.md,
      gradient: gradient,
      shadows: c.shadowCard,
      padding: padding,
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Címer
// ---------------------------------------------------------------------------

final Path _crestOuter = parseSvgPathData('M2 2.5h22v10.2c0 7-5.3 11.4-11 14.3C7.3 24.1 2 19.7 2 12.7z');
final Path _crestShield = parseSvgPathData('M5 5h16v7.4c0 5.2-3.8 8.6-8 10.9-4.2-2.3-8-5.7-8-10.9z');
final Path _crestShade = parseSvgPathData('M13 4L22 4V14C22 19 18 22 13 25z');
final Path _crestLight = parseSvgPathData('M5 5h6c-.5 4-2.5 7-6 9z');

/// A ház címere: bronz szélű pajzs a ház tinktúrájával, jobb alsó árnyékkal és bal felső fénnyel.
/// A kezdőbetű Cinzel, tintakontúrral. NPC-háznál a pajzs kontúrja szaggatott.
class HouseCrest extends StatelessWidget {
  const HouseCrest({super.key, required this.tincture, this.initial, this.size = 28, this.npc = false, this.name});
  final String tincture;
  final String? initial, name;
  final double size;
  final bool npc;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final k = size / 26;
    final st = TnText.title(const Color(0xFFFFF8E6)).copyWith(fontSize: 10 * k, height: 1, letterSpacing: 0, fontWeight: FontWeight.w800);
    return Semantics(
      label: npc ? 'ui.npc'.tr(namedArgs: {'name': name ?? 'ui.house'.tr()}) : name ?? 'ui.house'.tr(),
      child: ExcludeSemantics(
        child: SizedBox(
          width: size,
          height: size * 1.12,
          child: CustomPaint(
            painter: _CrestPainter(c, c.house(tincture), npc),
            child: initial == null
                ? null
                : Align(
                    alignment: const Alignment(0, -0.08),
                    child: Stack(children: [
                      Text(initial!,
                          style: st.copyWith(
                              color: null,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1.6 * k
                                ..strokeJoin = StrokeJoin.round
                                ..color = c.outline)),
                      Text(initial!, style: st),
                    ]),
                  ),
          ),
        ),
      ),
    );
  }
}

class _CrestPainter extends CustomPainter {
  _CrestPainter(this.c, this.fill, this.dashed);
  final TnColors c;
  final Color fill;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 26);
    // drop-shadow(0 1px 1px #00000059)
    canvas.drawPath(
      _crestOuter.shift(const Offset(0, 1)),
      Paint()
        ..color = const Color(0x59000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8),
    );
    canvas.drawPath(_crestOuter, Paint()..color = c.frame);
    canvas.drawPath(
      _crestOuter,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeJoin = StrokeJoin.round
        ..color = c.outline,
    );
    canvas.drawLine(const Offset(3.6, 4), const Offset(22.4, 4), Paint()
      ..strokeWidth = 1
      ..color = c.frameHi);
    canvas.drawPath(_crestShield, Paint()..color = fill);
    canvas.save();
    canvas.clipPath(_crestShield);
    canvas.drawPath(_crestShade, Paint()..color = const Color(0x2E000000));
    canvas.drawPath(_crestLight, Paint()..color = const Color(0x38FFFFFF));
    canvas.restore();
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = c.outline;
    canvas.drawPath(dashed ? dashPath(_crestShield, dashArray: CircularIntervalList<double>([2, 1.6])) : _crestShield, p);
  }

  @override
  bool shouldRepaint(_CrestPainter o) => o.fill != fill || o.dashed != dashed;
}

// ---------------------------------------------------------------------------
// Chipek
// ---------------------------------------------------------------------------

/// Chip (tn-chip): 13/20, 800, halvány pergamen alap, vékony kontúr.
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 1),
      decoration: BoxDecoration(color: bg ?? c.field, borderRadius: BorderRadius.circular(5), border: Border.all(color: border ?? c.lineStrong)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[GameIcon(icon!, size: 14, fallbackColor: color), const SizedBox(width: 4)],
        Text(label, style: TnText.data(color, size: 13).copyWith(height: 20 / 13)),
      ]),
    );
  }
}

/// Kis címkés érték-chip (pop-chip), például „Népszerűséged 23”, opcionális játékikonnal.
class StatChip extends StatelessWidget {
  const StatChip({super.key, required this.label, required this.value, this.suffix, this.tone, this.art});
  final String label, value;
  final String? suffix, tone, art;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final (fg, bg, bd) = switch (tone) {
      'warn' => (c.warn, c.warnSoft, c.warn),
      'ok' => (c.ok, c.okSoft, c.ok),
      _ => (c.ink, c.field, c.lineStrong),
    };
    final st = TnText.data(fg, size: 13).copyWith(height: 20 / 13);
    return Container(
      padding: EdgeInsets.fromLTRB(art == null ? 9 : 5, 1, 9, 1),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: bd),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Color(0x1F000000), offset: Offset(0, 1))],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (art != null) ...[GameIcon(art!, size: 16), const SizedBox(width: 5)],
        Text.rich(TextSpan(style: st, children: [
          TextSpan(text: '$label '),
          TextSpan(text: value, style: st.copyWith(fontWeight: FontWeight.w900)),
          if (suffix != null) TextSpan(text: ' $suffix'),
        ])),
      ]),
    );
  }
}

/// Kis kiemelő címke (cheap-tag), például „legolcsóbb”, „védett”.
class TinyTag extends StatelessWidget {
  const TinyTag(this.text, {super.key, this.tone});
  final String text;
  final String? tone;
  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final (fg, bg, bd) = switch (tone) {
      'danger' => (c.danger, c.dangerSoft, c.danger),
      'warn' => (c.warn, c.warnSoft, c.warn),
      'muted' => (c.inkMuted, c.hollow, c.lineStrong),
      _ => (c.btnGreenLo, const Color(0xFFE9F0DA), c.btnGreen),
    };
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(TnRadius.xs), border: Border.all(color: bd)),
      child: Text(text.toUpperCase(), style: TnText.data(fg, size: 10, weight: FontWeight.w900).copyWith(letterSpacing: 0.5, height: 14 / 10)),
    );
  }
}

/// Erőforrás sötét fa kapszulában, bronz szegéllyel és világos, vastag számmal (tn-res).
/// Az `arany`, `pp`, `legit`, `nep`, `ado` fajta játékikont kap, amely balra kilóg a kapszulából.
class ResourceChip extends StatelessWidget {
  const ResourceChip({super.key, required this.kind, required this.value, this.delta, this.max});
  final String kind;
  final int value;
  final int? delta, max;
  static const _names = {'arany', 'legit', 'pp', 'nep', 'ado'};

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final name = _names.contains(kind) ? 'ui.resource.$kind'.tr() : kind;
    return Tooltip(
      message: name,
      child: Semantics(
        label: '$name: ${max == null ? value : '$value / $max'}${delta != null ? ', ${signed(delta!)}' : ''}',
        child: ExcludeSemantics(
          child: Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Stack(clipBehavior: Clip.none, alignment: Alignment.centerLeft, children: [
              Container(
                constraints: const BoxConstraints(minWidth: 58, minHeight: 26),
                padding: const EdgeInsets.fromLTRB(27, 1, 10, 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: c.frameLo, width: 1.5),
                  gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF2B1C11), Color(0xFF3F2918)]),
                  boxShadow: const [BoxShadow(color: Color(0x80000000), offset: Offset(0, 1))],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(max == null ? '$value' : '$value/$max', style: TnText.data(const Color(0xFFFFF5DC), size: 15, weight: FontWeight.w900).copyWith(height: 20 / 15)),
                  if (delta != null) ...[
                    const SizedBox(width: 4),
                    Text(signed(delta!), style: TnText.data(delta! < 0 ? const Color(0xFFF2A996) : const Color(0xFFBDE08F), size: 12.5)),
                  ],
                ]),
              ),
              Positioned(left: -10, child: GameIcon(kind, size: 30, shadow: true, fallbackColor: c.frameHi)),
            ]),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Parancspont-számláló
// ---------------------------------------------------------------------------

/// A Parancspont-számláló pergamenlapon, fa- és bronzkeretben: viaszpecsét-korongok egy sorban.
/// Vörös viasz: elkölthető; szaggatott szélű bronz: lefoglalt; üres mélyedés: hiányzó pont.
class CommandPoints extends StatelessWidget {
  const CommandPoints({super.key, required this.available, required this.pending, this.max = 20, this.daily = 10});
  final int available, pending, max, daily;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final pend = pending.clamp(0, available);
    return Semantics(
      label: 'ui.command_points.semantics'.tr(namedArgs: {'free': '${available - pend}', 'pending': '$pend', 'max': '$max'}),
      child: ExcludeSemantics(
        child: Framed(
          width: double.infinity,
          border: c.wood,
          rings: [(c.frame, 1.5), (const Color(0x80FFF5DC), 1.5)],
          gradient: c.paperGradient,
          shadows: c.shadowCard,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
              Text('ui.command_points.title'.tr(), style: TnText.tab(c.ink).copyWith(letterSpacing: 0.7)),
              const Spacer(),
              Text('${available - pend} / $max', style: TnText.title(c.ink).copyWith(fontSize: 22, height: 26 / 22)),
            ]),
            const SizedBox(height: 8),
            LayoutBuilder(builder: (ctx, box) {
              final w = math.min(box.maxWidth, 380.0);
              final d = (w - 3 * (max - 1)) / max;
              return SizedBox(width: w, height: d, child: CustomPaint(painter: _PipsPainter(c, max, available - pend, available, d)));
            }),
            const SizedBox(height: 8),
            Text(pend > 0 ? 'ui.command_points.pending_daily'.tr(namedArgs: {'pending': '$pend', 'daily': '$daily'}) : 'ui.command_points.daily'.tr(namedArgs: {'daily': '$daily'}), style: TnText.caption(c.inkMuted)),
          ]),
        ),
      ),
    );
  }
}

class _PipsPainter extends CustomPainter {
  _PipsPainter(this.c, this.max, this.on, this.avail, this.d);
  final TnColors c;
  final int max, on, avail;
  final double d;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < max; i++) {
      final ctr = Offset(i * (d + 3) + d / 2, d / 2);
      final r = d / 2;
      final rect = Rect.fromCircle(center: ctr, radius: r);
      if (i < on) {
        canvas.drawCircle(ctr + const Offset(0, 1), r, Paint()..color = const Color(0x4D000000));
        canvas.drawCircle(
            ctr,
            r,
            Paint()
              ..shader = const RadialGradient(center: Alignment(-0.3, -0.4), radius: 0.9, colors: [Color(0xFFF3B19F), Color(0xFFF3B19F), Color(0xFFB3412F), Color(0xFF7D2518)], stops: [0, 0.12, 0.3, 1])
                  .createShader(rect));
        canvas.drawCircle(ctr, r - 0.5, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = c.outline);
      } else if (i < avail) {
        canvas.drawCircle(
            ctr,
            r,
            Paint()
              ..shader = const RadialGradient(center: Alignment(-0.3, -0.4), radius: 0.9, colors: [Colors.white, Colors.white, Color(0xFFF0CF7C), Color(0xFFB88A3E)], stops: [0, 0.1, 0.3, 1])
                  .createShader(rect));
        final ring = Path()..addOval(Rect.fromCircle(center: ctr, radius: r - 0.5));
        canvas.drawPath(
            dashPath(ring, dashArray: CircularIntervalList<double>([2, 1.5])),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1
              ..color = c.frameLo);
      } else {
        canvas.drawCircle(ctr, r, Paint()..color = c.hollow);
        // belső árnyék: felül sötétebb sarló
        canvas.save();
        canvas.clipPath(Path()..addOval(rect));
        canvas.drawCircle(ctr + const Offset(0, 1.5), r, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color(0x26000000)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.6));
        canvas.restore();
        canvas.drawCircle(ctr, r - 0.5, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = c.lineStrong);
      }
    }
  }

  @override
  bool shouldRepaint(_PipsPainter o) => o.on != on || o.avail != avail || o.max != max || o.d != d;
}

// ---------------------------------------------------------------------------
// Részesedés-sáv és tanács
// ---------------------------------------------------------------------------

/// Egy árucikk 100 részesedési pontja a tulajdonosok tinktúrájával; a Város része sraffozott
/// (a befolyássáv formája: sötét fa vályú, festett szegmensek felső fénnyel).
class ShareBar extends StatelessWidget {
  const ShareBar({super.key, required this.good, this.legend = false});
  final GoodView good;
  final bool legend;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final owners = good.sellers.where((s) => s.house != null && s.shares > 0).toList()..sort((a, b) => b.shares.compareTo(a.shares));
    final used = owners.fold<int>(0, (a, s) => a + s.shares);
    final cityPart = (100 - used).clamp(0, 100);
    Widget seg(Color col, {bool self = false}) => Container(
          decoration: BoxDecoration(color: col, border: self ? Border.all(color: const Color(0xFFFFF8E6), width: 1.5) : null),
          child: Column(children: [
            Container(height: 2, color: Color(self ? 0x55FFFFFF : 0x40FFFFFF)),
            const Spacer(),
            Container(height: 2, color: const Color(0x2E000000)),
          ]),
        );
    final parts = <(int, Widget)>[
      for (final s in owners) (s.shares, seg(c.house(s.house!.tincture), self: s.house!.self)),
      if (cityPart > 0) (cityPart, CustomPaint(painter: _HatchPainter(c.shareNeutral, const Color(0xFFC9B083)))),
    ];
    final cityName = 'ui.shares.city'.tr();
    final a11y = [for (final s in owners) '${s.house!.name} ${s.shares}', '$cityName $cityPart'].join(', ');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Semantics(
        label: 'ui.shares.semantics'.tr(namedArgs: {'good': good.name, 'parts': a11y}),
        child: Container(
          height: 20,
          decoration: BoxDecoration(
            color: c.woodLo,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: c.woodLo, width: 1.5),
            boxShadow: [BoxShadow(color: c.frameLo, spreadRadius: 1)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              for (var i = 0; i < parts.length; i++) ...[
                if (i > 0) const SizedBox(width: 1.5),
                Expanded(flex: parts[i].$1.clamp(1, 100), child: parts[i].$2),
              ],
            ]),
          ),
        ),
      ),
      if (legend) ...[
        const SizedBox(height: 6),
        Wrap(spacing: 12, runSpacing: 4, children: [
          for (final s in owners) _key(c, c.house(s.house!.tincture), s.house!.name, '${s.shares}', bold: s.house!.self),
          if (cityPart > 0) _key(c, c.shareNeutral, cityName, '$cityPart'),
        ]),
      ],
    ]);
  }

  Widget _key(TnColors c, Color sw, String name, String value, {bool bold = false}) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 11, height: 11, decoration: BoxDecoration(color: sw, borderRadius: BorderRadius.circular(2), border: Border.all(color: c.outline))),
        const SizedBox(width: 6),
        Text(name, style: (bold ? TnText.bodyStrong(c.ink) : TnText.body(c.ink)).copyWith(fontSize: 13)),
        const SizedBox(width: 4),
        Text(value, style: TnText.data(c.inkMuted, size: 12)),
      ]);
}

/// A városi tanács helyei (alapból 9) viaszpecsét-korongokként, a pártok tinktúrájával.
class SeatsBar extends StatelessWidget {
  const SeatsBar({super.key, required this.parties, this.total = 9});
  final List<PartyView> parties;
  final int total;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final legend = parties.where((p) => p.seats > 0).toList()..sort((a, b) => b.seats.compareTo(a.seats));
    final seats = <HouseRef?>[for (final p in legend) for (var i = 0; i < p.seats; i++) p.house];
    while (seats.length < total) {
      seats.add(null);
    }
    final text = legend.isEmpty ? 'ui.council.none'.tr() : 'ui.council.legend'.tr(namedArgs: {'list': legend.map((p) => '${p.house.name} ${p.seats}').join(' · ')});
    return Semantics(
      label: text,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ExcludeSemantics(
          child: Wrap(spacing: 4, runSpacing: 4, children: [
            for (final h in seats) SizedBox(width: 22, height: 22, child: CustomPaint(painter: _SeatPainter(c, h == null ? null : c.house(h.tincture), h?.self == true))),
          ]),
        ),
        const SizedBox(height: 6),
        Text(text, style: TnText.caption(c.inkMuted)),
      ]),
    );
  }
}

class _SeatPainter extends CustomPainter {
  _SeatPainter(this.c, this.fill, this.self);
  final TnColors c;
  final Color? fill;
  final bool self;

  @override
  void paint(Canvas canvas, Size size) {
    final ctr = size.center(Offset.zero);
    final r = size.width / 2;
    final circle = Path()..addOval(Rect.fromCircle(center: ctr, radius: r));
    if (fill == null) {
      canvas.drawPath(circle, Paint()..color = c.hollow);
      canvas.drawPath(
          dashPath(Path()..addOval(Rect.fromCircle(center: ctr, radius: r - 0.5)), dashArray: CircularIntervalList<double>([2.5, 2])),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = c.lineStrong);
      return;
    }
    if (self) {
      canvas.drawCircle(ctr, r + 2, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = c.frame);
    }
    canvas.drawCircle(ctr + const Offset(0, 1), r, Paint()
      ..color = const Color(0x59000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.6));
    canvas.drawPath(circle, Paint()..color = fill!);
    canvas.save();
    canvas.clipPath(circle);
    canvas.drawCircle(ctr + const Offset(0, 2), r, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0x40FFFFFF));
    canvas.drawCircle(ctr - const Offset(0, 2), r, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0x33000000));
    canvas.restore();
    canvas.drawCircle(ctr, r - 0.5, Paint()
      ..style = PaintingStyle.stroke
      ..color = c.outline);
  }

  @override
  bool shouldRepaint(_SeatPainter o) => o.fill != fill || o.self != self;
}

class _HatchPainter extends CustomPainter {
  _HatchPainter(this.bg, this.line);
  final Color bg, line;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = bg);
    final p = Paint()
      ..color = line
      ..strokeWidth = 1.5;
    for (double x = -size.height; x < size.width; x += 5.5) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), p);
    }
  }

  @override
  bool shouldRepaint(_HatchPainter o) => o.bg != bg || o.line != line;
}

/// Haladásjelző vályú (lap-progress, game-seats-bar): festett bronz vagy zöld töltéssel.
class TnMeter extends StatelessWidget {
  const TnMeter({super.key, required this.value, this.green = false, this.height = 10});
  final double value, height;
  final bool green;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final (hi, base, lo) = green ? (c.btnGreenHi, c.btnGreen, c.btnGreenLo) : (c.btnGoldHi, c.btnGold, c.btnGoldLo);
    return Container(
      height: height,
      decoration: BoxDecoration(color: c.hollow, borderRadius: BorderRadius.circular(3), border: Border.all(color: c.wood)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Stack(children: [
          Positioned(left: 0, right: 0, top: 0, height: 1.5, child: Container(color: const Color(0x33000000))),
          FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [hi, base])),
              alignment: Alignment.bottomCenter,
              child: green ? null : Container(height: 2, color: lo),
            ),
          ),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Űrlapelemek: fokozatválasztó, legördülő, táblázat
// ---------------------------------------------------------------------------

/// Egy fokozat a választósorban: nagy szám, név, mellékhatás.
class OptionItem {
  const OptionItem(this.id, this.big, this.label, this.sub);
  final String id, big, label, sub;
}

/// Kapcsológombsor fokozatváltáshoz (haszonkulcs, adóprogram, margin-row). Az aktuális fokozat
/// zöld, és nem választható.
class OptionRow extends StatelessWidget {
  const OptionRow({super.key, required this.items, required this.selected, this.onPick});
  final List<OptionItem> items;
  final String? selected;
  final ValueChanged<String>? onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Wrap(spacing: 6, runSpacing: 6, children: [
      for (final it in items)
        TnMiniButton(
          on: it.id == selected,
          semanticLabel: '${it.label} ${it.big}, ${it.sub}',
          onTap: onPick == null || it.id == selected ? null : () => onPick!(it.id),
          child: Builder(builder: (ctx) {
            final st = DefaultTextStyle.of(ctx).style;
            final on = it.id == selected;
            return Text.rich(TextSpan(children: [
              TextSpan(text: it.big, style: st.copyWith(fontWeight: FontWeight.w900)),
              TextSpan(text: ' ${it.label} '),
              TextSpan(text: it.sub, style: st.copyWith(fontSize: 12, color: on ? const Color(0xFFF2EEDD) : c.inkMuted, shadows: on ? st.shadows : null)),
            ]));
          }),
        ),
    ]);
  }
}

/// Mezőcímke (tn-field-label), opcionális játékikonnal (label-art).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.art});
  final String text;
  final String? art;
  @override
  Widget build(BuildContext context) {
    final t = Text(text.toUpperCase(), style: TnText.label(context.tn.inkMuted));
    if (art == null) return t;
    return Row(mainAxisSize: MainAxisSize.min, children: [GameIcon(art!, size: 16), const SizedBox(width: 6), Flexible(child: t)]);
  }
}

/// Címkés legördülő lista (tn-select): pergamen mező, 1,5 px-es kontúr, benyomott belső árnyék.
class TnSelect<T> extends StatelessWidget {
  const TnSelect({super.key, required this.label, required this.value, required this.items, required this.onChanged, this.hint});
  final String label;
  final T? value;
  final List<(T, String)> items;
  final ValueChanged<T>? onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final v = items.any((e) => e.$1 == value) ? value : (items.isEmpty ? null : items.first.$1);
    final disabled = onChanged == null;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      FieldLabel(label),
      const SizedBox(height: 4),
      Opacity(
        opacity: disabled ? 0.6 : 1,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.only(left: 12, right: 8),
          decoration: BoxDecoration(
            border: Border.all(color: c.lineStrong, width: 1.5),
            borderRadius: BorderRadius.circular(TnRadius.sm),
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFEDE0C4), Color(0xFFFBF5E6), Color(0xFFFBF5E6)], stops: [0, 0.12, 1]),
          ),
          alignment: Alignment.centerLeft,
          child: DropdownButton<T>(
            value: v,
            isDense: true,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            dropdownColor: c.paperRaised,
            borderRadius: BorderRadius.circular(TnRadius.sm),
            icon: Padding(padding: const EdgeInsets.only(left: 6), child: TnIcon('chevron', size: 16, color: c.inkMuted)),
            style: TnText.bodyStrong(c.ink).copyWith(fontSize: 16, fontWeight: FontWeight.w700),
            items: [for (final e in items) DropdownMenuItem(value: e.$1, child: Text(e.$2, overflow: TextOverflow.ellipsis))],
            onChanged: disabled ? null : (x) => x == null ? null : onChanged!(x),
          ),
        ),
      ),
      if (hint != null) ...[const SizedBox(height: 4), Text(hint!, style: TnText.caption(c.inkMuted))],
    ]);
  }
}

/// Egy oszlop a [MiniTable]-ben.
class Col {
  const Col(this.label, {this.flex = 1, this.right = false});
  final String label;
  final int flex;
  final bool right;
}

/// Adattábla (tn-table, főkönyv): sötét fa fejléc bronz Cinzel felirattal, sávozott sorok,
/// a saját sor acélkék kiemelésű; a számoszlopok jobbra igazítva.
class MiniTable extends StatelessWidget {
  const MiniTable({super.key, required this.cols, required this.rows, this.selfRows = const {}, this.empty});
  final List<Col> cols;
  final List<List<Widget>> rows;
  final Set<int> selfRows;
  final String? empty;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    Widget cell(Col col, Widget w) => Expanded(flex: col.flex, child: Align(alignment: col.right ? Alignment.centerRight : Alignment.centerLeft, child: w));
    final head = TnText.title(c.frameHi).copyWith(fontSize: 12.5, height: 18 / 12.5, letterSpacing: 0.5);
    return Container(
      decoration: BoxDecoration(border: Border.all(color: c.wood, width: 1.5), borderRadius: BorderRadius.circular(TnRadius.sm), color: c.paperRaised),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TnRadius.sm - 1.5),
        child: Container(
          foregroundDecoration: BoxDecoration(border: Border.all(color: c.frameHi), borderRadius: BorderRadius.circular(TnRadius.sm - 1.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [c.wood, c.woodLo])),
              child: Row(children: [
                for (final col in cols)
                  cell(col, Text(col.label, maxLines: 1, overflow: TextOverflow.fade, softWrap: false, style: col.right ? TnText.data(c.frameHi, size: 12.5).copyWith(height: 18 / 12.5) : head)),
              ]),
            ),
            if (rows.isEmpty && empty != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text(empty!, style: TnText.body(c.inkMuted).copyWith(fontSize: 14))),
            for (var r = 0; r < rows.length; r++)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selfRows.contains(r) ? c.verdigrisSoft : (r.isOdd ? const Color(0xFFF1E6CC) : null),
                  border: r == rows.length - 1 ? null : Border(bottom: BorderSide(color: c.line)),
                ),
                child: DefaultTextStyle.merge(
                  style: TnText.body(c.ink).copyWith(fontSize: 14),
                  child: Row(children: [for (var i = 0; i < cols.length; i++) cell(cols[i], i < rows[r].length ? rows[r][i] : const SizedBox.shrink())]),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

/// Egy ház címerrel és névvel (táblázatsorokba).
class HouseName extends StatelessWidget {
  const HouseName(this.house, {super.key, this.size = 14});
  final HouseRef house;
  final double size;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        HouseCrest(tincture: house.tincture, size: size, npc: house.npc, name: house.name),
        const SizedBox(width: 6),
        Flexible(child: Text(house.self ? 'ui.self'.tr(namedArgs: {'name': house.name}) : house.name, overflow: TextOverflow.ellipsis, style: TnText.body(context.tn.ink).copyWith(fontSize: 14))),
      ]);
}

// ---------------------------------------------------------------------------
// Jelentéskártya, értesítés
// ---------------------------------------------------------------------------

/// Jelentés levélpapíron (tn-report): vékony fakeret, bronz belső vonal, hajszálvonallal elválasztott fejléc.
class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report});
  final ReportView report;
  /// A jelentés fajtái (ikon és felirat kulcsa: `ui.report.kind.<fajta>`); ismeretlennél városi esemény.
  static const _kinds = {'kem', 'katonai', 'frakcio', 'diplomacia', 'esemeny'};

  /// A forrás megbízhatósága: a teli sávok száma (felirat: `ui.report.confidence.<szint>`).
  static const _conf = {'gyenge': 1, 'kozepes': 2, 'eros': 3};

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final kind = _kinds.contains(report.kind) ? report.kind : 'esemeny';
    final k = (kind, 'ui.report.kind.$kind'.tr());
    final level = _conf[report.confidence];
    final conf = level == null ? null : (level, 'ui.report.confidence.${report.confidence}'.tr());
    final toneColor = switch (report.tone) { 'danger' => c.danger, 'warn' => c.warn, 'ok' => c.ok, _ => null };
    final kindStyle = TnText.data(toneColor ?? c.inkMuted, size: 11.5, weight: FontWeight.w900).copyWith(letterSpacing: 0.7, height: 16 / 11.5);
    final tick = ' · ${'ui.report.round'.tr(namedArgs: {'round': '${report.round}'})} · ${shortDateTime(report.createdAt)}${report.isPublic ? ' · ${'ui.report.public'.tr()}' : ''}';
    return Framed(
      width: double.infinity,
      border: c.wood,
      borderWidth: 1.5,
      rings: [(c.frameHi, 1)],
      radius: 8,
      gradient: c.paperGradient,
      shadows: c.shadowCard,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
          child: Row(children: [
            TnIcon(k.$1, size: 15, color: toneColor ?? c.seal),
            const SizedBox(width: 5),
            Expanded(
              child: Text.rich(
                TextSpan(style: kindStyle, children: [
                  TextSpan(text: k.$2.toUpperCase()),
                  TextSpan(text: tick, style: kindStyle.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0)),
                ]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (conf != null) ...[
              const SizedBox(width: 8),
              for (var i = 0; i < 3; i++)
                Container(
                  width: 4,
                  height: 5.0 + i * 4,
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    color: i < conf.$1 ? c.btnGreen : c.hollow,
                    borderRadius: BorderRadius.circular(1),
                    border: Border.all(color: i < conf.$1 ? c.outline : c.lineStrong),
                  ),
                ),
              const SizedBox(width: 4),
              Text(conf.$2, style: TnText.caption(c.inkMuted).copyWith(fontSize: 12, height: 16 / 12)),
            ],
          ]),
        ),
        const SizedBox(height: 8),
        Text(report.title, style: TnText.title(c.ink).copyWith(fontSize: 16.5, height: 22 / 16.5)),
        const SizedBox(height: 4),
        Text(report.text, style: TnText.chronicle(c.ink)),
      ]),
    );
  }
}

/// Rövid értesítés pergamenen (Toast): tintakontúr és bronz belső keret; a cím Cinzel, a tónus színében.
class Notice extends StatelessWidget {
  const Notice({super.key, required this.tone, required this.title, this.body, this.icon});
  final String tone, title;
  final String? body, icon;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final (fg, top, bottom, ic) = switch (tone) {
      'danger' => (c.danger, const Color(0xFFF8E6DE), c.dangerSoft, 'warning'),
      'warn' => (c.warn, const Color(0xFFF8ECC8), c.warnSoft, 'warning'),
      'ok' => (c.ok, c.paperRaised, c.paper, 'check'),
      _ => (c.verdigris, c.paperRaised, c.paper, 'info'),
    };
    return Semantics(
      liveRegion: tone == 'danger',
      child: Framed(
        width: double.infinity,
        border: c.outline,
        borderWidth: 1.5,
        rings: [(c.frame, 2), (c.outline, 1)],
        radius: 8,
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]),
        shadows: const [BoxShadow(color: Color(0x80000000), offset: Offset(0, 6), blurRadius: 14, spreadRadius: -4)],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.only(top: 2), child: TnIcon(icon ?? ic, size: 20, color: fg)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TnText.title(fg).copyWith(fontSize: 15, height: 20 / 15)),
              if (body != null) ...[const SizedBox(height: 2), Text(body!, style: TnText.body(c.ink).copyWith(fontSize: 14, height: 20 / 14))],
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Lebegő értesítés (Toast) a képernyő alján.
void showToast(BuildContext context, String title, {String? body, String tone = 'info', Duration? duration}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.floating,
      duration: duration ?? Duration(milliseconds: tone == 'info' || tone == 'ok' ? 3400 : 5000),
      content: GestureDetector(onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(), child: Notice(tone: tone, title: title, body: body)),
    ));
}

/// Egységes hibaüzenet.
void showError(BuildContext context, Object e) => showToast(context, 'ui.failed'.tr(), body: e.toString(), tone: 'danger');

/// Szemöldökcím (tn-eyebrow), opcionális játékikonnal.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.art});
  final String text;
  final String? art;
  @override
  Widget build(BuildContext context) {
    final t = Text(text.toUpperCase(), style: TnText.eyebrow(context.tn.inkMuted));
    if (art == null) return t;
    return Row(mainAxisSize: MainAxisSize.min, children: [GameIcon(art!, size: 16), const SizedBox(width: 6), Flexible(child: t)]);
  }
}

/// Kártyacím játékikonnal (good-title): Cinzel cím az ikon mellett.
class ArtTitle extends StatelessWidget {
  const ArtTitle(this.text, {super.key, this.art, this.artSize = 26, this.size = 18});
  final String text;
  final String? art;
  final double artSize, size;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        if (art != null) ...[GameIcon(art!, size: artSize, shadow: true), const SizedBox(width: 8)],
        Flexible(child: Text(text, style: TnText.title(context.tn.ink).copyWith(fontSize: size, height: 1.25))),
      ]);
}

// ---------------------------------------------------------------------------
// Parancslap
// ---------------------------------------------------------------------------

/// Egy sor a [OrderSheet]-en.
class OrderSheetRow {
  const OrderSheetRow({required this.label, required this.cost, this.art, this.meta, this.warning, this.hidden = false});
  final String label, cost;

  /// Az akció neve; a sor elején az ág színű csempés játékikon.
  final String? art;
  final String? meta, warning;
  final bool hidden;
}

/// A parancslap tekercs formában (tn-orders): sötét fa fejléc bronz „Parancslap” címmel,
/// soronként az akció csempés ikonja, alul a PP-összeg és a bronz lepecsételés gomb.
class OrderSheet extends StatelessWidget {
  const OrderSheet({
    super.key,
    required this.orders,
    required this.total,
    required this.available,
    this.aside,
    this.sealed = false,
    this.onSeal,
    this.onRemove,
    this.busy = false,
    this.sealLabel,
  });
  final List<OrderSheetRow> orders;
  final int total, available;
  final String? aside;
  final bool sealed, busy;
  final VoidCallback? onSeal;
  final void Function(int index)? onRemove;

  /// A lepecsételés gomb felirata; alapból „Parancsok lepecsételése”.
  final String? sealLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final over = total > available;
    return Framed(
      width: double.infinity,
      border: c.wood,
      rings: const [],
      gradient: c.paperGradient,
      shadows: c.shadowCard,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: c.frame, width: 1.5)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.5, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [c.woodHi, c.wood]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6.5)),
              border: Border(bottom: BorderSide(color: c.frame, width: 1.5)),
            ),
            child: Row(children: [
              Expanded(
                  child: Text('ui.order_sheet.title'.tr(),
                      style: TnText.sheetTitle(c.frameHi).copyWith(fontSize: 17, height: 22 / 17, shadows: const [Shadow(color: Color(0x80000000), offset: Offset(0, 1))]))),
              if (aside != null) Text(aside!, style: TnText.caption(c.onWood)),
            ]),
          ),
          for (var i = 0; i < orders.length; i++) _row(context, c, i),
          Padding(
            padding: const EdgeInsets.fromLTRB(14.5, 12, 14.5, 12),
            child: Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 12, runSpacing: 12, children: [
              Text((over ? 'ui.order_sheet.total_over' : 'ui.order_sheet.total').tr(namedArgs: {'total': '$total', 'available': '$available'}), style: TnText.data(over ? c.danger : c.ink, size: 14)),
              if (sealed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: c.sealSoft, borderRadius: BorderRadius.circular(6), border: Border.all(color: c.seal)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    TnIcon('pp', size: 16, color: c.seal),
                    const SizedBox(width: 8),
                    Text('ui.order_sheet.sealed'.tr(), style: TnText.data(c.seal, size: 14)),
                  ]),
                )
              else
                TnButton(label: sealLabel ?? 'ui.order_sheet.seal'.tr(), icon: 'pp', kind: TnButtonKind.seal, busy: busy, onPressed: over || orders.isEmpty ? null : onSeal),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _row(BuildContext context, TnColors c, int i) {
    final o = orders[i];
    return Container(
      padding: EdgeInsets.fromLTRB(14.5, 12, onRemove == null || sealed ? 14.5 : 6, 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.lineStrong.withValues(alpha: 0.6)))),
      child: Row(children: [
        if (o.art != null) ...[GameIcon.tile(o.art!, size: 16), const SizedBox(width: 8)],
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              Text(o.label, style: TnText.bodyStrong(c.ink)),
              if (o.hidden)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(color: c.shareUnknown, borderRadius: BorderRadius.circular(3)),
                  child: Text('ui.order_sheet.hidden'.tr(), style: TnText.data(Colors.white, size: 11)),
                ),
            ]),
            if (o.meta != null && o.meta!.isNotEmpty) Text(o.meta!, style: TnText.caption(c.inkMuted)),
            if (o.warning != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(padding: const EdgeInsets.only(top: 2), child: TnIcon('warning', size: 14, color: c.warn)),
                  const SizedBox(width: 4),
                  Expanded(child: Text(o.warning!, style: TnText.caption(c.warn).copyWith(fontWeight: FontWeight.w800))),
                ]),
              ),
          ]),
        ),
        const SizedBox(width: 8),
        Text(o.cost, style: TnText.data(c.ink, size: 13.5)),
        if (onRemove != null && !sealed)
          IconButton(
            tooltip: 'ui.order_sheet.remove'.tr(namedArgs: {'label': o.label}),
            onPressed: busy ? null : () => onRemove!(i),
            visualDensity: VisualDensity.compact,
            icon: TnIcon('close', size: 14, color: c.inkMuted),
          ),
      ]),
    );
  }
}
