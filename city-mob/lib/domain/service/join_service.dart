import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../../core/failure.dart';
import '../model/join_extensions.dart';
import 'lobby_service.dart';

/// A jelentkezés űrlapjának adatai.
typedef JoinForm = ({String name, String tincture, String background, String start, String? startGood});

/// Játékrészletek a térképpel, a jelentkezés ellenőrzése és a kérés összeállítása.
@lazySingleton
class JoinService {
  JoinService(this._lobby);
  final LobbyService _lobby;

  /// A jelentkezés lépései.
  static const steps = ['Ház', 'Háttér', 'Kezdőhely', 'Összegzés'];
  static const minName = 3, maxName = 24;

  /// A játék részletei és a térképe egyben.
  Future<Either<Failure, (GameDetail, MapDef)>> detail(String id) async {
    final d = await _lobby.game(id);
    if (d.isLeft) return Left(d.left);
    final m = await _lobby.map(d.right.game.mapId);
    if (m.isLeft) return Left(m.left);
    return Right((d.right, m.right));
  }

  /// A ház nevének hibája, vagy null, ha jó.
  String? nameError(String name) {
    final v = name.trim();
    if (v.length < minName) return 'Legalább $minName betű kell.';
    if (v.length > maxName) return 'Legfeljebb $maxName betű lehet.';
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

  /// A szerver foglalt vagy hibás névre panaszkodik: vissza az első lépésre.
  bool nameRejected(Failure f) => f.message.contains('név');
}
