import 'package:tron_api/tron_api.dart';

/// Test data for the lobby, the details and the join flow.
GameSummary summary({
  String id = 'g1',
  String status = 'open',
  int round = 0,
  int players = 3,
  int maxPlayers = 10,
  MyHouse? myHouse,
  DateTime? closesAt,
}) =>
    GameSummary(
      id: id,
      name: 'Játék $id',
      status: status,
      mapId: 'm1',
      closesAt: closesAt,
      opensAt: null,
      round: round,
      maxRounds: 20,
      players: players,
      maxPlayers: maxPlayers,
      cities: 6,
      npcCount: 2,
      tags: const [],
      winner: null,
      myPlace: null,
      myHouse: myHouse,
    );

MyHouse house() => MyHouse(playerId: 'p1', houseName: 'Kékholló', tincture: 'azur', background: 'merchant', backgroundName: 'Kereskedőház', startSlot: 's1');

StartSlotDto slot(String id, {List<GoodOption> goods = const []}) => StartSlotDto(
      id: id,
      name: 'Birtok $id',
      x: 0,
      y: 0,
      neighbors: const ['c1', 'c2'],
      neighborNames: const ['Alfa', 'Béta'],
      note: '',
      homeCity: 'c1',
      homeCityName: 'Alfa',
      homeGoods: goods,
    );

GameDetail detail({GameSummary? game}) => GameDetail(
      game: game ?? summary(),
      starts: [
        slot('s1', goods: [GoodOption(id: 'wine', name: 'Bor'), GoodOption(id: 'salt', name: 'Só')]),
        slot('s2'),
      ],
      backgrounds: [
        BackgroundDto(id: 'noble', name: 'Nemesház', icon: 'nobility', perks: const []),
        BackgroundDto(id: 'merchant', name: 'Kereskedőház', icon: 'merchants', perks: const []),
      ],
      tinctures: const ['azur', 'gules'],
    );

final mapDef = MapDef(
  id: 'm1',
  name: 'Térkép',
  cities: const [],
  cityEdges: const [],
  starts: const [],
  terrain: TerrainDef(sea: null, rivers: const [], mountains: const [], forests: const [], fields: const [], marsh: const []),
);
