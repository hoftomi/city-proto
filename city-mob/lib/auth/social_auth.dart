import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../api/api_client.dart';
import '../config.dart';

/// Közösségi bejelentkezés. A kliens csak a szolgáltatói azonosítót szerzi meg; az ellenőrzést és a
/// saját munkamenet-token kiadását a backend végzi (/api/auth/*).
class SocialAuth {
  SocialAuth(this.api);
  final Api api;

  static bool get appleAvailable => !kIsWeb && (Platform.isIOS || Platform.isMacOS);
  static bool get googleConfigured => Config.googleServerClientId.isNotEmpty;
  static bool get discordConfigured => Config.discordClientId.isNotEmpty;

  bool _googleReady = false;

  Future<void> google() async {
    if (!googleConfigured) throw ApiException(0, 'A Google-belépés nincs beállítva (GOOGLE_SERVER_CLIENT_ID).');
    final g = GoogleSignIn.instance;
    if (!_googleReady) {
      await g.initialize(
        serverClientId: Config.googleServerClientId,
        clientId: Config.googleIosClientId.isEmpty ? null : Config.googleIosClientId,
      );
      _googleReady = true;
    }
    final account = await g.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) throw ApiException(0, 'A Google nem adott azonosító tokent.');
    await api.loginGoogle(idToken);
  }

  Future<void> apple() async {
    final cred = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );
    final token = cred.identityToken;
    if (token == null) throw ApiException(0, 'Az Apple nem adott azonosító tokent.');
    final name = [cred.givenName, cred.familyName].where((e) => e != null && e.isNotEmpty).join(' ');
    await api.loginApple(token, name.isEmpty ? null : name);
  }

  /// Discord: OAuth 2.0 authorization code + PKCE a rendszerböngészőben.
  Future<void> discord() async {
    if (!discordConfigured) throw ApiException(0, 'A Discord-belépés nincs beállítva (DISCORD_CLIENT_ID).');
    final verifier = _randomString(64);
    final challenge = base64Url.encode(sha256.convert(ascii.encode(verifier)).bytes).replaceAll('=', '');
    final state = _randomString(24);
    final url = Uri.https('discord.com', '/oauth2/authorize', {
      'client_id': Config.discordClientId,
      'response_type': 'code',
      'redirect_uri': Config.discordRedirectUri,
      'scope': 'identify email',
      'code_challenge': challenge,
      'code_challenge_method': 'S256',
      'state': state,
      'prompt': 'none',
    });
    final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: Config.discordCallbackScheme);
    final params = Uri.parse(result).queryParameters;
    if (params['state'] != state) throw ApiException(0, 'A Discord-válasz nem ehhez a belépéshez tartozik.');
    final code = params['code'];
    if (code == null) throw ApiException(0, 'A Discord-belépés megszakadt.');
    await api.loginDiscord(code, verifier, Config.discordRedirectUri);
  }

  static String _randomString(int n) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final r = Random.secure();
    return List.generate(n, (_) => chars[r.nextInt(chars.length)]).join();
  }
}
