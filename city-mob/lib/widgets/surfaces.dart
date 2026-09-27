import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';
import 'game_icon.dart';

// ---------------------------------------------------------------------------
// Asztal: a képernyő háttere
// ---------------------------------------------------------------------------

/// A képernyő háttere (tn-screen): régi térképlap `table-hi` → `table` átmenettel,
/// halvány 48 px-es rácsvonalakkal és a széleken sötétedő vignettával. Nem görög a tartalommal.
class TnScreen extends StatelessWidget {
  const TnScreen({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _TablePainter(context.tn), child: child);
}

class _TablePainter extends CustomPainter {
  _TablePainter(this.c);
  final TnColors c;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [c.tableHi, c.table]).createShader(rect));
    final grid = Paint()
      ..color = const Color(0x148F7148)
      ..strokeWidth = 1;
    for (double y = 47.5; y < size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (double x = 47.5; x < size.width; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    // radial-gradient(120% 90% at 50% 40%, transparent 55%, #7a5a3326 100%)
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.4);
    canvas.scale(size.width * 1.2, size.height * 0.9);
    canvas.drawRect(
      const Rect.fromLTRB(-2, -2, 2, 2),
      Paint()..shader = ui.Gradient.radial(Offset.zero, 1, const [Color(0x007A5A33), Color(0x007A5A33), Color(0x267A5A33)], const [0, 0.55, 1]),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_TablePainter o) => false;
}

// ---------------------------------------------------------------------------
// Faragott fa fejléc
// ---------------------------------------------------------------------------

/// Bronz Cinzel felirat sötét fán (tn-appbar-name).
TextStyle woodTitle(TnColors c, {double size = 17}) =>
    TnText.title(c.frameHi).copyWith(fontSize: size, height: 22 / 17, letterSpacing: size * 0.04, shadows: const [Shadow(color: Color(0x80000000), offset: Offset(0, 1.5))]);

/// Faragott fa fejléc bronz alsó szegéllyel (tn-appbar). A felső rendszersávot is kitölti.
class TnHeader extends StatelessWidget {
  const TnHeader({super.key, this.leading, this.title, this.actions = const [], this.bottom, this.top, this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 12)});
  final Widget? leading, title, bottom;

  /// Keskeny sötét sáv a fejléc tetején (app-exit: „← Játékok” és a játék neve).
  final Widget? top;
  final List<Widget> actions;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF6A4429), Color(0xFF4A2F1C), Color(0xFF3C2616)], stops: [0, 0.6, 1]),
          border: Border(bottom: BorderSide(color: c.frame, width: 2)),
          boxShadow: [BoxShadow(color: c.outline, offset: const Offset(0, 1.5)), const BoxShadow(color: Color(0x80000000), offset: Offset(0, 5), blurRadius: 8, spreadRadius: -3)],
        ),
        child: SafeArea(
          bottom: false,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
            if (top != null) ColoredBox(color: const Color(0xFF24160C), child: top),
            Padding(
              padding: padding,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
                if (leading != null || title != null || actions.isNotEmpty)
                  Row(children: [
                    if (leading != null) ...[leading!, const SizedBox(width: 8)],
                    Expanded(child: DefaultTextStyle.merge(style: woodTitle(c), overflow: TextOverflow.ellipsis, child: title ?? const SizedBox.shrink())),
                    for (final a in actions) ...[const SizedBox(width: 8), a],
                  ]),
                ?bottom,
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Az elszámolás időzítője sötét fa kapszulában, homokórával (TickTimer).
class TickTimer extends StatelessWidget {
  const TickTimer({super.key, required this.at, this.remaining, this.soon = false});
  final String at;
  final String? remaining;
  final bool soon;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final base = TnText.data(const Color(0xFFF6E9C8), size: 13, weight: FontWeight.w700).copyWith(height: 18 / 13);
    return Semantics(
      label: 'Elszámolás $at${remaining == null ? '' : ', $remaining múlva'}',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 2, 10, 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: soon ? c.btnGold : c.frameLo, width: 1.5),
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF2B1C11), Color(0xFF3F2918)]),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const GameIcon('homokora', size: 18),
            const SizedBox(width: 6),
            Text.rich(TextSpan(style: base, children: [
              const TextSpan(text: 'Elszámolás '),
              TextSpan(text: at, style: base.copyWith(fontWeight: FontWeight.w900, color: const Color(0xFFFFF5DC))),
              if (remaining != null) TextSpan(text: '  $remaining', style: base.copyWith(color: soon ? c.frameHi : const Color(0xFFD9C49A))),
            ])),
          ]),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bőrfülek
