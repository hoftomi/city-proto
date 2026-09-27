import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tron_api/tron_api.dart';

import '../../app/di/di.dart';
import '../../app/router/routes.dart';
import '../../domain/model/extensions.dart';
import '../../domain/model/lobby_extensions.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/game_widgets.dart';
import '../../widgets/map_view.dart';
import '../lobby/widgets/game_badges.dart';
import 'bloc/game_detail_bloc.dart';

/// Egy játék részletei: térkép, adatok, jelentkezés, visszavonás vagy belépés.
class GameDetailPage extends StatelessWidget {
  const GameDetailPage({super.key, required this.gameId});
  final String gameId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<GameDetailBloc>()..add(GameDetailStarted(gameId)), child: const _GameDetailView());
  }
}

class _GameDetailView extends StatelessWidget {
  const _GameDetailView();

  /// A jelentkezésre; ha onnan sikeresen tér vissza, a bloc frissít és üzen.
  Future<void> _join(BuildContext context, String id) async {
    final bloc = context.read<GameDetailBloc>();
    final ok = await context.push<bool>(Routes.join(id));
    if (ok == true) bloc.add(const GameDetailJoined());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return BlocListener<GameDetailBloc, GameDetailState>(
      listenWhen: (a, b) => b.notice != null && a.notice != b.notice,
      listener: (context, s) => showToast(context, s.notice!.title, body: s.notice!.body, tone: s.notice!.tone),
      child: Scaffold(
        body: TnScreen(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TnHeader(
              leading: TnButton(
                label: '← Játékok',
                kind: TnButtonKind.quiet,
                small: true,
                onPressed: () => context.canPop() ? context.pop() : context.go(Routes.lobby),
              ),
            ),
            Expanded(
              child: BlocBuilder<GameDetailBloc, GameDetailState>(builder: (context, s) {
                if (s.failure != null) {
                  return Center(
                      child: Padding(padding: const EdgeInsets.all(16), child: Notice(tone: 'danger', title: 'Nem sikerült betölteni', body: s.failure!.message)));
                }
                if (!s.ready) return const Center(child: CircularProgressIndicator());
                final g = s.game!;
                final h = g.myHouse;
                return ListView(padding: const EdgeInsets.all(16), children: [
                  Row(children: [Expanded(child: Eyebrow(g.season)), StatusChip(g)]),
                  const SizedBox(height: 4),
                  Text(g.name, style: TnText.display(c.ink)),
                  const SizedBox(height: 16),
                  MapView(map: s.map!),
                  const SizedBox(height: 16),
                  TnCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _fact(c, 'Kezdés', g.startText),
                      _fact(c, 'Hossz', '${g.days} nap · napi ${g.roundsPerDay} elszámolás (${g.maxRounds} elszámolás)'),
                      _fact(c, 'Házak', '${g.players} / ${g.maxPlayers} játékos + ${g.npcCount} NPC-ház'),
                      _fact(c, 'Városállamok', '${g.cities} · ágak: Vásártér, Városháza, Alvilág'),
                      _fact(c, 'Győzelem', 'A legtöbb Legitimitás a Koronázási Tanácson'),
                      if (g.tags.isNotEmpty) ...[const SizedBox(height: 8), Wrap(spacing: 6, runSpacing: 6, children: [for (final t in g.tags) Tag(t)])],
                    ]),
                  ),
                  const SizedBox(height: 16),
                  if (g.withdrawable && h != null) _MyHouseCard(g: g, house: h, busy: s.busy),
                  if (g.enterable)
                    TnButton(label: 'Belépés a játékba', icon: 'terkep', kind: TnButtonKind.primary, onPressed: () => context.go(Routes.map(g.id))),
                  if (g.canJoin)
                    TnButton(
                      label: g.running ? 'Csatlakozás a futó játékhoz' : 'Jelentkezés',
                      kind: TnButtonKind.primary,
                      onPressed: () => _join(context, g.id),
                    ),
                  if (g.closedFull) const Notice(tone: 'warn', title: 'A játék betelt'),
                  if (g.announced) Notice(tone: 'info', title: 'Még nem lehet jelentkezni', body: '${g.whenText}.'),
                  if (g.finished) Notice(tone: 'info', title: g.winnerText, body: g.myPlace == null ? null : 'A te helyezésed: ${g.myPlace}.'),
                ]);
              }),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _fact(TnColors c, String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 112, child: Text(k.toUpperCase(), style: TnText.eyebrow(c.inkMuted).copyWith(height: 20 / 11.5))),
          const SizedBox(width: 12),
          Expanded(child: Text(v, style: TnText.body(c.ink))),
        ]),
      );
}

/// A saját jelentkezés (a játék még nem indult): ház, háttér, visszavonás.
class _MyHouseCard extends StatelessWidget {
  const _MyHouseCard({required this.g, required this.house, required this.busy});
  final GameSummary g;
  final MyHouse house;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return TnCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          HouseCrest(tincture: house.tincture, initial: house.houseName.characters.first, size: 26, name: house.houseName),
          const SizedBox(width: 8),
          Text(house.houseName, style: TnText.bodyStrong(c.ink)),
          if (house.backgroundName != null) Text(' · ${house.backgroundName}', style: TnText.body(c.inkMuted)),
        ]),
        const SizedBox(height: 8),
        Text('Jelentkeztél. A játék ${g.startsAtText} indul, addig a jelentkezésed visszavonható.', style: TnText.body(c.inkMuted)),
        const SizedBox(height: 12),
        TnButton(
          label: 'Jelentkezés visszavonása',
          kind: TnButtonKind.danger,
          small: true,
          busy: busy,
          onPressed: () => context.read<GameDetailBloc>().add(const GameDetailWithdrawRequested()),
        ),
      ]),
    );
  }
}
