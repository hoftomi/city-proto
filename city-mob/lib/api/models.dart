// Az API adatai. A backend `game/api/Dtos.java` rekordjait tükrözik.

double _d(dynamic v) => v == null ? 0 : (v as num).toDouble();
int _i(dynamic v) => v == null ? 0 : (v as num).toInt();
List<T> _list<T>(dynamic v, T Function(Map<String, dynamic>) f) =>
    v == null ? <T>[] : (v as List).map((e) => f(e as Map<String, dynamic>)).toList();
List<String> _strings(dynamic v) => v == null ? <String>[] : (v as List).map((e) => e.toString()).toList();
DateTime? _date(dynamic v) {
  if (v == null) return null;
  if (v is num) return DateTime.fromMillisecondsSinceEpoch((v * 1000).round());
  return DateTime.tryParse(v.toString())?.toLocal();
}

class UserInfo {
  UserInfo(this.id, this.name, this.role);
  final String id, name, role;
  factory UserInfo.fromJson(Map<String, dynamic> j) => UserInfo(j['id'].toString(), j['name'] ?? '', j['role'] ?? 'PLAYER');
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'role': role};
}

class MyHouse {
  MyHouse(this.playerId, this.houseName, this.tincture, this.background, this.backgroundName, this.startSlot);
  final String playerId, houseName, tincture;
  final String? background, backgroundName, startSlot;
  factory MyHouse.fromJson(Map<String, dynamic> j) =>
      MyHouse(j['playerId'], j['houseName'], j['tincture'], j['background'], j['backgroundName'], j['startSlot']);
}

class GameSummary {
  GameSummary.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name'],
        season = j['season'],
        status = j['status'],
        mapId = j['mapId'],
        startsAt = _date(j['startsAt']),
        opensAt = _date(j['opensAt']),
        days = _i(j['days']),
        roundsPerDay = _i(j['roundsPerDay']),
        round = _i(j['round']),
        maxRounds = _i(j['maxRounds']),
        players = _i(j['players']),
        maxPlayers = _i(j['maxPlayers']),
        cities = _i(j['cities']),
        npcCount = _i(j['npcCount']),
        tags = _strings(j['tags']),
        winner = j['winner'],
        myPlace = j['myPlace'] == null ? null : _i(j['myPlace']),
        myHouse = j['myHouse'] == null ? null : MyHouse.fromJson(j['myHouse']);

  final String id, name, season, status, mapId;
  final DateTime? startsAt, opensAt;
  final int days, roundsPerDay, round, maxRounds, players, maxPlayers, cities, npcCount;
  final List<String> tags;
  final String? winner;
  final int? myPlace;
  final MyHouse? myHouse;

  bool get running => status == 'fut';
  bool get open => status == 'nyitott';
  bool get finished => status == 'lezarult';
  bool get announced => status == 'hamarosan';
  bool get joined => myHouse != null;
}

class StartSlot {
  StartSlot.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name'],
        x = _d(j['x']),
        y = _d(j['y']),
        neighbors = _strings(j['neighbors']),
        neighborNames = _strings(j['neighborNames']),
        note = j['note'] ?? '';
  final String id, name, note;
  final double x, y;
  final List<String> neighbors, neighborNames;
}

class Background {
  Background.fromJson(Map<String, dynamic> j) : id = j['id'], name = j['name'], icon = j['icon'], perks = _strings(j['perks']);
  final String id, name, icon;
  final List<String> perks;
}

class GameDetail {
  GameDetail.fromJson(Map<String, dynamic> j)
      : game = GameSummary.fromJson(j['game']),
        starts = _list(j['starts'], StartSlot.fromJson),
        backgrounds = _list(j['backgrounds'], Background.fromJson),
        tinctures = _strings(j['tinctures']);
  final GameSummary game;
  final List<StartSlot> starts;
  final List<Background> backgrounds;
  final List<String> tinctures;
}

// ---------- Térkép ----------

