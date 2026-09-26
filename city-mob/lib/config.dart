import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Futásidejű beállítások. Mindegyik felülírható: `flutter run --dart-define=API_BASE=https://...`
class Config {
  static const _apiBase = String.fromEnvironment('API_BASE');

  /// Android emulátorból a gép localhostja 10.0.2.2, iOS szimulátorból localhost.
  static String get apiBase {
    if (_apiBase.isNotEmpty) return _apiBase;
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';
  }

  /// A Google „Web application” típusú OAuth kliens azonosítója: ehhez a célközönséghez kapunk ID tokent.
  static const googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

  /// iOS-en az iOS típusú OAuth kliens azonosítója.
  static const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  static const discordClientId = String.fromEnvironment('DISCORD_CLIENT_ID');
  static const discordRedirectUri = String.fromEnvironment('DISCORD_REDIRECT_URI', defaultValue: 'tronnelkul://auth');
  static const discordCallbackScheme = String.fromEnvironment('DISCORD_CALLBACK_SCHEME', defaultValue: 'tronnelkul');

  /// Fejlesztői belépés szolgáltató nélkül (a backenden is engedélyezni kell: DEV_LOGIN=true).
  static const devLogin = bool.fromEnvironment('DEV_LOGIN', defaultValue: kDebugMode);
}
