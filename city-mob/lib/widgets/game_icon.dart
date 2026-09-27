import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/tokens.dart';
import 'tn_icon.dart';

/// A Krónika IV illusztrált játékikonjai (`assets/k4/icons/<név>.svg`, a tokenek beégetve).
const Set<String> kGameIcons = {
  // Erőforrás
  'arany', 'pp', 'legit', 'nep', 'ado',
  // Árucikk
  'gabona', 'bor', 'vas', 'ko', 'so', 'hal', 'fuszer', 'tozeg', 'csempesz', 'gyapju', 'lo',
  // Ág
  'vasarter', 'varoshaza', 'alvilag',
  // Navigáció és idő
  'navTerkep', 'navVaros', 'navJel', 'navRang', 'homokora',
  // Akció
  'route', 'margin', 'buyShares', 'buyout', 'defend', 'foundParty', 'program', 'festival', 'news', 'hireSpy', 'guard', 'spy', 'verify', 'debunk',
};

/// Az akciók hatalmi ága (a csempe színe). Ami nincs itt, az `kozos`.
const Map<String, String> kActionBranch = {
  'route': 'kozos',
  'margin': 'vasarter', 'buyShares': 'vasarter', 'buyout': 'vasarter', 'defend': 'vasarter',
  'foundParty': 'varoshaza', 'program': 'varoshaza', 'festival': 'varoshaza', 'news': 'varoshaza',
  'hireSpy': 'alvilag', 'guard': 'alvilag', 'spy': 'alvilag', 'verify': 'alvilag', 'debunk': 'alvilag',
};

/// A vonalikon-nevek játékikonja (Button `icon`, NavBar `icon` automatikus fordítása).
const Map<String, String> kNavArt = {'terkep': 'navTerkep', 'varos': 'navVaros', 'kem': 'navJel', 'pp': 'pp', 'legit': 'navRang', 'diplomacia': 'program'};

/// Egy ikonnévhez tartozó játékikon neve, ha van ilyen (különben null).
String? gameArtFor(String? name) => name == null ? null : (kGameIcons.contains(name) ? name : kNavArt[name]);

/// Teli, illusztratív játékikon vékony tintakontúrral.
///
/// * [name]: az ikon neve (lásd [kGameIcons]); ismeretlen névnél a [TnIcon] vonalikonra esik vissza.
/// * [size]: az ikon mérete (alapérték 20).
/// * [tile]: ha meg van adva, az ikon ágszínű csempére kerül (mérete `size × 1,6`). Értéke egy ág
///   (`vasarter` | `varoshaza` | `alvilag` | `kozos`, vagy az API-s `keresk` | `polit` | `kem`),
///   illetve `auto`: ekkor az akció ágából jön ([kActionBranch]). Lásd még [GameIcon.tile].
/// * [shadow]: lágy vetett árnyék az ikon alatt (gombokon, sötét fán).
/// * [label]: ha az ikon önállóan hordoz jelentést, ez a képernyőolvasó szövege.
class GameIcon extends StatelessWidget {
  const GameIcon(this.name, {super.key, this.size = 20, this.tile, this.shadow = false, this.label, this.fallbackColor, this.opacity = 1});

  /// Csempés ikon az akció ágának színével.
  const GameIcon.tile(this.name, {super.key, this.size = 16, String branch = 'auto', this.label, this.fallbackColor})
      : tile = branch,
        shadow = false,
        opacity = 1;

  final String name;
  final double size;
  final String? tile;
  final bool shadow;
  final String? label;
  final Color? fallbackColor;
  final double opacity;

  static bool has(String? name) => name != null && kGameIcons.contains(name);

  @override
  Widget build(BuildContext context) {
    if (!kGameIcons.contains(name)) {
      final icon = TnIcon(name, size: size, color: fallbackColor, semanticLabel: label);
      return tile == null ? icon : _tile(context, Center(child: TnIcon(name, size: size, color: fallbackColor ?? context.tn.ink)));
    }
    Widget art = SvgPicture.asset('assets/k4/icons/$name.svg', width: size, height: size, excludeFromSemantics: true);
    if (shadow) {
      // A CSS drop-shadow közelítése: sötét, eltolt sziluett az ikon alatt.
      art = SizedBox(
        width: size,
        height: size,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(
            left: 0,
            top: size * 0.06,
            child: SvgPicture.asset('assets/k4/icons/$name.svg',
                width: size, height: size, excludeFromSemantics: true, colorFilter: const ColorFilter.mode(Color(0x59000000), BlendMode.srcIn)),
          ),
          art,
        ]),
      );
    }
    if (opacity < 1) art = Opacity(opacity: opacity, child: art);
    if (tile != null) art = _tile(context, Center(child: art));
    return label == null ? ExcludeSemantics(child: art) : Semantics(label: label, image: true, child: ExcludeSemantics(child: art));
  }

  Widget _tile(BuildContext context, Widget child) {
    final c = context.tn;
    final b = tile == 'auto' ? (kActionBranch[name] ?? 'kozos') : branchKey(tile);
    final s = (size * 1.6).roundToDouble();
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [c.field, c.branchSoft(b)]),
        border: Border.all(color: c.branch(b)),
        boxShadow: const [BoxShadow(color: Color(0x4D000000), offset: Offset(0, 1), blurRadius: 1)],
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: const Color(0x99FFFFFF))),
        child: child,
      ),
    );
  }
}
