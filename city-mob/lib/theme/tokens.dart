import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Krónika IV design system color tokens (prototype-kronika4/src/ds/tokens.css).
/// There is a single light theme ("Day"); no dark theme.
@immutable
class TnColors extends ThemeExtension<TnColors> {
  const TnColors();

  // Table: the screen background (old map sheet)
  final Color table = const Color(0xFFD9C7A0);
  final Color tableHi = const Color(0xFFE8DAB8);
  final Color tableLo = const Color(0xFFB89C6C);

  // Parchment
  final Color paper = const Color(0xFFEFE2C3);
  final Color paperRaised = const Color(0xFFF7EED8);
  final Color paperSunk = const Color(0xFFE2D0A8);
  final Color line = const Color(0xFFCDB68A);
  final Color lineStrong = const Color(0xFF8F7148);
  final Color outline = const Color(0xFF3A2A1C);

  /// Light base for fields and chips (#fbf5e6).
  final Color field = const Color(0xFFFBF5E6);

  /// Empty dot, empty council seat, bar base (#e3d2ac).
  final Color hollow = const Color(0xFFE3D2AC);

  // Text
  final Color ink = const Color(0xFF2C1F13);
  final Color inkMuted = const Color(0xFF5F4A33);
  final Color onInk = const Color(0xFFF7EED8);
  final Color onBtn = const Color(0xFFFFF9EC);

  // Wood and bronze frame
  final Color wood = const Color(0xFF5A3A22);
  final Color woodHi = const Color(0xFF7A5233);
  final Color woodLo = const Color(0xFF3A2416);
  final Color frame = const Color(0xFFB88A3E);
  final Color frameHi = const Color(0xFFE3C27A);
  final Color frameLo = const Color(0xFF7E5A22);

  /// Light label on dark wood (secondary).
  final Color onWood = const Color(0xFFE8D6AE);

  // Accent (the verdigris role): steel blue
  final Color verdigris = const Color(0xFF235F7E);
  final Color verdigrisSoft = const Color(0xFFD5E4E6);
  final Color onVerdigris = const Color(0xFFFFFFFF);

  // Matte button paints
  final Color btnGreenHi = const Color(0xFF86AD55);
  final Color btnGreen = const Color(0xFF4E7629);
  final Color btnGreenLo = const Color(0xFF36561B);
  final Color btnBlueHi = const Color(0xFF6F98BB);
  final Color btnBlue = const Color(0xFF3B6A90);
  final Color btnBlueLo = const Color(0xFF244763);
  final Color btnGoldHi = const Color(0xFFF0CF7C);
  final Color btnGold = const Color(0xFFC89232);
  final Color btnGoldLo = const Color(0xFF86591A);
  final Color btnRedHi = const Color(0xFFD17A5F);
  final Color btnRed = const Color(0xFFA23B26);
  final Color btnRedLo = const Color(0xFF6C2012);
  final Color btnCreamHi = const Color(0xFFFBF4E2);
  final Color btnCream = const Color(0xFFE8D8B2);
  final Color btnCreamLo = const Color(0xFFA98C5C);

  // Sealing
  final Color seal = const Color(0xFF8C2A1C);
  final Color sealSoft = const Color(0xFFF1DDD2);
  final Color onSeal = const Color(0xFFFFFFFF);

  // Status
  final Color danger = const Color(0xFF9B2C1C);
  final Color dangerSoft = const Color(0xFFF3DCD3);
  final Color warn = const Color(0xFF7A4D06);
  final Color warnSoft = const Color(0xFFF1E2BB);
  final Color ok = const Color(0xFF235F7E);
  final Color okSoft = const Color(0xFFD7E5E8);

  // Shares
  final Color shareNeutral = const Color(0xFFE3D3AD);
  final Color shareUnknown = const Color(0xFF7D6F5F);

  // Map (used by the map and city painters)
  final Color mapGrass = const Color(0xFFA3B86E);
  final Color mapSea = const Color(0xFF5D98AB);
  final Color mapSeaDeep = const Color(0xFF467F94);
  final Color mapSeaLine = const Color(0xFFE8F1EC);
  final Color mapSand = const Color(0xFFE0CB95);
  final Color mapRelief = const Color(0xFF5A4128);
  final Color mapForest = const Color(0xFF4D7535);
  final Color mapField = const Color(0xFFD8B55C);
  final Color mapRoad = const Color(0xFFD9C08A);
  final Color mapRoadLo = const Color(0xFFA8895A);
  final Color mapBlock = const Color(0xFFECDFBF);
  final Color stone = const Color(0xFFCBBFA7);
  final Color stoneLo = const Color(0xFF958770);

