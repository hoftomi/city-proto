// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rival_sheet.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RivalSheetCWProxy {
  RivalSheet house(HouseRef house);

  RivalSheet executeAt(DateTime executeAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RivalSheet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RivalSheet(...).copyWith(id: 12, name: "My name")
  /// ````
  RivalSheet call({HouseRef house, DateTime executeAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRivalSheet.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRivalSheet.copyWith.fieldName(...)`
class _$RivalSheetCWProxyImpl implements _$RivalSheetCWProxy {
  const _$RivalSheetCWProxyImpl(this._value);

  final RivalSheet _value;

  @override
  RivalSheet house(HouseRef house) => this(house: house);

  @override
  RivalSheet executeAt(DateTime executeAt) => this(executeAt: executeAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RivalSheet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RivalSheet(...).copyWith(id: 12, name: "My name")
  /// ````
  RivalSheet call({
    Object? house = const $CopyWithPlaceholder(),
    Object? executeAt = const $CopyWithPlaceholder(),
  }) {
    return RivalSheet(
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

extension $RivalSheetCopyWith on RivalSheet {
  /// Returns a callable class that can be used as follows: `instanceOfRivalSheet.copyWith(...)` or like so:`instanceOfRivalSheet.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RivalSheetCWProxy get copyWith => _$RivalSheetCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RivalSheet _$RivalSheetFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RivalSheet', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['house', 'executeAt']);
      final val = RivalSheet(
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

Map<String, dynamic> _$RivalSheetToJson(RivalSheet instance) =>
    <String, dynamic>{
      'house': instance.house.toJson(),
      'executeAt': instance.executeAt.toIso8601String(),
    };
