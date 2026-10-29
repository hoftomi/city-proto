import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/format.dart';
import 'k4_assets.dart';
import 'k4_viewport.dart';
import 'paint_util.dart';

/// A district's flag: the leading house's name (Marketplace: most shares, Town Hall: most council seats,
/// Underworld: your own spy network), and whether it is your own house. Houses have no colours: every flag is
/// the neutral house tone, your own one carries a bronze border and finial.
class DistrictFlags {
  const DistrictFlags({this.leader, this.self = false});
  final String? leader;
  final bool self;

  @override
  bool operator ==(Object other) => other is DistrictFlags && other.leader == leader && other.self == self;

  @override
  int get hashCode => Object.hash(leader, self);
}

/// The neutral house tone (TnColors.house).
const _houseTone = Color(0xFF5E5246);

/// When zoomed, the view centers on this point for the selected district (the prototype's FOCUS values).
const _focus = {'trade': Offset(0.6, 0.6), 'politics': Offset(0.5, 0.42), 'espionage': Offset(0.42, 0.56)};

bool _inPoly(Offset p, List<Offset> poly) {
  var c = false;
  for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    final a = poly[i], b = poly[j];
    if (((a.dy > p.dy) != (b.dy > p.dy)) && (p.dx < (b.dx - a.dx) * (p.dy - a.dy) / (b.dy - a.dy) + a.dx)) c = !c;
  }
  return c;
}

/// Isometric, painted city view of the city-state (Krónika IV, 720 × 540). The image is exported from the
/// design system (assets/k4/cityview); selection, flags and tappable districts are a drawn layer.
/// Zoomable and pannable, starts at 1.8× zoom on the selected district.
/// District keys match the power branch id (OrderView.branch): trade, politics, espionage.
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
      label: 'ui.city_view.semantics'.tr(namedArgs: {'name': name, 'district': selected == null ? 'ui.city_view.none'.tr() : districtName(selected!)}),
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
                // District buttons for screen readers
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
    // Leading house's flag above the district label
    for (final e in a.labels.entries) {
      final f = flags[e.key];
      if (f?.leader != null) _flag(canvas, e.value + const Offset(-4, -34), self: f!.self);
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

  void _flag(Canvas canvas, Offset at, {bool self = false}) {
    final pole = Paint()
      ..color = K4.outline
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(at, at + const Offset(0, 22), pole);
    // Own house: a bronze finial on the pole.
    if (self) canvas.drawCircle(at - const Offset(0, 1.5), 2.2, Paint()..color = K4.frameHi);
    final cloth = Path()
      ..moveTo(at.dx, at.dy)
      ..cubicTo(at.dx + 5, at.dy - 2, at.dx + 10, at.dy + 2, at.dx + 15, at.dy)
      ..lineTo(at.dx + 12, at.dy + 4.5)
      ..lineTo(at.dx + 15, at.dy + 9)
      ..cubicTo(at.dx + 10, at.dy + 11, at.dx + 5, at.dy + 7, at.dx, at.dy + 9)
      ..close();
    canvas.drawPath(cloth, Paint()..color = _houseTone);
    canvas.drawPath(cloth, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = self ? 1.6 : 0.9
      ..color = self ? K4.frameHi : K4.outline);
  }

  @override
  bool shouldRepaint(_Overlay o) => o.selected != selected || o.k != k || o.flags != flags;
}