  /// House colors (painted, muted heraldic tinctures).
  final Map<String, Color> houses = const {
    'red': Color(0xFFB23A2E),
    'blue': Color(0xFF2F5F9E),
    'green': Color(0xFF3D7B3A),
    'gold': Color(0xFFC99A2A),
    'purple': Color(0xFF744A9A),
    'black': Color(0xFF34313A),
    'orange': Color(0xFFC46A24),
    'mulberry': Color(0xFF973B62),
  };

  /// Power branches: icon tile border and the selected leather tab's top strip.
  final Map<String, (Color, Color)> branches = const {
    'trade': (Color(0xFFA86A14), Color(0xFFF2E0BD)),
    'politics': (Color(0xFF2F5F9E), Color(0xFFDBE3EE)),
    'espionage': (Color(0xFF6A4A8A), Color(0xFFE6DCEC)),
    'common': (Color(0xFF4F7A35), Color(0xFFE1E9D2)),
  };

  Color house(String? tincture) => houses[tincture] ?? houses['black']!;

  /// Branch color; also accepts art and faction names (see [branchKey]).
  Color branch(String? id) => branches[branchKey(id)]!.$1;
  Color branchSoft(String? id) => branches[branchKey(id)]!.$2;

  /// Shadows (shadow-card, shadow-float).
  List<BoxShadow> get shadowCard => [
        BoxShadow(color: outline, offset: const Offset(0, 3)),
        const BoxShadow(color: Color(0x802C1F13), offset: Offset(0, 8), blurRadius: 16, spreadRadius: -8),
      ];
  List<BoxShadow> get shadowFloat => const [
        BoxShadow(color: Color(0x2E000000), offset: Offset(0, 4)),
        BoxShadow(color: Color(0x992C1F13), offset: Offset(0, 14), blurRadius: 28, spreadRadius: -8),
      ];

  /// Parchment card base: `paper-raised` → `paper`.
  LinearGradient get paperGradient => LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [paperRaised, paper]);

  static const light = TnColors();

  @override
  TnColors copyWith() => this;

  @override
  TnColors lerp(ThemeExtension<TnColors>? other, double t) => this;
}

/// Normalizes branch ids, art names and faction names to the branch keys (trade, politics, espionage, common).
String branchKey(String? id) => switch (id) {
      'trade' || 'market' || 'merchants' => 'trade',
      'politics' || 'townHall' || 'nobility' => 'politics',
      'espionage' || 'underworld' || 'soldiers' => 'espionage',
      _ => 'common',
    };

/// Text styles: Cinzel for titles (display), Nunito Sans 600–900 for every other surface and number.
class TnText {
  static const _emboss = [Shadow(color: Color(0xFFFFF6DC), offset: Offset(0, 1)), Shadow(color: Color(0x1F000000), offset: Offset(0, -1))];

  static TextStyle _cinzel(Color c, double size, {double? height, FontWeight weight = FontWeight.w700, double spacing = 0.03, List<Shadow>? shadows}) =>
      GoogleFonts.cinzel(fontSize: size, height: height, fontWeight: weight, letterSpacing: size * spacing, color: c, shadows: shadows);

  static TextStyle _sans(Color c, double size, {double? height, FontWeight weight = FontWeight.w600, double spacing = 0}) =>
      GoogleFonts.nunitoSans(fontSize: size, height: height, fontWeight: weight, letterSpacing: size * spacing, color: c);

  /// Engraved screen title (tn-city-title): Cinzel 700, with light embossing.
  static TextStyle display(Color c) => _cinzel(c, 30, height: 36 / 30, shadows: _emboss);

  /// Large title (sign-in).
  static TextStyle hero(Color c) => _cinzel(c, 46, height: 50 / 46, shadows: _emboss);

  static TextStyle mapLabel(Color c, {bool major = false}) => _cinzel(c, major ? 15 : 13, weight: major ? FontWeight.w800 : FontWeight.w700, spacing: major ? 0.06 : 0.04);

  /// Card and report title (tn-report-title).
  static TextStyle title(Color c) => _cinzel(c, 18, height: 24 / 18, spacing: 0.02);

  /// Sheet title, order sheet title (tn-sheet-title).
  static TextStyle sheetTitle(Color c) => _cinzel(c, 20, height: 26 / 20, spacing: 0.04);

