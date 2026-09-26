import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A design system színtokenjei (design-system/tokens.json). Nappali és éjjeli téma.
@immutable
class TnColors extends ThemeExtension<TnColors> {
  const TnColors({
    required this.paper,
    required this.paperRaised,
    required this.paperSunk,
    required this.line,
    required this.lineStrong,
    required this.ink,
    required this.inkMuted,
    required this.onInk,
    required this.verdigris,
    required this.verdigrisSoft,
    required this.onVerdigris,
    required this.seal,
    required this.sealSoft,
    required this.onSeal,
    required this.danger,
    required this.dangerSoft,
    required this.warn,
    required this.warnSoft,
    required this.ok,
    required this.okSoft,
    required this.mapSea,
    required this.mapSeaLine,
    required this.mapRelief,
    required this.mapForest,
    required this.mapBlock,
    required this.shareNeutral,
    required this.shareUnknown,
    required this.houses,
  });

  final Color paper, paperRaised, paperSunk, line, lineStrong, ink, inkMuted, onInk;
  final Color verdigris, verdigrisSoft, onVerdigris, seal, sealSoft, onSeal;
  final Color danger, dangerSoft, warn, warnSoft, ok, okSoft;
  final Color mapSea, mapSeaLine, mapRelief, mapForest, mapBlock, shareNeutral, shareUnknown;
  final Map<String, Color> houses;

  Color house(String? tincture) => houses[tincture] ?? houses['fekete']!;

  static const light = TnColors(
    paper: Color(0xFFECEEE6), paperRaised: Color(0xFFF7F8F3), paperSunk: Color(0xFFE0E3D8),
    line: Color(0xFFC3C9BD), lineStrong: Color(0xFF7F8A7D), ink: Color(0xFF1B262C), inkMuted: Color(0xFF4E5C64), onInk: Color(0xFFF7F8F3),
    verdigris: Color(0xFF1F6B61), verdigrisSoft: Color(0xFFD4E7E0), onVerdigris: Color(0xFFFFFFFF),
    seal: Color(0xFF8A1C2B), sealSoft: Color(0xFFF1DCDC), onSeal: Color(0xFFFFFFFF),
    danger: Color(0xFFB02A1E), dangerSoft: Color(0xFFF6DDD8), warn: Color(0xFF7D5200), warnSoft: Color(0xFFF3E6C8),
    ok: Color(0xFF1F5A8A), okSoft: Color(0xFFD9E6F1),
    mapSea: Color(0xFFC9D9D6), mapSeaLine: Color(0xFF7FA19D), mapRelief: Color(0xFF7D7866), mapForest: Color(0xFFA9B99C), mapBlock: Color(0xFFBCC2B4),
    shareNeutral: Color(0xFFD3D8CC), shareUnknown: Color(0xFF5B6268),
    houses: {
      'voros': Color(0xFFB0302F), 'kek': Color(0xFF2C5FA8), 'zold': Color(0xFF2F7A45), 'arany': Color(0xFF9C7414),
      'bibor': Color(0xFF6E3F93), 'fekete': Color(0xFF2A2D30), 'narancs': Color(0xFFB0601E), 'szeder': Color(0xFF8C2F5A),
    },
  );

  static const dark = TnColors(
    paper: Color(0xFF12181C), paperRaised: Color(0xFF1A2227), paperSunk: Color(0xFF0D1215),
    line: Color(0xFF2F3B42), lineStrong: Color(0xFF5A6A72), ink: Color(0xFFE4E8E1), inkMuted: Color(0xFF9EABB1), onInk: Color(0xFF12181C),
    verdigris: Color(0xFF5FC2AE), verdigrisSoft: Color(0xFF143029), onVerdigris: Color(0xFF0D1215),
    seal: Color(0xFFE27A85), sealSoft: Color(0xFF3A1A1F), onSeal: Color(0xFF12181C),
    danger: Color(0xFFF08070), dangerSoft: Color(0xFF3D1A15), warn: Color(0xFFE3B44E), warnSoft: Color(0xFF33280F),
    ok: Color(0xFF80B7E2), okSoft: Color(0xFF142636),
    mapSea: Color(0xFF0F252B), mapSeaLine: Color(0xFF2F5860), mapRelief: Color(0xFF7D796B), mapForest: Color(0xFF2C4232), mapBlock: Color(0xFF34424A),
    shareNeutral: Color(0xFF2A343A), shareUnknown: Color(0xFF737E84),
    houses: {
      'voros': Color(0xFFE06A62), 'kek': Color(0xFF6F9EE6), 'zold': Color(0xFF6CC08A), 'arany': Color(0xFFE2B84A),
      'bibor': Color(0xFFB08AD6), 'fekete': Color(0xFFB4BABD), 'narancs': Color(0xFFE0935A), 'szeder': Color(0xFFD77AA3),
    },
  );

