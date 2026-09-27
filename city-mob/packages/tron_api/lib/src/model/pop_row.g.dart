// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pop_row.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PopRowCWProxy {
  PopRow house(HouseRef house);

  PopRow value(double value);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PopRow(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PopRow(...).copyWith(id: 12, name: "My name")
  /// ````
  PopRow call({HouseRef house, double value});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPopRow.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPopRow.copyWith.fieldName(...)`
class _$PopRowCWProxyImpl implements _$PopRowCWProxy {
  const _$PopRowCWProxyImpl(this._value);

  final PopRow _value;

  @override
  PopRow house(HouseRef house) => this(house: house);

  @override
  PopRow value(double value) => this(value: value);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PopRow(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PopRow(...).copyWith(id: 12, name: "My name")
  /// ````
  PopRow call({
    Object? house = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
  }) {
    return PopRow(
      house: house == const $CopyWithPlaceholder()
          ? _value.house
          // ignore: cast_nullable_to_non_nullable
          : house as HouseRef,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as double,
    );
  }
}

extension $PopRowCopyWith on PopRow {
  /// Returns a callable class that can be used as follows: `instanceOfPopRow.copyWith(...)` or like so:`instanceOfPopRow.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PopRowCWProxy get copyWith => _$PopRowCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopRow _$PopRowFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PopRow', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['house', 'value']);
      final val = PopRow(
        house: $checkedConvert(
          'house',
          (v) => HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        value: $checkedConvert('value', (v) => (v as num).toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$PopRowToJson(PopRow instance) => <String, dynamic>{
  'house': instance.house.toJson(),
  'value': instance.value,
};
