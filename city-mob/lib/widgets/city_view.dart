import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../api/models.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'map_view.dart' show paintTerrain;
import 'paint_util.dart';

/// Egy negyed zászlói: a Domináns ház és (szoros versenyben) a második ház tinktúrája.
class DistrictFlags {
  const DistrictFlags({this.dominant, this.contested});
  final String? dominant, contested;
}

const _wall = [Offset(60, 70), Offset(150, 30), Offset(260, 40), Offset(320, 110), Offset(300, 200), Offset(210, 250), Offset(100, 240), Offset(40, 160)];
const _gates = [Offset(40, 160), Offset(185, 35), Offset(320, 110), Offset(210, 250)];
const _streets = [
  [Offset(40, 160), Offset(180, 140)],
  [Offset(180, 140), Offset(320, 110)],
  [Offset(185, 35), Offset(180, 140)],
  [Offset(180, 140), Offset(210, 250)],
];

class _District {
  const _District(this.poly, this.label, this.flag);
  final List<Offset> poly;
  final Offset label, flag;
}

const _districts = {
  'nemesseg': _District([Offset(60, 70), Offset(150, 30), Offset(185, 35), Offset(180, 140), Offset(40, 160)], Offset(110, 138), Offset(138, 72)),
  'katonasag': _District([Offset(185, 35), Offset(260, 40), Offset(320, 110), Offset(180, 140)], Offset(226, 124), Offset(262, 52)),
  'kereskedok': _District([Offset(40, 160), Offset(180, 140), Offset(320, 110), Offset(300, 200), Offset(210, 250), Offset(100, 240)], Offset(185, 224), Offset(224, 162)),
};

bool _inPoly(double x, double y, List<Offset> poly) {
  var c = false;
  for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    final a = poly[i], b = poly[j];
    if (((a.dy > y) != (b.dy > y)) && (x < (b.dx - a.dx) * (y - a.dy) / (b.dy - a.dy) + a.dx)) c = !c;
  }
  return c;
}

double _segDist(double px, double py, Offset a, Offset b) {
  final dx = b.dx - a.dx, dy = b.dy - a.dy;
  final t = (((px - a.dx) * dx + (py - a.dy) * dy) / (dx * dx + dy * dy)).clamp(0.0, 1.0);
  return math.sqrt(math.pow(px - a.dx - t * dx, 2) + math.pow(py - a.dy - t * dy, 2));
}

bool _nearWall(double x, double y) {
  for (var i = 0; i < _wall.length; i++) {
    if (_segDist(x, y, _wall[i], _wall[(i + 1) % _wall.length]) < 9) return true;
  }
  return false;
}

bool _landmark(double x, double y) =>
    (x > 84 && x < 146 && y > 66 && y < 122) || (math.sqrt(math.pow(x - 244, 2) + math.pow(y - 80, 2)) < 38) || (x > 144 && x < 228 && y > 154 && y < 208);

final Map<String, List<Rect>> _blockCache = {};

/// Háztömbök a város nevéből generálva (ugyanaz az algoritmus, mint a web design systemben).
List<Rect> cityBlocks(String seed) => _blockCache.putIfAbsent(seed, () {
      final r = SeededRng(seed);
      final out = <Rect>[];
      for (double y = 36; y < 250; y += 12) {
        for (double x = 44; x < 320; x += 13) {
          final w = 7 + r.next() * 4, hh = 6 + r.next() * 3.5, bx = x + (r.next() - 0.5) * 3, by = y + (r.next() - 0.5) * 3;
          final cx = bx + w / 2, cy = by + hh / 2;
          if (r.next() < 0.12) continue;
          if (!_inPoly(bx, by, _wall) || !_inPoly(bx + w, by + hh, _wall) || !_inPoly(bx + w, by, _wall) || !_inPoly(bx, by + hh, _wall)) continue;
          if (_nearWall(cx, cy)) continue;
          if (_streets.any((s) => _segDist(cx, cy, s[0], s[1]) < 9)) continue;
          if (_landmark(cx, cy)) continue;
          out.add(Rect.fromLTWH(bx, by, w, hh));
        }
      }
      return out;
    });

class CityViewWidget extends StatelessWidget {
  const CityViewWidget({super.key, required this.name, this.coast = false, this.stability = 'stabil', this.districts = const {}, this.selected, this.onSelect});
  final String name, stability;
  final bool coast;
  final Map<String, DistrictFlags> districts;
  final String? selected;
  final ValueChanged<String>? onSelect;

