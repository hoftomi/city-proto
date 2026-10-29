import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/failure.dart';
import '../../core/tr.dart';
import '../model/join_extensions.dart';
import 'lobby_service.dart';

/// Data of the join form.
typedef JoinForm = ({String name, String tincture, String background, String start, String? startGood});

/// Game details with the map, join validation and request assembly.
@lazySingleton
class JoinService {
  JoinService(this._lobby);
  final LobbyService _lobby;

  /// Steps of joining.
  static const steps = [Tr('join.step.house'), Tr('join.step.background'), Tr('join.step.start'), Tr('join.step.summary')];
  static const minName = 3, maxName = 24;

  /// The game's details and its map together.
  Future<Either<Failure, (GameDetail, MapDef)>> detail(String id) async {
    final d = await _lobby.game(id);
    if (d.isLeft) return Left(d.left);
    final m = await _lobby.map(d.right.game.mapId);
    if (m.isLeft) return Left(m.left);
    return Right((d.right, m.right));
  }

  /// Error for the house name, or null if valid.
  Tr? nameError(String name) {
    final v = name.trim();
    if (v.length < minName) return Tr('join.name_too_short', {'min': '$minName'});
    if (v.length > maxName) return Tr('join.name_too_long', {'max': '$maxName'});
    return null;
  }

  JoinRequest request(GameDetail d, JoinForm f) => JoinRequest(
        houseName: f.name.trim(),
        tincture: f.tincture,
        background: f.background,
        startSlot: f.start,
        startGood: d.good(f.background, f.start, f.startGood)?.id,
      );

  Future<Either<Failure, GameSummary>> join(GameDetail d, JoinForm f) => _lobby.join(d.game.id, request(d, f));

  /// The server complains about a taken or invalid name: back to the first step. Inspects the server text (ProblemDetail
  /// `detail`), not a displayed label.
  bool nameRejected(Failure f) => f.code == 'house_name';
}
