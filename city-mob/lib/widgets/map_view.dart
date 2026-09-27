import 'package:flutter/material.dart';

import 'package:tron_api/tron_api.dart';

import '../domain/model/extensions.dart';
import 'k4_assets.dart';
import 'k4_viewport.dart';
import 'paint_util.dart';

/// A régió festett térképe (Krónika IV): a domborzat, a várak és a birtokok a design systemből exportált képek
/// (assets/k4), az utak és a kijelölés rajzolt réteg. 360×260-as koordinátarendszer.
/// Játék közben (state + onSelect) nagyítható és húzható, 2× nagyítással indul; előnézetben teljes nézet.
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

  bool get _inGame => state != null && onSelect != null;

  Offset get _focus {
    final c = selected == null ? null : map.city(selected!);
    return c == null ? const Offset(0.35, 0.5) : Offset(c.x / w, c.y / h);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<K4Assets>(
      future: K4Assets.load(),
      builder: (ctx, snap) => K4Viewport(
        aspect: w / h,
        zoom: _inGame ? 2 : 1,
        maxZoom: 3.2,
        focus: _focus,
        controls: _inGame,
        builder: (ctx, size) => snap.hasData ? _layers(size, size.width / w, snap.data!) : const SizedBox.shrink(),
      ),
    );
  }

  Widget _layers(Size size, double k, K4Assets a) {
    final estate = state?.me.estate;
    final estatePos = estate == null ? null : map.pos(estate);
    final nearStart = selectedStart == null ? const <String>[] : map.starts.where((s) => s.id == selectedStart).firstOrNull?.neighbors ?? const [];
    Widget sprite(String asset, num x, num y, Rect box) => Positioned(
          left: (x + box.left) * k,
          top: (y + box.top) * k,
          width: box.width * k,
          height: box.height * k,
          child: IgnorePointer(child: Image.asset(asset, fit: BoxFit.fill, filterQuality: FilterQuality.medium, gaplessPlayback: true)),
        );
    return Semantics(
      label: '${map.name} térképe',
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned.fill(child: Image.asset('assets/k4/map/${map.id}.webp', fit: BoxFit.fill, filterQuality: FilterQuality.medium, gaplessPlayback: true)),
        Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _RoutePainter(map, state, showStarts ? selectedStart : null, selected, k)))),
        if (showStarts)
          for (final s in map.starts) sprite('assets/k4/estates/${s.id == selectedStart ? 'kek' : 'fekete_npc'}.webp', s.x, s.y, a.estateBox),
        if (estatePos != null) ...[
          sprite('assets/k4/estates/${state!.me.tincture}.webp', estatePos.$1, estatePos.$2, a.estateBox),
          Positioned(
            left: (estatePos.$1 - 40) * k,
            top: (estatePos.$2 + 10) * k,
            width: 80 * k,
            child: IgnorePointer(child: Text('Birtokod', textAlign: TextAlign.center, style: K4.label(7 * k))),
          ),
        ],
        for (final c in map.cities)
          sprite('assets/k4/cities/${c.id}_${_reachable(c.id, nearStart) ? 'on' : 'off'}.webp', c.x, c.y, a.cityBox),
        if (onSelect != null)
          for (final c in map.cities)
            _hit(k, c.x, c.y, '${c.name}${_reachLabel(c.id)}', () => onSelect!(c.id), selected == c.id),
        if (showStarts && onSelectStart != null)
          for (final s in map.starts) _hit(k, s.x, s.y, 'Kezdőhely: ${s.name}', () => onSelectStart!(s.id), selectedStart == s.id),
      ]),
    );
  }

  /// Elérhető-e a város: játékban a hálózatod szerint, jelentkezéskor a kiválasztott kezdőhely szomszédjai. Előnézetben mind.
  bool _reachable(String id, List<String> nearStart) {
    if (showStarts) return nearStart.contains(id);
    final cv = state?.cities.where((x) => x.id == id).firstOrNull;
    return cv == null || cv.reachable;
  }

  String _reachLabel(String id) {
    final cv = state?.cities.where((x) => x.id == id).firstOrNull;
    if (cv == null) return '';
    return cv.reachable ? ', elérhető' : ', nem vezet ide útvonalad';
  }

  Widget _hit(double k, num x, num y, String label, VoidCallback onTap, bool selected) {
    final r = 22 * k;
    return Positioned(
      left: x * k - r,
      top: y * k - r,
      width: r * 2,
      height: r * 2,
      child: Semantics(button: true, selected: selected, label: label, child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap)),
    );
  }
}

