// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house_ref.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HouseRefCWProxy {
  HouseRef playerId(String playerId);

  HouseRef name(String name);

  HouseRef tincture(String tincture);

  HouseRef npc(bool npc);

  HouseRef self(bool self);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HouseRef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HouseRef(...).copyWith(id: 12, name: "My name")
  /// ````
  HouseRef call({
    String playerId,
    String name,
    String tincture,
    bool npc,
    bool self,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHouseRef.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHouseRef.copyWith.fieldName(...)`
class _$HouseRefCWProxyImpl implements _$HouseRefCWProxy {
  const _$HouseRefCWProxyImpl(this._value);

  final HouseRef _value;

  @override
  HouseRef playerId(String playerId) => this(playerId: playerId);

  @override
  HouseRef name(String name) => this(name: name);

  @override
  HouseRef tincture(String tincture) => this(tincture: tincture);

  @override
  HouseRef npc(bool npc) => this(npc: npc);

  @override
  HouseRef self(bool self) => this(self: self);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HouseRef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HouseRef(...).copyWith(id: 12, name: "My name")
  /// ````
  HouseRef call({
    Object? playerId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? tincture = const $CopyWithPlaceholder(),
    Object? npc = const $CopyWithPlaceholder(),
    Object? self = const $CopyWithPlaceholder(),
  }) {
    return HouseRef(
      playerId: playerId == const $CopyWithPlaceholder()
          ? _value.playerId
          // ignore: cast_nullable_to_non_nullable
          : playerId as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      tincture: tincture == const $CopyWithPlaceholder()
          ? _value.tincture
          // ignore: cast_nullable_to_non_nullable
          : tincture as String,
      npc: npc == const $CopyWithPlaceholder()
          ? _value.npc
          // ignore: cast_nullable_to_non_nullable
          : npc as bool,
      self: self == const $CopyWithPlaceholder()
          ? _value.self
          // ignore: cast_nullable_to_non_nullable
          : self as bool,
    );
  }
}

extension $HouseRefCopyWith on HouseRef {
  /// Returns a callable class that can be used as follows: `instanceOfHouseRef.copyWith(...)` or like so:`instanceOfHouseRef.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HouseRefCWProxy get copyWith => _$HouseRefCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HouseRef _$HouseRefFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HouseRef', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['playerId', 'name', 'tincture', 'npc', 'self'],
      );
      final val = HouseRef(
        playerId: $checkedConvert('playerId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        tincture: $checkedConvert('tincture', (v) => v as String),
        npc: $checkedConvert('npc', (v) => v as bool),
        self: $checkedConvert('self', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$HouseRefToJson(HouseRef instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'name': instance.name,
  'tincture': instance.tincture,
  'npc': instance.npc,
  'self': instance.self,
};
