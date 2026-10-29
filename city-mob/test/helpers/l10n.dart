// ignore_for_file: implementation_imports
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/widgets.dart';

/// Tests use the real labels too: the app fallback (assets/translations/hu.json), which
/// tools/sync_translations.py generates from the backend i18n files. Call it in setUpAll; `tr()` works from then on.
void loadTestTranslations() {
  final map = jsonDecode(File('assets/translations/hu.json').readAsStringSync()) as Map<String, dynamic>;
  Localization.load(const Locale('hu'), translations: Translations(map));
}
