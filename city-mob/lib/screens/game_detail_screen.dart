import 'package:flutter/material.dart';

import '../api/models.dart';
import '../app_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import '../widgets/buttons.dart';
import '../widgets/game_widgets.dart';
import '../widgets/map_view.dart';
import 'game_shell.dart';
import 'join_screen.dart';
import 'lobby_screen.dart';

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({super.key, required this.gameId});
  final String gameId;
  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  late Future<(GameDetail, MapDef)> _data = _load();
  bool _busy = false;

  Future<(GameDetail, MapDef)> _load() async {
    final d = await api.game(widget.gameId);
    final m = await api.map(d.game.mapId);
    return (d, m);
  }

  void _reload() => setState(() => _data = _load());

  Future<void> _withdraw() async {
    setState(() => _busy = true);
    try {
      await api.withdraw(widget.gameId);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jelentkezés visszavonva.')));
      _reload();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Scaffold(
      appBar: AppBar(backgroundColor: c.paperRaised, surfaceTintColor: Colors.transparent, shape: Border(bottom: BorderSide(color: c.line))),
      body: FutureBuilder<(GameDetail, MapDef)>(
        future: _data,
        builder: (ctx, snap) {
          if (snap.hasError) return Center(child: Padding(padding: const EdgeInsets.all(16), child: Notice(tone: 'danger', title: 'Nem sikerült betölteni', body: '${snap.error}')));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final (d, map) = snap.data!;
          final g = d.game;
          final canJoin = !g.joined && (g.open || (g.running && g.round <= 3)) && g.players < g.maxPlayers;
          return ListView(padding: const EdgeInsets.all(16), children: [
            Row(children: [Expanded(child: Eyebrow(g.season)), StatusChip(g)]),
            const SizedBox(height: 4),
            Text(g.name, style: TnText.display(c.ink)),
            const SizedBox(height: 16),
            MapView(map: map),
            const SizedBox(height: 16),
            TnCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _fact(c, 'Kezdés', g.startsAt != null && !g.running && !g.finished ? dateLong(g.startsAt!) : whenText(g)),
                _fact(c, 'Hossz', '${g.days} nap · ${g.roundsPerDay} kör / nap (${g.maxRounds} kör)'),
                _fact(c, 'Házak', '${g.players} / ${g.maxPlayers} játékos + ${g.npcCount} NPC-ház'),
                _fact(c, 'Városállamok', '${g.cities} · frakciók: Nemesség, Kereskedők, Katonaság'),
                _fact(c, 'Győzelem', 'A legtöbb Legitimitás a Koronázási Tanácson'),
                if (g.tags.isNotEmpty) ...[const SizedBox(height: 8), Wrap(spacing: 6, runSpacing: 6, children: [for (final t in g.tags) Tag(t)])],
              ]),
            ),
            const SizedBox(height: 16),
            if (g.joined && g.open)
              TnCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    HouseCrest(tincture: g.myHouse!.tincture, initial: g.myHouse!.houseName.characters.first, size: 26, name: g.myHouse!.houseName),
                    const SizedBox(width: 8),
                    Text(g.myHouse!.houseName, style: TnText.heading(c.ink)),
                    if (g.myHouse!.backgroundName != null) Text(' · ${g.myHouse!.backgroundName}', style: TnText.body(c.inkMuted)),
                  ]),
                  const SizedBox(height: 8),
                  Text('Jelentkeztél. A játék ${g.startsAt != null ? dateLong(g.startsAt!) : 'hamarosan'} indul, addig a jelentkezésed visszavonható.', style: TnText.body(c.inkMuted)),
                  const SizedBox(height: 12),
                  TnButton(label: 'Jelentkezés visszavonása', kind: TnButtonKind.danger, small: true, busy: _busy, onPressed: _withdraw),
                ]),
              ),
            if (g.joined && g.running)
              TnButton(
                label: 'Belépés a játékba',
                icon: 'terkep',
                kind: TnButtonKind.primary,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GameShell(gameId: g.id, mapId: g.mapId, gameName: '${g.name} · ${g.season}'))),
              ),
            if (canJoin)
              TnButton(
                label: g.running ? 'Csatlakozás a futó játékhoz' : 'Jelentkezés',
                kind: TnButtonKind.primary,
                onPressed: () async {
                  final ok = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => JoinScreen(detail: d, map: map)));
                  if (ok == true) {
                    _reload();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jelentkeztél. Értesítünk, amikor a játék indul.')));
                    }
                  }
                },
              ),
            if (!g.joined && g.open && g.players >= g.maxPlayers) const Notice(tone: 'warn', title: 'A játék betelt'),
            if (g.announced) Notice(tone: 'info', title: 'Még nem lehet jelentkezni', body: '${whenText(g)}.'),
            if (g.finished) Notice(tone: 'info', title: 'Győztes: ${g.winner ?? '–'}', body: g.myPlace == null ? null : 'A te helyezésed: ${g.myPlace}.'),
          ]);
        },
      ),
    );
  }

  Widget _fact(TnColors c, String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 112, child: Text(k.toUpperCase(), style: TnText.label(c.inkMuted).copyWith(height: 20 / 12))),
          const SizedBox(width: 12),
          Expanded(child: Text(v, style: TnText.body(c.ink))),
        ]),
      );
}