// ---------------------------------------------------------------------------

class TnTabItem {
  const TnTabItem(this.id, this.label, {this.badge, this.art, this.tone});
  final String id, label;
  final String? badge;

  /// Játékikon a felirat előtt.
  final String? art;

  /// Ágszín a kijelölt fül felső csíkján (`vasarter` | `varoshaza` | `alvilag`, vagy `keresk` | `polit` | `kem`).
  final String? tone;
}

/// Bőrfülek (tn-tabs): a fülsor a fa alapvonalra ül; a kijelölt fül világos pergamen,
/// felül bronz vagy ágszínű csíkkal, és 2 px-lel rálóg a tartalomra.
class TnTabs extends StatelessWidget {
  const TnTabs({super.key, required this.tabs, required this.active, required this.onChange, this.expand = false});
  final List<TnTabItem> tabs;
  final String active;
  final ValueChanged<String> onChange;

  /// Igaz: a fülek kitöltik a szélességet (városnegyedek); hamis: természetes szélesség, vízszintesen görgethető.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final items = <Widget>[
      for (var i = 0; i < tabs.length; i++) ...[
        if (i > 0) const SizedBox(width: 4),
        if (expand) Expanded(child: _Tab(t: tabs[i], on: tabs[i].id == active, onTap: () => onChange(tabs[i].id), fill: true)) else _Tab(t: tabs[i], on: tabs[i].id == active, onTap: () => onChange(tabs[i].id)),
      ],
    ];
    final row = Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min, children: items);
    return Container(
      padding: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.wood, width: 2))),
      child: expand ? row : SingleChildScrollView(scrollDirection: Axis.horizontal, clipBehavior: Clip.none, child: row),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.t, required this.on, required this.onTap, this.fill = false});
  final TnTabItem t;
  final bool on, fill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final strip = on ? (t.tone == null ? c.frame : c.branch(t.tone)) : null;
    final label = Row(mainAxisSize: MainAxisSize.min, children: [
      if (t.art != null) ...[GameIcon(t.art!, size: 18), const SizedBox(width: 6)],
      Flexible(child: Text(t.label, maxLines: 1, overflow: TextOverflow.fade, softWrap: false, style: TnText.tab(on ? c.ink : c.inkMuted))),
      if (t.badge != null) ...[const SizedBox(width: 6), TnBadge(t.badge!, size: 11)],
    ]);
    Widget tab = CustomPaint(
      painter: _TabPainter(
        top: on ? c.paperRaised : const Color(0xFFEFE2C3),
        bottom: on ? c.paper : c.paperSunk,
        border: on ? c.wood : c.lineStrong,
        strip: strip,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 42),
        child: Padding(
          padding: EdgeInsets.fromLTRB(fill ? 8 : 14, 6, fill ? 8 : 14, 6),
          child: Center(widthFactor: fill ? null : 1, child: fill ? FittedBox(fit: BoxFit.scaleDown, child: label) : label),
        ),
      ),
    );
    if (on) tab = Transform.translate(offset: const Offset(0, 2), child: tab);
    return Semantics(
      button: true,
      selected: on,
      label: t.label,
      excludeSemantics: true,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: tab),
    );
  }
}

class _TabPainter extends CustomPainter {
  _TabPainter({required this.top, required this.bottom, required this.border, this.strip});
  final Color top, bottom, border;
  final Color? strip;