  static const w = 360.0, h = 280.0;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Semantics(
      label: '$name látképe. Kijelölve: ${selected == null ? 'nincs' : districtName(selected!)}.',
      child: AspectRatio(
        aspectRatio: w / h,
        child: LayoutBuilder(builder: (ctx, box) {
          final k = box.maxWidth / w;
          return GestureDetector(
            onTapUp: onSelect == null
                ? null
                : (d) {
                    final x = d.localPosition.dx / k, y = d.localPosition.dy / k;
                    for (final e in _districts.entries) {
                      if (_inPoly(x, y, e.value.poly)) {
                        onSelect!(e.key);
                        return;
                      }
                    }
                  },
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: c.line), borderRadius: BorderRadius.circular(TnRadius.sm)),
              clipBehavior: Clip.antiAlias,
              child: CustomPaint(size: Size(box.maxWidth, box.maxWidth * h / w), painter: _CityPainter(name, coast, stability, districts, selected, c)),
            ),
          );
        }),
      ),
    );
  }
}

class _CityPainter extends CustomPainter {
  _CityPainter(this.name, this.coast, this.stability, this.districts, this.selected, this.c);
  final String name, stability;
  final bool coast;
  final Map<String, DistrictFlags> districts;
  final String? selected;
  final TnColors c;

