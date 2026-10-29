import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every label comes from the backend: every translation key used in the code exists among the backend's labels
/// (assets/translations/hu.json = the backend's resources/i18n/hu files, tools/sync_translations.py).
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

  test('fallback is up to date with the backend files', () {
    final dir = Directory('../tron-nelkul/backend/src/main/resources/i18n/hu');
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
    for (final f in files) {
      final ns = f.uri.pathSegments.last.replaceAll('.json', '');
      expect(translations[ns], jsonDecode(f.readAsStringSync()), reason: 'run: python3 tools/sync_translations.py ($ns)');
    }
  });

  test('all keys used in the code exist', () {
    // Two forms: 'ns.key'.tr(…)  and  Tr('ns.key'…); dynamic keys containing $ are skipped
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
    expect(missing, isEmpty, reason: 'missing labels in the backend resources/i18n/hu files');
  });
}
