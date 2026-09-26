import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Determinisztikus véletlen, bitre azonos a web prototípus `rng(seed)` függvényével,
/// így az erdők, mocsarak és háztömbök ugyanúgy néznek ki minden eszközön.
class SeededRng {
  SeededRng(String seed) {
    var s = 0;
    for (final c in seed.codeUnits) {
      s = (s * 31 + c) & 0xFFFFFFFF;
    }
    _s = s == 0 ? 7 : s;
  }
  late int _s;
  double next() {
    _s = (_s * 1664525 + 1013904223) & 0xFFFFFFFF;
    return _s / 4294967296.0;
  }
}

void dashedLine(Canvas canvas, Offset a, Offset b, Paint paint, double dash, double gap) {
  final total = (b - a).distance;
  if (total == 0) return;
  final dir = (b - a) / total;
  var d = 0.0;
  while (d < total) {
    final e = math.min(d + dash, total);
    canvas.drawLine(a + dir * d, a + dir * e, paint);
    d = e + gap;
  }
}

void dashedCircle(Canvas canvas, Offset c, double r, Paint paint, double dash, double gap) {
  final circ = 2 * math.pi * r;
  final n = (circ / (dash + gap)).floor().clamp(4, 400);
  final step = 2 * math.pi / n, sweep = step * dash / (dash + gap);
  for (var i = 0; i < n; i++) {
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), i * step, sweep, false, paint);
  }
}

/// Felirat papírszínű „glóriával”, hogy vonalak fölött is olvasható legyen.
void haloText(Canvas canvas, String text, Offset at, TextStyle style, Color halo, {TextAlign align = TextAlign.left, double haloWidth = 4}) {
  TextPainter tp(Paint? fg) => TextPainter(
        text: TextSpan(text: text, style: fg == null ? style : _withForeground(style, fg)),
        textDirection: TextDirection.ltr,
      )..layout();
  final stroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = haloWidth
    ..strokeJoin = StrokeJoin.round
    ..color = halo;
  final back = tp(stroke), front = tp(null);
  final dx = align == TextAlign.right ? -front.width : (align == TextAlign.center ? -front.width / 2 : 0.0);
  final o = Offset(at.dx + dx, at.dy - front.height / 2);
  back.paint(canvas, o);
  front.paint(canvas, o);
}

ui.Path starPolygon(Offset c, int points, double outer, double inner, {double rotation = -math.pi / 2}) {
  final p = ui.Path();
  for (var i = 0; i < points * 2; i++) {
    final r = i.isEven ? outer : inner;
    final a = rotation + i * math.pi / points;
    final pt = Offset(c.dx + math.cos(a) * r, c.dy + math.sin(a) * r);
    if (i == 0) {
      p.moveTo(pt.dx, pt.dy);
    } else {
      p.lineTo(pt.dx, pt.dy);
    }
  }
  return p..close();
}

/// A TextStyle `color` és `foreground` mezője nem lehet egyszerre kitöltve, ezért új stílust építünk.
TextStyle _withForeground(TextStyle s, Paint fg) => TextStyle(
      fontFamily: s.fontFamily,
      fontFamilyFallback: s.fontFamilyFallback,
      fontSize: s.fontSize,
      fontWeight: s.fontWeight,
      fontStyle: s.fontStyle,
      letterSpacing: s.letterSpacing,
      height: s.height,
      foreground: fg,
    );
