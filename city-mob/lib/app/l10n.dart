import 'package:flutter/widgets.dart';

/// A támogatott nyelvek. A feliratok a backendről jönnek (resources/i18n/`<nyelv>`); új nyelvhez ott kell
/// felvenni a mappát, és ide a nyelvet.
class L10n {
  static const hu = Locale('hu');
  static const supported = [hu];

  /// Az app tartalék feliratai (tools/sync_translations.py).
  static const path = 'assets/translations';
}
