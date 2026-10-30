import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/tokens.dart';
import 'tn_icon.dart';

/// Krónika IV illustrated game icons (`assets/k4/icons/<name>.svg`, tokens baked in).
const Set<String> kGameIcons = {
  // Resource
  'gold', 'silver', 'bronze', 'pp', 'legit', 'popularity', 'tax',
  // Good
  'grain', 'wine', 'iron', 'stone', 'salt', 'fish', 'spice', 'peat', 'contraband', 'wool', 'horse',
  // Branch
  'market', 'townHall', 'underworld',
  // Navigation and time
  'navMap', 'navCity', 'navReports', 'navRanking', 'hourglass',
  // Action
  'route', 'margin', 'buyShares', 'buyout', 'defend', 'foundParty', 'program', 'festival', 'news', 'hireSpy', 'guard', 'spy', 'verify', 'debunk',
};

/// Power branch of each action (the tile color). Anything not listed is `common`.
const Map<String, String> kActionBranch = {
  'route': 'common',
  'margin': 'trade', 'buyShares': 'trade', 'buyout': 'trade', 'defend': 'trade',
  'foundParty': 'politics', 'program': 'politics', 'festival': 'politics', 'news': 'politics',
  'hireSpy': 'espionage', 'guard': 'espionage', 'spy': 'espionage', 'verify': 'espionage', 'debunk': 'espionage',
};

/// Game icon for line-icon names (automatic mapping of Button `icon`, NavBar `icon`).
const Map<String, String> kNavArt = {'map': 'navMap', 'city': 'navCity', 'spy': 'navReports', 'pp': 'pp', 'legit': 'navRanking', 'diplomacy': 'program'};

/// Game icon name for an icon name, if one exists (otherwise null).
String? gameArtFor(String? name) => name == null ? null : (kGameIcons.contains(name) ? name : kNavArt[name]);

/// Filled, illustrative game icon with a thin ink outline.
///
/// * [name]: icon name (see [kGameIcons]); unknown names fall back to the [TnIcon] line icon.
/// * [size]: icon size (default 20).
/// * [tile]: if set, the icon sits on a branch-colored tile (size `size × 1.6`). Its value is a branch
///   (`trade` | `politics` | `espionage` | `common`, or the art names `market` | `townHall` | `underworld`),
///   or `auto`: then it comes from the action's branch ([kActionBranch]). See also [GameIcon.tile].
/// * [shadow]: soft drop shadow under the icon (on buttons, dark wood).
/// * [label]: if the icon carries meaning on its own, this is the screen reader text.
class GameIcon extends StatelessWidget {
  const GameIcon(this.name, {super.key, this.size = 20, this.tile, this.shadow = false, this.label, this.fallbackColor, this.opacity = 1});

  /// Tiled icon in the action's branch color.
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
      // Approximates CSS drop-shadow: dark, offset silhouette under the icon.
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
    final b = tile == 'auto' ? (kActionBranch[name] ?? 'common') : branchKey(tile);
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
