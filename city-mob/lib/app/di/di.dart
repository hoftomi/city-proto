import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

/// A függőségek (get_it + injectable). A regisztrációt a build_runner generálja: `dart run build_runner build`.
final getIt = GetIt.instance;

@InjectableInit(initializerName: 'init', preferRelativeImports: true, asExtension: true)
void configureDependencies() => getIt.init();
