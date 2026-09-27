import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;

/// A Krónika IV exportált rajzainak adatai (assets/k4/k4.json, a tools/k4_export állítja elő):
/// a várak és birtokok kivágási kerete, a városkép negyedeinek koppintható sokszögei és feliratai.
class K4Assets {
  K4Assets._(this.cityBox, this.estateBox, this.districts, this.labels, this._cityIds);

  /// A térképi vár képe ennyivel tér el a város pontjától: [bal, felső, szélesség, magasság] a 360×260-as térképen.
  final Rect cityBox;
  final Rect estateBox;

  /// Negyed (keresk | polit | kem) → sokszög a 720×540-es városképen.
  final Map<String, List<Offset>> districts;
  final Map<String, Offset> labels;
  final Map<String, String> _cityIds;

  static const _districtKey = {'Vásártér': 'keresk', 'Városháza': 'polit', 'Alvilág': 'kem'};

  static Future<K4Assets>? _loading;
  static K4Assets? instance;

  static Future<K4Assets> load() => _loading ??= rootBundle.loadString('assets/k4/k4.json').then((raw) {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        Rect box(List v) => Rect.fromLTWH((v[0] as num).toDouble(), (v[1] as num).toDouble(), (v[2] as num).toDouble(), (v[3] as num).toDouble());
        final d = j['districts'] as Map<String, dynamic>;
        final districts = <String, List<Offset>>{};
        (d['polygons'] as Map<String, dynamic>).forEach((name, pts) {
          districts[_districtKey[name] ?? name] = [for (final p in pts as List) Offset((p[0] as num).toDouble(), (p[1] as num).toDouble())];
        });
        final labels = <String, Offset>{};
        (d['labels'] as Map<String, dynamic>).forEach((name, p) => labels[_districtKey[name] ?? name] = Offset((p[0] as num).toDouble(), (p[1] as num).toDouble()));
        final ids = <String, String>{};
        (j['maps'] as Map<String, dynamic>).forEach((_, m) {
          for (final c in (m['cities'] as List)) {
            ids[c['name'] as String] = c['id'] as String;
          }
        });
        return instance = K4Assets._(box(j['cityBox']), box(j['estateBox']), districts, labels, ids);
      });

  /// A városkép fájlja a város neve alapján (a név a rajz véletlenszerű részleteinek magja is).
  String? cityViewAsset(String cityName) {
    final id = _cityIds[cityName];
    return id == null ? null : 'assets/k4/cityview/$id.webp';
  }
}
