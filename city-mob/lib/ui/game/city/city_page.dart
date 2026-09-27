import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/di.dart';
import '../../../app/router/routes.dart';
import '../../../domain/model/city_extensions.dart';
import '../../../domain/model/extensions.dart';
import '../../../domain/service/city_service.dart';
import '../../../theme/tokens.dart';
import '../../../util/format.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/city_view.dart';
import '../../../widgets/game_widgets.dart';
import '../bloc/game_bloc.dart';
import '../widgets/game_tab_scroll.dart';
import 'bloc/city_bloc.dart';
import 'widgets/city_common.dart';
import 'widgets/city_dialogs.dart';
import 'widgets/market_section.dart';
import 'widgets/town_hall_section.dart';
import 'widgets/underworld_section.dart';

/// A városnézet: fejléc, látkép, és a három negyed (Vásártér, Városháza, Alvilág).
/// A város ([cityId]) és a negyed ([district]) az URL lekérdezési paramétere; a negyedváltás és a „← Térkép”
/// navigáció. A CityBloc városonként új (a kulcs a város), a negyed minden buildnél a paraméterből jön.
class CityPage extends StatelessWidget {
  const CityPage({super.key, this.cityId, this.district});
  final String? cityId, district;

  @override
  Widget build(BuildContext context) => BlocProvider(
        key: ValueKey('city/$cityId'),
        create: (context) => CityBloc(context.read<GameBloc>(), getIt<CityService>())..add(CityStarted(cityId)),
        child: _CityView(district: cityDistrict(district)),
      );
}

class _CityView extends StatelessWidget {
  const _CityView({required this.district});
  final String district;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CityBloc, CityState>(
          listenWhen: (a, b) => b.notice != null && a.notice != b.notice,
          listener: (context, s) => showToast(context, s.notice!.title.text, body: s.notice!.body?.text, tone: s.notice!.tone),
        ),
        BlocListener<CityBloc, CityState>(
          listenWhen: (a, b) => !a.moveSpyOpen && b.moveSpyOpen,
          listener: (context, s) => showCityDialog(context, const MoveSpyDialog()),
        ),
        BlocListener<CityBloc, CityState>(
          listenWhen: (a, b) => a.sale == null && b.sale != null,
          listener: (context, s) => showCityDialog(context, const IntelSaleDialog()),
        ),
      ],
      child: BlocBuilder<CityBloc, CityState>(
        builder: (context, s) {
          if (!s.ready) return const Center(child: CircularProgressIndicator());
          return GameTabScroll(
            child: _CityBody(s: s, district: district),
          );
        },
      ),
    );
  }
}

class _CityBody extends StatelessWidget {
  const _CityBody({required this.s, required this.district});
  final CityState s;
  final String district;

  static const _art = {'keresk': 'vasarter', 'polit': 'varoshaza', 'kem': 'alvilag'};

  @override
  Widget build(BuildContext context) {
    final c = context.tn, cv = s.city!;
    void openDistrict(String d) => context.go(Routes.city(s.gameId!, cityId: s.cityId, district: d));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TnButton(label: 'city.back_to_map'.tr(), kind: TnButtonKind.quiet, small: true, onPressed: () => context.go(Routes.map(s.gameId!))),
        ),
        const SizedBox(height: 6),
        Eyebrow(
          [
            cv.profile,
            if (cv.key) 'city.key_city'.tr(),
            if (s.can && cv.distance != null) 'city.distance'.tr(namedArgs: {'n': '${cv.distance}'}),
            if (!s.can) 'city.unreachable_tag'.tr(),
          ].join(' · '),
        ),
        const SizedBox(height: 4),
        Text(cv.name, style: TnText.display(c.ink)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final x in s.stats) StatChip(label: x.label.text, value: x.value.text, suffix: x.suffix?.text, tone: x.tone, art: x.art)],
        ),
        const SizedBox(height: 16),
        CityViewWidget(
          name: cv.name,
          coast: cv.coast,
          districts: {for (final e in s.dominants.entries) e.key: DistrictFlags(dominant: e.value)},
          selected: district,
          onSelect: openDistrict,
        ),
        const SizedBox(height: 16),
        TnTabs(
          expand: true,
          active: district,
          onChange: openDistrict,
          tabs: [for (final f in cityDistricts) TnTabItem(f, districtName(f), art: _art[f], tone: _art[f])],
        ),
        const SizedBox(height: 16),
        if (!s.can) ...[_Unreachable(s: s), gap()],
        switch (district) {
          'polit' => TownHallSection(s: s),
          'kem' => UnderworldSection(s: s),
          _ => MarketSection(s: s),
        },
      ],
    );
  }
}

/// Nem elérhető város: nézni lehet, cselekedni nem; útvonal építhető ide.
class _Unreachable extends StatelessWidget {
  const _Unreachable({required this.s});
  final CityState s;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CityBloc>();
    return TnCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Notice(tone: 'warn', title: 'city.unreachable.title'.tr(), body: 'city.unreachable.body'.tr()),
          for (final b in s.routes) ...[
            gap(8),
            TnButton(
              label: 'city.unreachable.route'.tr(namedArgs: {'from': b.fromName, 'pp': '${s.catalog.pp('route')}', 'gold': '${s.rules.routeCost}'}),
              art: 'route',
              busy: s.busy,
              onPressed: () => bloc.add(CityRouteRequested(b.from)),
            ),
          ],
        ],
      ),
    );
  }
}
