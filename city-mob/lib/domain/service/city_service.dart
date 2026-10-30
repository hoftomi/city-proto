import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../model/city_extensions.dart';
import '../model/extensions.dart';

/// City view operations: choosing the city to show, and assembling orders (OrderRequest) from the
/// district forms. Every order builder returns null if the order can't be issued now
/// (city unreachable, no free spy, invalid target, ...).
@lazySingleton
class CityService {
  /// The city to show: the one requested in the URL, the one selected on the map, or the first reachable.
  String? resolveCity(GameState s, String? requested, String? selected) => s.cityFor(requested, selected);

  OrderRequest? route(GameState s, CityView cv, String from) {
    final b = s.routesTo(cv.id).where((b) => b.from == from).firstOrNull;
    return b == null ? null : OrderRequest(type: 'route', from: b.from, to: b.to);
  }

  OrderRequest? defend(GameState s, CityView cv, String orderId) {
    final t = s.threatsIn(cv.id).where((t) => t.orderId == orderId).firstOrNull;
    if (!cv.reachable || t == null || t.defending) return null;
    return OrderRequest(type: 'defend', city: cv.id, sheetId: t.sheetId, orderId: t.orderId);
  }

  /// Margin change of a good. At most one waits on the draft per good (the server replaces it):
  /// picking the pending level does nothing, picking the level in effect while a change is pending sends
  /// it again (the server then drops the pending order), and without a pending change it does nothing.
  OrderRequest? margin(GameState s, CityView cv, String goodId, String level) {
    final g = cv.goods.where((g) => g.id == goodId).firstOrNull;
    if (!cv.reachable || g == null || g.myShares < 1 || s.catalog.margin(level) == null) return null;
    final pending = s.pendingMargin(cv.id, goodId);
    if (level == pending || (level == g.myMargin && pending == null)) return null;
    return OrderRequest(type: 'margin', city: cv.id, good: goodId, level: level);
  }

  OrderRequest? buyShares(CityView cv, GoodPlan p) =>
      !cv.reachable || !p.canBuy ? null : OrderRequest(type: 'buyShares', city: cv.id, good: p.good.id, pts: p.buyPts);

  OrderRequest? buyout(CityView cv, GoodPlan p) => !cv.reachable || p.targetId == null
      ? null
      : OrderRequest(type: 'buyout', city: cv.id, good: p.good.id, target: p.targetId, pts: p.boPts);

  OrderRequest? foundParty(CityView cv) => !cv.reachable || cv.myProgram != null ? null : OrderRequest(type: 'foundParty', city: cv.id);

  OrderRequest? program(GameState s, CityView cv, String level) =>
      !cv.reachable || cv.myProgram == null || s.catalog.program(level) == null ? null : OrderRequest(type: 'program', city: cv.id, level: level);

  /// The festival is held by the party.
  OrderRequest? festival(CityView cv) => !cv.reachable || cv.myProgram == null ? null : OrderRequest(type: 'festival', city: cv.id);

  OrderRequest? news(CityView cv, NewsPlan p) => !cv.reachable || !p.ok
      ? null
      : OrderRequest(type: 'news', city: cv.id, template: p.template!.id, target: p.target!.playerId, good: p.goodId);

  OrderRequest? hireSpy(GameState s, CityView cv) => !cv.reachable || cv.spiesFull(s.rules) ? null : OrderRequest(type: 'hireSpy', city: cv.id);

  OrderRequest? guard(CityView cv) => !cv.reachable || cv.freeSpies < 1 ? null : OrderRequest(type: 'guard', city: cv.id);

  /// Spy relocation (7.1): needs a free spy, and the target city must be in your network and not full.
  OrderRequest? moveSpy(GameState s, CityView cv, String to) {
    final dest = s.spyDestinations(cv.id).where((x) => x.id == to).firstOrNull;
    if (!cv.reachable || cv.freeSpies < 1 || dest == null || dest.spiesFull(s.rules)) return null;
    return OrderRequest(type: 'moveSpy', city: cv.id, to: to);
  }

  /// Scouting: against a rival with a maturing order sheet, with a free spy.
  OrderRequest? spy(GameState s, CityView cv, String target) =>
      !cv.reachable || cv.freeSpies < 1 || !s.rivalSheets.any((l) => l.house.playerId == target) ? null : OrderRequest(type: 'spy', city: cv.id, target: target);

  /// Verify or debunk, depending on where the news item stands.
  OrderRequest? checkNews(CityView cv, String newsId) {
    final n = cv.news.where((n) => n.id == newsId).firstOrNull;
    return switch (n == null ? NewsCheck.none : cv.newsCheck(n)) {
      NewsCheck.verify => OrderRequest(type: 'verify', city: cv.id, newsId: newsId),
      NewsCheck.debunk => OrderRequest(type: 'debunk', city: cv.id, newsId: newsId),
      NewsCheck.none => null,
    };
  }

  /// Initial values of the sell dialog: the first possible buyer and the rule-based price (whole gold);
  /// null if there's no one to sell to (or the plan is no longer sellable).
  (String buyer, String price)? saleDefaults(GameState s, String intelId) {
    final it = s.intel.where((i) => i.id == intelId).firstOrNull;
    if (it == null || !it.live || it.bought) return null;
    final buyers = s.intelBuyers(it);
    return buyers.isEmpty ? null : (buyers.first.playerId, '${s.rules.infoPrice ~/ 100}');
  }

  /// The entered price in bronze: the user types whole gold (sent ×100); the rule-based price for empty or invalid text.
  int salePrice(GameState s, String text) {
    final gold = int.tryParse(text.trim());
    return gold == null ? s.rules.infoPrice : gold * 100;
  }

  /// Whether the given house is a valid buyer for this plan.
  bool validBuyer(GameState s, String intelId, String buyer) {
    final it = s.intel.where((i) => i.id == intelId).firstOrNull;
    return it != null && s.intelBuyers(it).any((h) => h.playerId == buyer);
  }
}