class CityDef {
  CityDef.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name'],
        x = _d(j['x']),
        y = _d(j['y']),
        key = j['key'] == true,
        coast = j['coast'] == true,
        profile = j['profile'] ?? '';
  final String id, name, profile;
  final double x, y;
  final bool key, coast;
}

class Terrain {
  Terrain({this.sea, this.rivers = const [], this.mountains = const [], this.forests = const [], this.fields = const [], this.marsh = const []});
  Terrain.fromJson(Map<String, dynamic> j)
      : sea = j['sea'],
        rivers = _strings(j['rivers']),
        mountains = _nums(j['mountains']),
        forests = _nums(j['forests']),
        fields = _nums(j['fields']),
        marsh = _nums(j['marsh']);
  final String? sea;
  final List<String> rivers;
  final List<List<double>> mountains, forests, fields, marsh;

  static List<List<double>> _nums(dynamic v) =>
      v == null ? [] : (v as List).map((e) => (e as List).map((n) => (n as num).toDouble()).toList()).toList();
}

class MapDef {
  MapDef.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name'],
        cities = _list(j['cities'], CityDef.fromJson),
        cityEdges = (j['cityEdges'] as List).map((e) => _strings(e)).toList(),
        starts = _list(j['starts'], StartSlot.fromJson),
        terrain = Terrain.fromJson(j['terrain']);
  final String id, name;
  final List<CityDef> cities;
  final List<List<String>> cityEdges;
  final List<StartSlot> starts;
  final Terrain terrain;

  CityDef? city(String id) => cities.where((c) => c.id == id).firstOrNull;
  StartSlot? start(String nodeId) => starts.where((s) => 'birtok:${s.id}' == nodeId).firstOrNull;

  /// Egy csomópont (város vagy birtok) helye.
  (double, double)? pos(String node) {
    final c = city(node);
    if (c != null) return (c.x, c.y);
    final s = start(node);
    if (s != null) return (s.x, s.y);
    return null;
  }

  String nodeName(String node) => city(node)?.name ?? start(node)?.name ?? node;
}

// ---------- Játékállapot ----------

class Cost {
  Cost.fromJson(Map<String, dynamic> j) : pp = _i(j['pp']), arany = _i(j['arany']), bp = _i(j['bp']), ke = _i(j['ke']);
  final int pp, arany, bp, ke;
}

class Me {
  Me.fromJson(Map<String, dynamic> j)
      : playerId = j['playerId'],
        houseName = j['houseName'],
        tincture = j['tincture'],
        estate = j['estate'],
        pp = _i(j['pp']),
        ppMax = _i(j['ppMax']),
        arany = _i(j['arany']),
        bp = _i(j['bp']),
        ke = _i(j['ke']),
        legit = _i(j['legit']),
        sealed = j['sealed'] == true;
  final String playerId, houseName, tincture;
  final String? estate;
  final int pp, ppMax, arany, bp, ke, legit;
  final bool sealed;
}

class Segment {
  Segment.fromJson(Map<String, dynamic> j)
      : playerId = j['playerId'],
        name = j['name'],
        tincture = j['tincture'],
        value = _d(j['value']),
        label = j['label'] ?? '',
        self = j['self'] == true,
        npc = j['npc'] == true;
  final String playerId, name, tincture, label;
  final double value;
  final bool self, npc;
}

class Rival {
  Rival.fromJson(Map<String, dynamic> j) : playerId = j['playerId'], name = j['name'];
  final String playerId, name;
}

class FactionView {
  FactionView.fromJson(Map<String, dynamic> j)
      : faction = j['faction'],
        level = j['level'],
        precision = j['precision'],
        segments = _list(j['segments'], Segment.fromJson),
        unknown = _d(j['unknown']),
        unknownLabel = j['unknownLabel'],
        ownHidden = _d(j['ownHidden']),
        neutral = _d(j['neutral']),
        suspicion = _i(j['suspicion']),
        dominantTincture = j['dominantTincture'],
        contestedTincture = j['contestedTincture'],
        rivals = _list(j['rivals'], Rival.fromJson);
  final String faction, precision;
  final String? level, unknownLabel, dominantTincture, contestedTincture;
  final List<Segment> segments;
  final double unknown, ownHidden, neutral;
  final int suspicion;
  final List<Rival> rivals;
}

