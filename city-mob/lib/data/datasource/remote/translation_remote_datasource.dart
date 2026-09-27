import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

/// A feliratok a backendről (GET /api/i18n/{lang}, bejelentkezés nélkül).
@lazySingleton
class TranslationRemoteDataSource {
  TranslationRemoteDataSource(this._api);
  final I18nApi _api;

  Future<Map<String, dynamic>> translations(String lang) async => Map<String, dynamic>.from((await _api.getTranslations(lang: lang)).data!);
}
