import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'game_icon.dart';
import 'tn_icon.dart';
import 'unit_text.dart';

enum TnButtonKind { normal, primary, seal, quiet, danger }

/// Color matrix for 80% desaturation (CSS `grayscale(.8)`) on disabled buttons.
const ColorFilter kGrayscale80 = ColorFilter.matrix([
  0.3702, 0.5723, 0.0575, 0, 0, //
  0.1702, 0.7723, 0.0575, 0, 0, //
  0.1702, 0.5723, 0.2575, 0, 0, //
  0, 0, 0, 1, 0,
]);

/// Three shades of a matte button paint (top highlight, base, bottom rim).
typedef Paint3 = (Color hi, Color base, Color lo);

/// Matte, slightly convex surface: top highlight, bottom rim, ink outline and drop shadow (tn-btn).
/// Approximates the CSS inner shadows (inset box-shadow) with strips.
class Bevel extends StatelessWidget {
  const Bevel({
    super.key,
    required this.paint,
    required this.child,
    this.radius = 8,
    this.pressed = false,
    this.rim = 3,
    this.border,
    this.borderWidth = 1.5,
    this.dropShadow = true,
    this.highlight = const Color(0x59FFFFFF),
    this.innerRing = const Color(0x1AFFFFFF),
  });
  final Paint3 paint;
  final Widget child;
  final double radius, rim, borderWidth;
  final bool pressed, dropShadow;
  final Color? border;
  final Color highlight, innerRing;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final (hi, base, lo) = paint;
    final r = BorderRadius.circular(radius);
    final rimH = pressed ? rim / 2 : rim;
    return Transform.translate(
      offset: Offset(0, pressed ? 1.5 : 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: r,
          border: Border.all(color: border ?? c.outline, width: borderWidth),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [hi, base, base], stops: const [0, 0.45, 1]),
          boxShadow: !dropShadow
              ? null
              : pressed
                  ? [BoxShadow(color: c.outline, offset: const Offset(0, 0.5))]
                  : [
                      BoxShadow(color: c.outline, offset: const Offset(0, 2)),
                      const BoxShadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 6, spreadRadius: -3),
                    ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular((radius - borderWidth).clamp(0, 99)),
          child: Stack(children: [
            Positioned(left: 0, right: 0, top: 0, height: 1, child: ColoredBox(color: highlight)),
            Positioned(left: 0, right: 0, bottom: 0, height: rimH, child: ColoredBox(color: lo)),
            Positioned.fill(child: IgnorePointer(child: DecoratedBox(decoration: BoxDecoration(border: Border.all(color: innerRing))))),
            Padding(padding: EdgeInsets.only(bottom: rimH), child: child),
          ]),
        ),
      ),
    );
  }
}

/// The design system button. Touch target is at least 44 px tall (small: 34 px, sealing: 50 px).
///
/// * [kind]: `normal` steel blue (default), `primary` forest green, `seal` bronze with dark Cinzel label
///   (for sealing only), `danger` brick red, `quiet` parchment.
/// * [art]: game icon before the label ([GameIcon] name). If not given, the [icon] name
///   automatically becomes a game icon if one exists (e.g. `route`, `pp`, `city` → `navCity`),
///   otherwise [icon] is shown as a line icon.
class TnButton extends StatefulWidget {
  const TnButton({
    super.key,
    required this.label,
    this.onPressed,
    this.kind = TnButtonKind.normal,
    this.icon,
    this.art,
    this.small = false,
    this.busy = false,
    this.expand = false,
    this.leading,
    this.alignStart = false,
    this.minHeight,
    this.fontSize,
  });
  final String label;
  final VoidCallback? onPressed;
  final TnButtonKind kind;
  final String? icon, art;
  final bool small, busy, expand, alignStart;

  /// Custom element before the label (e.g. the social sign-in letter mark).
  final Widget? leading;
  final double? minHeight, fontSize;

  @override
  State<TnButton> createState() => _TnButtonState();
}

