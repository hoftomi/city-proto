// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_def.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CityDefCWProxy {
  CityDef id(String id);

  CityDef name(String name);

  CityDef x(int x);

  CityDef y(int y);

  CityDef key(bool key);

  CityDef coast(bool coast);

  CityDef profile(String profile);

  CityDef goods(List<GoodDef> goods);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CityDef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CityDef(...).copyWith(id: 12, name: "My name")
  /// ````
  CityDef call({
    String id,
    String name,
    int x,
    int y,
    bool key,
    bool coast,
    String profile,
    List<GoodDef> goods,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCityDef.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCityDef.copyWith.fieldName(...)`
class _$CityDefCWProxyImpl implements _$CityDefCWProxy {
  const _$CityDefCWProxyImpl(this._value);

  final CityDef _value;

  @override
  CityDef id(String id) => this(id: id);

  @override
  CityDef name(String name) => this(name: name);

  @override
  CityDef x(int x) => this(x: x);

  @override
  CityDef y(int y) => this(y: y);

  @override
  CityDef key(bool key) => this(key: key);

  @override
  CityDef coast(bool coast) => this(coast: coast);

  @override
  CityDef profile(String profile) => this(profile: profile);

  @override
  CityDef goods(List<GoodDef> goods) => this(goods: goods);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CityDef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CityDef(...).copyWith(id: 12, name: "My name")
  /// ````
  CityDef call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? x = const $CopyWithPlaceholder(),
    Object? y = const $CopyWithPlaceholder(),
    Object? key = const $CopyWithPlaceholder(),
    Object? coast = const $CopyWithPlaceholder(),
    Object? profile = const $CopyWithPlaceholder(),
    Object? goods = const $CopyWithPlaceholder(),
  }) {
    return CityDef(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      x: x == const $CopyWithPlaceholder()
          ? _value.x
          // ignore: cast_nullable_to_non_nullable
          : x as int,
      y: y == const $CopyWithPlaceholder()
          ? _value.y
          // ignore: cast_nullable_to_non_nullable
          : y as int,
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as bool,
      coast: coast == const $CopyWithPlaceholder()
          ? _value.coast
          // ignore: cast_nullable_to_non_nullable
          : coast as bool,
      profile: profile == const $CopyWithPlaceholder()
          ? _value.profile
          // ignore: cast_nullable_to_non_nullable
          : profile as String,
      goods: goods == const $CopyWithPlaceholder()
          ? _value.goods
          // ignore: cast_nullable_to_non_nullable
          : goods as List<GoodDef>,
    );
  }
}

extension $CityDefCopyWith on CityDef {
  /// Returns a callable class that can be used as follows: `instanceOfCityDef.copyWith(...)` or like so:`instanceOfCityDef.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CityDefCWProxy get copyWith => _$CityDefCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityDef _$CityDefFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CityDef', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'x',
          'y',
          'key',
          'coast',
          'profile',
          'goods',
        ],
      );
      final val = CityDef(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        x: $checkedConvert('x', (v) => (v as num).toInt()),
        y: $checkedConvert('y', (v) => (v as num).toInt()),
        key: $checkedConvert('key', (v) => v as bool),
        coast: $checkedConvert('coast', (v) => v as bool),
        profile: $checkedConvert('profile', (v) => v as String),
        goods: $checkedConvert(
          'goods',
          (v) => (v as List<dynamic>)
              .map((e) => GoodDef.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CityDefToJson(CityDef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'x': instance.x,
  'y': instance.y,
  'key': instance.key,
  'coast': instance.coast,
  'profile': instance.profile,
  'goods': instance.goods.map((e) => e.toJson()).toList(),
};
