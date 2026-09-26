import 'package:flutter/material.dart';

import '../api/models.dart';
import '../app_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import '../widgets/buttons.dart';
import '../widgets/game_widgets.dart';
import '../widgets/map_view.dart';
import '../widgets/tn_icon.dart';

/// Jelentkezés négy lépésben: ház, háttér, kezdőhely, összegzés.
class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key, required this.detail, required this.map});
  final GameDetail detail;
  final MapDef map;
  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static const _steps = ['Ház', 'Háttér', 'Kezdőhely', 'Összegzés'];
  int step = 0;
  final _name = TextEditingController();
  bool touched = false, busy = false;
  late String tincture = widget.detail.tinctures.first;
  late String background = widget.detail.backgrounds.firstWhere((b) => b.id == 'kereskedo', orElse: () => widget.detail.backgrounds.first).id;
  late String start = widget.detail.starts.first.id;

  String? get nameError {
    final v = _name.text.trim();
    if (v.length < 3) return 'Legalább 3 betű kell.';
    if (v.length > 24) return 'Legfeljebb 24 betű lehet.';
    return null;
  }

  Future<void> _next() async {
    if (step == 0) {
      setState(() => touched = true);
      if (nameError != null) return;
    }
    if (step < 3) {
      setState(() => step++);
      return;
    }
    setState(() => busy = true);
    try {
      await api.join(widget.detail.game.id, houseName: _name.text.trim(), tincture: tincture, background: background, startSlot: start);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        showError(context, e);
        // Foglalt név esetén vissza az első lépésre
        if (e.toString().contains('név')) setState(() => step = 0);
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final g = widget.detail.game;
    return PopScope(
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && step > 0) setState(() => step--);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: c.paperRaised,
          surfaceTintColor: Colors.transparent,
          title: Text(g.name, style: TnText.caption(c.inkMuted).copyWith(fontSize: 13)),
          bottom: PreferredSize(preferredSize: const Size.fromHeight(44), child: _Stepper(step: step, steps: _steps)),
        ),
        body: SafeArea(
          child: Column(children: [
            Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [_body(c)])),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TnButton(
                label: step == 3 ? 'Jelentkezés megerősítése' : 'Tovább',
                kind: TnButtonKind.primary,
                expand: true,
                busy: busy,
                onPressed: step == 0 && touched && nameError != null ? null : _next,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _title(TnColors c, String t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(t, style: TnText.display(c.ink).copyWith(fontSize: 26, height: 30 / 26)));

  Widget _body(TnColors c) {
    final d = widget.detail;
    switch (step) {
      case 0:
        final initial = _name.text.trim().isEmpty ? '?' : _name.text.trim().characters.first.toUpperCase();
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _title(c, 'Alapítsd meg a házad'),
          Row(children: [
            HouseCrest(tincture: tincture, initial: initial, size: 64, name: _name.text),
            const SizedBox(width: 16),
            Expanded(child: Text(_name.text.trim().isEmpty ? 'Házad neve' : _name.text.trim(), style: TnText.display(c.ink).copyWith(fontSize: 24))),
          ]),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            maxLength: 30,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => setState(() => touched = true),
            decoration: InputDecoration(
              labelText: 'A ház neve',
              hintText: 'például Kékholló',
              border: const OutlineInputBorder(),
              errorText: touched ? nameError : null,
              helperText: 'Így látnak a többiek a térképen és a ranglistán.',
              counterText: '',
            ),
          ),
          const SizedBox(height: 16),
          Text('TINKTÚRA (A HÁZAD SZÍNE)', style: TnText.label(c.inkMuted)),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.1,
            children: [
              for (final t in d.tinctures)
                Semantics(
                  selected: t == tincture,
                  button: true,
                  label: tinctureName(t),
                  child: InkWell(
                    onTap: () => setState(() => tincture = t),
                    child: Container(
                      decoration: BoxDecoration(
                        color: c.paperRaised,
                        borderRadius: BorderRadius.circular(TnRadius.sm),
                        border: Border.all(color: t == tincture ? c.verdigris : c.line, width: t == tincture ? 2 : 1),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        HouseCrest(tincture: t, size: 26),
                        const SizedBox(height: 4),
                        Text(tinctureName(t), style: TnText.bodyStrong(t == tincture ? c.verdigris : c.ink).copyWith(fontSize: 12)),
                      ]),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Egy tinktúrát több ház is választhat; a nevek egyediek.', style: TnText.caption(c.inkMuted)),
        ]);
      case 1:
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _title(c, 'Honnan jön a házad?'),
          Text('A háttér előnyt ad, de nem zár be egyetlen útra. Bármelyik frakcióért versenyezhetsz.', style: TnText.body(c.inkMuted)),
          const SizedBox(height: 12),
          for (final b in d.backgrounds) ...[
            _Choice(icon: b.icon, title: b.name, lines: b.perks, selected: b.id == background, onTap: () => setState(() => background = b.id)),
            const SizedBox(height: 8),
          ],
        ]);
      case 2:
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _title(c, 'Hol áll a birtokod?'),
          Text('A birtokodból két szomszédos városba indulsz ingyenes útvonallal. Akciót csak a hálózatodban lévő városban indíthatsz.',
              style: TnText.body(c.inkMuted)),
          const SizedBox(height: 12),
          MapView(map: widget.map, showStarts: true, selectedStart: start, onSelectStart: (s) => setState(() => start = s)),
          const SizedBox(height: 12),
          for (final s in d.starts) ...[
            _Choice(icon: 'route', title: s.name, lines: ['Szomszédos: ${s.neighborNames.join(', ')}', s.note], selected: s.id == start, onTap: () => setState(() => start = s.id)),
            const SizedBox(height: 8),
          ],
        ]);
      default:
        final bg = d.backgrounds.firstWhere((b) => b.id == background);
        final st = d.starts.firstWhere((s) => s.id == start);
        final g = d.game;
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _title(c, 'Minden készen áll'),
          TnCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                HouseCrest(tincture: tincture, initial: _name.text.trim().characters.first.toUpperCase(), size: 56, name: _name.text),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_name.text.trim(), style: TnText.display(c.ink).copyWith(fontSize: 24)),
                    Text('${bg.name} · ${tinctureName(tincture)}', style: TnText.body(c.inkMuted)),
                  ]),
                ),
              ]),
              const SizedBox(height: 16),
              _kv(c, 'Játék', '${g.name} · ${g.season}'),
              _kv(c, 'Kezdés', g.running ? 'Most (a játék már fut)' : (g.startsAt != null ? dateLong(g.startsAt!) : 'hamarosan')),
              _kv(c, 'Kezdőhely', '${st.name} (${st.neighborNames.join(', ')})'),
              _kv(c, 'Induló készlet', '10 PP · 15 arany · 5 BP · 2 KE'),
            ]),
          ),
          const SizedBox(height: 12),
          Text('A kezdésig bármikor visszavonhatod a jelentkezést. A ház neve és tinktúrája a kezdés után már nem változtatható.', style: TnText.caption(c.inkMuted)),
        ]);
    }
  }

  Widget _kv(TnColors c, String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 112, child: Text(k.toUpperCase(), style: TnText.label(c.inkMuted).copyWith(height: 20 / 12))),
          const SizedBox(width: 12),
          Expanded(child: Text(v, style: TnText.body(c.ink))),
        ]),
      );
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.step, required this.steps});
  final int step;
  final List<String> steps;
  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          Expanded(
            child: Semantics(
              label: '${i + 1}. lépés: ${steps[i]}${i == step ? ', aktuális' : ''}',
              child: Container(
                padding: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(border: Border(top: BorderSide(width: 3, color: i == step ? c.verdigris : (i < step ? c.ink : c.line)))),
                child: Text('${i + 1}  ${steps[i]}', style: TnText.bodyStrong(i == step ? c.verdigris : (i < step ? c.ink : c.inkMuted)).copyWith(fontSize: 11)),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({required this.icon, required this.title, required this.lines, required this.selected, required this.onTap});
  final String icon, title;
  final List<String> lines;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: c.paperRaised,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TnRadius.sm), side: BorderSide(color: selected ? c.verdigris : c.line, width: selected ? 2 : 1)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: selected ? c.verdigrisSoft : c.paperSunk, borderRadius: BorderRadius.circular(TnRadius.sm)),
                child: TnIcon(icon, size: 22, color: selected ? c.verdigris : c.ink),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TnText.heading(c.ink)),
                  for (final l in lines) Text(l, style: TnText.body(c.ink).copyWith(fontSize: 14, height: 20 / 14)),
                ]),
              ),
              if (selected) TnIcon('check', size: 18, color: c.verdigris),
            ]),
          ),
        ),
      ),
    );
  }
}
