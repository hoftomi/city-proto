import 'package:tron_api/tron_api.dart';

/// Segédek a jelentkezéshez (a GameDetail kínálatából).
extension GameDetailJoinX on GameDetail {
  StartSlotDto? slot(String? id) => starts.where((s) => s.id == id).firstOrNull;
  BackgroundDto? background(String? id) => backgrounds.where((b) => b.id == id).firstOrNull;

  /// Alapértelmezések: az első tinktúra, a Kereskedőház (ha van), az első kezdőhely.
  String get defaultTincture => tinctures.firstOrNull ?? '';
  String get defaultBackground => background('kereskedo')?.id ?? backgrounds.firstOrNull?.id ?? '';
  String get defaultStart => starts.firstOrNull?.id ?? '';

  /// Kell-e induló árucikket választani: csak a Kereskedőháznak, ha a kezdővárosnak van árucikke.
  bool needsGood(String background, String start) => background == 'kereskedo' && (slot(start)?.homeGoods.isNotEmpty ?? false);

  /// A választott induló árucikk; ha a választás nem a kezdőváros árucikke, az első.
  GoodOption? good(String background, String start, String? chosen) {
    if (!needsGood(background, start)) return null;
    final goods = slot(start)!.homeGoods;
    return goods.where((g) => g.id == chosen).firstOrNull ?? goods.first;
  }
}
