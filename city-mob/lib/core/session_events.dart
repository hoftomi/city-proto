import 'dart:async';

import 'package:injectable/injectable.dart';

/// A hálózati réteg jelzi, ha a szerver 401-et ad (lejárt vagy visszavont token); az AuthBloc erre kiléptet.
@lazySingleton
class SessionEvents {
  final _expired = StreamController<void>.broadcast();

  Stream<void> get expired => _expired.stream;

  void expire() => _expired.add(null);

  @disposeMethod
  void dispose() => _expired.close();
}
