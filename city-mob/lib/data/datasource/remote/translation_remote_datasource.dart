import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

/// Labels from the backend (GET /api/i18n/{lang}, no sign-in needed).
@lazySingleton
class TranslationRemoteDataSource {
  TranslationRemoteDataSource(this._api);
  final I18nApi _api;

  Future<Map<String, dynamic>> translations(String lang) async => Map<String, dynamic>.from((await _api.getTranslations(lang: lang)).data!);
}
