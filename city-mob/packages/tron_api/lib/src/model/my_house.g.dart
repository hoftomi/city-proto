// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_house.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MyHouseCWProxy {
  MyHouse playerId(String playerId);

  MyHouse houseName(String houseName);

  MyHouse tincture(String tincture);

  MyHouse background(String? background);

  MyHouse backgroundName(String? backgroundName);

  MyHouse startSlot(String? startSlot);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyHouse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyHouse(...).copyWith(id: 12, name: "My name")
  /// ````
  MyHouse call({
    String playerId,
    String houseName,
    String tincture,
    String? background,
    String? backgroundName,
    String? startSlot,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMyHouse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMyHouse.copyWith.fieldName(...)`
class _$MyHouseCWProxyImpl implements _$MyHouseCWProxy {
  const _$MyHouseCWProxyImpl(this._value);

  final MyHouse _value;

  @override
  MyHouse playerId(String playerId) => this(playerId: playerId);

  @override
  MyHouse houseName(String houseName) => this(houseName: houseName);

  @override
  MyHouse tincture(String tincture) => this(tincture: tincture);

  @override
  MyHouse background(String? background) => this(background: background);

  @override
  MyHouse backgroundName(String? backgroundName) =>
      this(backgroundName: backgroundName);

  @override
  MyHouse startSlot(String? startSlot) => this(startSlot: startSlot);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyHouse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyHouse(...).copyWith(id: 12, name: "My name")
  /// ````
  MyHouse call({
    Object? playerId = const $CopyWithPlaceholder(),
    Object? houseName = const $CopyWithPlaceholder(),
    Object? tincture = const $CopyWithPlaceholder(),
    Object? background = const $CopyWithPlaceholder(),
    Object? backgroundName = const $CopyWithPlaceholder(),
    Object? startSlot = const $CopyWithPlaceholder(),
  }) {
    return MyHouse(
      playerId: playerId == const $CopyWithPlaceholder()
          ? _value.playerId
          // ignore: cast_nullable_to_non_nullable
          : playerId as String,
      houseName: houseName == const $CopyWithPlaceholder()
          ? _value.houseName
          // ignore: cast_nullable_to_non_nullable
          : houseName as String,
      tincture: tincture == const $CopyWithPlaceholder()
          ? _value.tincture
          // ignore: cast_nullable_to_non_nullable
          : tincture as String,
      background: background == const $CopyWithPlaceholder()
          ? _value.background
          // ignore: cast_nullable_to_non_nullable
          : background as String?,
      backgroundName: backgroundName == const $CopyWithPlaceholder()
          ? _value.backgroundName
          // ignore: cast_nullable_to_non_nullable
          : backgroundName as String?,
      startSlot: startSlot == const $CopyWithPlaceholder()
          ? _value.startSlot
          // ignore: cast_nullable_to_non_nullable
          : startSlot as String?,
    );
  }
}

extension $MyHouseCopyWith on MyHouse {
  /// Returns a callable class that can be used as follows: `instanceOfMyHouse.copyWith(...)` or like so:`instanceOfMyHouse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MyHouseCWProxy get copyWith => _$MyHouseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyHouse _$MyHouseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MyHouse', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'playerId',
          'houseName',
          'tincture',
          'background',
          'backgroundName',
          'startSlot',
        ],
      );
      final val = MyHouse(
        playerId: $checkedConvert('playerId', (v) => v as String),
        houseName: $checkedConvert('houseName', (v) => v as String),
        tincture: $checkedConvert('tincture', (v) => v as String),
        background: $checkedConvert('background', (v) => v as String?),
        backgroundName: $checkedConvert('backgroundName', (v) => v as String?),
        startSlot: $checkedConvert('startSlot', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MyHouseToJson(MyHouse instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'houseName': instance.houseName,
  'tincture': instance.tincture,
  'background': instance.background,
  'backgroundName': instance.backgroundName,
  'startSlot': instance.startSlot,
};
