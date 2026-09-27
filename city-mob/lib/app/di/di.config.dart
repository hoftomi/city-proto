// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tron_api/tron_api.dart' as _i200;

import '../../core/auth_interceptor.dart' as _i988;
import '../../core/session_events.dart' as _i325;
import '../../data/datasource/auth/identity_datasource.dart' as _i948;
import '../../data/datasource/local/user_local_datasource.dart' as _i809;
import '../../data/datasource/remote/remote_datasources.dart' as _i931;
import '../../data/repository/repositories.dart' as _i280;
import '../../domain/service/auth_service.dart' as _i657;
import '../../domain/service/city_service.dart' as _i77;
import '../../domain/service/game_service.dart' as _i566;
import '../../domain/service/join_service.dart' as _i360;
import '../../domain/service/lobby_service.dart' as _i978;
import '../../ui/auth/bloc/auth_bloc.dart' as _i842;
import '../../ui/game/bloc/game_bloc.dart' as _i136;
import '../../ui/game/ranking/bloc/ranking_bloc.dart' as _i561;
import '../../ui/game/reports/bloc/reports_bloc.dart' as _i295;
import '../../ui/game_detail/bloc/game_detail_bloc.dart' as _i653;
import '../../ui/join/bloc/join_bloc.dart' as _i349;
import '../../ui/lobby/bloc/lobby_bloc.dart' as _i805;
import 'network_module.dart' as _i567;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i325.SessionEvents>(
      () => _i325.SessionEvents(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i948.IdentityDataSource>(
      () => _i948.IdentityDataSource(),
    );
    gh.lazySingleton<_i809.UserLocalDataSource>(
      () => _i809.UserLocalDataSource(),
    );
    gh.lazySingleton<_i77.CityService>(() => _i77.CityService());
    gh.lazySingleton<_i988.AuthInterceptor>(
      () => _i988.AuthInterceptor(
        gh<_i948.IdentityDataSource>(),
        gh<_i325.SessionEvents>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i988.AuthInterceptor>()),
    );
    gh.lazySingleton<_i200.TronApi>(
      () => networkModule.tronApi(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i200.AuthApi>(
      () => networkModule.authApi(gh<_i200.TronApi>()),
    );
    gh.lazySingleton<_i200.LobbyApi>(
      () => networkModule.lobbyApi(gh<_i200.TronApi>()),
    );
    gh.lazySingleton<_i200.GameApi>(
      () => networkModule.gameApi(gh<_i200.TronApi>()),
    );
    gh.lazySingleton<_i200.AdminApi>(
      () => networkModule.adminApi(gh<_i200.TronApi>()),
    );
    gh.lazySingleton<_i931.GameRemoteDataSource>(
      () =>
          _i931.GameRemoteDataSource(gh<_i200.GameApi>(), gh<_i200.AdminApi>()),
    );
    gh.lazySingleton<_i931.LobbyRemoteDataSource>(
      () => _i931.LobbyRemoteDataSource(gh<_i200.LobbyApi>()),
    );
    gh.lazySingleton<_i280.LobbyRepository>(
      () => _i280.LobbyRepository(gh<_i931.LobbyRemoteDataSource>()),
    );
    gh.lazySingleton<_i280.MapRepository>(
      () => _i280.MapRepository(gh<_i931.LobbyRemoteDataSource>()),
    );
    gh.lazySingleton<_i931.AuthRemoteDataSource>(
      () => _i931.AuthRemoteDataSource(gh<_i200.AuthApi>()),
    );
    gh.lazySingleton<_i280.GameRepository>(
      () => _i280.GameRepository(gh<_i931.GameRemoteDataSource>()),
    );
    gh.lazySingleton<_i280.AuthRepository>(
      () => _i280.AuthRepository(
        gh<_i948.IdentityDataSource>(),
        gh<_i931.AuthRemoteDataSource>(),
        gh<_i809.UserLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i566.GameService>(
      () => _i566.GameService(
        gh<_i280.GameRepository>(),
        gh<_i280.MapRepository>(),
      ),
    );
    gh.lazySingleton<_i978.LobbyService>(
      () => _i978.LobbyService(
        gh<_i280.LobbyRepository>(),
        gh<_i280.MapRepository>(),
      ),
    );
    gh.lazySingleton<_i360.JoinService>(
      () => _i360.JoinService(gh<_i978.LobbyService>()),
    );
    gh.lazySingleton<_i657.AuthService>(
      () => _i657.AuthService(
        gh<_i280.AuthRepository>(),
        gh<_i325.SessionEvents>(),
      ),
    );
    gh.factory<_i653.GameDetailBloc>(
      () => _i653.GameDetailBloc(
        gh<_i978.LobbyService>(),
        gh<_i360.JoinService>(),
      ),
    );
    gh.factory<_i349.JoinBloc>(() => _i349.JoinBloc(gh<_i360.JoinService>()));
    gh.factory<_i136.GameBloc>(() => _i136.GameBloc(gh<_i566.GameService>()));
    gh.factory<_i561.RankingBloc>(
      () => _i561.RankingBloc(gh<_i566.GameService>()),
    );
    gh.factory<_i295.ReportsBloc>(
      () => _i295.ReportsBloc(gh<_i566.GameService>()),
    );
    gh.lazySingleton<_i842.AuthBloc>(
      () => _i842.AuthBloc(gh<_i657.AuthService>()),
    );
    gh.factory<_i805.LobbyBloc>(
      () => _i805.LobbyBloc(gh<_i978.LobbyService>(), gh<_i842.AuthBloc>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i567.NetworkModule {}
