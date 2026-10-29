import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/auth_interceptor.dart';
import '../../core/config.dart';

/// Dio and the generated API clients (packages/tron_api). The Firebase ID token is attached by AuthInterceptor.
@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(AuthInterceptor auth) => Dio(BaseOptions(
        baseUrl: Config.apiBase,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ))
        ..interceptors.add(auth);

  /// Empty interceptor list: ours runs instead of the generated client's own auth interceptors.
  @lazySingleton
  TronApi tronApi(Dio dio) => TronApi(dio: dio, interceptors: const []);

  @lazySingleton
  AuthApi authApi(TronApi api) => api.getAuthApi();

  @lazySingleton
  LobbyApi lobbyApi(TronApi api) => api.getLobbyApi();

  @lazySingleton
  GameApi gameApi(TronApi api) => api.getGameApi();

  @lazySingleton
  AdminApi adminApi(TronApi api) => api.getAdminApi();

  @lazySingleton
  I18nApi i18nApi(TronApi api) => api.getI18nApi();

  @lazySingleton
  SharedPreferencesAsync get preferences => SharedPreferencesAsync();
}
