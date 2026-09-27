import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Minden felirat a backendről jön: a kódban használt összes fordítási kulcs szerepel a backend feliratai között
/// (assets/translations/hu.json = a backend resources/i18n/hu fájljai, tools/sync_translations.py).
void main() {
  final translations = jsonDecode(File('assets/translations/hu.json').readAsStringSync()) as Map<String, dynamic>;

  bool has(String key) {
    dynamic node = translations;
    for (final part in key.split('.')) {
      if (node is! Map || !node.containsKey(part)) return false;
      node = node[part];
    }
    return node is String;
  }

  test('a tartalék naprakész a backend fájljaihoz képest', () {
    final dir = Directory('../tron-nelkul/backend/src/main/resources/i18n/hu');
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
    for (final f in files) {
      final ns = f.uri.pathSegments.last.replaceAll('.json', '');
      expect(translations[ns], jsonDecode(f.readAsStringSync()), reason: 'futtasd: python3 tools/sync_translations.py ($ns)');
    }
  });

  test('a kódban használt kulcsok mind léteznek', () {
    // Két alak: 'ns.key'.tr(…)  és  Tr('ns.key'…); a $-t tartalmazó, dinamikus kulcsokat kihagyjuk
    final patterns = [RegExp(r"'([a-z_]+(?:\.[a-z0-9_]+)+)'\s*\.tr\("), RegExp(r"\bTr\(\s*'([a-z_]+(?:\.[a-z0-9_]+)+)'")];
    final missing = <String>{};
    var used = 0;
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'))) {
      final src = f.readAsStringSync();
      for (final p in patterns) {
        for (final m in p.allMatches(src)) {
          used++;
          if (!has(m.group(1)!)) missing.add('${m.group(1)}  (${f.path})');
        }
      }
    }
    expect(used, greaterThan(0));
    expect(missing, isEmpty, reason: 'hiányzó feliratok a backend resources/i18n/hu fájljaiban');
  });
}
