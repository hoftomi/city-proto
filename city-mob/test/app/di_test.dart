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

/// The generated DI registration (di.config.dart) is complete: every bloc and service resolves.
void main() {
  setUpAll(configureDependencies);

  test('blocs and services resolve', () {
    expect(getIt<AuthBloc>(), same(getIt<AuthBloc>()), reason: 'AuthBloc is a singleton');
    expect(getIt<GameBloc>(), isNot(same(getIt<GameBloc>())), reason: 'GameBloc is new per game');
    for (final create in <Object Function()>[
      () => getIt<LobbyBloc>(), () => getIt<GameDetailBloc>(), () => getIt<JoinBloc>(), () => getIt<ReportsBloc>(),
      () => getIt<RankingBloc>(), () => getIt<CityService>(), () => getIt<JoinService>(),
    ]) {
      expect(create(), isNotNull);
    }
  });
}
