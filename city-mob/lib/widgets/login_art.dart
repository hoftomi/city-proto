import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../theme/tokens.dart';

/// A borító grafikája: térképlap tengerparttal, házzászlókkal, útvonallal, pecséttel és szélrózsával.
class LoginArt extends StatelessWidget {
  const LoginArt({super.key});
  @override
  Widget build(BuildContext context) => ExcludeSemantics(child: CustomPaint(painter: _ArtPainter(context.tn), size: Size.infinite));
}

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.c);
  final TnColors c;
  static final _coast = parseSvgPathData('M250 0C230 40 262 80 244 118C226 156 270 184 262 224C256 256 236 276 242 300');
  static final _sea = parseSvgPathData('M250 0C230 40 262 80 244 118C226 156 270 184 262 224C256 256 236 276 242 300H390V0Z');

  @override
  void paint(Canvas canvas, Size size) {
    // 390×300 kompozíció, a szélességhez igazítva, függőlegesen középre vágva
    final k = size.width / 390;
    canvas.save();
    canvas.translate(0, (size.height - 300 * k) / 2);
    canvas.scale(k);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 390, 300), Paint()..color = c.paper);
    final relief = Paint()
      ..style = PaintingStyle.stroke
      ..color = c.mapRelief;
    canvas.drawOval(const Rect.fromLTWH(34, 136, 180, 106), relief);
    canvas.drawOval(const Rect.fromLTWH(70, 164, 108, 58), relief);
    canvas.drawPath(_sea, Paint()..color = c.ink);
    canvas.save();
    canvas.clipPath(_sea);
    for (final (dx, a) in const [(12.0, 0.9), (26.0, 0.6), (44.0, 0.35)]) {
      canvas.save();
      canvas.translate(dx, 0);
      canvas.drawPath(_coast, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = c.paper.withValues(alpha: a));
      canvas.restore();
    }
    canvas.restore();
    final route = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = c.verdigris;
    canvas.drawPath(dashPath(parseSvgPathData('M20 270C70 262 96 230 126 196'), dashArray: CircularIntervalList<double>([1, 10])), route);
    canvas.drawPath(parseSvgPathData('M126 196C166 152 202 142 238 136'), route);
    canvas.drawCircle(const Offset(126, 196), 7, Paint()..color = c.paperRaised);
    canvas.drawCircle(const Offset(126, 196), 7, route..strokeWidth = 3);
    canvas.drawCircle(const Offset(243, 135), 10, Paint()..color = c.paperRaised);
    canvas.drawCircle(const Offset(243, 135), 10, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = c.ink);
    final pole = Paint()
      ..strokeWidth = 2
      ..color = c.ink;
    for (final (x, len, t) in const [(28.0, 104.0, 'voros'), (74.0, 70.0, 'kek'), (120.0, 42.0, 'arany')]) {
      canvas.drawLine(Offset(x, 0), Offset(x, len + 16), pole);
      canvas.drawPath(Path()
        ..moveTo(x, 0)
        ..lineTo(x + 34, 0)
        ..lineTo(x + 34, len)
        ..lineTo(x + 17, len - 12)
        ..lineTo(x, len)
        ..close(), Paint()..color = c.house(t));
    }
    // Szélrózsa a tengeren
    final rose = Path();
    const pts = [Offset(0, -34), Offset(4, -4), Offset(34, 0), Offset(4, 4), Offset(0, 34), Offset(-4, 4), Offset(-34, 0), Offset(-4, -4)];
    rose.addPolygon([for (final p in pts) p + const Offset(330, 64)], true);
    canvas.drawCircle(const Offset(330, 64), 26, Paint()
      ..style = PaintingStyle.stroke
      ..color = c.paper.withValues(alpha: 0.6));
    canvas.drawPath(rose, Paint()..color = c.paper);
    // Pecsét
    canvas.drawCircle(const Offset(318, 262), 50, Paint()..color = c.seal);
    canvas.drawCircle(const Offset(318, 262), 37, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = c.onSeal.withValues(alpha: 0.6));
    canvas.drawPath(parseSvgPathData('M298 271H338L342 248L329 259L318 240L307 259L294 248Z'), Paint()..color = c.onSeal.withValues(alpha: 0.85));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ArtPainter o) => o.c != c;
}
