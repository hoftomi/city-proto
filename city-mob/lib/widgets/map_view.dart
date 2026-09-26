import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../api/models.dart';
import '../theme/tokens.dart';
import 'paint_util.dart';

/// A régió térképe: domborzat, utak, birtokok, városok, szélrózsa és kartus.
/// 360×260-as koordinátarendszerben rajzol, és a rendelkezésre álló szélességre skáláz.
class MapView extends StatelessWidget {
  const MapView({
    super.key,
    required this.map,
    this.state,
    this.selected,
    this.onSelect,
    this.showStarts = false,
    this.selectedStart,
    this.onSelectStart,
  });

  final MapDef map;
  final GameState? state;
  final String? selected;
  final ValueChanged<String>? onSelect;
  final bool showStarts;
  final String? selectedStart;
  final ValueChanged<String>? onSelectStart;

  static const w = 360.0, h = 260.0;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return AspectRatio(
      aspectRatio: w / h,
      child: LayoutBuilder(builder: (ctx, box) {
        final k = box.maxWidth / w;
        return Container(
          decoration: BoxDecoration(border: Border.all(color: c.line), borderRadius: BorderRadius.circular(TnRadius.sm)),
          clipBehavior: Clip.antiAlias,
          child: Stack(children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(map: map, state: state, selected: selected, showStarts: showStarts, selectedStart: selectedStart, c: c),
              ),
            ),
            // Érintési célok és képernyőolvasó-gombok a városokhoz / kezdőhelyekhez
            if (onSelect != null)
              for (final city in map.cities)
                _hit(k, city.x, city.y, '${city.name}${_reachLabel(city.id)}', () => onSelect!(city.id), selected == city.id),
            if (showStarts && onSelectStart != null)
              for (final s in map.starts) _hit(k, s.x, s.y, 'Kezdőhely: ${s.name}', () => onSelectStart!(s.id), selectedStart == s.id),
          ]),
        );
      }),
    );
  }

  String _reachLabel(String id) {
    final cv = state?.cities.where((x) => x.id == id).firstOrNull;
    if (cv == null) return '';
    return cv.reachable ? ', elérhető' : ', nem vezet ide útvonalad';
  }

  Widget _hit(double k, double x, double y, String label, VoidCallback onTap, bool selected) {
    const r = 22.0;
    return Positioned(
      left: x * k - r,
      top: y * k - r,
      width: r * 2,
      height: r * 2,
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.map, required this.state, required this.selected, required this.showStarts, required this.selectedStart, required this.c});
  final MapDef map;
  final GameState? state;
  final String? selected, selectedStart;
  final bool showStarts;
  final TnColors c;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / MapView.w);
    canvas.drawRect(const Rect.fromLTWH(0, 0, MapView.w, MapView.h), Paint()..color = c.paper);
    _grid(canvas);
    paintTerrain(canvas, map.terrain, c);
    _routes(canvas);
    _estates(canvas);
    if (showStarts) _starts(canvas);
    for (final city in map.cities) {
      _city(canvas, city);
    }
    _compass(canvas, const Offset(326, 44), 20);
    _cartouche(canvas, 8, 212, 138, map.name.toUpperCase());
  }

  void _grid(Canvas canvas) {
    final p = Paint()
      ..color = c.line.withValues(alpha: 0.7)
      ..strokeWidth = 0.6;
    for (double x = 40; x < MapView.w; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, MapView.h), p);
    }
    for (double y = 40; y < MapView.h; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(MapView.w, y), p);
    }
  }

  Offset? _pos(String n) {
    final p = map.pos(n);
    return p == null ? null : Offset(p.$1, p.$2);
  }

  void _routes(Canvas canvas) {
    final own = <String>{}, pending = <String>{};
    for (final r in state?.routes ?? const <RouteView>[]) {
      (r.state == 'own' ? own : pending).add(_key(r.from, r.to));
    }
    final base = Paint()
      ..color = c.lineStrong
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (final e in map.cityEdges) {
      final a = _pos(e[0]), b = _pos(e[1]);
      if (a == null || b == null) continue;
      if (own.contains(_key(e[0], e[1])) || pending.contains(_key(e[0], e[1]))) continue;
      dashedLine(canvas, a, b, base, 1, 5);
    }
    for (final r in state?.routes ?? const <RouteView>[]) {
      final a = _pos(r.from), b = _pos(r.to);
      if (a == null || b == null) continue;
      final p = Paint()
        ..color = c.verdigris
        ..strokeCap = StrokeCap.round
        ..strokeWidth = r.state == 'own' ? 3 : 2;
      if (r.state == 'own') {
        canvas.drawLine(a, b, p);
      } else {
        dashedLine(canvas, a, b, p, 6, 4);
      }
    }
  }

  static String _key(String a, String b) => a.compareTo(b) < 0 ? '$a|$b' : '$b|$a';

  static final _estatePath = parseSvgPathData('M0 0h14v6.5c0 4.5-3.5 7.5-7 9.5C3.5 14 0 11 0 6.5z');

  void _shield(Canvas canvas, Offset at, Color fill, {bool dashed = false}) {
    canvas.save();
    canvas.translate(at.dx - 7, at.dy - 8);
    canvas.drawPath(_estatePath, Paint()..color = fill);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = c.paper;
    canvas.drawPath(dashed ? dashPath(_estatePath, dashArray: CircularIntervalList<double>([2, 1.5])) : _estatePath, stroke);
    canvas.restore();
  }

  void _estates(Canvas canvas) {
    final estate = state?.me.estate;
    if (estate == null) return;
    final at = _pos(estate);
    if (at == null) return;
    _shield(canvas, at, c.house(state!.me.tincture));
    haloText(canvas, 'Birtokod', at + const Offset(0, 20), TnText.mapLabel(c.ink).copyWith(fontSize: 11), c.paper, align: TextAlign.center);
  }

  void _starts(Canvas canvas) {
    for (final s in map.starts) {
      final at = Offset(s.x, s.y);
      final on = s.id == selectedStart;
      for (final n in s.neighbors) {
        final b = _pos(n);
        if (b == null) continue;
        final p = Paint()
          ..color = on ? c.verdigris : c.lineStrong
          ..strokeWidth = on ? 2 : 1.5
          ..strokeCap = StrokeCap.round;
        if (on) {
          dashedLine(canvas, at, b, p, 6, 4);
        } else {
          dashedLine(canvas, at, b, p, 1, 5);
        }
      }
      final ring = Paint()..color = on ? c.verdigrisSoft : c.paperRaised;
      canvas.drawCircle(at, 16, ring);
      final rs = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = on ? 2 : 1.5
        ..color = on ? c.verdigris : c.lineStrong;
      if (on) {
        canvas.drawCircle(at, 16, rs);
      } else {
        dashedCircle(canvas, at, 16, rs, 3, 3);
      }
      _shield(canvas, at, on ? c.house('kek') : c.house('fekete'), dashed: !on);
    }
  }

  void _city(Canvas canvas, CityDef city) {
    final at = Offset(city.x, city.y);
    final cv = state?.cities.where((x) => x.id == city.id).firstOrNull;
    final nearStart = showStarts && selectedStart != null && (map.starts.where((s) => s.id == selectedStart).firstOrNull?.neighbors.contains(city.id) ?? false);
    final reachable = (cv?.reachable ?? false) || nearStart;
    final unreachable = cv != null && !cv.reachable;
    final r = city.key ? 7.0 : 5.5;
    if (reachable) canvas.drawCircle(at, r + 7, Paint()..color = c.verdigrisSoft);
    if (city.id == selected) {
      dashedCircle(canvas, at, city.key ? 16 : 14, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = c.verdigris, 4, 3);
    }
    canvas.drawCircle(at, r, Paint()..color = c.paperRaised);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = city.key ? 3 : 2
      ..color = unreachable ? c.inkMuted : c.ink;
    if (unreachable) {
      dashedCircle(canvas, at, r, stroke, 2, 2);
    } else {
      canvas.drawCircle(at, r, stroke);
    }
    if (city.key) canvas.drawCircle(at, 2.5, Paint()..color = unreachable ? c.inkMuted : c.ink);
    final right = city.x < 290;
    haloText(canvas, city.name, at + Offset(right ? r + 6 : -(r + 6), 0.5), TnText.mapLabel(unreachable ? c.inkMuted : c.ink, major: city.key), c.paper,
        align: right ? TextAlign.left : TextAlign.right);
    final stab = cv?.stability;
    if (stab == 'ingatag' || stab == 'lazongo') {
      haloText(canvas, stab == 'lazongo' ? '!!' : '!', at + Offset(0, -r - 7), TnText.bodyStrong(stab == 'lazongo' ? c.danger : c.warn).copyWith(fontSize: 11), c.paper,
          align: TextAlign.center, haloWidth: 3);
    }
  }

  void _compass(Canvas canvas, Offset at, double R) {
    canvas.drawCircle(at, R * 0.78, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = c.ink.withValues(alpha: 0.6));
    // 8 ágú rózsa: a fő ágak hosszabbak
    final rose = Path();
    for (var i = 0; i < 16; i++) {
      final a = -math.pi / 2 + i * math.pi / 8;
      final rad = i.isOdd ? R * 0.22 : (i % 4 == 0 ? R : R * 0.55);
      final p = at + Offset(math.cos(a) * rad, math.sin(a) * rad);
      if (i == 0) {
        rose.moveTo(p.dx, p.dy);
      } else {
        rose.lineTo(p.dx, p.dy);
      }
    }
    rose.close();
    canvas.drawPath(rose, Paint()..color = c.paperRaised);
    canvas.drawPath(rose, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = c.ink);
    canvas.drawPath(Path()
      ..moveTo(at.dx, at.dy - R)
      ..lineTo(at.dx + R * 0.22, at.dy - R * 0.22)
      ..lineTo(at.dx, at.dy)
      ..close(), Paint()..color = c.ink);
    haloText(canvas, 'É', at + Offset(0, -R - 7), TnText.mapLabel(c.ink, major: true).copyWith(fontSize: 11), c.paper, align: TextAlign.center, haloWidth: 3);
  }

  void _cartouche(Canvas canvas, double x, double y, double w, String title) {
    final outer = Rect.fromLTWH(x, y, w, 40);
    canvas.drawRect(outer, Paint()..color = c.paperRaised);
    canvas.drawRect(outer, Paint()
      ..style = PaintingStyle.stroke
      ..color = c.ink);
    canvas.drawRect(outer.deflate(3), Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = c.ink);
    final tp = TextPainter(
      text: TextSpan(text: title, style: TnText.mapLabel(c.ink, major: true).copyWith(fontSize: 12)),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: w - 12);
    tp.paint(canvas, Offset(x + (w - tp.width) / 2, y + 8));
    final bx = x + w / 2 - 30, by = y + 25;
    canvas.drawRect(Rect.fromLTWH(bx, by, 30, 3), Paint()..color = c.ink);
    canvas.drawRect(Rect.fromLTWH(bx + 30, by, 30, 3), Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = c.ink);
    final sp = TextPainter(text: TextSpan(text: '1 napi járóföld', style: TnText.caption(c.inkMuted).copyWith(fontSize: 7)), textDirection: TextDirection.ltr)..layout();
    sp.paint(canvas, Offset(x + (w - sp.width) / 2, by + 4));
  }

  @override
  bool shouldRepaint(_MapPainter o) => o.state != state || o.selected != selected || o.selectedStart != selectedStart || o.c != c || o.map != map;
}

