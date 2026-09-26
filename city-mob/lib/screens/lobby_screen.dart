import 'package:flutter/material.dart';

import '../api/models.dart';
import '../app_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import '../widgets/buttons.dart';
import '../widgets/game_widgets.dart';
import '../widgets/tn_icon.dart';
import 'game_detail_screen.dart';
import 'game_shell.dart';

/// Játékválasztó: folyamatban lévő, új, saját és lezárult játékok.
class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});
  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late Future<List<GameSummary>> _games = api.games();
  int _tab = 0;

  void _reload() => setState(() => _games = api.games());

  Future<void> _open(GameSummary g) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => GameDetailScreen(gameId: g.id)));
    _reload();
  }

  void _enter(GameSummary g) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => GameShell(gameId: g.id, mapId: g.mapId, gameName: '${g.name} · ${g.season}')));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final user = session.user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c.paperRaised,
        surfaceTintColor: Colors.transparent,
        title: Text('Trón nélkül', style: TnText.mapLabel(c.ink, major: true).copyWith(fontSize: 18)),
        actions: [
          if (user != null) Center(child: Text(user.name, style: TnText.caption(c.inkMuted).copyWith(fontSize: 13))),
          TextButton(onPressed: () => session.signOut(), child: Text('Kilépés', style: TnText.bodyStrong(c.verdigris))),
        ],
        shape: Border(bottom: BorderSide(color: c.line)),
      ),
      body: FutureBuilder<List<GameSummary>>(
        future: _games,
        builder: (ctx, snap) {
          if (snap.hasError) return _ErrorView(message: snap.error.toString(), onRetry: _reload);
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final all = snap.data!;
          final running = all.where((g) => g.joined && g.running).toList();
          final mine = all.where((g) => g.joined && !g.finished).toList();
          final list = switch (_tab) {
            1 => mine,
            2 => all.where((g) => g.finished).toList(),
            _ => all.where((g) => (g.open || g.announced || g.running) && !g.joined).toList(),
          };
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(padding: const EdgeInsets.all(16), children: [
              if (running.isNotEmpty) ...[
                const Eyebrow('Folytasd, ahol abbahagytad'),
                const SizedBox(height: 8),
                for (final g in running) ...[
                  TnCard(
                    borderColor: c.verdigris,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Row(children: [
                        HouseCrest(tincture: g.myHouse!.tincture, initial: g.myHouse!.houseName.characters.first, size: 26, name: g.myHouse!.houseName),
                        const SizedBox(width: 8),
                        Expanded(child: Text(g.name, style: TnText.heading(c.ink))),
                        Text('${g.round}. kör / ${g.maxRounds}', style: TnText.caption(c.inkMuted)),
                      ]),
                      const SizedBox(height: 12),
                      TnButton(label: 'Belépés a játékba', icon: 'terkep', kind: TnButtonKind.primary, onPressed: () => _enter(g)),
                    ]),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
              ],
              _Tabs(active: _tab, mineCount: mine.length, onChange: (t) => setState(() => _tab = t)),
              const SizedBox(height: 16),
              if (list.isEmpty)
                Text(_tab == 1 ? 'Még nem jelentkeztél játékra. Válassz egyet az Új játékok közül.' : 'Nincs itt játék.', style: TnText.body(c.inkMuted)),
              for (final g in list) ...[_GameCard(g: g, onTap: () => _open(g)), const SizedBox(height: 12)],
            ]),
          );
        },
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.mineCount, required this.onChange});
  final int active, mineCount;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    final labels = ['Új játékok', 'Saját', 'Lezárult'];
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
      child: Row(children: [
        for (var i = 0; i < 3; i++)
          Semantics(
            selected: i == active,
            button: true,
            child: InkWell(
              onTap: () => onChange(i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: i == active ? c.verdigris : Colors.transparent, width: 2))),
                child: Row(children: [
                  Text(labels[i], style: TnText.bodyStrong(i == active ? c.verdigris : c.inkMuted).copyWith(fontSize: 14)),
                  if (i == 1 && mineCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(color: c.verdigris, borderRadius: BorderRadius.circular(99)),
                      child: Text('$mineCount', style: TnText.data(c.onVerdigris, size: 11)),
                    ),
                  ],
                ]),
              ),
            ),
          ),
      ]),
    );
  }
}

