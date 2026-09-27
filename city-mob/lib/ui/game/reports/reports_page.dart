import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/di.dart';
import '../../../domain/model/game_view_extensions.dart';
import '../../../theme/tokens.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/game_widgets.dart';
import '../bloc/game_bloc.dart';
import '../widgets/game_tab_scroll.dart';
import 'bloc/reports_bloc.dart';

/// A Jelentések fül: szűrhető jelentéskártyák. A játékállapot változásait továbbadja a ReportsBlocnak,
/// amely eldönti, kell-e újratölteni.
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReportsBloc>(
      create: (c) => getIt<ReportsBloc>()..add(ReportsGameUpdated(c.read<GameBloc>().state.game)),
      child: BlocListener<GameBloc, GameViewState>(
        listenWhen: (a, b) => a.game != b.game,
        listener: (context, v) => context.read<ReportsBloc>().add(ReportsGameUpdated(v.game)),
        child: const _ReportsView(),
      ),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    final c = context.tn;
    return GameTabScroll(
      onRefresh: () => context.read<ReportsBloc>().add(const ReportsRefreshRequested()),
      child: BlocBuilder<ReportsBloc, ReportsState>(builder: (context, s) {
        if (s.status == ReportsStatus.failure) return Notice(tone: 'danger', title: 'Nem sikerült betölteni', body: s.failure?.message);
        if (s.loading) return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
        final list = s.visible;
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final f in ReportFilter.values)
              TnMiniButton(on: s.filter == f, onTap: () => context.read<ReportsBloc>().add(ReportsFilterChanged(f)), child: Text(f.label)),
          ]),
          const SizedBox(height: 12),
          if (list.isEmpty) TnCard(child: Text('Még nincs jelentés. Az első az elszámolás vagy a parancslapod lefutása után érkezik.', style: TnText.body(c.inkMuted))),
          for (final r in list) ...[ReportCard(report: r), const SizedBox(height: 12)],
        ]);
      }),
    );
  }
}
