import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/failure.dart';
import '../datasource/auth/identity_datasource.dart';
import '../datasource/local/user_local_datasource.dart';
import '../datasource/remote/remote_datasources.dart';

/// A kivételeket Failure-ré alakítja: a repositoryk mindig Either-t adnak vissza, nem dobnak.
Future<Either<Failure, T>> guard<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } catch (e) {
    return Left(Failure.from(e));
  }
}

/// A belépett felhasználó: a szolgáltatói belépés (Firebase), a backend felhasználója és a helyi másolata.
@lazySingleton
class AuthRepository {
  AuthRepository(this._identity, this._remote, this._local);
  final IdentityDataSource _identity;
  final AuthRemoteDataSource _remote;
  final UserLocalDataSource _local;

  /// Újraindításkor: a mentett felhasználó, ha a Firebase-munkamenet is él.
  Future<UserDto?> restore() async {
    if (!_identity.signedIn) return null;
    return _local.read();
  }

  /// A friss felhasználói adat a backendtől (például megváltozott a szerep); a helyi másolatot is frissíti.
  Future<Either<Failure, UserDto>> refresh() => guard(() async {
        final u = await _remote.me();
        await _local.write(u);
        return u;
      });

  /// Szolgáltatói belépés, majd a saját felhasználónk lekérése. null, ha a felhasználó megszakította.
  /// Ha a backend nem fogad, a Firebase-ből is kilépünk.
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
            throw const Failure('Ismeretlen szolgáltató.');
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

  Future<Either<Failure, List<GameSummary>>> games() => guard(_remote.games);

  Future<Either<Failure, GameDetail>> game(String id) => guard(() => _remote.game(id));

  Future<Either<Failure, GameSummary>> join(String id, JoinRequest request) => guard(() => _remote.join(id, request));

  Future<Either<Failure, void>> withdraw(String id) => guard(() => _remote.withdraw(id));
}

/// A térképek nem változnak játék közben, ezért a memóriában gyorsítótárazzuk őket.
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

  /// Admin: azonnali elszámolás, utána a friss állapot.
  Future<Either<Failure, GameState>> adminSettle(String id) => guard(() async {
        await _remote.adminSettle(id);
        return _remote.state(id);
      });

  /// Admin: időtekerés (null: a következő eseményig), utána a friss állapot.
  Future<Either<Failure, GameState>> adminAdvance(String id, int? minutes) => guard(() async {
        await _remote.adminAdvance(id, minutes);
        return _remote.state(id);
      });
}
