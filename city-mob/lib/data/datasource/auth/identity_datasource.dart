import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/config.dart';
import '../../../core/failure.dart';
import '../../../core/tr.dart';
import '../../../firebase_options.dart';

/// A Discord PKCE-folyamatának eredménye: a kód, amelyet a backend vált be.
class DiscordCode {
  const DiscordCode(this.code, this.verifier, this.redirectUri);
  final String code, verifier, redirectUri;
}

/// Az identitásszolgáltatók (Firebase, Google, Apple, Discord) SDK-jai. Hibánál [Failure]-t dob;
/// a felhasználó által megszakított belépésnél `false`-t ad vissza.
@lazySingleton
class IdentityDataSource {
  FirebaseAuth get _fb => FirebaseAuth.instance;
  bool _googleReady = false;

  bool get signedIn => _fb.currentUser != null;

  /// A Firebase ID tokenje; lejárat előtt magától megújul.
  Future<String?> idToken() async => _fb.currentUser?.getIdToken();

  Future<bool> signInWithGoogle() async {
    final g = GoogleSignIn.instance;
    if (!_googleReady) {
      final iosClientId = Config.googleIosClientId.isNotEmpty ? Config.googleIosClientId : DefaultFirebaseOptions.currentPlatform.iosClientId;
      await g.initialize(
        serverClientId: Config.googleServerClientId.isEmpty ? null : Config.googleServerClientId,
        clientId: !kIsWeb && Platform.isIOS ? iosClientId : null,
      );
      _googleReady = true;
    }
    final GoogleSignInAccount account;
    try {
      account = await g.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return false;
      if (e.code == GoogleSignInExceptionCode.clientConfigurationError) {
        throw const Failure(Tr('auth.google_not_configured'));
      }
      throw const Failure(Tr('auth.google_failed'));
    }
    final idToken = account.authentication.idToken;
    if (idToken == null) throw const Failure(Tr('auth.google_no_token'));
    await _firebase(() => _fb.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken)));
    return true;
  }

  Future<bool> signInWithApple() async {
    // A Firebase a nonce eredeti értékét kéri, az Apple a SHA-256 kivonatát.
    final rawNonce = _randomString(32);
    final AuthorizationCredentialAppleID cred;
    try {
      cred = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: sha256.convert(utf8.encode(rawNonce)).toString(),
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return false;
      throw const Failure(Tr('auth.apple_failed'));
    }
    final token = cred.identityToken;
    if (token == null) throw const Failure(Tr('auth.apple_no_token'));
    // Az Apple a nevet csak az első belépéskor adja át: a Firebase-fiókba mentjük, így az ID tokenben is ott lesz.
    final name = [cred.givenName, cred.familyName].where((e) => e != null && e.isNotEmpty).join(' ');
    await _firebase(() async {
      final result = await _fb.signInWithCredential(
          OAuthProvider('apple.com').credential(idToken: token, rawNonce: rawNonce, accessToken: cred.authorizationCode));
      final user = result.user;
      if (user != null && name.isNotEmpty && (user.displayName ?? '').isEmpty) {
        await user.updateDisplayName(name);
        await user.getIdToken(true);
      }
      return result;
    });
    return true;
  }

  /// Discord: OAuth 2.0 authorization code + PKCE a rendszerböngészőben. null, ha a felhasználó megszakította.
  Future<DiscordCode?> discordCode() async {
    if (!Config.discordConfigured) throw const Failure(Tr('auth.discord_not_configured'));
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
    final String result;
    try {
      result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: Config.discordCallbackScheme);
    } catch (_) {
      return null;
    }
    final params = Uri.parse(result).queryParameters;
    if (params['state'] != state) throw const Failure(Tr('auth.discord_state_mismatch'));
    final code = params['code'];
    if (code == null) return null;
    return DiscordCode(code, verifier, Config.discordRedirectUri);
  }

  Future<void> signInWithCustomToken(String token) => _firebase(() => _fb.signInWithCustomToken(token));

  Future<void> signOut() => _fb.signOut();

  Future<UserCredential> _firebase(Future<UserCredential> Function() f) async {
    try {
      return await f();
    } on FirebaseAuthException catch (e) {
      throw Failure(Tr(switch (e.code) {
        'network-request-failed' => 'auth.network',
        'user-disabled' => 'auth.disabled',
        'account-exists-with-different-credential' => 'auth.account_exists',
        _ => 'auth.failed',
      }));
    }
  }

  static String _randomString(int n) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final r = Random.secure();
    return List.generate(n, (_) => chars[r.nextInt(chars.length)]).join();
  }
}