/// Utak a design system MapRoute stílusában: alap (földút), saját (bronz), tervezett (szaggatott bronz),
/// valamint a kijelölt város gyűrűje.
class _RoutePainter extends CustomPainter {
  _RoutePainter(this.map, this.state, this.start, this.selected, this.k);
  final MapDef map;
  final GameState? state;
  final String? start, selected;
  final double k;

  static String _key(String a, String b) => a.compareTo(b) < 0 ? '$a|$b' : '$b|$a';

  Offset? _pos(String n) {
    final p = map.pos(n);
    return p == null ? null : Offset(p.$1, p.$2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(k);
    final own = <String>{}, pending = <String>{};
    for (final r in state?.routes ?? const <RouteView>[]) {
      (r.state == 'own' ? own : pending).add(_key(r.from, r.to));
    }
    final startSlot = start == null ? null : map.starts.where((s) => s.id == start).firstOrNull;
    final edges = <(String, String)>[for (final e in map.cityEdges) (e[0], e[1])];
    for (final r in state?.routes ?? const <RouteView>[]) {
      if (!edges.any((e) => _key(e.$1, e.$2) == _key(r.from, r.to))) edges.add((r.from, r.to));
    }
    if (startSlot != null) {
      for (final n in startSlot.neighbors) {
        edges.add(('birtok:${startSlot.id}', n));
        pending.add(_key('birtok:${startSlot.id}', n));
      }
    }
    for (final e in edges) {
      final a = _pos(e.$1), b = _pos(e.$2);
      if (a == null || b == null) continue;
      final key = _key(e.$1, e.$2);
      _route(canvas, a, b, own.contains(key) ? 'own' : pending.contains(key) ? 'pending' : 'base');
    }
    // A kijelölt vár talapzata: izometrikus, szaggatott bronz ellipszis a vár alatt
    final sel = selected == null ? null : map.city(selected!);
    if (sel != null) {
      final r = sel.key ? 40.0 : 34.0;
      final oval = Rect.fromCenter(center: Offset(sel.x.toDouble(), sel.y + 4.0), width: r * 2, height: r * 1.15);
      canvas.drawOval(oval, Paint()..color = K4.paper.withValues(alpha: 0.4));
      final path = dashPathOval(oval, 5, 3.5);
      canvas.drawPath(path, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..color = K4.frameHi);
      canvas.drawOval(oval.inflate(1.4), Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = K4.outline.withValues(alpha: 0.5));
    }
  }

  void _route(Canvas canvas, Offset a, Offset b, String state) {
    Paint p(Color c, double w, {double opacity = 1, bool blur = false}) => Paint()
      ..color = c.withValues(alpha: opacity)
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = blur ? const MaskFilter.blur(BlurStyle.normal, 1.2) : null;
    switch (state) {
      case 'own':
        canvas.drawLine(a, b, p(K4.outline, 8, opacity: 0.55, blur: true));
        canvas.drawLine(a, b, p(K4.frameHi, 5.5));
        dashedLine(canvas, a, b, p(K4.frameLo, 1.4), 1.4, 3.2);
      case 'pending':
        dashedLine(canvas, a, b, p(K4.outline, 7, opacity: 0.55, blur: true), 8, 6);
        dashedLine(canvas, a, b, p(K4.frameHi, 4.5), 8, 6);
      default:
        canvas.drawLine(a, b, p(K4.outline, 5, opacity: 0.25, blur: true));
        canvas.drawLine(a, b, p(K4.road, 3.2));
        dashedLine(canvas, a, b, p(K4.roadLo, 1.4), 1, 4);
    }
  }

  @override
  bool shouldRepaint(_RoutePainter o) => o.state != state || o.start != start || o.selected != selected || o.k != k || o.map != map;
}

/// Szaggatott ellipszis útvonala.
Path dashPathOval(Rect oval, double dash, double gap) {
  final src = Path()..addOval(oval);
  final out = Path();
  for (final m in src.computeMetrics()) {
    for (double d = 0; d < m.length; d += dash + gap) {
      out.addPath(m.extractPath(d, (d + dash).clamp(0, m.length)), Offset.zero);
    }
  }
  return out;
}
