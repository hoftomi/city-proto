import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/app/di/di.dart';
import 'package:tron_nelkul/domain/service/city_service.dart';
import 'package:tron_nelkul/domain/service/join_service.dart';
import 'package:tron_nelkul/ui/auth/bloc/auth_bloc.dart';
import 'package:tron_nelkul/ui/game/bloc/game_bloc.dart';
import 'package:tron_nelkul/ui/game/ranking/bloc/ranking_bloc.dart';
import 'package:tron_nelkul/ui/game/reports/bloc/reports_bloc.dart';
import 'package:tron_nelkul/ui/game_detail/bloc/game_detail_bloc.dart';
import 'package:tron_nelkul/ui/join/bloc/join_bloc.dart';
import 'package:tron_nelkul/ui/lobby/bloc/lobby_bloc.dart';

/// A generált DI-regisztráció (di.config.dart) teljes: minden bloc és service feloldható.
void main() {
  setUpAll(configureDependencies);

  test('a blocok és a service-ek feloldhatók', () {
    expect(getIt<AuthBloc>(), same(getIt<AuthBloc>()), reason: 'az AuthBloc egyetlen példány');
    expect(getIt<GameBloc>(), isNot(same(getIt<GameBloc>())), reason: 'a GameBloc játékonként új');
    for (final create in <Object Function()>[
      () => getIt<LobbyBloc>(), () => getIt<GameDetailBloc>(), () => getIt<JoinBloc>(), () => getIt<ReportsBloc>(),
      () => getIt<RankingBloc>(), () => getIt<CityService>(), () => getIt<JoinService>(),
    ]) {
      expect(create(), isNotNull);
    }
  });
}