  Path _poly(List<Offset> pts) => Path()..addPolygon(pts, true);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / CityViewWidget.w);
    canvas.drawRect(const Rect.fromLTWH(0, 0, CityViewWidget.w, CityViewWidget.h), Paint()..color = c.paper);
    paintTerrain(
      canvas,
      Terrain(
        sea: coast ? 'M336 84C318 140 352 176 310 222C284 250 262 266 252 280H360V84Z' : null,
        fields: [
          [6, 8, 46, 26, -8],
          [8, 196, 36, 24, 10],
          [322, 20, 34, 22, 6],
          if (!coast) [300, 228, 50, 26, -6],
        ],
        forests: const [
          [26, 262, 6],
          [340, 70, 4],
        ],
        mountains: coast
            ? const []
            : const [
                [330, 160, 1],
                [345, 178, 0.8],
              ],
      ),
      c,
    );
    // Utak a kapuktól kifelé
    final road = Paint()
      ..strokeWidth = 1.2
      ..color = c.mapRelief;
    for (final g in _gates) {
      final d = g - const Offset(180, 140);
      dashedLine(canvas, g, g + d / d.distance * 40, road, 3, 3);
    }
    final wall = _poly(_wall);
    canvas.drawPath(wall, Paint()..color = c.paperRaised);
    if (selected != null && _districts[selected] != null) {
      final sel = _poly(_districts[selected]!.poly);
      canvas.drawPath(sel, Paint()..color = c.verdigrisSoft);
      canvas.drawPath(dashPath(sel, dashArray: CircularIntervalList<double>([5, 3])), Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = c.verdigris);
    }
    final block = Paint()..color = c.mapBlock;
    for (final b in cityBlocks(name)) {
      canvas.drawRect(b, block);
    }
    // Felsőváros: palota
    final ink = Paint()..color = c.ink;
    canvas.drawRect(const Rect.fromLTWH(92, 76, 48, 38), ink);
    canvas.drawRect(const Rect.fromLTWH(102, 86, 28, 18), Paint()..color = c.paperRaised);
    for (final t in const [Offset(92, 76), Offset(140, 76), Offset(92, 114), Offset(140, 114)]) {
      canvas.drawCircle(t, 4.5, ink);
    }
    // Citadella: csillagerőd
    final bastion = starPolygon(const Offset(244, 80), 5, 31, 19);
    canvas.drawPath(bastion, Paint()..color = c.paperRaised);
    canvas.drawPath(bastion, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round
      ..color = c.ink);
    canvas.drawRect(const Rect.fromLTWH(236, 72, 16, 16), ink);
    // Vásártér
    final square = Path()..addRect(const Rect.fromLTWH(148, 158, 76, 46));
    canvas.drawPath(square, Paint()..color = c.paper);
    canvas.drawPath(dashPath(square, dashArray: CircularIntervalList<double>([3, 2])), Paint()
      ..style = PaintingStyle.stroke
      ..color = c.ink);
    for (final s in const [Offset(156, 166), Offset(170, 166), Offset(196, 166), Offset(210, 166), Offset(156, 190), Offset(210, 190)]) {
      canvas.drawRect(Rect.fromLTWH(s.dx, s.dy, 8, 6), Paint()..color = c.mapRelief);
    }
    canvas.drawCircle(const Offset(186, 181), 5, Paint()..color = c.mapSea);
    canvas.drawCircle(const Offset(186, 181), 5, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = c.ink);
    // Fal, tornyok, kapuk
    canvas.drawPath(wall, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeJoin = StrokeJoin.round
      ..color = c.ink);
    for (final t in _wall) {
      canvas.drawCircle(t, 5, Paint()..color = c.paperRaised);
      canvas.drawCircle(t, 5, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..color = c.ink);
    }
    for (final g in _gates) {
      canvas.save();
      canvas.translate(g.dx, g.dy);
      canvas.rotate(math.pi / 4);
      canvas.drawRect(const Rect.fromLTWH(-4, -4, 8, 8), ink);
      canvas.restore();
    }
    if (coast) {
      final pier = Paint()
        ..strokeWidth = 3
        ..color = c.ink;
      canvas.drawLine(const Offset(300, 200), const Offset(324, 216), pier);
      canvas.drawLine(const Offset(284, 214), const Offset(304, 232), pier);
      _ship(canvas, const Offset(332, 244));
      _ship(canvas, const Offset(344, 196));
    }
    // Zászlók és feliratok
    for (final e in _districts.entries) {
      final f = districts[e.key];
      final flag = e.value.flag;
      if (f?.contested != null) _pennant(canvas, flag + const Offset(10, 4), f!.contested!);
      if (f?.dominant != null) _pennant(canvas, flag, f!.dominant!);
      final on = selected == e.key;
      haloText(canvas, districtName(e.key), e.value.label, TnText.mapLabel(on ? c.verdigris : c.ink, major: true).copyWith(fontSize: 12), c.paperRaised,
          align: TextAlign.center);
    }
    if (stability == 'lazongo') {
      for (final f in const [Offset(86, 196), Offset(270, 150), Offset(120, 60)]) {
        final p = parseSvgPathData('M${f.dx} ${f.dy}c-5-3-4-8 0-13c0 4 3 4 3 7c1-2 2-3 1-5c4 4 3 9-4 11z');
        canvas.drawPath(p, Paint()..color = c.danger);
        canvas.drawPath(p, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = c.paper);
      }
    } else if (stability == 'ingatag') {
      final smoke = Paint()..color = c.inkMuted.withValues(alpha: 0.55);
      canvas.drawCircle(const Offset(290, 150), 4, smoke);
      canvas.drawCircle(const Offset(293, 141), 5, smoke);
      canvas.drawCircle(const Offset(289, 130), 6.5, smoke);
    }
  }

  void _pennant(Canvas canvas, Offset at, String tincture) {
    canvas.drawLine(at + const Offset(0, 22), at + const Offset(0, -4), Paint()
      ..strokeWidth = 1.3
      ..color = c.ink);
    final p = Path()
      ..moveTo(at.dx, at.dy - 4)
      ..relativeLineTo(13, 0)
      ..relativeLineTo(-4, 4)
      ..relativeLineTo(4, 4)
      ..relativeLineTo(-13, 0)
      ..close();
    canvas.drawPath(p, Paint()..color = c.house(tincture));
    canvas.drawPath(p, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = c.paperRaised);
  }

  void _ship(Canvas canvas, Offset at) {
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.drawPath(Path()
      ..moveTo(-9, 0)
      ..lineTo(9, 0)
      ..lineTo(5, 4)
      ..lineTo(-5, 4)
      ..close(), Paint()..color = c.ink);
    canvas.drawLine(Offset.zero, const Offset(0, -14), Paint()
      ..strokeWidth = 1
      ..color = c.ink);
    final sail = parseSvgPathData('M1-13c6 3 6 8 0 11z');
    canvas.drawPath(sail, Paint()..color = c.paperRaised);
    canvas.drawPath(sail, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = c.ink);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CityPainter o) =>
      o.name != name || o.selected != selected || o.stability != stability || o.coast != coast || o.c != c || o.districts != districts;
}
