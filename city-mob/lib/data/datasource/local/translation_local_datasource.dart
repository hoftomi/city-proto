import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A feliratok helyi példányai: a legutóbb a szervertől kapott változat (gyorsítótár), és az app tartaléka
/// (assets/translations, tools/sync_translations.py készíti a backend fájljaiból) az első, hálózat nélküli indításhoz.
@lazySingleton
class TranslationLocalDataSource {
  TranslationLocalDataSource(this._prefs);
  final SharedPreferencesAsync _prefs;

  static String _key(String lang) => 'tn_translations_$lang';

  Future<Map<String, dynamic>?> cached(String lang) async {
    try {
      final raw = await _prefs.getString(_key(lang));
      return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> store(String lang, Map<String, dynamic> translations) => _prefs.setString(_key(lang), jsonEncode(translations));

  Future<Map<String, dynamic>> bundled(String path, String lang) async {
    try {
      return jsonDecode(await rootBundle.loadString('$path/$lang.json')) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
