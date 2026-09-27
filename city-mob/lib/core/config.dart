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

  /// A Google „Web application” típusú OAuth kliens azonosítója (a Firebase hozta létre, google-services.json
  /// `client_type: 3`). Ehhez a célközönséghez kapunk ID tokent; Androidon kötelező.
  static const googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID',
      defaultValue: '961636113755-a0ne86375jg8hti4aj9civbr88jut3bu.apps.googleusercontent.com');

  /// iOS-en az iOS típusú OAuth kliens azonosítója. Alapból a firebase_options.dart iosClientId értéke.
  static const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  static const discordClientId = String.fromEnvironment('DISCORD_CLIENT_ID');
  static const discordRedirectUri = String.fromEnvironment('DISCORD_REDIRECT_URI', defaultValue: 'tronnelkul://auth');
  static const discordCallbackScheme = String.fromEnvironment('DISCORD_CALLBACK_SCHEME', defaultValue: 'tronnelkul');

  static bool get appleAvailable => !kIsWeb && (Platform.isIOS || Platform.isMacOS);
  static bool get discordConfigured => discordClientId.isNotEmpty;
}
