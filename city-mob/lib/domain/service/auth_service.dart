import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/failure.dart';
import '../../core/session_events.dart';
import '../../data/repository/repositories.dart';

/// Bejelentkezés és kilépés. A szolgáltatók: google, apple, discord.
@lazySingleton
class AuthService {
  AuthService(this._repo, this._events);
  final AuthRepository _repo;
  final SessionEvents _events;

  /// A szerver 401-et adott: a munkamenet lejárt.
  Stream<void> get sessionExpired => _events.expired;

  Future<UserDto?> restore() => _repo.restore();

  /// null jobb oldal: a felhasználó megszakította a belépést.
  Future<Either<Failure, UserDto?>> signIn(String provider) => _repo.signIn(provider);

  Future<Either<Failure, UserDto>> refresh() => _repo.refresh();

  Future<void> signOut() => _repo.signOut();
}
