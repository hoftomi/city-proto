// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_house.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminHouseCWProxy {
  AdminHouse playerId(String playerId);

  AdminHouse userId(String? userId);

  AdminHouse userName(String? userName);

  AdminHouse houseName(String houseName);

  AdminHouse background(Background? background);

  AdminHouse npc(bool npc);

  AdminHouse persona(String? persona);

  AdminHouse legit(int legit);

  AdminHouse gold(double? gold);

  AdminHouse pp(int? pp);

  AdminHouse place(int? place);

  AdminHouse joinedAt(DateTime joinedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminHouse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminHouse(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminHouse call({
    String playerId,
    String? userId,
    String? userName,
    String houseName,
    Background? background,
    bool npc,
    String? persona,
    int legit,
    double? gold,
    int? pp,
    int? place,
    DateTime joinedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminHouse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminHouse.copyWith.fieldName(...)`
class _$AdminHouseCWProxyImpl implements _$AdminHouseCWProxy {
  const _$AdminHouseCWProxyImpl(this._value);

  final AdminHouse _value;

  @override
  AdminHouse playerId(String playerId) => this(playerId: playerId);

  @override
  AdminHouse userId(String? userId) => this(userId: userId);

  @override
  AdminHouse userName(String? userName) => this(userName: userName);

  @override
  AdminHouse houseName(String houseName) => this(houseName: houseName);

  @override
  AdminHouse background(Background? background) => this(background: background);

  @override
  AdminHouse npc(bool npc) => this(npc: npc);

  @override
  AdminHouse persona(String? persona) => this(persona: persona);

  @override
  AdminHouse legit(int legit) => this(legit: legit);

  @override
  AdminHouse gold(double? gold) => this(gold: gold);

  @override
  AdminHouse pp(int? pp) => this(pp: pp);

  @override
  AdminHouse place(int? place) => this(place: place);

  @override
  AdminHouse joinedAt(DateTime joinedAt) => this(joinedAt: joinedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminHouse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminHouse(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminHouse call({
    Object? playerId = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
    Object? userName = const $CopyWithPlaceholder(),
    Object? houseName = const $CopyWithPlaceholder(),
    Object? background = const $CopyWithPlaceholder(),
    Object? npc = const $CopyWithPlaceholder(),
    Object? persona = const $CopyWithPlaceholder(),
    Object? legit = const $CopyWithPlaceholder(),
    Object? gold = const $CopyWithPlaceholder(),
    Object? pp = const $CopyWithPlaceholder(),
    Object? place = const $CopyWithPlaceholder(),
    Object? joinedAt = const $CopyWithPlaceholder(),
  }) {
    return AdminHouse(
      playerId: playerId == const $CopyWithPlaceholder()
          ? _value.playerId
          // ignore: cast_nullable_to_non_nullable
          : playerId as String,
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String?,
      userName: userName == const $CopyWithPlaceholder()
          ? _value.userName
          // ignore: cast_nullable_to_non_nullable
          : userName as String?,
      houseName: houseName == const $CopyWithPlaceholder()
          ? _value.houseName
          // ignore: cast_nullable_to_non_nullable
          : houseName as String,
      background: background == const $CopyWithPlaceholder()
          ? _value.background
          // ignore: cast_nullable_to_non_nullable
          : background as Background?,
      npc: npc == const $CopyWithPlaceholder()
          ? _value.npc
          // ignore: cast_nullable_to_non_nullable
          : npc as bool,
      persona: persona == const $CopyWithPlaceholder()
          ? _value.persona
          // ignore: cast_nullable_to_non_nullable
          : persona as String?,
      legit: legit == const $CopyWithPlaceholder()
          ? _value.legit
          // ignore: cast_nullable_to_non_nullable
          : legit as int,
      gold: gold == const $CopyWithPlaceholder()
          ? _value.gold
          // ignore: cast_nullable_to_non_nullable
          : gold as double?,
      pp: pp == const $CopyWithPlaceholder()
          ? _value.pp
          // ignore: cast_nullable_to_non_nullable
          : pp as int?,
      place: place == const $CopyWithPlaceholder()
          ? _value.place
          // ignore: cast_nullable_to_non_nullable
          : place as int?,
      joinedAt: joinedAt == const $CopyWithPlaceholder()
          ? _value.joinedAt
          // ignore: cast_nullable_to_non_nullable
          : joinedAt as DateTime,
    );
  }
}

extension $AdminHouseCopyWith on AdminHouse {
  /// Returns a callable class that can be used as follows: `instanceOfAdminHouse.copyWith(...)` or like so:`instanceOfAdminHouse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminHouseCWProxy get copyWith => _$AdminHouseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminHouse _$AdminHouseFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AdminHouse',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'playerId',
        'userId',
        'userName',
        'houseName',
        'background',
        'npc',
        'persona',
        'legit',
        'gold',
        'pp',
        'place',
        'joinedAt',
      ],
    );
    final val = AdminHouse(
      playerId: $checkedConvert('playerId', (v) => v as String),
      userId: $checkedConvert('userId', (v) => v as String?),
      userName: $checkedConvert('userName', (v) => v as String?),
      houseName: $checkedConvert('houseName', (v) => v as String),
      background: $checkedConvert(
        'background',
        (v) => $enumDecodeNullable(_$BackgroundEnumMap, v),
      ),
      npc: $checkedConvert('npc', (v) => v as bool),
      persona: $checkedConvert('persona', (v) => v as String?),
      legit: $checkedConvert('legit', (v) => (v as num).toInt()),
      gold: $checkedConvert('gold', (v) => (v as num?)?.toDouble()),
      pp: $checkedConvert('pp', (v) => (v as num?)?.toInt()),
      place: $checkedConvert('place', (v) => (v as num?)?.toInt()),
      joinedAt: $checkedConvert('joinedAt', (v) => DateTime.parse(v as String)),
    );
    return val;
  },
);

Map<String, dynamic> _$AdminHouseToJson(AdminHouse instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'userId': instance.userId,
      'userName': instance.userName,
      'houseName': instance.houseName,
      'background': _$BackgroundEnumMap[instance.background],
      'npc': instance.npc,
      'persona': instance.persona,
      'legit': instance.legit,
      'gold': instance.gold,
      'pp': instance.pp,
      'place': instance.place,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

const _$BackgroundEnumMap = {
  Background.merchant: 'merchant',
  Background.noble: 'noble',
  Background.shadow: 'shadow',
};
