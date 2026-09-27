// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CostCWProxy {
  Cost pp(int pp);

  Cost gold(int gold);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Cost(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Cost(...).copyWith(id: 12, name: "My name")
  /// ````
  Cost call({int pp, int gold});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCost.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCost.copyWith.fieldName(...)`
class _$CostCWProxyImpl implements _$CostCWProxy {
  const _$CostCWProxyImpl(this._value);

  final Cost _value;

  @override
  Cost pp(int pp) => this(pp: pp);

  @override
  Cost gold(int gold) => this(gold: gold);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Cost(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Cost(...).copyWith(id: 12, name: "My name")
  /// ````
  Cost call({
    Object? pp = const $CopyWithPlaceholder(),
    Object? gold = const $CopyWithPlaceholder(),
  }) {
    return Cost(
      pp: pp == const $CopyWithPlaceholder()
          ? _value.pp
          // ignore: cast_nullable_to_non_nullable
          : pp as int,
      gold: gold == const $CopyWithPlaceholder()
          ? _value.gold
          // ignore: cast_nullable_to_non_nullable
          : gold as int,
    );
  }
}

extension $CostCopyWith on Cost {
  /// Returns a callable class that can be used as follows: `instanceOfCost.copyWith(...)` or like so:`instanceOfCost.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CostCWProxy get copyWith => _$CostCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cost _$CostFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Cost', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['pp', 'gold']);
      final val = Cost(
        pp: $checkedConvert('pp', (v) => (v as num).toInt()),
        gold: $checkedConvert('gold', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
  'pp': instance.pp,
  'gold': instance.gold,
};