  /// Leather tab label.
  static TextStyle tab(Color c) => _cinzel(c, 14, height: 18 / 14);

  static TextStyle heading(Color c) => _sans(c, 16, height: 22 / 16, weight: FontWeight.w800);
  static TextStyle body(Color c) => _sans(c, 15, height: 22 / 15);
  static TextStyle bodyStrong(Color c) => _sans(c, 15, height: 22 / 15, weight: FontWeight.w800);

  /// Field label (tn-field-label): 12/16, 800, letter-spaced. The caller supplies uppercase text.
  static TextStyle label(Color c) => _sans(c, 12, height: 16 / 12, weight: FontWeight.w800, spacing: 0.05);

  /// Eyebrow title (tn-eyebrow): 11.5/16, 900.
  static TextStyle eyebrow(Color c) => _sans(c, 11.5, height: 16 / 11.5, weight: FontWeight.w900, spacing: 0.08);

  /// Hint (tn-field-hint): 13/18.
  static TextStyle caption(Color c) => _sans(c, 13, height: 18 / 13);

  /// Report and news text (tn-report-text).
  static TextStyle chronicle(Color c) => _sans(c, 15, height: 22 / 15);

  /// Button label.
  static TextStyle button(Color c, {bool small = false}) => _sans(c, small ? 13.5 : 15, height: 20 / 15, weight: FontWeight.w800, spacing: 0.01);

  /// Numbers: tabular digits, bold.
  static TextStyle data(Color c, {double size = 13, FontWeight weight = FontWeight.w800}) =>
      GoogleFonts.nunitoSans(fontSize: size, fontWeight: weight, color: c, fontFeatures: const [FontFeature.tabularFigures()]);
}

class TnSpace {
  static const s1 = 4.0, s2 = 8.0, s3 = 12.0, s4 = 16.0, s6 = 24.0, s8 = 32.0;
}

/// Subtle corners: field 6, card and map frame 10, sheet 14.
class TnRadius {
  static const xs = 3.0, sm = 6.0, md = 10.0, lg = 14.0;
}

/// The app theme. Light theme only; the parameter is kept for legacy callers.
ThemeData buildTheme([Brightness _ = Brightness.light]) {
  const c = TnColors.light;
  final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
  OutlineInputBorder border(Color col, [double w = 1.5]) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(TnRadius.sm), borderSide: BorderSide(color: col, width: w));
  return base.copyWith(
    scaffoldBackgroundColor: c.table,
    canvasColor: c.paperRaised,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: c.verdigris,
      onPrimary: c.onVerdigris,
      secondary: c.btnGreen,
      onSecondary: c.onBtn,
      error: c.danger,
      onError: c.onSeal,
      surface: c.paperRaised,
      onSurface: c.ink,
    ),
    textTheme: GoogleFonts.nunitoSansTextTheme(base.textTheme).apply(bodyColor: c.ink, displayColor: c.ink),
    dividerColor: c.line,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.verdigris, linearTrackColor: c.hollow),
    textSelectionTheme: TextSelectionThemeData(cursorColor: c.verdigris, selectionColor: c.verdigrisSoft, selectionHandleColor: c.verdigris),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.field,
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      labelStyle: TnText.label(c.inkMuted),
      floatingLabelStyle: TnText.label(c.verdigris),
      hintStyle: TnText.body(c.inkMuted).copyWith(fontSize: 16),
      helperStyle: TnText.caption(c.inkMuted),
      errorStyle: TnText.caption(c.danger),
      suffixStyle: TnText.bodyStrong(c.inkMuted),
      border: border(c.lineStrong),
      enabledBorder: border(c.lineStrong),
      focusedBorder: border(c.verdigris, 2),
      errorBorder: border(c.danger),
      focusedErrorBorder: border(c.danger, 2),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.paperRaised,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TnRadius.lg), side: BorderSide(color: c.wood, width: 3)),
      titleTextStyle: TnText.sheetTitle(c.ink),
      contentTextStyle: TnText.body(c.ink),
    ),
    snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.transparent, elevation: 0, behavior: SnackBarBehavior.floating, insetPadding: EdgeInsets.fromLTRB(16, 0, 16, 12)),
    extensions: const [c],
  );
}

extension TnContext on BuildContext {
  TnColors get tn => Theme.of(this).extension<TnColors>() ?? TnColors.light;
}
