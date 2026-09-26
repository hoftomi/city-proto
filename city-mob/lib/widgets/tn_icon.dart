import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

/// A design system vonalikonjai (24-es rács, 1,75-ös vonal). Ugyanazok az útvonalak, mint a web bundle-ben.
const Map<String, List<String>> kTnIcons = {
  'nemesseg': ['M4 18h16', 'M5 18 4 8l5 4 3-6 3 6 5-4-1 10'],
  'kereskedok': ['M12 4v16', 'M8 20h8', 'M5 7h14', 'M5 7l-3 6h6z', 'M19 7l-3 6h6z'],
  'katonasag': ['M19 5 9 15', 'M15 5h4v4', 'M7 13l4 4', 'M8 16l-3 3', 'M4 18l2 2'],
  'arany': ['M12 5a7 7 0 1 0 0 14 7 7 0 1 0 0-14z', 'M12 8.5v7'],
  'bp': ['M6 4h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6z', 'M9 9h6', 'M9 13h6'],
  'ke': ['M12 3l7 3v6c0 4-3 7-7 9-4-2-7-5-7-9V6z'],
  'legit': ['M12 3l2.6 5.6 6.1.7-4.5 4.2 1.2 6L12 16.6 6.6 19.5l1.2-6-4.5-4.2 6.1-.7z'],
  'pp': ['M12 4a8 8 0 1 0 0 16 8 8 0 1 0 0-16z', 'M12 9a3 3 0 1 0 0 6 3 3 0 1 0 0-6z'],
  'kem': ['M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z', 'M12 9a3 3 0 1 0 0 6 3 3 0 1 0 0-6z'],
  'katonai': ['M5 21V4h11l-2 4 2 4H5'],
  'diplomacia': ['M7 3h10v18l-5-3-5 3z'],
  'esemeny': ['M12 3v2', 'M6 11a6 6 0 0 1 12 0v5l2 2H4l2-2z', 'M10 21h4'],
  'frakcio': ['M4 20V10l8-6 8 6v10', 'M9 20v-6h6v6'],
  'route': ['M4 18c4 0 4-12 8-12s4 12 8 12'],
  'lock': ['M6 11h12v9H6z', 'M9 11V8a3 3 0 0 1 6 0v3'],
  'warning': ['M12 3l10 18H2z', 'M12 10v5', 'M12 18v.5'],
  'clock': ['M12 4a8 8 0 1 0 0 16 8 8 0 1 0 0-16z', 'M12 8v4l3 2'],
  'check': ['M5 12l5 5 9-10'],
  'close': ['M6 6l12 12', 'M18 6 6 18'],
  'hidden': ['M3 10c3-3 15-3 18 0l-2 6h-5l-2-2-2 2H5z'],
  'info': ['M12 4a8 8 0 1 0 0 16 8 8 0 1 0 0-16z', 'M12 11v5', 'M12 8v.5'],
  'terkep': ['M3 6l6-2 6 2 6-2v14l-6 2-6-2-6 2z', 'M9 4v14', 'M15 6v14'],
  'varos': ['M3 21V10l3-2 3 2v11', 'M9 21V6l3-3 3 3v15', 'M15 21v-9l3-2 3 2v9', 'M2 21h20'],
  'back': ['M15 5l-7 7 7 7'],
};

final Map<String, Path> _cache = {};

Path _iconPath(String name) => _cache.putIfAbsent(name, () {
      final p = Path();
      for (final d in kTnIcons[name] ?? kTnIcons['info']!) {
        p.addPath(parseSvgPathData(d), Offset.zero);
      }
      return p;
    });

class TnIcon extends StatelessWidget {
  const TnIcon(this.name, {super.key, this.size = 18, this.color, this.semanticLabel});
  final String name;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = color ?? DefaultTextStyle.of(context).style.color ?? IconTheme.of(context).color ?? Colors.black;
    final icon = CustomPaint(size: Size.square(size), painter: _IconPainter(_iconPath(name), c));
    return semanticLabel == null ? ExcludeSemantics(child: icon) : Semantics(label: semanticLabel, child: icon);
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.path, this.color);
  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.75
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_IconPainter old) => old.path != path || old.color != color;
}
