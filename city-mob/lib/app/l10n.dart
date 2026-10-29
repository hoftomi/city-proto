import 'package:flutter/widgets.dart';

/// Supported languages. Labels come from the backend (resources/i18n/`<lang>`); for a new language, add the folder
/// there and the language here.
class L10n {
  static const hu = Locale('hu');
  static const supported = [hu];

  /// The app's fallback labels (tools/sync_translations.py).
  static const path = 'assets/translations';
}