String whenText(GameSummary g) {
  if (g.running) return '${g.round}. kör / ${g.maxRounds}';
  if (g.open && g.startsAt != null) return 'Kezdés ${relativeDays(g.startsAt!)}';
  if (g.announced && g.opensAt != null) return 'Jelentkezés ${relativeDays(g.opensAt!)} nyílik';
  return 'Lezárult';
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.g, {super.key});
  final GameSummary g;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    if (g.joined && g.open) return TnChip(label: 'Jelentkeztél', icon: 'check', fg: c.onVerdigris, bg: c.verdigris);
    if (g.open && g.players / g.maxPlayers >= 0.9) return TnChip(label: 'Majdnem tele', fg: c.warn, bg: c.warnSoft);
    return switch (g.status) {
      'fut' => TnChip(label: g.round <= 3 ? 'Fut · még csatlakozhatsz' : 'Fut', fg: c.verdigris, bg: c.verdigrisSoft),
      'nyitott' => TnChip(label: 'Jelentkezés nyitva', fg: c.ok, bg: c.okSoft),
      'hamarosan' => TnChip(label: 'Hamarosan', fg: c.inkMuted),
      _ => TnChip(label: 'Lezárult', fg: c.inkMuted, bg: c.paperSunk),
    };
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.g, required this.onTap});
  final GameSummary g;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Semantics(
      button: true,
      label: '${g.name}, ${g.season}. ${whenText(g)}.',
      child: Material(
        color: c.paperRaised,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TnRadius.sm), side: BorderSide(color: c.line)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Eyebrow(g.season),
                    const SizedBox(height: 2),
                    Text(g.name, style: TnText.display(c.ink).copyWith(fontSize: 22, height: 26 / 22)),
                  ]),
                ),
                StatusChip(g),
              ]),
              const SizedBox(height: 12),
              Wrap(spacing: 16, runSpacing: 4, children: [
                _fact(c, 'clock', whenText(g)),
                _fact(c, 'terkep', '${g.days} nap · ${g.roundsPerDay} kör / nap'),
              ]),
              const SizedBox(height: 12),
              if (!g.finished)
                Row(children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(value: g.maxPlayers == 0 ? 0 : g.players / g.maxPlayers, minHeight: 6, color: c.ink, backgroundColor: c.paperSunk),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${g.players} / ${g.maxPlayers} ház', style: TnText.data(c.ink)),
                ])
              else
                Text('Győztes: ${g.winner ?? '–'}${g.myPlace != null ? ' · a te helyezésed: ${g.myPlace}.' : ''}', style: TnText.caption(c.inkMuted).copyWith(fontSize: 13)),
              if (g.myHouse != null) ...[
                const SizedBox(height: 8),
                Row(children: [
                  HouseCrest(tincture: g.myHouse!.tincture, size: 16, name: g.myHouse!.houseName),
                  const SizedBox(width: 6),
                  Text(g.myHouse!.houseName, style: TnText.bodyStrong(c.ink).copyWith(fontSize: 13)),
                ]),
              ],
              if (g.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(spacing: 6, runSpacing: 6, children: [for (final t in g.tags) Tag(t)]),
              ],
            ]),
          ),
        ),
      ),
    );
  }

  Widget _fact(TnColors c, String icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
        TnIcon(icon, size: 15, color: c.inkMuted),
        const SizedBox(width: 6),
        Text(text, style: TnText.body(c.inkMuted).copyWith(fontSize: 14)),
      ]);
}

class Tag extends StatelessWidget {
  const Tag(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(color: c.paperSunk, borderRadius: BorderRadius.circular(TnRadius.xs)),
      child: Text(text, style: TnText.bodyStrong(c.inkMuted).copyWith(fontSize: 12)),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Notice(tone: 'danger', title: 'Nem sikerült betölteni', body: message),
            const SizedBox(height: 12),
            TnButton(label: 'Újra', onPressed: onRetry),
          ]),
        ),
      );
}
