import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/auth_interceptor.dart';
import '../../core/config.dart';

/// A Dio és a generált API-kliensek (packages/tron_api). A Firebase ID tokent az AuthInterceptor teszi rá.
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

  /// Üres interceptorlista: a generált kliens saját hitelesítő interceptorai helyett a miénk fut.
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
