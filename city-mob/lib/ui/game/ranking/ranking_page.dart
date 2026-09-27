import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/di.dart';
import '../../../theme/tokens.dart';
import '../../../widgets/game_widgets.dart';
import '../bloc/game_bloc.dart';
import '../widgets/game_tab_scroll.dart';
import 'bloc/ranking_bloc.dart';

/// A Rangsor fül: legitimitás-rangsor és a saját népszerűség városonként. A játékállapot változásait
/// továbbadja a RankingBlocnak, amely eldönti, kell-e újratölteni.
class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RankingBloc>(
      create: (c) => getIt<RankingBloc>()..add(RankingGameUpdated(c.read<GameBloc>().state.game)),
      child: BlocListener<GameBloc, GameViewState>(
        listenWhen: (a, b) => a.game != b.game,
        listener: (context, v) => context.read<RankingBloc>().add(RankingGameUpdated(v.game)),
        child: const _RankingView(),
      ),
    );
  }
}

class _RankingView extends StatelessWidget {
  const _RankingView();

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return GameTabScroll(
      onRefresh: () => context.read<RankingBloc>().add(const RankingRefreshRequested()),
      child: BlocBuilder<RankingBloc, RankingState>(builder: (context, s) {
        if (s.status == RankingStatus.failure) return Notice(tone: 'danger', title: 'Nem sikerült betölteni', body: s.failure?.message);
        if (s.loading) return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Eyebrow(s.caption),
          const SizedBox(height: 4),
          Text('Legitimitás', style: TnText.display(c.ink).copyWith(fontSize: 26, height: 30 / 26)),
          const SizedBox(height: 12),
          MiniTable(
            cols: const [Col('#', flex: 1, right: true), Col('Ház', flex: 7), Col('Rész.', flex: 2, right: true), Col('Hely', flex: 2, right: true), Col('L', flex: 2, right: true)],
            selfRows: s.selfRows,
            rows: [
              for (final r in s.rows)
                [
                  Text('${r.rank}', style: TnText.data(c.ink)),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(children: [
                      HouseCrest(tincture: r.tincture, size: 18, npc: r.npc, name: r.name),
                      const SizedBox(width: 8),
                      Flexible(child: Text(r.self ? '${r.name} (te)' : r.name, overflow: TextOverflow.ellipsis, style: TnText.body(c.ink))),
                    ]),
                  ),
                  Text('${r.shares}', style: TnText.data(c.ink)),
                  Text('${r.seats}', style: TnText.data(c.ink)),
                  Text('${r.legit}', style: TnText.data(c.ink, weight: FontWeight.w900)),
                ],
            ],
          ),
          const SizedBox(height: 16),
          TnCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Eyebrow('Népszerűséged'),
              const SizedBox(height: 8),
              MiniTable(
                cols: const [Col('Város', flex: 5), Col('Népszerűség', flex: 4, right: true), Col('Tanácshely', flex: 4, right: true)],
                rows: [
                  for (final p in s.popularity)
                    [
                      Text(p.name, style: TnText.body(c.ink)),
                      Text('${p.pop}', style: TnText.data(c.ink)),
                      Text('${p.seats}', style: TnText.data(c.ink)),
                    ],
                ],
              ),
              const SizedBox(height: 8),
              Text('Legitimitás elszámolásonként: tanácshelyenként +1, többség +3, legtöbb eladás +2, legnépszerűbb +2 városonként.', style: TnText.caption(c.inkMuted)),
            ]),
          ),
        ]);
      }),
    );
  }
}
