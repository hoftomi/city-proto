import 'package:tron_api/tron_api.dart';

/// Helpers for the generated API models (packages/tron_api). Widgets use these so they don't have to
/// search and compute themselves.

extension GameSummaryX on GameSummary {
  bool get running => status == 'running';
  bool get open => status == 'open';
  bool get finished => status == 'finished';
  bool get announced => status == 'announced';
  bool get joined => myHouse != null;
}

extension MapDefX on MapDef {
  CityDef? city(String id) => cities.where((c) => c.id == id).firstOrNull;

  /// Start slot by node id (`estate:<id>`).
  StartSlot? start(String nodeId) => starts.where((s) => 'estate:${s.id}' == nodeId).firstOrNull;

  /// Position of a node (city or estate) on the 360×260 map.
  (double, double)? pos(String node) {
    final c = city(node);
    if (c != null) return (c.x.toDouble(), c.y.toDouble());
    final s = start(node);
    if (s != null) return (s.x.toDouble(), s.y.toDouble());
    return null;
  }

  String nodeName(String node) => city(node)?.name ?? start(node)?.name ?? node;
}

extension CityViewX on CityView {
  bool get reachable => reach == 'reachable';
  int get mySeats => parties.where((p) => p.house.self).fold(0, (a, p) => a + p.seats);

  /// City tax rate in percent (the server sends a fraction).
  int get taxPercent => (taxRate <= 1 ? taxRate * 100 : taxRate).round();
}

extension CatalogX on Catalog {
  ActionInfo? action(String id) => actions.where((a) => a.id == id).firstOrNull;
  LevelInfo? margin(String? id) => margins.where((m) => m.id == id).firstOrNull;
  LevelInfo? program(String? id) => programs.where((m) => m.id == id).firstOrNull;
  NewsTemplateInfo? template(String? id) => news.where((m) => m.id == id).firstOrNull;
  String marginLabel(String? id) => margin(id)?.label ?? id ?? '–';
  String programLabel(String? id) => program(id)?.label ?? id ?? '–';

  /// PP cost of an action.
  int pp(String id, [int fallback = 1]) => action(id)?.pp ?? fallback;
}

extension GameStateX on GameState {
  CityView city(String id) => cities.firstWhere((c) => c.id == id);
  CityView? cityOrNull(String? id) => cities.where((c) => c.id == id).firstOrNull;
  String houseName(String idOrName) => houses.where((h) => h.playerId == idOrName).firstOrNull?.name ?? idOrName;
  RulesInfo get rules => catalog.rules;

  /// Buyout threats not defended against yet.
  int get openThreats => threats.where((t) => !t.defending).length;
}

extension UserDtoX on UserDto {
  bool get admin => role == 'ADMIN';
}
