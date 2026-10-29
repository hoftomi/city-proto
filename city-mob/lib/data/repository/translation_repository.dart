import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../datasource/local/translation_local_datasource.dart';
import '../datasource/remote/translation_remote_datasource.dart';

/// The easy_localization loader (modelled on ktk's TranslationRepository): every label comes from the backend.
/// Order: the server's fresh version (and we save it); if unreachable, the last saved one; finally the app fallback.
/// In the deep-merged result the fresher source overrides the older, so missing keys aren't empty either.
@lazySingleton
class TranslationRepository extends AssetLoader {
  TranslationRepository(this._remote, this._local);
  final TranslationRemoteDataSource _remote;
  final TranslationLocalDataSource _local;

  static const timeout = Duration(seconds: 6);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final lang = locale.languageCode;
    final result = await _local.bundled(path, lang);
    final server = await _fromServer(lang);
    final newest = server ?? await _local.cached(lang);
    if (newest != null) _merge(result, newest);
    return result;
  }

  Future<Map<String, dynamic>?> _fromServer(String lang) async {
    try {
      final t = await _remote.translations(lang).timeout(timeout);
      if (t.isEmpty) return null;
      await _local.store(lang, t);
      return t;
    } catch (_) {
      return null;
    }
  }

  static void _merge(Map<String, dynamic> into, Map<String, dynamic> from) {
    from.forEach((k, v) {
      final cur = into[k];
      if (v is Map && cur is Map<String, dynamic>) {
        _merge(cur, Map<String, dynamic>.from(v));
      } else {
        into[k] = v is Map ? Map<String, dynamic>.from(v) : v;
      }
    });
  }
}
