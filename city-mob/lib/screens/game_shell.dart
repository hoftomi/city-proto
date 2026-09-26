import 'dart:async';

import 'package:flutter/material.dart';

import '../api/models.dart';
import '../app_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import '../widgets/buttons.dart';
import '../widgets/city_view.dart';
import '../widgets/game_widgets.dart';
import '../widgets/map_view.dart';
import '../widgets/tn_icon.dart';

/// A játék képernyői: Térkép, Város, Parancslap, Jelentések, Rangsor.
class GameShell extends StatefulWidget {
  const GameShell({super.key, required this.gameId, required this.mapId, required this.gameName});
  final String gameId, mapId, gameName;
  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> {
  GameState? state;
  MapDef? map;
  Object? error;
  int tab = 0;
  String? city;
  String faction = 'kereskedok';
  bool hidden = false;
  bool busy = false;
  final Map<String, String> smearTarget = {};
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    _load();
    _clock = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final m = await api.map(widget.mapId);
      final s = await api.state(widget.gameId);
      setState(() {
        map = m;
        state = s;
        city ??= s.cities.firstWhere((c) => c.reachable, orElse: () => s.cities.first).id;
        error = null;
      });
    } catch (e) {
      setState(() => error = e);
    }
  }

  Future<void> _act(Future<GameState> Function() f, {String? success}) async {
    setState(() => busy = true);
    try {
      final s = await f();
      setState(() => state = s);
      if (success != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success), duration: const Duration(seconds: 2)));
      }
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _openCity(String id) => setState(() {
        city = id;
        tab = 1;
      });

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    if (error != null && state == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Notice(tone: 'danger', title: 'Nem sikerült betölteni a játékot', body: '$error'),
              const SizedBox(height: 12),
              TnButton(label: 'Újra', onPressed: _load),
            ]),
          ),
        ),
      );
    }
    final s = state, m = map;
    if (s == null || m == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final body = switch (tab) {
      0 => _mapTab(c, s, m),
      1 => _cityTab(c, s, m),
      2 => _ordersTab(c, s),
      3 => _ReportsTab(gameId: widget.gameId, key: ValueKey('rep${s.round}')),
      _ => _RankingTab(gameId: widget.gameId, key: ValueKey('rank${s.round}')),
    };

    return Scaffold(
      body: Column(children: [
        _TopBar(state: s, gameName: widget.gameName, onExit: () => Navigator.of(context).pop()),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView(padding: const EdgeInsets.all(16), children: [body]),
          ),
        ),
      ]),
      bottomNavigationBar: _NavBar(
        active: tab,
        orders: s.orders.length,
        onChange: (t) => setState(() => tab = t),
      ),
    );
  }

  // ---------------------------------------------------------------- Térkép
  Widget _mapTab(TnColors c, GameState s, MapDef m) {
    final sel = city == null ? null : s.city(city!);
    final def = sel == null ? null : m.city(sel.id);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      CommandPoints(available: s.me.pp, pending: s.pending.pp, max: s.me.ppMax),
      const SizedBox(height: 16),
      MapView(map: m, state: s, selected: city, onSelect: (id) => setState(() => city = id)),
      const SizedBox(height: 16),
      if (sel == null || def == null)
        Text('Koppints egy városra a térképen.', style: TnText.body(c.inkMuted))
      else
        TnCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(child: Eyebrow('${def.profile}${def.key ? ' · kulcsváros' : ''}${sel.distance != null ? ' · ${sel.distance} lépés' : ''}')),
              StabilityChip(sel.stability),
            ]),
            const SizedBox(height: 4),
            Text(sel.name, style: TnText.display(c.ink).copyWith(fontSize: 26, height: 30 / 26)),
            const SizedBox(height: 12),
            if (!sel.reachable) ...[
              const Notice(tone: 'warn', title: 'Nem vezet ide útvonalad', body: 'Akciót csak a hálózatodban lévő városban indíthatsz. Építs útvonalat egy szomszédos városból.'),
              const SizedBox(height: 12),
            ],
            for (final f in sel.factions) ...[
              InfluenceBar(view: f, legend: false, aside: ControlBadge(f.level)),
              const SizedBox(height: 12),
            ],
            if (sel.bestLevel == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text('Itt még nincs jelenléted, ezért a riválisok értékeit csak 10 pontos sávokban látod.', style: TnText.caption(c.inkMuted)),
              ),
            Wrap(alignment: WrapAlignment.end, spacing: 8, runSpacing: 8, children: [
              for (final b in s.buildable.where((b) => b.to == sel.id))
                TnButton(
                  label: 'Útvonal innen: ${b.fromName}',
                  icon: 'route',
                  busy: busy,
                  onPressed: () => _act(() => api.addOrder(s.gameId, {'type': 'route', 'from': b.from, 'to': b.to}), success: 'Parancslapra került: útvonal ${b.toName} felé.'),
                ),
              TnButton(label: 'Város megnyitása', icon: 'varos', kind: TnButtonKind.primary, onPressed: () => _openCity(sel.id)),
            ]),
          ]),
        ),
    ]);
  }

  // ---------------------------------------------------------------- Város
  Widget _cityTab(TnColors c, GameState s, MapDef m) {
    final cv = s.city(city ?? s.cities.first.id);
    final def = m.city(cv.id)!;
    final f = cv.faction(faction);
    final districts = {
      for (final fv in cv.factions) fv.faction: DistrictFlags(dominant: fv.dominantTincture, contested: fv.contestedTincture),
    };
    final ownOpen = f.segments.where((x) => x.self).fold<double>(0, (a, x) => a + x.value);

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Align(
        alignment: Alignment.centerLeft,
        child: TnButton(label: '← Térkép', kind: TnButtonKind.quiet, small: true, onPressed: () => setState(() => tab = 0)),
      ),
      Eyebrow('${def.profile}${def.key ? ' · kulcsváros' : ''}${cv.distance != null ? ' · ${cv.distance} lépés' : ''}'),
      const SizedBox(height: 4),
      Text(cv.name, style: TnText.display(c.ink)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [StabilityChip(cv.stability), ControlBadge(cv.bestLevel)]),
      const SizedBox(height: 16),
      CityViewWidget(name: cv.name, coast: def.coast, stability: cv.stability, districts: districts, selected: faction, onSelect: (x) => setState(() => faction = x)),
      const SizedBox(height: 12),
      _DistrictTabs(active: faction, onChange: (x) => setState(() => faction = x)),
      const SizedBox(height: 12),
      TnCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          InfluenceBar(view: f, aside: ControlBadge(f.level)),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: SuspicionMeter(f.suspicion)), Text('Romlás: ${cv.decayPercent}% / kör', style: TnText.caption(c.inkMuted).copyWith(fontSize: 13))]),
          if (f.ownHidden > 0) ...[
            const SizedBox(height: 8),
            Text('Saját rejtett befolyásod itt: ${num1(f.ownHidden)}. Mások ezt az „Ismeretlen” sorban látják.', style: TnText.caption(c.inkMuted)),
          ],
        ]),
      ),
      const SizedBox(height: 12),
      if (!cv.reachable)
        TnCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Notice(tone: 'warn', title: 'Nem vezet ide útvonalad', body: 'Akciót csak a hálózatodban lévő városban indíthatsz (szabálykönyv 4.3).'),
            const SizedBox(height: 12),
            for (final b in s.buildable.where((b) => b.to == cv.id))
              TnButton(
                label: 'Útvonal innen: ${b.fromName} · 1 PP · 3 A',
                icon: 'route',
                busy: busy,
                onPressed: () => _act(() => api.addOrder(s.gameId, {'type': 'route', 'from': b.from, 'to': b.to}), success: 'Parancslapra került az útvonal.'),
              ),
          ]),
        )
      else
        TnCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(child: Eyebrow('Akciók: ${districtName(faction)} · ${factionName(faction)}')),
            ]),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: hidden,
              onChanged: s.me.sealed ? null : (v) => setState(() => hidden = v),
              title: Text('Rejtett akció', style: TnText.bodyStrong(c.ink)),
              subtitle: Text('+1 PP és +50% költség. Nem ad kontrollt és Legitimitást, amíg le nem leplezed.', style: TnText.caption(c.inkMuted)),
            ),
            for (final a in s.actions.where((a) => a.factions.contains(faction))) ...[
              Divider(color: c.line, height: 24),
              _actionRow(c, s, cv, f, a, ownOpen),
            ],
          ]),
        ),
    ]);
  }

  Widget _actionRow(TnColors c, GameState s, CityView cv, FactionView f, ActionInfo a, double ownOpen) {
    final isGain = a.power > 0;
    final cost = isGain && hidden ? a.hiddenCost : a.cost;
    final needsPresence = a.needsPresence && ownOpen < 10;
    final isSmear = a.id == 'smear';
    final target = smearTarget[f.faction] ?? (f.rivals.isNotEmpty ? f.rivals.first.playerId : null);
    final disabled = s.me.sealed || needsPresence || (isSmear && target == null);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text.rich(TextSpan(children: [
            TextSpan(text: a.label, style: TnText.bodyStrong(c.ink)),
            if (isGain) TextSpan(text: ' · alaperő +${a.power.toStringAsFixed(0)}', style: TnText.body(c.inkMuted)),
          ])),
          const SizedBox(height: 4),
          Wrap(spacing: 6, runSpacing: 4, children: [
            if (cost.pp > 0) ResourceChip(kind: 'pp', value: cost.pp),
            if (cost.arany > 0) ResourceChip(kind: 'arany', value: cost.arany),
            if (cost.bp > 0) ResourceChip(kind: 'bp', value: cost.bp),
            if (cost.ke > 0) ResourceChip(kind: 'ke', value: cost.ke),
          ]),
          if (isSmear && f.rivals.isNotEmpty) ...[
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: target,
              isDense: true,
              items: [for (final r in f.rivals) DropdownMenuItem(value: r.playerId, child: Text('Célpont: ${r.name}', style: TnText.body(c.ink)))],
              onChanged: (v) => setState(() => smearTarget[f.faction] = v!),
            ),
          ],
          if (isSmear && f.rivals.isEmpty) Text('Nincs célpont ebben a frakcióban.', style: TnText.caption(c.inkMuted)),
          if (needsPresence) Text('Legalább Jelenlét (10) kell hozzá.', style: TnText.caption(c.inkMuted)),
        ]),
      ),
      const SizedBox(width: 12),
      TnButton(
        label: 'Parancslapra',
        small: true,
        kind: isSmear ? TnButtonKind.danger : TnButtonKind.normal,
        busy: busy,
        onPressed: disabled
            ? null
            : () => _act(
                  () => api.addOrder(s.gameId, {
                    'type': a.id,
                    'city': cv.id,
                    'faction': f.faction,
                    'hidden': isGain && hidden,
                    if (isSmear) 'targetId': target,
                  }),
                  success: 'Parancslapra került: ${a.label}',
                ),
      ),
    ]);
  }

  // ---------------------------------------------------------------- Parancslap
  Widget _ordersTab(TnColors c, GameState s) {
    final isAdmin = session.user?.role == 'ADMIN';
    final over = s.pending.pp > s.me.pp;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      CommandPoints(available: s.me.pp, pending: s.pending.pp, max: s.me.ppMax),
      const SizedBox(height: 16),
      TnCard(
        padding: EdgeInsets.zero,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(children: [
              Expanded(child: Text('Parancslap', style: TnText.title(c.ink).copyWith(fontSize: 18))),
              Text('${s.round}. kör', style: TnText.caption(c.inkMuted).copyWith(fontSize: 13)),
            ]),
          ),
          Divider(height: 1, color: c.line),
          if (s.orders.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Üres a parancslap. Válassz egy várost a térképen, majd egy negyedet, és adj hozzá akciót.', style: TnText.body(c.inkMuted)),
            ),
          for (final o in s.orders) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                      Text(o.label, style: TnText.bodyStrong(c.ink)),
                      if (o.hidden)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(color: c.shareUnknown, borderRadius: BorderRadius.circular(TnRadius.xs)),
                          child: Text('REJTETT', style: TnText.label(c.paperRaised).copyWith(fontSize: 11)),
                        ),
                    ]),
                    Text([o.cityLabel, if (o.faction != null) factionName(o.faction!), if (o.targetName != null) 'célpont: ${o.targetName}'].join(' · '),
                        style: TnText.caption(c.inkMuted).copyWith(fontSize: 13)),
                  ]),
                ),
                Text(_costText(o.cost), style: TnText.data(c.ink)),
                if (!s.me.sealed)
                  IconButton(
                    tooltip: '${o.label} törlése',
                    onPressed: busy ? null : () => _act(() => api.removeOrder(s.gameId, o.id)),
                    icon: TnIcon('close', size: 16, color: c.inkMuted),
                  ),
              ]),
            ),
            Divider(height: 1, color: c.line),
          ],
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 12, runSpacing: 12, children: [
              Text('${s.pending.pp} / ${s.me.pp} PP${over ? ' · túllépés' : ''}', style: TnText.data(over ? c.danger : c.ink, size: 14)),
              if (s.me.sealed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: c.sealSoft, borderRadius: BorderRadius.circular(99)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [TnIcon('pp', size: 16, color: c.seal), const SizedBox(width: 8), Text('Lepecsételve', style: TnText.bodyStrong(c.seal))]),
                )
              else
                TnButton(
                  label: 'Parancsok lepecsételése',
                  icon: 'pp',
                  kind: TnButtonKind.seal,
                  busy: busy,
                  onPressed: s.orders.isEmpty || over ? null : () => _act(() => api.seal(s.gameId), success: 'Parancsaid lepecsételve.'),
                ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      if (s.nextResolutionAt != null)
        Text('A parancsok a következő feldolgozáskor futnak le: ${hhmm(s.nextResolutionAt!)} (${remaining(s.nextResolutionAt!)} múlva). '
            'A le nem pecsételt parancsok is lefutnak.', style: TnText.caption(c.inkMuted)),
      if (s.me.sealed) ...[
        const SizedBox(height: 12),
        TnButton(label: 'Pecsét feltörése', kind: TnButtonKind.quiet, onPressed: busy ? null : () => _act(() => api.unseal(s.gameId))),
      ],
      if (isAdmin) ...[
        const SizedBox(height: 24),
        TnCard(
          borderColor: c.lineStrong,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Eyebrow('Fejlesztői eszköz (ADMIN)'),
            const SizedBox(height: 8),
            Text('A kör feldolgozása azonnal, a 8:00 / 20:00 ütemezés helyett.', style: TnText.caption(c.inkMuted)),
            const SizedBox(height: 8),
            TnButton(
              label: 'Feldolgozás most',
              icon: 'clock',
              kind: TnButtonKind.primary,
              busy: busy,
              onPressed: () async {
                await _act(() async {
                  await api.adminResolve(s.gameId);
                  return api.state(s.gameId);
                }, success: 'A ${s.round}. kör lezárult.');
                if (mounted) setState(() => tab = 3);
              },
            ),
          ]),
        ),
      ],
    ]);
  }

  static String _costText(Cost c) => [
        if (c.pp > 0) '${c.pp} PP',
        if (c.arany > 0) '${c.arany} A',
        if (c.bp > 0) '${c.bp} BP',
        if (c.ke > 0) '${c.ke} KE',
      ].join(' · ');
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state, required this.gameName, required this.onExit});
  final GameState state;
  final String gameName;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final me = state.me;
    final next = state.nextResolutionAt;
    final soon = next != null && next.difference(DateTime.now()).inMinutes <= 60;
    return Material(
      color: c.paperRaised,
      child: SafeArea(
        bottom: false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            color: c.ink,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(children: [
              InkWell(onTap: onExit, child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('← Játékok', style: TnText.bodyStrong(c.onInk).copyWith(fontSize: 12)))),
              const Spacer(),
              Flexible(child: Text(gameName, overflow: TextOverflow.ellipsis, style: TnText.caption(c.onInk.withValues(alpha: 0.75)))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 8, children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  HouseCrest(tincture: me.tincture, initial: me.houseName.characters.first, size: 24, name: me.houseName),
                  const SizedBox(width: 8),
                  Text(me.houseName, style: TnText.mapLabel(c.ink, major: true).copyWith(fontSize: 16)),
                ]),
                if (next != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: c.paperRaised, border: Border.all(color: soon ? c.seal : c.line), borderRadius: BorderRadius.circular(99)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      TnIcon('clock', size: 16, color: soon ? c.seal : c.ink),
                      const SizedBox(width: 6),
                      Text('Feldolgozás ', style: TnText.body(soon ? c.seal : c.ink).copyWith(fontSize: 13)),
                      Text(hhmm(next), style: TnText.data(soon ? c.seal : c.ink, weight: FontWeight.w600)),
                      Text(' · ${remaining(next)}', style: TnText.body(soon ? c.seal : c.inkMuted).copyWith(fontSize: 13)),
                    ]),
                  ),
              ]),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 6, children: [
                ResourceChip(kind: 'arany', value: me.arany),
                ResourceChip(kind: 'bp', value: me.bp),
                ResourceChip(kind: 'ke', value: me.ke),
                ResourceChip(kind: 'legit', value: me.legit),
              ]),
            ]),
          ),
          Divider(height: 1, color: c.line),
        ]),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.active, required this.onChange, required this.orders});
  final int active, orders;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    const items = [('terkep', 'Térkép'), ('varos', 'Város'), ('pp', 'Parancslap'), ('kem', 'Jelentések'), ('legit', 'Rangsor')];
    return Material(
      color: c.paperRaised,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: c.line))),
          height: 60,
          child: Row(children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: Semantics(
                  selected: i == active,
                  button: true,
                  label: items[i].$2,
                  child: InkWell(
                    onTap: () => onChange(i),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Stack(clipBehavior: Clip.none, children: [
                        TnIcon(items[i].$1, size: 22, color: i == active ? c.verdigris : c.inkMuted),
                        if (i == 2 && orders > 0)
                          Positioned(
                            right: -10,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(color: c.seal, borderRadius: BorderRadius.circular(99)),
                              child: Text('$orders', style: TnText.data(c.onSeal, size: 10)),
                            ),
                          ),
                      ]),
                      const SizedBox(height: 2),
                      Text(items[i].$2, style: TnText.bodyStrong(i == active ? c.verdigris : c.inkMuted).copyWith(fontSize: 11)),
                    ]),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class _DistrictTabs extends StatelessWidget {
  const _DistrictTabs({required this.active, required this.onChange});
  final String active;
  final ValueChanged<String> onChange;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
      child: Row(children: [
        for (final f in const ['nemesseg', 'kereskedok', 'katonasag'])
          Semantics(
            selected: f == active,
            button: true,
            child: InkWell(
              onTap: () => onChange(f),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: f == active ? c.verdigris : Colors.transparent))),
                child: Text(districtName(f), style: TnText.bodyStrong(f == active ? c.verdigris : c.inkMuted).copyWith(fontSize: 14)),
              ),
            ),
          ),
      ]),
    );
  }
}

