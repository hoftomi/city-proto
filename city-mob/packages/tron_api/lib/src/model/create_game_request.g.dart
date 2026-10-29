// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_game_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateGameRequestCWProxy {
  CreateGameRequest id(String id);

  CreateGameRequest name(String name);

  CreateGameRequest mapId(String mapId);

  CreateGameRequest opensAt(DateTime? opensAt);

  CreateGameRequest closesAt(DateTime? closesAt);

  CreateGameRequest maxPlayers(int maxPlayers);

  CreateGameRequest npcCount(int npcCount);

  CreateGameRequest tags(List<String> tags);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateGameRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateGameRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateGameRequest call({
    String id,
    String name,
    String mapId,
    DateTime? opensAt,
    DateTime? closesAt,
    int maxPlayers,
    int npcCount,
    List<String> tags,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateGameRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateGameRequest.copyWith.fieldName(...)`
class _$CreateGameRequestCWProxyImpl implements _$CreateGameRequestCWProxy {
  const _$CreateGameRequestCWProxyImpl(this._value);

  final CreateGameRequest _value;

  @override
  CreateGameRequest id(String id) => this(id: id);

  @override
  CreateGameRequest name(String name) => this(name: name);

  @override
  CreateGameRequest mapId(String mapId) => this(mapId: mapId);

  @override
  CreateGameRequest opensAt(DateTime? opensAt) => this(opensAt: opensAt);

  @override
  CreateGameRequest closesAt(DateTime? closesAt) => this(closesAt: closesAt);

  @override
  CreateGameRequest maxPlayers(int maxPlayers) => this(maxPlayers: maxPlayers);

  @override
  CreateGameRequest npcCount(int npcCount) => this(npcCount: npcCount);

  @override
  CreateGameRequest tags(List<String> tags) => this(tags: tags);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateGameRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateGameRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateGameRequest call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? mapId = const $CopyWithPlaceholder(),
    Object? opensAt = const $CopyWithPlaceholder(),
    Object? closesAt = const $CopyWithPlaceholder(),
    Object? maxPlayers = const $CopyWithPlaceholder(),
    Object? npcCount = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
  }) {
    return CreateGameRequest(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      mapId: mapId == const $CopyWithPlaceholder()
          ? _value.mapId
          // ignore: cast_nullable_to_non_nullable
          : mapId as String,
      opensAt: opensAt == const $CopyWithPlaceholder()
          ? _value.opensAt
          // ignore: cast_nullable_to_non_nullable
          : opensAt as DateTime?,
      closesAt: closesAt == const $CopyWithPlaceholder()
          ? _value.closesAt
          // ignore: cast_nullable_to_non_nullable
          : closesAt as DateTime?,
      maxPlayers: maxPlayers == const $CopyWithPlaceholder()
          ? _value.maxPlayers
          // ignore: cast_nullable_to_non_nullable
          : maxPlayers as int,
      npcCount: npcCount == const $CopyWithPlaceholder()
          ? _value.npcCount
          // ignore: cast_nullable_to_non_nullable
          : npcCount as int,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>,
    );
  }
}

extension $CreateGameRequestCopyWith on CreateGameRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateGameRequest.copyWith(...)` or like so:`instanceOfCreateGameRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateGameRequestCWProxy get copyWith =>
      _$CreateGameRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGameRequest _$CreateGameRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateGameRequest', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'mapId',
          'opensAt',
          'closesAt',
          'maxPlayers',
          'npcCount',
          'tags',
        ],
      );
      final val = CreateGameRequest(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        mapId: $checkedConvert('mapId', (v) => v as String),
        opensAt: $checkedConvert(
          'opensAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        closesAt: $checkedConvert(
          'closesAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        maxPlayers: $checkedConvert('maxPlayers', (v) => (v as num).toInt()),
        npcCount: $checkedConvert('npcCount', (v) => (v as num).toInt()),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CreateGameRequestToJson(CreateGameRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mapId': instance.mapId,
      'opensAt': instance.opensAt?.toIso8601String(),
      'closesAt': instance.closesAt?.toIso8601String(),
      'maxPlayers': instance.maxPlayers,
      'npcCount': instance.npcCount,
      'tags': instance.tags,
    };
