import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

/// A bejelentkezett felhasználó (név, szerep) a készülék biztonságos tárolójában, hogy újraindításkor
/// hálózat nélkül is azonnal belépett állapotban induljon az app.
@lazySingleton
class UserLocalDataSource {
  static const _storage = FlutterSecureStorage();
  static const _key = 'tn_user';

  Future<UserDto?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      return raw == null ? null : UserDto.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(UserDto user) => _storage.write(key: _key, value: jsonEncode(user.toJson()));

  Future<void> clear() => _storage.delete(key: _key);
}
