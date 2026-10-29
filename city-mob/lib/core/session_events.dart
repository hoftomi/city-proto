import 'dart:async';

import 'package:injectable/injectable.dart';

/// The network layer signals when the server returns 401 (expired or revoked token); AuthBloc then signs out.
@lazySingleton
class SessionEvents {
  final _expired = StreamController<void>.broadcast();

  Stream<void> get expired => _expired.stream;

  void expire() => _expired.add(null);

  @disposeMethod
  void dispose() => _expired.close();
}
