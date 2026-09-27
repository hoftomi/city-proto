import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

import '../model/city_extensions.dart';
import '../model/extensions.dart';

/// A városnézet műveletei: a megjelenítendő város kiválasztása, és a negyedek űrlapjaiból a parancsok
/// (OrderRequest) összeállítása. Minden parancsépítő null-t ad, ha a parancs most nem adható ki
/// (nem elérhető a város, nincs szabad kém, érvénytelen célpont, ...).
@lazySingleton
class CityService {
  /// A megjelenítendő város: az URL-ben kért, a térképen kijelölt, vagy az első elérhető.
  String? resolveCity(GameState s, String? requested, String? selected) => s.cityFor(requested, selected);

  OrderRequest? route(GameState s, CityView cv, String from) {
    final b = s.routesTo(cv.id).where((b) => b.from == from).firstOrNull;
    return b == null ? null : OrderRequest(type: 'route', from: b.from, to: b.to);
  }

  OrderRequest? defend(GameState s, CityView cv, String orderId) {
    final t = s.threatsIn(cv.id).where((t) => t.orderId == orderId).firstOrNull;
    if (!cv.reachable || t == null || t.defending) return null;
    return OrderRequest(type: 'defend', city: cv.id, lapId: t.lapId, orderId: t.orderId);
  }

  OrderRequest? margin(GameState s, CityView cv, String goodId, String level) {
    final g = cv.goods.where((g) => g.id == goodId).firstOrNull;
    if (!cv.reachable || g == null || g.myShares < 1 || s.catalog.margin(level) == null) return null;
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

  /// A fesztivált a párt rendezi.
  OrderRequest? festival(CityView cv) => !cv.reachable || cv.myProgram == null ? null : OrderRequest(type: 'festival', city: cv.id);

  OrderRequest? news(CityView cv, NewsPlan p) => !cv.reachable || !p.ok
      ? null
      : OrderRequest(type: 'news', city: cv.id, template: p.template!.id, target: p.target!.playerId, good: p.goodId);

  OrderRequest? hireSpy(GameState s, CityView cv) => !cv.reachable || cv.spiesFull(s.rules) ? null : OrderRequest(type: 'hireSpy', city: cv.id);

  OrderRequest? guard(CityView cv) => !cv.reachable || cv.freeSpies < 1 ? null : OrderRequest(type: 'guard', city: cv.id);

  /// Kém áthelyezése (7.1): szabad kém kell, és a célváros a hálózatodban legyen, ne legyen tele.
  OrderRequest? moveSpy(GameState s, CityView cv, String to) {
    final dest = s.spyDestinations(cv.id).where((x) => x.id == to).firstOrNull;
    if (!cv.reachable || cv.freeSpies < 1 || dest == null || dest.spiesFull(s.rules)) return null;
    return OrderRequest(type: 'moveSpy', city: cv.id, to: to);
  }

  /// Kifürkészés: egy érlelő parancslappal rendelkező rivális ellen, szabad kémmel.
  OrderRequest? spy(GameState s, CityView cv, String target) =>
      !cv.reachable || cv.freeSpies < 1 || !s.rivalLaps.any((l) => l.house.playerId == target) ? null : OrderRequest(type: 'spy', city: cv.id, target: target);

  /// Ellenőrzés vagy leleplezés, attól függően, hol tart a hír.
  OrderRequest? checkNews(CityView cv, String newsId) {
    final n = cv.news.where((n) => n.id == newsId).firstOrNull;
    return switch (n == null ? NewsCheck.none : cv.newsCheck(n)) {
      NewsCheck.verify => OrderRequest(type: 'verify', city: cv.id, newsId: newsId),
      NewsCheck.debunk => OrderRequest(type: 'debunk', city: cv.id, newsId: newsId),
      NewsCheck.none => null,
    };
  }

  /// Az eladás párbeszédének kezdőértékei: az első lehetséges vevő és a szabály szerinti ár;
  /// null, ha nincs kinek eladni (vagy a terv már nem eladható).
  (String buyer, String price)? saleDefaults(GameState s, String intelId) {
    final it = s.intel.where((i) => i.id == intelId).firstOrNull;
    if (it == null || !it.live || it.bought) return null;
    final buyers = s.intelBuyers(it);
    return buyers.isEmpty ? null : (buyers.first.playerId, '${s.rules.infoPrice}');
  }

  /// A beírt ár; üres vagy hibás szövegnél a szabály szerinti ár.
  int salePrice(GameState s, String text) => int.tryParse(text.trim()) ?? s.rules.infoPrice;

  /// Érvényes vevő-e a megadott ház ehhez a tervhez.
  bool validBuyer(GameState s, String intelId, String buyer) {
    final it = s.intel.where((i) => i.id == intelId).firstOrNull;
    return it != null && s.intelBuyers(it).any((h) => h.playerId == buyer);
  }
}
