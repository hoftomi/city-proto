import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'tn_icon.dart';

enum TnButtonKind { normal, primary, seal, quiet, danger }

/// A design system gombja. Az érintési cél legalább 44 px magas.
class TnButton extends StatelessWidget {
  const TnButton({super.key, required this.label, this.onPressed, this.kind = TnButtonKind.normal, this.icon, this.small = false, this.busy = false, this.expand = false});
  final String label;
  final VoidCallback? onPressed;
  final TnButtonKind kind;
  final String? icon;
  final bool small, busy, expand;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final (bg, fg, border) = switch (kind) {
      TnButtonKind.primary => (c.ink, c.onInk, c.ink),
      TnButtonKind.seal => (c.seal, c.onSeal, c.seal),
      TnButtonKind.quiet => (Colors.transparent, c.verdigris, Colors.transparent),
      TnButtonKind.danger => (c.paperRaised, c.danger, c.danger),
      TnButtonKind.normal => (c.paperRaised, c.ink, c.lineStrong),
    };
    final disabled = onPressed == null || busy;
    final shape = kind == TnButtonKind.seal
        ? const StadiumBorder()
        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(TnRadius.sm));
    final child = Row(mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
      if (busy)
        SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: fg))
      else if (icon != null)
        TnIcon(icon!, size: small ? 16 : 18, color: fg),
      if (busy || icon != null) const SizedBox(width: 8),
      Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: TnText.bodyStrong(fg).copyWith(fontSize: small ? 13 : 15))),
    ]);
    return Opacity(
      opacity: disabled && !busy ? 0.45 : 1,
      child: Material(
        color: bg,
        shape: shape.copyWith(side: BorderSide(color: border)),
        child: InkWell(
          customBorder: shape,
          onTap: disabled ? null : onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: small ? 36 : 48),
            child: Padding(padding: EdgeInsets.symmetric(horizontal: kind == TnButtonKind.seal ? 24 : (small ? 12 : 16)), child: Center(widthFactor: 1, child: child)),
          ),
        ),
      ),
    );
  }
}
