// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_map.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminMapCWProxy {
  AdminMap id(String id);

  AdminMap name(String name);

  AdminMap cities(int cities);

  AdminMap starts(int starts);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminMap(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminMap(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminMap call({String id, String name, int cities, int starts});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminMap.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminMap.copyWith.fieldName(...)`
class _$AdminMapCWProxyImpl implements _$AdminMapCWProxy {
  const _$AdminMapCWProxyImpl(this._value);

  final AdminMap _value;

  @override
  AdminMap id(String id) => this(id: id);

  @override
  AdminMap name(String name) => this(name: name);

  @override
  AdminMap cities(int cities) => this(cities: cities);

  @override
  AdminMap starts(int starts) => this(starts: starts);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminMap(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminMap(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminMap call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? cities = const $CopyWithPlaceholder(),
    Object? starts = const $CopyWithPlaceholder(),
  }) {
    return AdminMap(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      cities: cities == const $CopyWithPlaceholder()
          ? _value.cities
          // ignore: cast_nullable_to_non_nullable
          : cities as int,
      starts: starts == const $CopyWithPlaceholder()
          ? _value.starts
          // ignore: cast_nullable_to_non_nullable
          : starts as int,
    );
  }
}

extension $AdminMapCopyWith on AdminMap {
  /// Returns a callable class that can be used as follows: `instanceOfAdminMap.copyWith(...)` or like so:`instanceOfAdminMap.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminMapCWProxy get copyWith => _$AdminMapCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminMap _$AdminMapFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminMap', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'cities', 'starts']);
      final val = AdminMap(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        cities: $checkedConvert('cities', (v) => (v as num).toInt()),
        starts: $checkedConvert('starts', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AdminMapToJson(AdminMap instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'cities': instance.cities,
  'starts': instance.starts,
};