/// A domborzati réteg (tenger, folyók, szántók, mocsár, hegyek, erdők). A városnézet is használja.
void paintTerrain(Canvas canvas, Terrain t, TnColors c) {
  for (final f in t.fields) {
    _field(canvas, f, c);
  }
  if (t.sea != null) {
    final sea = parseSvgPathData(t.sea!);
    canvas.drawPath(sea, Paint()..color = c.mapSea);
    canvas.save();
    canvas.clipPath(sea);
    const widths = [22.0, 14.0, 7.0], inner = [18.0, 10.0, 3.0];
    for (var i = 0; i < 3; i++) {
      canvas.drawPath(sea, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = widths[i]
        ..color = c.mapSeaLine.withValues(alpha: 0.35 + i * 0.2));
    }
    for (final w in inner) {
      canvas.drawPath(sea, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w
        ..color = c.mapSea);
    }
    canvas.restore();
    canvas.drawPath(sea, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..color = c.mapSeaLine);
  }
  for (final d in t.rivers) {
    final p = parseSvgPathData(d);
    canvas.drawPath(p, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..color = c.mapSeaLine);
    canvas.drawPath(p, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..color = c.mapSea);
  }
  for (final m in t.marsh) {
    _marsh(canvas, m[0], m[1], m.length > 2 ? m[2].toInt() : 5, c);
  }
  for (final m in t.mountains) {
    _mountain(canvas, m[0], m[1], m.length > 2 ? m[2] : 1, c);
  }
  for (final f in t.forests) {
    _forest(canvas, f[0], f[1], f.length > 2 ? f[2].toInt() : 5, c);
  }
}

