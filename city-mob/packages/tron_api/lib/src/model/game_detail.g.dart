// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GameDetailCWProxy {
  GameDetail game(GameSummary game);

  GameDetail mapId(String mapId);

  GameDetail round(int round);

  GameDetail maxRounds(int maxRounds);

  GameDetail players(int players);

  GameDetail maxPlayers(int maxPlayers);

  GameDetail cities(int cities);

  GameDetail npcCount(int npcCount);

  GameDetail starts(List<StartSlotDto> starts);

  GameDetail backgrounds(List<BackgroundDto> backgrounds);

  GameDetail tinctures(List<String> tinctures);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GameDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GameDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  GameDetail call({
    GameSummary game,
    String mapId,
    int round,
    int maxRounds,
    int players,
    int maxPlayers,
    int cities,
    int npcCount,
    List<StartSlotDto> starts,
    List<BackgroundDto> backgrounds,
    List<String> tinctures,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGameDetail.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGameDetail.copyWith.fieldName(...)`
class _$GameDetailCWProxyImpl implements _$GameDetailCWProxy {
  const _$GameDetailCWProxyImpl(this._value);

  final GameDetail _value;

  @override
  GameDetail game(GameSummary game) => this(game: game);

  @override
  GameDetail mapId(String mapId) => this(mapId: mapId);

  @override
  GameDetail round(int round) => this(round: round);

  @override
  GameDetail maxRounds(int maxRounds) => this(maxRounds: maxRounds);

  @override
  GameDetail players(int players) => this(players: players);

  @override
  GameDetail maxPlayers(int maxPlayers) => this(maxPlayers: maxPlayers);

  @override
  GameDetail cities(int cities) => this(cities: cities);

  @override
  GameDetail npcCount(int npcCount) => this(npcCount: npcCount);

  @override
  GameDetail starts(List<StartSlotDto> starts) => this(starts: starts);

  @override
  GameDetail backgrounds(List<BackgroundDto> backgrounds) =>
      this(backgrounds: backgrounds);

  @override
  GameDetail tinctures(List<String> tinctures) => this(tinctures: tinctures);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GameDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GameDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  GameDetail call({
    Object? game = const $CopyWithPlaceholder(),
    Object? mapId = const $CopyWithPlaceholder(),
    Object? round = const $CopyWithPlaceholder(),
    Object? maxRounds = const $CopyWithPlaceholder(),
    Object? players = const $CopyWithPlaceholder(),
    Object? maxPlayers = const $CopyWithPlaceholder(),
    Object? cities = const $CopyWithPlaceholder(),
    Object? npcCount = const $CopyWithPlaceholder(),
    Object? starts = const $CopyWithPlaceholder(),
    Object? backgrounds = const $CopyWithPlaceholder(),
    Object? tinctures = const $CopyWithPlaceholder(),
  }) {
    return GameDetail(
      game: game == const $CopyWithPlaceholder()
          ? _value.game
          // ignore: cast_nullable_to_non_nullable
          : game as GameSummary,
      mapId: mapId == const $CopyWithPlaceholder()
          ? _value.mapId
          // ignore: cast_nullable_to_non_nullable
          : mapId as String,
      round: round == const $CopyWithPlaceholder()
          ? _value.round
          // ignore: cast_nullable_to_non_nullable
          : round as int,
      maxRounds: maxRounds == const $CopyWithPlaceholder()
          ? _value.maxRounds
          // ignore: cast_nullable_to_non_nullable
          : maxRounds as int,
      players: players == const $CopyWithPlaceholder()
          ? _value.players
          // ignore: cast_nullable_to_non_nullable
          : players as int,
      maxPlayers: maxPlayers == const $CopyWithPlaceholder()
          ? _value.maxPlayers
          // ignore: cast_nullable_to_non_nullable
          : maxPlayers as int,
      cities: cities == const $CopyWithPlaceholder()
          ? _value.cities
          // ignore: cast_nullable_to_non_nullable
          : cities as int,
      npcCount: npcCount == const $CopyWithPlaceholder()
          ? _value.npcCount
          // ignore: cast_nullable_to_non_nullable
          : npcCount as int,
      starts: starts == const $CopyWithPlaceholder()
          ? _value.starts
          // ignore: cast_nullable_to_non_nullable
          : starts as List<StartSlotDto>,
      backgrounds: backgrounds == const $CopyWithPlaceholder()
          ? _value.backgrounds
          // ignore: cast_nullable_to_non_nullable
          : backgrounds as List<BackgroundDto>,
      tinctures: tinctures == const $CopyWithPlaceholder()
          ? _value.tinctures
          // ignore: cast_nullable_to_non_nullable
          : tinctures as List<String>,
    );
  }
}

extension $GameDetailCopyWith on GameDetail {
  /// Returns a callable class that can be used as follows: `instanceOfGameDetail.copyWith(...)` or like so:`instanceOfGameDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GameDetailCWProxy get copyWith => _$GameDetailCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameDetail _$GameDetailFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GameDetail', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'game',
          'mapId',
          'round',
          'maxRounds',
          'players',
          'maxPlayers',
          'cities',
          'npcCount',
          'starts',
          'backgrounds',
          'tinctures',
        ],
      );
      final val = GameDetail(
        game: $checkedConvert(
          'game',
          (v) => GameSummary.fromJson(v as Map<String, dynamic>),
        ),
        mapId: $checkedConvert('mapId', (v) => v as String),
        round: $checkedConvert('round', (v) => (v as num).toInt()),
        maxRounds: $checkedConvert('maxRounds', (v) => (v as num).toInt()),
        players: $checkedConvert('players', (v) => (v as num).toInt()),
        maxPlayers: $checkedConvert('maxPlayers', (v) => (v as num).toInt()),
        cities: $checkedConvert('cities', (v) => (v as num).toInt()),
        npcCount: $checkedConvert('npcCount', (v) => (v as num).toInt()),
        starts: $checkedConvert(
          'starts',
          (v) => (v as List<dynamic>)
              .map((e) => StartSlotDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        backgrounds: $checkedConvert(
          'backgrounds',
          (v) => (v as List<dynamic>)
              .map((e) => BackgroundDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        tinctures: $checkedConvert(
          'tinctures',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GameDetailToJson(GameDetail instance) =>
    <String, dynamic>{
      'game': instance.game.toJson(),
      'mapId': instance.mapId,
      'round': instance.round,
      'maxRounds': instance.maxRounds,
      'players': instance.players,
      'maxPlayers': instance.maxPlayers,
      'cities': instance.cities,
      'npcCount': instance.npcCount,
      'starts': instance.starts.map((e) => e.toJson()).toList(),
      'backgrounds': instance.backgrounds.map((e) => e.toJson()).toList(),
      'tinctures': instance.tinctures,
    };
