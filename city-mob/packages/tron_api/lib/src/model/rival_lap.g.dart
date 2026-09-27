// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rival_lap.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RivalLapCWProxy {
  RivalLap house(HouseRef house);

  RivalLap executeAt(DateTime executeAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RivalLap(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RivalLap(...).copyWith(id: 12, name: "My name")
  /// ````
  RivalLap call({HouseRef house, DateTime executeAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRivalLap.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRivalLap.copyWith.fieldName(...)`
class _$RivalLapCWProxyImpl implements _$RivalLapCWProxy {
  const _$RivalLapCWProxyImpl(this._value);

  final RivalLap _value;

  @override
  RivalLap house(HouseRef house) => this(house: house);

  @override
  RivalLap executeAt(DateTime executeAt) => this(executeAt: executeAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RivalLap(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RivalLap(...).copyWith(id: 12, name: "My name")
  /// ````
  RivalLap call({
    Object? house = const $CopyWithPlaceholder(),
    Object? executeAt = const $CopyWithPlaceholder(),
  }) {
    return RivalLap(
      house: house == const $CopyWithPlaceholder()
          ? _value.house
          // ignore: cast_nullable_to_non_nullable
          : house as HouseRef,
      executeAt: executeAt == const $CopyWithPlaceholder()
          ? _value.executeAt
          // ignore: cast_nullable_to_non_nullable
          : executeAt as DateTime,
    );
  }
}

extension $RivalLapCopyWith on RivalLap {
  /// Returns a callable class that can be used as follows: `instanceOfRivalLap.copyWith(...)` or like so:`instanceOfRivalLap.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RivalLapCWProxy get copyWith => _$RivalLapCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RivalLap _$RivalLapFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RivalLap', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['house', 'executeAt']);
      final val = RivalLap(
        house: $checkedConvert(
          'house',
          (v) => HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        executeAt: $checkedConvert(
          'executeAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RivalLapToJson(RivalLap instance) => <String, dynamic>{
  'house': instance.house.toJson(),
  'executeAt': instance.executeAt.toIso8601String(),
};