String _fmtSeed(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();

void _field(Canvas canvas, List<double> f, TnColors c) {
  final x = f[0], y = f[1], w = f[2], h = f[3], rot = f.length > 4 ? f[4] : 0.0;
  canvas.save();
  canvas.translate(x + w / 2, y + h / 2);
  canvas.rotate(rot * math.pi / 180);
  canvas.translate(-(x + w / 2), -(y + h / 2));
  canvas.drawRect(Rect.fromLTWH(x, y, w, h), Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8
    ..color = c.mapRelief.withValues(alpha: 0.8));
  final p = Paint()
    ..strokeWidth = 0.6
    ..color = c.mapRelief.withValues(alpha: 0.7);
  for (double i = 3.5; i < h; i += 3.5) {
    canvas.drawLine(Offset(x, y + i), Offset(x + w, y + i), p);
  }
  canvas.restore();
}

void _mountain(Canvas canvas, double x, double y, double s, TnColors c) {
  final w = 11 * s, ht = 13 * s;
  final peak = Path()
    ..moveTo(x - w, y)
    ..lineTo(x, y - ht)
    ..lineTo(x + w, y);
  canvas.drawPath(peak, Paint()..color = c.paperRaised);
  canvas.drawPath(peak, Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.3
    ..strokeJoin = StrokeJoin.round
    ..color = c.mapRelief);
  final hatch = Paint()
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round
    ..color = c.mapRelief;
  for (var i = 1; i <= 4; i++) {
    final t = i / 5;
    final a = Offset(x + w * t * 0.9, y - ht + ht * t + 1);
    canvas.drawLine(a, a + Offset(-2.5 * s, 4 * s), hatch);
  }
}

void _forest(Canvas canvas, double x, double y, int n, TnColors c) {
  final r = SeededRng('f${_fmtSeed(x)}${_fmtSeed(y)}');
  final trees = <(double, double, double)>[];
  for (var i = 0; i < n; i++) {
    final tx = x + (r.next() - 0.5) * n * 5, ty = y + (r.next() - 0.5) * n * 2.6, rr = 3 + r.next() * 1.6;
    trees.add((tx, ty, rr));
  }
  trees.sort((a, b) => a.$2.compareTo(b.$2));
  final trunk = Paint()
    ..strokeWidth = 1
    ..color = c.mapRelief;
  for (final t in trees) {
    canvas.drawLine(Offset(t.$1, t.$2), Offset(t.$1, t.$2 + t.$3 + 2.5), trunk);
    canvas.drawCircle(Offset(t.$1, t.$2), t.$3, Paint()..color = c.mapForest);
    canvas.drawCircle(Offset(t.$1, t.$2), t.$3, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = c.mapRelief);
  }
}

void _marsh(Canvas canvas, double x, double y, int n, TnColors c) {
  final r = SeededRng('m${_fmtSeed(x)}');
  final p = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.9
    ..strokeCap = StrokeCap.round
    ..color = c.mapRelief;
  for (var i = 0; i < n; i++) {
    final mx = x + (r.next() - 0.5) * 30, my = y + (r.next() - 0.5) * 14;
    canvas.drawLine(Offset(mx - 4, my), Offset(mx + 4, my), p);
    canvas.drawLine(Offset(mx, my), Offset(mx - 2, my - 4), p);
    canvas.drawLine(Offset(mx, my), Offset(mx, my - 5), p);
    canvas.drawLine(Offset(mx, my), Offset(mx + 2, my - 4), p);
  }
}
