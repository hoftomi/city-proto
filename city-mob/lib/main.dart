import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di/di.dart';
import 'app/l10n.dart';
import 'data/repository/translation_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: L10n.supported,
    path: L10n.path,
    fallbackLocale: L10n.hu,
    startLocale: L10n.hu,
    useOnlyLangCode: true,
    // Minden felirat a backendről jön (offline: gyorsítótár, végül az app tartaléka).
    assetLoader: getIt<TranslationRepository>(),
    child: const TronApp(),
  ));
}
