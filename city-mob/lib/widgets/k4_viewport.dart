import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A Krónika IV rajzainak színei, amelyeket a térkép és a városkép kerete használ (design-system-kronika4/tokens).
class K4 {
  static const wood = Color(0xFF5A3A22), woodHi = Color(0xFF7A5233), woodLo = Color(0xFF3A2416);
  static const frame = Color(0xFFB88A3E), frameHi = Color(0xFFE3C27A), frameLo = Color(0xFF7E5A22);
  static const outline = Color(0xFF3A2A1C), ink = Color(0xFF2C1F13), grass = Color(0xFFA3B86E);
  static const road = Color(0xFFD9C08A), roadLo = Color(0xFFA8895A), paper = Color(0xFFFFF8E6);
  static const steel = Color(0xFF235F7E), red = Color(0xFF9E3B2C);

  /// Vésett felirat a térképen (Cinzel, sötét peremmel).
  static TextStyle label(double size, {Color color = paper}) => GoogleFonts.cinzel(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: size * 0.05,
        color: color,
        shadows: const [Shadow(color: outline, blurRadius: 2), Shadow(color: outline, offset: Offset(0, 1), blurRadius: 1)],
      );
}

/// Nagyítható, húzható ablak a világtérképhez és a városnézethez (design system: MapViewport).
/// Fa és bronz keretben áll, jobb alul nagyítás, kicsinyítés és „teljes nézet” gombbal.
/// A tartalom a teljes szélességre skálázott méretet kapja; a nagyítás 0,6-os lépésekben halad.
class K4Viewport extends StatefulWidget {
  const K4Viewport({
    super.key,
    required this.aspect,
    required this.builder,
    this.zoom = 1,
    this.maxZoom = 3,
    this.focus = const Offset(0.5, 0.5),
    this.controls = true,
  });

  /// Szélesség / magasság.
  final double aspect;

  /// A tartalom a teljes szélességre skálázott méretben (1× nagyításnál ennyi látszik).
  final Widget Function(BuildContext context, Size size) builder;

  /// Kezdő nagyítás (1 = teljes szélesség).
  final double zoom;
  final double maxZoom;

  /// Erre a pontra (0–1 arányban) áll be a nézet induláskor és amikor megváltozik.
  final Offset focus;
  final bool controls;

  @override
  State<K4Viewport> createState() => _K4ViewportState();
}

class _K4ViewportState extends State<K4Viewport> with SingleTickerProviderStateMixin {
  final _ctl = TransformationController();
  late final AnimationController _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
  Animation<Matrix4>? _tween;
  Size _size = Size.zero;
  bool _placed = false;

  @override
  void initState() {
    super.initState();
    _anim.addListener(() { if (_tween != null) _ctl.value = _tween!.value; });
  }

  @override
  void didUpdateWidget(K4Viewport old) {
    super.didUpdateWidget(old);
    if (old.focus != widget.focus && _size != Size.zero) _go(_scale, widget.focus);
  }

  @override
  void dispose() {
    _anim.dispose();
    _ctl.dispose();
    super.dispose();
  }

  double get _scale => _ctl.value.getMaxScaleOnAxis();

  Matrix4 _matrix(double z, Offset f) {
    final w = _size.width, h = _size.height;
    final tx = (w / 2 - f.dx * w * z).clamp(w - w * z, 0.0), ty = (h / 2 - f.dy * h * z).clamp(h - h * z, 0.0);
    return Matrix4.identity()
      ..translateByDouble(tx, ty, 0, 1)
      ..scaleByDouble(z, z, 1, 1);
  }

  /// A mostani nézet közepe 0–1 arányban (a nagyítás gombjai ezt tartják meg).
  Offset get _center {
    final m = _ctl.value, z = _scale;
    final tx = m.getTranslation().x, ty = m.getTranslation().y;
    return Offset((_size.width / 2 - tx) / (_size.width * z), (_size.height / 2 - ty) / (_size.height * z));
  }

  void _go(double z, Offset f, {bool animate = true}) {
    final target = _matrix(z.clamp(1.0, widget.maxZoom), f);
    if (!animate) { _ctl.value = target; return; }
    _tween = Matrix4Tween(begin: _ctl.value, end: target).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: K4.wood,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: K4.outline, spreadRadius: 1.5),
          BoxShadow(color: Color(0x80000000), offset: Offset(0, 6), blurRadius: 12, spreadRadius: -4),
        ],
      ),
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(color: K4.grass, border: Border.all(color: K4.frame), borderRadius: BorderRadius.circular(6)),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: widget.aspect,
          child: LayoutBuilder(builder: (ctx, box) {
            final size = Size(box.maxWidth, box.maxWidth / widget.aspect);
            if (size != _size) {
              // Első elhelyezéskor a kezdő nagyítás és fókusz, átméretezéskor a mostani nézet marad
              final first = !_placed;
              final z = first ? widget.zoom : _scale, f = first ? widget.focus : _center;
              _size = size;
              _placed = true;
              WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _go(z, f, animate: false); });
            }
            return Stack(children: [
              InteractiveViewer(
                transformationController: _ctl,
                minScale: 1,
                maxScale: widget.maxZoom,
                clipBehavior: Clip.none,
                onInteractionEnd: (_) => setState(() {}),
                child: SizedBox.fromSize(size: size, child: widget.builder(ctx, size)),
              ),
              if (widget.controls)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: AnimatedBuilder(
                    animation: _ctl,
                    builder: (_, _) => Column(mainAxisSize: MainAxisSize.min, children: [
                      _Btn(label: 'Nagyítás', text: '+', onTap: _scale < widget.maxZoom - 0.01 ? () => _go(_scale + 0.6, _center) : null),
                      const SizedBox(height: 5),
                      _Btn(label: 'Kicsinyítés', text: '−', onTap: _scale > 1.01 ? () => _go(_scale - 0.6, _center) : null),
                      const SizedBox(height: 5),
                      _Btn(label: 'Teljes nézet', icon: Icons.fullscreen_exit_rounded, onTap: _scale > 1.01 ? () => _go(1, const Offset(0.5, 0.5)) : null),
                    ]),
                  ),
                ),
            ]);
          }),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  const _Btn({required this.label, this.text, this.icon, this.onTap});
  final String label;
  final String? text;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: Opacity(
        opacity: onTap == null ? 0.45 : 0.92,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [K4.woodHi, K4.wood]),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: K4.frame),
              boxShadow: const [BoxShadow(color: K4.outline, spreadRadius: 1), BoxShadow(color: Color(0x66000000), offset: Offset(0, 2), blurRadius: 3)],
            ),
            child: icon != null
                ? Icon(icon, size: 18, color: K4.frameHi)
                : Text(text!, style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w800, height: 1, color: K4.frameHi)),
          ),
        ),
      ),
    );
  }
}
