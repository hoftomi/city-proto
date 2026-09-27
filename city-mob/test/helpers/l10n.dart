// ignore_for_file: implementation_imports
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/widgets.dart';

/// A tesztekben is a valódi feliratok szólnak: az app tartaléka (assets/translations/hu.json), amelyet a
/// tools/sync_translations.py a backend i18n fájljaiból állít elő. Hívd a setUpAll-ban; a `tr()` innentől működik.
void loadTestTranslations() {
  final map = jsonDecode(File('assets/translations/hu.json').readAsStringSync()) as Map<String, dynamic>;
  Localization.load(const Locale('hu'), translations: Translations(map));
}
