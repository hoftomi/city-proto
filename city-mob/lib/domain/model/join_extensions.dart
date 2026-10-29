import 'package:tron_api/tron_api.dart';

/// Helpers for joining (from the GameDetail offering).
extension GameDetailJoinX on GameDetail {
  StartSlotDto? slot(String? id) => starts.where((s) => s.id == id).firstOrNull;
  BackgroundDto? background(Background? id) => backgrounds.where((b) => b.id == id).firstOrNull;

  /// Defaults: the Merchant House (if offered, else the first offered background), the first start slot.
  Background get defaultBackground => background(Background.merchant)?.id ?? backgrounds.firstOrNull?.id ?? Background.merchant;
  String get defaultStart => starts.firstOrNull?.id ?? '';

  /// Whether a starting good must be chosen: only for the Merchant House, if the home city has goods.
  bool needsGood(Background? background, String start) => background == Background.merchant && (slot(start)?.homeGoods.isNotEmpty ?? false);

  /// The chosen starting good; if the choice isn't a good of the home city, the first one.
  GoodOption? good(Background? background, String start, String? chosen) {
    if (!needsGood(background, start)) return null;
    final goods = slot(start)!.homeGoods;
    return goods.where((g) => g.id == chosen).firstOrNull ?? goods.first;
  }
}
