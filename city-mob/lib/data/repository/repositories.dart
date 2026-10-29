import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/failure.dart';
import '../../core/tr.dart';
import '../datasource/auth/identity_datasource.dart';
import '../datasource/local/user_local_datasource.dart';
import '../datasource/remote/remote_datasources.dart';

/// Converts exceptions to Failure: repositories always return Either, never throw.
Future<Either<Failure, T>> guard<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } catch (e) {
    return Left(Failure.from(e));
  }
}

/// The signed-in user: provider sign-in (Firebase), the backend user and its local copy.
@lazySingleton
class AuthRepository {
  AuthRepository(this._identity, this._remote, this._local);
  final IdentityDataSource _identity;
  final AuthRemoteDataSource _remote;
  final UserLocalDataSource _local;

  /// On restart: the saved user, if the Firebase session is still alive.
  Future<UserDto?> restore() async {
    if (!_identity.signedIn) return null;
    return _local.read();
  }

  /// Fresh user data from the backend (e.g. the role changed); also updates the local copy.
  Future<Either<Failure, UserDto>> refresh() => guard(() async {
        final u = await _remote.me();
        await _local.write(u);
        return u;
      });

  /// Provider sign-in, then fetching our own user. null if the user cancelled.
  /// If the backend rejects it, we sign out of Firebase too.
  Future<Either<Failure, UserDto?>> signIn(String provider) => guard(() async {
        final bool done;
        switch (provider) {
          case 'google':
            done = await _identity.signInWithGoogle();
          case 'apple':
            done = await _identity.signInWithApple();
          case 'discord':
            final code = await _identity.discordCode();
            if (code == null) return null;
            await _identity.signInWithCustomToken(await _remote.discordCustomToken(code.code, code.verifier, code.redirectUri));
            done = true;
          default:
            throw const Failure(Tr('auth.unknown_provider'));
        }
        if (!done) return null;
        try {
          final u = await _remote.me();
          await _local.write(u);
          return u;
        } catch (_) {
          await _identity.signOut();
          rethrow;
        }
      });

  Future<void> signOut() async {
    await _local.clear();
    await _identity.signOut();
  }
}

@lazySingleton
class LobbyRepository {
  LobbyRepository(this._remote);
  final LobbyRemoteDataSource _remote;

  Future<Either<Failure, List<GameSummary>>> joinedGames() => guard(_remote.joinedGames);

  Future<Either<Failure, List<GameSummary>>> availableGames() => guard(_remote.availableGames);

  Future<Either<Failure, List<GameSummary>>> archivedGames() => guard(_remote.archivedGames);

  Future<Either<Failure, GameDetail>> game(String id) => guard(() => _remote.game(id));

  Future<Either<Failure, GameSummary>> join(String id, JoinRequest request) => guard(() => _remote.join(id, request));

  Future<Either<Failure, void>> withdraw(String id) => guard(() => _remote.withdraw(id));
}

/// Maps don't change during a game, so we cache them in memory.
@lazySingleton
class MapRepository {
  MapRepository(this._remote);
  final LobbyRemoteDataSource _remote;
  final Map<String, MapDef> _cache = {};

  Future<Either<Failure, MapDef>> map(String mapId) async {
    final hit = _cache[mapId];
    if (hit != null) return Right(hit);
    return (await guard(() => _remote.map(mapId))).map((m) => _cache[mapId] = m);
  }
}

@lazySingleton
class GameRepository {
  GameRepository(this._remote);
  final GameRemoteDataSource _remote;

  Future<Either<Failure, GameState>> state(String id) => guard(() => _remote.state(id));

  Future<Either<Failure, GameState>> addOrder(String id, OrderRequest order) => guard(() => _remote.addOrder(id, order));

  Future<Either<Failure, GameState>> removeOrder(String id, String orderId) => guard(() => _remote.removeOrder(id, orderId));

  Future<Either<Failure, GameState>> seal(String id) => guard(() => _remote.seal(id));

  Future<Either<Failure, GameState>> offerIntel(String id, String intelId, String buyerId, int price) =>
      guard(() => _remote.offerIntel(id, intelId, buyerId, price));

  Future<Either<Failure, GameState>> acceptOffer(String id, String offerId) => guard(() => _remote.acceptOffer(id, offerId));

  Future<Either<Failure, GameState>> declineOffer(String id, String offerId) => guard(() => _remote.declineOffer(id, offerId));

  Future<Either<Failure, List<ReportView>>> reports(String id) => guard(() => _remote.reports(id));

  Future<Either<Failure, List<RankRow>>> ranking(String id) => guard(() => _remote.ranking(id));

}
