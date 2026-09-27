// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'good_def.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoodDefCWProxy {
  GoodDef id(String id);

  GoodDef name(String name);

  GoodDef supply(int supply);

  GoodDef demand(int demand);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoodDef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoodDef(...).copyWith(id: 12, name: "My name")
  /// ````
  GoodDef call({String id, String name, int supply, int demand});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGoodDef.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGoodDef.copyWith.fieldName(...)`
class _$GoodDefCWProxyImpl implements _$GoodDefCWProxy {
  const _$GoodDefCWProxyImpl(this._value);

  final GoodDef _value;

  @override
  GoodDef id(String id) => this(id: id);

  @override
  GoodDef name(String name) => this(name: name);

  @override
  GoodDef supply(int supply) => this(supply: supply);

  @override
  GoodDef demand(int demand) => this(demand: demand);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoodDef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoodDef(...).copyWith(id: 12, name: "My name")
  /// ````
  GoodDef call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? supply = const $CopyWithPlaceholder(),
    Object? demand = const $CopyWithPlaceholder(),
  }) {
    return GoodDef(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      supply: supply == const $CopyWithPlaceholder()
          ? _value.supply
          // ignore: cast_nullable_to_non_nullable
          : supply as int,
      demand: demand == const $CopyWithPlaceholder()
          ? _value.demand
          // ignore: cast_nullable_to_non_nullable
          : demand as int,
    );
  }
}

extension $GoodDefCopyWith on GoodDef {
  /// Returns a callable class that can be used as follows: `instanceOfGoodDef.copyWith(...)` or like so:`instanceOfGoodDef.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoodDefCWProxy get copyWith => _$GoodDefCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodDef _$GoodDefFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GoodDef', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'supply', 'demand']);
      final val = GoodDef(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        supply: $checkedConvert('supply', (v) => (v as num).toInt()),
        demand: $checkedConvert('demand', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$GoodDefToJson(GoodDef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'supply': instance.supply,
  'demand': instance.demand,
};