class _ReportsTab extends StatefulWidget {
  const _ReportsTab({super.key, required this.gameId});
  final String gameId;
  @override
  State<_ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<_ReportsTab> {
  late final Future<List<ReportView>> _f = api.reports(widget.gameId);
  @override
  Widget build(BuildContext context) => FutureBuilder<List<ReportView>>(
        future: _f,
        builder: (ctx, snap) {
          if (snap.hasError) return Notice(tone: 'danger', title: 'Nem sikerült betölteni', body: '${snap.error}');
          if (!snap.hasData) return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
          if (snap.data!.isEmpty) return Text('Még nincs jelentés. Az első a kör feldolgozása után érkezik.', style: TnText.body(context.tn.inkMuted));
          return Column(children: [for (final r in snap.data!) ...[ReportCard(report: r), const SizedBox(height: 12)]]);
        },
      );
}

class _RankingTab extends StatefulWidget {
  const _RankingTab({super.key, required this.gameId});
  final String gameId;
  @override
  State<_RankingTab> createState() => _RankingTabState();
}

class _RankingTabState extends State<_RankingTab> {
  late final Future<List<RankRow>> _f = api.ranking(widget.gameId);
  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return FutureBuilder<List<RankRow>>(
      future: _f,
      builder: (ctx, snap) {
        if (snap.hasError) return Notice(tone: 'danger', title: 'Nem sikerült betölteni', body: '${snap.error}');
        if (!snap.hasData) return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Legitimitás', style: TnText.display(c.ink).copyWith(fontSize: 26)),
          const SizedBox(height: 12),
          TnCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              for (final r in snap.data!)
                Container(
                  color: r.self ? c.verdigrisSoft : null,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(children: [
                    SizedBox(width: 28, child: Text('${r.rank}', textAlign: TextAlign.right, style: TnText.data(c.ink))),
                    const SizedBox(width: 12),
                    HouseCrest(tincture: r.tincture, size: 18, npc: r.npc, name: r.name),
                    const SizedBox(width: 8),
                    Expanded(child: Text(r.name, style: TnText.body(c.ink))),
                    if (r.npc) Padding(padding: const EdgeInsets.only(right: 8), child: Text('NPC', style: TnText.caption(c.inkMuted))),
                    Text('${r.legit}', style: TnText.data(c.ink)),
                  ]),
                ),
            ]),
          ),
        ]);
      },
    );
  }
}