  @override
  TnColors copyWith() => this;

  @override
  TnColors lerp(ThemeExtension<TnColors>? other, double t) => (other is TnColors && t >= 0.5) ? other : this;
}

/// Betűstílusok (design system: Térképfelirat, Szöveg, Krónika, Számok).
class TnText {
  static TextStyle display(Color c) => GoogleFonts.alegreyaSc(fontSize: 32, height: 36 / 32, fontWeight: FontWeight.w500, letterSpacing: 0.6, color: c);
  static TextStyle mapLabel(Color c, {bool major = false}) => GoogleFonts.alegreyaSc(
      fontSize: major ? 15 : 13, fontWeight: major ? FontWeight.w700 : FontWeight.w500, letterSpacing: major ? 1.5 : 1.0, color: c);
  static TextStyle title(Color c) => GoogleFonts.alegreyaSans(fontSize: 20, height: 26 / 20, fontWeight: FontWeight.w700, color: c);
  static TextStyle heading(Color c) => GoogleFonts.alegreyaSans(fontSize: 16, height: 22 / 16, fontWeight: FontWeight.w700, color: c);
  static TextStyle body(Color c) => GoogleFonts.alegreyaSans(fontSize: 15, height: 22 / 15, color: c);
  static TextStyle bodyStrong(Color c) => GoogleFonts.alegreyaSans(fontSize: 15, height: 22 / 15, fontWeight: FontWeight.w600, color: c);
  static TextStyle label(Color c) => GoogleFonts.alegreyaSans(fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w700, letterSpacing: 0.7, color: c);
  static TextStyle caption(Color c) => GoogleFonts.alegreyaSans(fontSize: 12, height: 16 / 12, color: c);
  static TextStyle chronicle(Color c) => GoogleFonts.alegreya(fontSize: 16, height: 24 / 16, fontStyle: FontStyle.italic, color: c);
  static TextStyle data(Color c, {double size = 13, FontWeight weight = FontWeight.w500}) =>
      GoogleFonts.ibmPlexMono(fontSize: size, fontWeight: weight, color: c, fontFeatures: const [FontFeature.tabularFigures()]);
}

class TnSpace {
  static const s1 = 4.0, s2 = 8.0, s3 = 12.0, s4 = 16.0, s6 = 24.0, s8 = 32.0;
}

class TnRadius {
  static const xs = 2.0, sm = 4.0, md = 8.0;
}

ThemeData buildTheme(Brightness b) {
  final c = b == Brightness.dark ? TnColors.dark : TnColors.light;
  final base = ThemeData(useMaterial3: true, brightness: b);
  return base.copyWith(
    scaffoldBackgroundColor: c.paper,
    colorScheme: ColorScheme(
      brightness: b,
      primary: c.ink, onPrimary: c.onInk,
      secondary: c.verdigris, onSecondary: c.onVerdigris,
      error: c.danger, onError: c.onSeal,
      surface: c.paper, onSurface: c.ink,
    ),
    textTheme: GoogleFonts.alegreyaSansTextTheme(base.textTheme).apply(bodyColor: c.ink, displayColor: c.ink),
    dividerColor: c.line,
    extensions: [c],
  );
}

extension TnContext on BuildContext {
  TnColors get tn => Theme.of(this).extension<TnColors>()!;
}