class CityView {
  CityView.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name'],
        stability = j['stability'],
        reach = j['reach'],
        distance = j['distance'] == null ? null : _i(j['distance']),
        bestLevel = j['bestLevel'],
        decayPercent = _i(j['decayPercent']),
        factions = _list(j['factions'], FactionView.fromJson);
  final String id, name, stability, reach;
  final int? distance;
  final String? bestLevel;
  final int decayPercent;
  final List<FactionView> factions;
  bool get reachable => reach == 'reachable';
  FactionView faction(String f) => factions.firstWhere((x) => x.faction == f);
}

class RouteView {
  RouteView.fromJson(Map<String, dynamic> j) : from = j['from'], to = j['to'], state = j['state'];
  final String from, to, state;
}

class Buildable {
  Buildable.fromJson(Map<String, dynamic> j) : from = j['from'], to = j['to'], fromName = j['fromName'], toName = j['toName'];
  final String from, to, fromName, toName;
}

class OrderView {
  OrderView.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        type = j['type'],
        label = j['label'],
        cityLabel = j['cityLabel'] ?? '',
        faction = j['faction'],
        hidden = j['hidden'] == true,
        targetName = j['targetName'],
        cost = Cost.fromJson(j['cost']);
  final String id, type, label, cityLabel;
  final String? faction, targetName;
  final bool hidden;
  final Cost cost;
}

class ActionInfo {
  ActionInfo.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        label = j['label'],
        factions = _strings(j['factions']),
        power = _d(j['power']),
        needsPresence = j['needsPresence'] == true,
        cost = Cost.fromJson(j['cost']),
        hiddenCost = Cost.fromJson(j['hiddenCost']);
  final String id, label;
  final List<String> factions;
  final double power;
  final bool needsPresence;
  final Cost cost, hiddenCost;
}

class GameState {
  GameState.fromJson(Map<String, dynamic> j)
      : gameId = j['gameId'],
        gameName = j['gameName'],
        mapId = j['mapId'],
        status = j['status'],
        round = _i(j['round']),
        maxRounds = _i(j['maxRounds']),
        nextResolutionAt = _date(j['nextResolutionAt']),
        me = Me.fromJson(j['me']),
        pending = Cost.fromJson(j['pending']),
        routes = _list(j['routes'], RouteView.fromJson),
        buildable = _list(j['buildable'], Buildable.fromJson),
        cities = _list(j['cities'], CityView.fromJson),
        orders = _list(j['orders'], OrderView.fromJson),
        actions = _list(j['actions'], ActionInfo.fromJson);
  final String gameId, gameName, mapId, status;
  final int round, maxRounds;
  final DateTime? nextResolutionAt;
  final Me me;
  final Cost pending;
  final List<RouteView> routes;
  final List<Buildable> buildable;
  final List<CityView> cities;
  final List<OrderView> orders;
  final List<ActionInfo> actions;

  CityView city(String id) => cities.firstWhere((c) => c.id == id);
}

class ReportView {
  ReportView.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        round = _i(j['round']),
        kind = j['kind'],
        confidence = j['confidence'],
        title = j['title'],
        text = j['text'],
        tone = j['tone'] ?? 'info',
        createdAt = _date(j['createdAt']);
  final String id, kind, title, text, tone;
  final int round;
  final String? confidence;
  final DateTime? createdAt;
}

class RankRow {
  RankRow.fromJson(Map<String, dynamic> j)
      : rank = _i(j['rank']),
        playerId = j['playerId'],
        name = j['name'],
        tincture = j['tincture'],
        npc = j['npc'] == true,
        legit = _i(j['legit']),
        self = j['self'] == true;
  final int rank, legit;
  final String playerId, name, tincture;
  final bool npc, self;
}
