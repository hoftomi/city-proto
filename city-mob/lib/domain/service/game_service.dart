import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/failure.dart';
import '../../data/repository/repositories.dart';
import '../model/extensions.dart';

/// Game operations and values computed from game state (clock, due refresh, added order).
@lazySingleton
class GameService {
  GameService(this._games, this._maps);
  final GameRepository _games;
  final MapRepository _maps;

  /// The state and its map.
  Future<Either<Failure, (GameState, MapDef)>> load(String gameId) async {
    final s = await _games.state(gameId);
    if (s.isLeft) return Left(s.left);
    final m = await _maps.map(s.right.mapId);
    return m.map((map) => (s.right, map));
  }

  Future<Either<Failure, GameState>> state(String gameId) => _games.state(gameId);

  Future<Either<Failure, GameState>> addOrder(String gameId, OrderRequest order) => _games.addOrder(gameId, order);

  Future<Either<Failure, GameState>> removeOrder(String gameId, String orderId) => _games.removeOrder(gameId, orderId);

  Future<Either<Failure, GameState>> seal(String gameId) => _games.seal(gameId);

  Future<Either<Failure, GameState>> offerIntel(String gameId, String intelId, String buyerId, int price) =>
      _games.offerIntel(gameId, intelId, buyerId, price);

  Future<Either<Failure, GameState>> acceptOffer(String gameId, String offerId) => _games.acceptOffer(gameId, offerId);

  Future<Either<Failure, GameState>> declineOffer(String gameId, String offerId) => _games.declineOffer(gameId, offerId);

  Future<Either<Failure, List<ReportView>>> reports(String gameId) => _games.reports(gameId);

  Future<Either<Failure, List<RankRow>>> ranking(String gameId) => _games.ranking(gameId);

  Future<Either<Failure, GameState>> adminSettle(String gameId) => _games.adminSettle(gameId);

  /// The game clock: `clock.now` at the last fetch plus the time elapsed on the device since
  /// (the admin may have fast-forwarded it, so it's not the device clock).
  DateTime gameNow(GameState s, DateTime fetchedAt, DateTime deviceNow) => s.clock.now.add(deviceNow.difference(fetchedAt));

  /// Whether my sheet or a settlement has run since, i.e. whether the state needs refreshing.
  bool refreshDue(GameState s, DateTime now) {
    bool past(DateTime? t, int sec) => t != null && now.isAfter(t.add(Duration(seconds: sec)));
    return past(s.sheet?.executeAt, 5) || past(s.clock.nextSettlementAt, 10);
  }

  /// The order newly added to the draft (with its warning, e.g. for false news).
  OrderView? addedOrder(GameState before, GameState after) {
    final ids = {for (final o in before.draft) o.id};
    return after.draft.where((o) => !ids.contains(o.id)).lastOrNull;
  }

  /// The starting city: the first reachable, or the first.
  String? defaultCity(GameState s) => s.cities.where((c) => c.reachable).firstOrNull?.id ?? s.cities.firstOrNull?.id;

  /// Order sheet badge: draft orders and undefended threats.
  int ordersBadge(GameState s) => s.draft.length + s.openThreats;
}