class _TnButtonState extends State<TnButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final w = widget;
    final seal = w.kind == TnButtonKind.seal;
    final Paint3 paint = switch (w.kind) {
      TnButtonKind.primary => (c.btnGreenHi, c.btnGreen, c.btnGreenLo),
      TnButtonKind.seal => (c.btnGoldHi, c.btnGold, c.btnGoldLo),
      TnButtonKind.danger => (c.btnRedHi, c.btnRed, c.btnRedLo),
      TnButtonKind.quiet => (c.btnCreamHi, c.btnCream, c.btnCreamLo),
      TnButtonKind.normal => (c.btnBlueHi, c.btnBlue, c.btnBlueLo),
    };
    final dark = seal || w.kind == TnButtonKind.quiet;
    final fg = dark ? c.ink : c.onBtn;
    final disabled = w.onPressed == null || w.busy;
    final size = w.fontSize ?? (seal ? 16.0 : (w.small ? 13.5 : 15.0));
    final style = seal
        ? TnText.tab(fg).copyWith(fontSize: size, height: 20 / 16, letterSpacing: size * 0.04, shadows: const [Shadow(color: Color(0x80FFF3C8), offset: Offset(0, 1))])
        : TnText.button(fg, small: w.small).copyWith(
            fontSize: size,
            shadows: dark ? null : const [Shadow(color: Color(0x99000000), offset: Offset(0, 1), blurRadius: 1), Shadow(color: Color(0x66000000), blurRadius: 1)],
          );
    final art = w.art ?? gameArtFor(w.icon);
    final artSize = w.small ? 18.0 : (seal ? 24.0 : 20.0);
    Widget? lead;
    if (w.busy) {
      lead = SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: fg));
    } else if (w.leading != null) {
      lead = w.leading;
    } else if (art != null) {
      lead = GameIcon(art, size: artSize, shadow: true);
    } else if (w.icon != null) {
      lead = TnIcon(w.icon!, size: w.small ? 16 : 18, color: fg);
    }
    final content = Row(
      mainAxisSize: w.expand || w.alignStart ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: w.alignStart ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        if (lead != null) ...[lead, SizedBox(width: w.alignStart ? 12 : 8)],
        Flexible(child: UnitText(w.label, overflow: TextOverflow.ellipsis, style: style)),
      ],
    );
    final minH = w.minHeight ?? (seal ? 50.0 : (w.small ? 34.0 : 44.0));
    final padH = seal ? 24.0 : (w.small ? 12.0 : 16.0);
    Widget button = Bevel(
      paint: paint,
      radius: seal ? 10 : (w.small ? 7 : 8),
      pressed: _down && !disabled,
      rim: w.small ? 2.5 : 3,
      highlight: seal ? const Color(0xA6FFFFFF) : const Color(0x59FFFFFF),
      innerRing: seal ? const Color(0x33FFF0C0) : const Color(0x1AFFFFFF),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minH - 3 - (w.small ? 2.5 : 3)),
        child: Padding(padding: EdgeInsets.symmetric(horizontal: padH), child: Center(widthFactor: 1, child: content)),
      ),
    );
    if (disabled && !w.busy) {
      button = Opacity(opacity: 0.55, child: ColorFiltered(colorFilter: kGrayscale80, child: button));
    }
    return Semantics(
      button: true,
      enabled: !disabled,
      label: unitPlain(w.label),
      excludeSemantics: true,
      child: MouseRegion(
        cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: disabled ? null : (_) => setState(() => _down = true),
          onTapUp: disabled ? null : (_) => setState(() => _down = false),
          onTapCancel: disabled ? null : () => setState(() => _down = false),
          onTap: disabled ? null : w.onPressed,
          child: Padding(padding: const EdgeInsets.only(bottom: 2), child: button),
        ),
      ),
    );
  }
}

/// Small parchment toggle button (margin-btn, clock-btns): level picker, filter, admin clock.
/// The selected ([on]) variant is forest green, the [pending] one (a change waiting on the order sheet)
/// steel blue, both with a light label.
class TnMiniButton extends StatelessWidget {
  const TnMiniButton({super.key, required this.child, this.on = false, this.pending = false, this.onTap, this.semanticLabel});
  final Widget child;
  final bool on, pending;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final lit = on || pending;
    final fg = lit ? c.onBtn : c.ink;
    return Semantics(
      button: true,
      selected: on,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Bevel(
          paint: on
              ? (c.btnGreenHi, c.btnGreen, c.btnGreenLo)
              : pending
                  ? (c.btnBlueHi, c.btnBlue, c.btnBlueLo)
                  : (c.btnCreamHi, c.btnCream, c.btnCreamLo),
          radius: 6,
          rim: 2,
          borderWidth: 1,
          border: lit ? c.outline : c.lineStrong,
          dropShadow: false,
          highlight: const Color(0x00FFFFFF),
          innerRing: const Color(0x00FFFFFF),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 32 - 2 - 2),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 3, 10, 2),
              child: DefaultTextStyle.merge(
                style: TnText.button(fg).copyWith(
                  fontSize: 13,
                  height: 18 / 13,
                  shadows: lit ? const [Shadow(color: Color(0x99000000), offset: Offset(0, 1), blurRadius: 1)] : null,
                ),
                child: Center(widthFactor: 1, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
