import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import 'models.dart';
import 'session.dart';

/// Felhasználónak megjeleníthető hiba (a backend ProblemDetail `detail` mezője).
class ApiException implements Exception {
  ApiException(this.status, this.message);
  final int status;
  final String message;
  @override
  String toString() => message;
}

class Api {
  Api(this.session, {http.Client? client}) : _http = client ?? http.Client();
  final Session session;
  final http.Client _http;

  Uri _u(String path) => Uri.parse('${Config.apiBase}$path');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (session.token != null) 'Authorization': 'Bearer ${session.token}',
      };

  Future<dynamic> _send(Future<http.Response> Function() call) async {
    http.Response r;
    try {
      r = await call().timeout(const Duration(seconds: 20));
    } catch (_) {
      throw ApiException(0, 'Nem érem el a szervert. Ellenőrizd a kapcsolatot.');
    }
    if (r.statusCode == 401 && session.loggedIn) {
      await session.signOut();
      throw ApiException(401, 'A munkamenet lejárt. Jelentkezz be újra.');
    }
    final body = r.body.isEmpty ? null : jsonDecode(utf8.decode(r.bodyBytes));
    if (r.statusCode >= 400) {
      final msg = body is Map && body['detail'] != null ? body['detail'].toString() : 'Hiba történt (${r.statusCode}).';
      throw ApiException(r.statusCode, msg);
    }
    return body;
  }

  Future<dynamic> get(String p) => _send(() => _http.get(_u(p), headers: _headers));
  Future<dynamic> post(String p, [Object? body]) => _send(() => _http.post(_u(p), headers: _headers, body: jsonEncode(body ?? {})));
  Future<dynamic> delete(String p) => _send(() => _http.delete(_u(p), headers: _headers));

  // ---------- Hitelesítés ----------
  Future<void> _auth(String path, Map<String, dynamic> body) async {
    final j = await post(path, body) as Map<String, dynamic>;
    await session.signIn(j['token'], UserInfo.fromJson(j['user']));
  }

  Future<void> loginGoogle(String idToken) => _auth('/api/auth/google', {'idToken': idToken});
  Future<void> loginApple(String idToken, String? name) => _auth('/api/auth/apple', {'idToken': idToken, 'name': name});
  Future<void> loginDiscord(String code, String verifier, String redirectUri) =>
      _auth('/api/auth/discord', {'code': code, 'codeVerifier': verifier, 'redirectUri': redirectUri});
  Future<void> loginDev(String name) => _auth('/api/auth/dev', {'name': name});

  // ---------- Lobbi ----------
  Future<List<GameSummary>> games() async => (await get('/api/games') as List).map((e) => GameSummary.fromJson(e)).toList();
  Future<GameDetail> game(String id) async => GameDetail.fromJson(await get('/api/games/$id'));
  Future<void> join(String id, {required String houseName, required String tincture, required String background, required String startSlot}) =>
      post('/api/games/$id/join', {'houseName': houseName, 'tincture': tincture, 'background': background, 'startSlot': startSlot});
  Future<void> withdraw(String id) => delete('/api/games/$id/join');

  final Map<String, MapDef> _maps = {};
  Future<MapDef> map(String mapId) async => _maps[mapId] ??= MapDef.fromJson(await get('/api/games/maps/$mapId'));

  // ---------- Játék ----------
  Future<GameState> state(String id) async => GameState.fromJson(await get('/api/games/$id/state'));
  Future<List<ReportView>> reports(String id) async => (await get('/api/games/$id/reports') as List).map((e) => ReportView.fromJson(e)).toList();
  Future<List<RankRow>> ranking(String id) async => (await get('/api/games/$id/ranking') as List).map((e) => RankRow.fromJson(e)).toList();

  Future<GameState> addOrder(String id, Map<String, dynamic> order) async => GameState.fromJson(await post('/api/games/$id/orders', order));
  Future<GameState> removeOrder(String id, String orderId) async => GameState.fromJson(await delete('/api/games/$id/orders/$orderId'));
  Future<GameState> seal(String id) async => GameState.fromJson(await post('/api/games/$id/seal'));
  Future<GameState> unseal(String id) async => GameState.fromJson(await delete('/api/games/$id/seal'));

  // ---------- Fejlesztés (ADMIN) ----------
  Future<void> adminResolve(String id) => post('/api/admin/games/$id/resolve');
}
