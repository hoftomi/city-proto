import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Runtime settings. Each can be overridden: `flutter run --dart-define=API_BASE=https://...`
class Config {
  static const _apiBase = String.fromEnvironment('API_BASE');

  /// From the Android emulator the host's localhost is 10.0.2.2, from the iOS simulator it's localhost.
  static String get apiBase {
    if (_apiBase.isNotEmpty) return _apiBase;
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';
  }

  /// Client ID of the Google "Web application" OAuth client (created by Firebase, google-services.json
  /// `client_type: 3`). ID tokens are issued for this audience; required on Android.
  static const googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID',
      defaultValue: '961636113755-a0ne86375jg8hti4aj9civbr88jut3bu.apps.googleusercontent.com');

  /// On iOS, the client ID of the iOS OAuth client. Defaults to iosClientId from firebase_options.dart.
  static const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  static const discordClientId = String.fromEnvironment('DISCORD_CLIENT_ID');
  static const discordRedirectUri = String.fromEnvironment('DISCORD_REDIRECT_URI', defaultValue: 'tronnelkul://auth');
  static const discordCallbackScheme = String.fromEnvironment('DISCORD_CALLBACK_SCHEME', defaultValue: 'tronnelkul');

  static bool get appleAvailable => !kIsWeb && (Platform.isIOS || Platform.isMacOS);
  static bool get discordConfigured => discordClientId.isNotEmpty;
}
