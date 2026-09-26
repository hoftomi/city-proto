import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models.dart';

/// A bejelentkezett felhasználó és a saját JWT tokenünk. A token a készülék biztonságos tárolójában marad.
class Session extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _kToken = 'tn_token', _kUser = 'tn_user';

  String? token;
  UserInfo? user;
  bool loaded = false;

  bool get loggedIn => token != null;

  Future<void> load() async {
    try {
      token = await _storage.read(key: _kToken);
      final raw = await _storage.read(key: _kUser);
      if (raw != null) user = UserInfo.fromJson(jsonDecode(raw));
    } catch (_) {
      token = null;
      user = null;
    }
    loaded = true;
    notifyListeners();
  }

  Future<void> signIn(String newToken, UserInfo u) async {
    token = newToken;
    user = u;
    await _storage.write(key: _kToken, value: newToken);
    await _storage.write(key: _kUser, value: jsonEncode(u.toJson()));
    notifyListeners();
  }

  Future<void> signOut() async {
    token = null;
    user = null;
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kUser);
    notifyListeners();
  }
}

/// Egyszerű hozzáférés a munkamenethez a widgetfából.
class SessionScope extends InheritedNotifier<Session> {
  const SessionScope({super.key, required Session session, required super.child}) : super(notifier: session);

  static Session of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<SessionScope>()!.notifier!;
  static Session read(BuildContext context) => context.getInheritedWidgetOfExactType<SessionScope>()!.notifier!;
}