  @override
  void paint(Canvas canvas, Size size) {
    const r = 8.0, bw = 1.5;
    final w = size.width, h = size.height;
    final shape = Path()
      ..moveTo(0, h)
      ..lineTo(0, r)
      ..arcToPoint(const Offset(r, 0), radius: const Radius.circular(r))
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: const Radius.circular(r))
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(shape, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]).createShader(Offset.zero & size));
    if (strip != null) {
      canvas.save();
      canvas.clipPath(shape);
      canvas.drawRect(Rect.fromLTWH(0, 0, w, bw + 3), Paint()..color = strip!);
      canvas.restore();
    }
    final edge = Path()
      ..moveTo(bw / 2, h)
      ..lineTo(bw / 2, r)
      ..arcToPoint(Offset(r, bw / 2), radius: const Radius.circular(r - bw / 2))
      ..lineTo(w - r, bw / 2)
      ..arcToPoint(Offset(w - bw / 2, r), radius: const Radius.circular(r - bw / 2))
      ..lineTo(w - bw / 2, h);
    canvas.drawPath(
      edge,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = bw
        ..color = border,
    );
  }

  @override
  bool shouldRepaint(_TabPainter o) => o.top != top || o.bottom != bottom || o.border != border || o.strip != strip;
}

/// Kerek, téglavörös számjelvény (fül, navigáció).
class TnBadge extends StatelessWidget {
  const TnBadge(this.text, {super.key, this.size = 10.5});
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Container(
      constraints: BoxConstraints(minWidth: size + 5),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: c.btnRed, borderRadius: BorderRadius.circular(99), border: Border.all(color: c.outline)),
      child: Text(text, textAlign: TextAlign.center, style: TnText.data(Colors.white, size: size, weight: FontWeight.w900).copyWith(height: 15 / size)),
    );
  }
}

// ---------------------------------------------------------------------------
// Alsó navigáció
// ---------------------------------------------------------------------------

class TnNavItem {
  const TnNavItem(this.label, {required this.icon, this.art, this.badge});
  final String label;

  /// Vonalikon neve; a játékikon automatikusan ebből jön (terkep, varos, kem, pp, legit), ha nincs [art].
  final String icon;
  final String? art, badge;
}

/// Alsó navigáció sötét fán, bronz felső szegéllyel (tn-nav). A kijelölt fül ikonja
/// bronz keretes, izzó mezőbe kerül, a felirata bronz lesz.
class TnNavBar extends StatelessWidget {
  const TnNavBar({super.key, required this.items, required this.active, required this.onChange});
  final List<TnNavItem> items;
  final int active;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [c.wood, c.woodLo]),
        border: Border(top: BorderSide(color: c.frame, width: 2)),
        boxShadow: [BoxShadow(color: c.outline, offset: const Offset(0, -1.5))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
          child: Row(children: [
            for (var i = 0; i < items.length; i++) Expanded(child: _navItem(c, i)),
          ]),
        ),
      ),
    );
  }

  Widget _navItem(TnColors c, int i) {
    final it = items[i], on = i == active;
    final art = it.art ?? gameArtFor(it.icon);
    return Semantics(
      button: true,
      selected: on,
      label: '${it.label}${it.badge != null ? ', ${it.badge}' : ''}',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChange(i),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                width: 42,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: on ? c.frame : Colors.transparent, width: 1.5),
                  gradient: on ? const RadialGradient(center: Alignment(0, -0.2), radius: 0.75, colors: [Color(0xFF8A6034), Color(0xFF4A2F1C)]) : null,
                  boxShadow: on ? const [BoxShadow(color: Color(0x59E3C27A), blurRadius: 8)] : null,
                ),
                child: art != null ? GameIcon(art, size: 28, shadow: true, opacity: on ? 1 : 0.88) : GameIcon(it.icon, size: 22, fallbackColor: on ? c.frameHi : c.onWood),
              ),
              if (it.badge != null) Positioned(top: -5, right: -6, child: TnBadge(it.badge!)),
            ]),
            const SizedBox(height: 3),
            Text(it.label, maxLines: 1, overflow: TextOverflow.fade, softWrap: false, style: TnText.data(on ? c.frameHi : c.onWood, size: 11, weight: FontWeight.w800).copyWith(height: 14 / 11)),
          ]),
        ),
      ),
    );
  }
}
