import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/format.dart';
import 'k4_assets.dart';
import 'k4_viewport.dart';
import 'paint_util.dart';

/// Egy negyed zászlói: a vezető ház (Vásártér: legtöbb részesedés, Városháza: legtöbb tanácshely,
/// Alvilág: a saját kémhálózatod) és egy esetleges második ház tinktúrája.
class DistrictFlags {
  const DistrictFlags({this.dominant, this.contested});
  final String? dominant, contested;
}

/// A heraldikai tinktúrák festett színei (design system: house-*).
const _houseColors = {
  'voros': Color(0xFFB23A2E), 'kek': Color(0xFF2F5F9E), 'zold': Color(0xFF3D7B3A), 'arany': Color(0xFFC99A2A),
  'bibor': Color(0xFF744A9A), 'fekete': Color(0xFF34313A), 'narancs': Color(0xFFC46A24), 'szeder': Color(0xFF973B62),
};

/// Nagyításkor erre a pontra áll a nézet a kijelölt negyednél (a prototípus FOCUS értékei).
const _focus = {'keresk': Offset(0.6, 0.6), 'polit': Offset(0.5, 0.42), 'kem': Offset(0.42, 0.56)};

bool _inPoly(Offset p, List<Offset> poly) {
  var c = false;
  for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    final a = poly[i], b = poly[j];
    if (((a.dy > p.dy) != (b.dy > p.dy)) && (p.dx < (b.dx - a.dx) * (p.dy - a.dy) / (b.dy - a.dy) + a.dx)) c = !c;
  }
  return c;
}

/// A városállam izometrikus, festett látképe (Krónika IV, 720 × 540). A kép a design systemből exportált
/// (assets/k4/cityview), a kijelölés, a zászlók és a koppintható negyedek rajzolt réteg.
/// Nagyítható és húzható, 1,8× nagyítással indul a kijelölt negyednél.
/// A negyedek kulcsa megegyezik a hatalmi ág azonosítójával (OrderView.branch): keresk, polit, kem.
class CityViewWidget extends StatelessWidget {
  const CityViewWidget({super.key, required this.name, this.coast = false, this.districts = const {}, this.selected, this.onSelect});
  final String name;
  final bool coast;
  final Map<String, DistrictFlags> districts;
  final String? selected;
  final ValueChanged<String>? onSelect;

  static const w = 720.0, h = 540.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$name látképe. Kijelölve: ${selected == null ? 'nincs' : districtName(selected!)}.',
      child: FutureBuilder<K4Assets>(
        future: K4Assets.load(),
        builder: (ctx, snap) => K4Viewport(
          aspect: w / h,
          zoom: 1.8,
          maxZoom: 3,
          focus: _focus[selected] ?? const Offset(0.5, 0.5),
          builder: (ctx, size) {
            final a = snap.data;
            if (a == null) return const SizedBox.shrink();
            final k = size.width / w;
            final asset = a.cityViewAsset(name);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: onSelect == null
                  ? null
                  : (d) {
                      final p = d.localPosition / k;
                      for (final e in a.districts.entries) {
                        if (_inPoly(p, e.value)) {
                          onSelect!(e.key);
                          return;
                        }
                      }
                    },
              child: Stack(children: [
                if (asset != null) Positioned.fill(child: Image.asset(asset, fit: BoxFit.fill, filterQuality: FilterQuality.medium, gaplessPlayback: true)),
                Positioned.fill(child: CustomPaint(painter: _Overlay(a, selected, districts, k))),
                // A negyedek gombjai képernyőolvasóhoz
                if (onSelect != null)
                  for (final e in a.labels.entries)
                    Positioned(
                      left: (e.value.dx - 50) * k,
                      top: (e.value.dy - 20) * k,
                      width: 100 * k,
                      height: 28 * k,
                      child: Semantics(button: true, selected: selected == e.key, label: districtName(e.key), onTap: () => onSelect!(e.key)),
                    ),
              ]),
            );
          },
        ),
      ),
    );
  }
}

class _Overlay extends CustomPainter {
  _Overlay(this.a, this.selected, this.flags, this.k);
  final K4Assets a;
  final String? selected;
  final Map<String, DistrictFlags> flags;
  final double k;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(k);
    final poly = selected == null ? null : a.districts[selected];
    if (poly != null) {
      final path = Path()..addPolygon(poly, true);
      canvas.drawPath(path, Paint()..color = const Color(0xFFFFF8E6).withValues(alpha: 0.38));
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeJoin = StrokeJoin.round
        ..color = K4.frameHi;
      for (var i = 0; i < poly.length; i++) {
        dashedLine(canvas, poly[i], poly[(i + 1) % poly.length], stroke, 6, 4);
      }
    }
    // A vezető ház zászlója a negyed felirata fölött
    for (final e in a.labels.entries) {
      final f = flags[e.key];
      if (f?.dominant != null) _flag(canvas, e.value + const Offset(-4, -34), _houseColors[f!.dominant] ?? K4.ink);
      if (f?.contested != null) _flag(canvas, e.value + const Offset(12, -28), _houseColors[f!.contested] ?? K4.ink, small: true);
      if (e.key == selected) {
        final tp = TextPainter(
          text: TextSpan(text: districtName(e.key), style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: K4.frameHi,
              shadows: const [Shadow(color: K4.outline, blurRadius: 2.5), Shadow(color: K4.outline, offset: Offset(0, 1.2), blurRadius: 1)])),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, e.value - Offset(tp.width / 2, tp.height * 0.8));
      }
    }
  }

  void _flag(Canvas canvas, Offset at, Color color, {bool small = false}) {
    final s = small ? 0.75 : 1.0;
    final pole = Paint()
      ..color = K4.outline
      ..strokeWidth = 1.4 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(at, at + Offset(0, 22 * s), pole);
    final cloth = Path()
      ..moveTo(at.dx, at.dy)
      ..cubicTo(at.dx + 5 * s, at.dy - 2 * s, at.dx + 10 * s, at.dy + 2 * s, at.dx + 15 * s, at.dy)
      ..lineTo(at.dx + 12 * s, at.dy + 4.5 * s)
      ..lineTo(at.dx + 15 * s, at.dy + 9 * s)
      ..cubicTo(at.dx + 10 * s, at.dy + 11 * s, at.dx + 5 * s, at.dy + 7 * s, at.dx, at.dy + 9 * s)
      ..close();
    canvas.drawPath(cloth, Paint()..color = color);
    canvas.drawPath(cloth, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = K4.outline);
  }

  @override
  bool shouldRepaint(_Overlay o) => o.selected != selected || o.k != k || o.flags != flags;
}
