import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/api/models.dart';
import 'package:tron_nelkul/util/format.dart';
import 'package:tron_nelkul/widgets/paint_util.dart';

void main() {
  test('magyar számformázás', () {
    expect(num1(42.34), '42,3');
    expect(signed(-2), '−2');
    expect(signed(3), '+3');
  });

  test('a determinisztikus véletlen megegyezik a web prototípussal', () {
    // JS: rng('f56152')() — ugyanaz az LCG, ezért az erdők ugyanott állnak minden kliensen
    final a = SeededRng('f56152'), b = SeededRng('f56152');
    expect(a.next(), b.next());
    expect(a.next(), inInclusiveRange(0, 1));
  });

  test('játékállapot beolvasása', () {
    final s = GameState.fromJson({
      'gameId': 'delkelet-1', 'gameName': 'Délkelet', 'mapId': 'delkelet', 'status': 'fut', 'round': 2, 'maxRounds': 28,
      'nextResolutionAt': '2026-09-26T18:00:00Z',
      'me': {'playerId': 'p', 'houseName': 'Kékholló', 'tincture': 'kek', 'estate': 'birtok:nyugat', 'pp': 10, 'ppMax': 20, 'arany': 15, 'bp': 5, 'ke': 2, 'legit': 0, 'sealed': false},
      'pending': {'pp': 0, 'arany': 0, 'bp': 0, 'ke': 0},
      'routes': [], 'buildable': [], 'orders': [], 'actions': [],
      'cities': [
        {'id': 'szelmezo', 'name': 'Szélmező', 'stability': 'ingatag', 'reach': 'reachable', 'distance': 1, 'bestLevel': null, 'decayPercent': 7,
         'factions': [{'faction': 'kereskedok', 'level': null, 'precision': 'band10', 'segments': [], 'unknown': 0, 'ownHidden': 0, 'neutral': 100, 'suspicion': 0, 'rivals': []}]}
      ],
    });
    expect(s.city('szelmezo').reachable, isTrue);
    expect(s.city('szelmezo').faction('kereskedok').neutral, 100);
    expect(s.nextResolutionAt, isNotNull);
  });
}
