import 'package:easy_localization/easy_localization.dart';
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
        if (s.status == RankingStatus.failure) return Notice(tone: 'danger', title: 'ranking.load_failed'.tr(), body: s.failure?.message.text);
        if (s.loading) return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Eyebrow(s.caption.text),
          const SizedBox(height: 4),
          Text('ranking.title'.tr(), style: TnText.display(c.ink).copyWith(fontSize: 26, height: 30 / 26)),
          const SizedBox(height: 12),
          MiniTable(
            cols: [
              const Col('#', flex: 1, right: true),
              Col('ranking.col.house'.tr(), flex: 7),
              Col('ranking.col.shares'.tr(), flex: 2, right: true),
              Col('ranking.col.seats'.tr(), flex: 2, right: true),
              Col('ranking.col.legit'.tr(), flex: 2, right: true),
            ],
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
                      Flexible(child: Text(r.self ? 'ranking.self'.tr(namedArgs: {'name': r.name}) : r.name, overflow: TextOverflow.ellipsis, style: TnText.body(c.ink))),
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
              Eyebrow('ranking.popularity.title'.tr()),
              const SizedBox(height: 8),
              MiniTable(
                cols: [
                  Col('ranking.popularity.city'.tr(), flex: 5),
                  Col('ranking.popularity.pop'.tr(), flex: 4, right: true),
                  Col('ranking.popularity.seats'.tr(), flex: 4, right: true),
                ],
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
              Text('ranking.hint'.tr(), style: TnText.caption(c.inkMuted)),
            ]),
          ),
        ]);
      }),
    );
  }
}
