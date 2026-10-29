import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/domain/model/extensions.dart';
import 'package:tron_api/tron_api.dart';

/// Real backend responses (from the rules engine's sample state, written with Spring's generated models)
/// can be parsed with the mobile generated models too: both sides generate from the same api/openapi.yaml.
void main() {
  Map<String, dynamic> fixture(String name) => jsonDecode(File('test/fixtures/$name').readAsStringSync()) as Map<String, dynamic>;

  test('GameState', () {
    final s = GameState.fromJson(fixture('game_state.json'));
    expect(s.cities, hasLength(5));
    expect(s.me.houseName, 'Kékholló');
    expect(s.sheet, isNotNull);
    expect(s.draft.where((o) => o.warning != null), isNotEmpty, reason: 'fake news warns');
    expect(s.threats.single.by.name, 'Varjúvár');
    expect(s.city('szelmezo').goods.last.sellers.any((x) => x.city && x.house == null), isTrue);
    expect(s.catalog.pp('moveSpy'), 1);
    expect(GameState.fromJson(s.toJson()).gameId, s.gameId);
  });

  test('MapDef', () {
    final m = MapDef.fromJson(fixture('map_delkelet.json'));
    expect(m.cities, hasLength(5));
    expect(m.pos('estate:west'), isNotNull);
    expect(m.terrain.mountains.first, hasLength(3));
  });
}
