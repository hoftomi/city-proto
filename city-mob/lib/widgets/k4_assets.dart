import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;

/// Data for the exported Krónika IV drawings (assets/k4/k4.json, produced by tools/k4_export):
/// crop boxes of castles and estates, tappable polygons and labels of the city view districts.
class K4Assets {
  K4Assets._(this.cityBox, this.estateBox, this.districts, this.labels, this._cityIds);

  /// Offset of the map castle image from the city point: [left, top, width, height] on the 360×260 map.
  final Rect cityBox;
  final Rect estateBox;

  /// District (trade | politics | espionage) → polygon on the 720×540 city view.
  final Map<String, List<Offset>> districts;
  final Map<String, Offset> labels;
  final Map<String, String> _cityIds;

  static Future<K4Assets>? _loading;
  static K4Assets? instance;

  static Future<K4Assets> load() => _loading ??= rootBundle.loadString('assets/k4/k4.json').then((raw) {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        Rect box(List v) => Rect.fromLTWH((v[0] as num).toDouble(), (v[1] as num).toDouble(), (v[2] as num).toDouble(), (v[3] as num).toDouble());
        final d = j['districts'] as Map<String, dynamic>;
        final districts = <String, List<Offset>>{};
        (d['polygons'] as Map<String, dynamic>).forEach((name, pts) {
          districts[name] = [for (final p in pts as List) Offset((p[0] as num).toDouble(), (p[1] as num).toDouble())];
        });
        final labels = <String, Offset>{};
        (d['labels'] as Map<String, dynamic>).forEach((name, p) => labels[name] = Offset((p[0] as num).toDouble(), (p[1] as num).toDouble()));
        final ids = <String, String>{};
        (j['maps'] as Map<String, dynamic>).forEach((_, m) {
          for (final c in (m['cities'] as List)) {
            ids[c['name'] as String] = c['id'] as String;
          }
        });
        return instance = K4Assets._(box(j['cityBox']), box(j['estateBox']), districts, labels, ids);
      });

  /// City view file by city name (the name also seeds the drawing's random details).
  String? cityViewAsset(String cityName) {
    final id = _cityIds[cityName];
    return id == null ? null : 'assets/k4/cityview/$id.webp';
  }
}
