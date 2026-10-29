import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/failure.dart';
import '../../core/session_events.dart';
import '../../data/repository/repositories.dart';

/// Sign-in and sign-out. Providers: google, apple, discord.
@lazySingleton
class AuthService {
  AuthService(this._repo, this._events);
  final AuthRepository _repo;
  final SessionEvents _events;

  /// The server returned 401: the session expired.
  Stream<void> get sessionExpired => _events.expired;

  Future<UserDto?> restore() => _repo.restore();

  /// null right side: the user cancelled sign-in.
  Future<Either<Failure, UserDto?>> signIn(String provider) => _repo.signIn(provider);

  Future<Either<Failure, UserDto>> refresh() => _repo.refresh();

  Future<void> signOut() => _repo.signOut();
}
