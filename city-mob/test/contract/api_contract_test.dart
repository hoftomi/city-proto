import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tron_nelkul/domain/model/extensions.dart';
import 'package:tron_api/tron_api.dart';

/// A backend valódi válaszai (a szabálymotor mintaállapotából, a Spring generált modelljeivel írva)
/// a mobil generált modelljeivel is beolvashatók: a két oldal ugyanabból az api/openapi.yaml-ból generál.
void main() {
  Map<String, dynamic> fixture(String name) => jsonDecode(File('test/fixtures/$name').readAsStringSync()) as Map<String, dynamic>;

  test('GameState', () {
    final s = GameState.fromJson(fixture('game_state.json'));
    expect(s.cities, hasLength(5));
    expect(s.me.houseName, 'Kékholló');
    expect(s.lap, isNotNull);
    expect(s.draft.where((o) => o.warning != null), isNotEmpty, reason: 'a hamis hír figyelmeztet');
    expect(s.threats.single.by.name, 'Varjúvár');
    expect(s.city('szelmezo').goods.last.sellers.any((x) => x.city && x.house == null), isTrue);
    expect(s.catalog.pp('moveSpy'), 1);
    expect(GameState.fromJson(s.toJson()).gameId, s.gameId);
  });

  test('MapDef', () {
    final m = MapDef.fromJson(fixture('map_delkelet.json'));
    expect(m.cities, hasLength(5));
    expect(m.pos('birtok:nyugat'), isNotNull);
    expect(m.terrain.mountains.first, hasLength(3));
  });
}
