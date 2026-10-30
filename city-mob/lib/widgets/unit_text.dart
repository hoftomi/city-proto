import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'game_icon.dart';

/// Unit markers in translated and server texts: `[pp]`, `[gold]`, `[pop]`, `[legit]`.
final RegExp kUnitMarker = RegExp(r'\[(pp|gold|pop|legit)\]');

/// Game icon of each unit marker.
const Map<String, String> kUnitIcons = {'pp': 'pp', 'gold': 'gold', 'pop': 'popularity', 'legit': 'legit'};

/// Whether [text] contains at least one unit marker.
bool hasUnits(String text) => kUnitMarker.hasMatch(text);

/// [text] with every unit marker replaced by its word (`ui.unit.<unit>`), for screen readers,
/// tooltips and other plain-text sinks.
String unitPlain(String text) => text.replaceAllMapped(kUnitMarker, (m) => 'ui.unit.${m[1]}'.tr());

/// Inline spans of [text]: plain text runs as [TextSpan]s, unit markers as baseline-aligned
/// [GameIcon] [WidgetSpan]s sized to the font of [style] (fallback 14).
///
/// * [upper]: upper-cases the text runs (labels, eyebrows), never the markers.
List<InlineSpan> unitSpans(String text, TextStyle? style, {bool upper = false}) {
  final size = style?.fontSize ?? 14;
  final spans = <InlineSpan>[];
  var start = 0;
  String run(String s) => upper ? s.toUpperCase() : s;
  for (final m in kUnitMarker.allMatches(text)) {
    if (m.start > start) spans.add(TextSpan(text: run(text.substring(start, m.start)), style: style));
    spans.add(unitIconSpan(m[1]!, size, style: style));
    start = m.end;
  }
  if (start < text.length) spans.add(TextSpan(text: run(text.substring(start)), style: style));
  return spans;
}

/// One unit icon as an inline span. The icon is a bit larger than the font and sinks below the
/// baseline about as deep as the descenders, so it lines up with the digits next to it.
WidgetSpan unitIconSpan(String unit, double fontSize, {TextStyle? style}) {
  final iconSize = (fontSize * 1.2).roundToDouble();
  return WidgetSpan(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    style: style,
    child: _UnitIcon(name: kUnitIcons[unit]!, size: iconSize, descent: (iconSize * 0.2).roundToDouble()),
  );
}

/// Icon box that reports its baseline [descent] px above its bottom edge.
class _UnitIcon extends StatelessWidget {
  const _UnitIcon({required this.name, required this.size, required this.descent});
  final String name;
  final double size, descent;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: _Baseline(descent: descent, child: GameIcon(name, size: size)),
      );
}

class _Baseline extends SingleChildRenderObjectWidget {
  const _Baseline({required this.descent, required super.child});
  final double descent;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderBaseline(descent);

  @override
  void updateRenderObject(BuildContext context, _RenderBaseline renderObject) => renderObject.descent = descent;
}

class _RenderBaseline extends RenderProxyBox {
  _RenderBaseline(this._descent);
  double _descent;
  set descent(double v) {
    if (v == _descent) return;
    _descent = v;
    markNeedsLayout();
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) => size.height - _descent;
}

/// Text that renders unit markers as inline game icons. Without markers it is a plain [Text].
/// Its semantics label is the plain-text form ([unitPlain]), so screen readers read "arany", not "[gold]".
class UnitText extends StatelessWidget {
  const UnitText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textAlign,
    this.upper = false,
  });
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextAlign? textAlign;

  /// Upper-case the text runs (markers stay intact).
  final bool upper;

  @override
  Widget build(BuildContext context) {
    if (!hasUnits(text)) {
      return Text(upper ? text.toUpperCase() : text, style: style, maxLines: maxLines, overflow: overflow, softWrap: softWrap, textAlign: textAlign);
    }
    final effective = DefaultTextStyle.of(context).style.merge(style);
    return Text.rich(
      TextSpan(children: unitSpans(text, effective, upper: upper)),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textAlign: textAlign,
      semanticsLabel: unitPlain(text),
    );
  }
}
