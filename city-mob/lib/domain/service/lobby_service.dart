import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/failure.dart';
import '../../data/repository/repositories.dart';

/// Játékválasztó, játékrészletek és jelentkezés.
@lazySingleton
class LobbyService {
  LobbyService(this._lobby, this._maps);
  final LobbyRepository _lobby;
  final MapRepository _maps;

  Future<Either<Failure, List<GameSummary>>> games() => _lobby.games();

  Future<Either<Failure, GameDetail>> game(String id) => _lobby.game(id);

  Future<Either<Failure, MapDef>> map(String mapId) => _maps.map(mapId);

  Future<Either<Failure, GameSummary>> join(String id, JoinRequest request) => _lobby.join(id, request);

  Future<Either<Failure, void>> withdraw(String id) => _lobby.withdraw(id);
}
