// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_def.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MapDefCWProxy {
  MapDef id(String id);

  MapDef name(String name);

  MapDef cities(List<CityDef> cities);

  MapDef cityEdges(List<List<String>> cityEdges);

  MapDef starts(List<StartSlot> starts);

  MapDef terrain(TerrainDef terrain);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MapDef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MapDef(...).copyWith(id: 12, name: "My name")
  /// ````
  MapDef call({
    String id,
    String name,
    List<CityDef> cities,
    List<List<String>> cityEdges,
    List<StartSlot> starts,
    TerrainDef terrain,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMapDef.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMapDef.copyWith.fieldName(...)`
class _$MapDefCWProxyImpl implements _$MapDefCWProxy {
  const _$MapDefCWProxyImpl(this._value);

  final MapDef _value;

  @override
  MapDef id(String id) => this(id: id);

  @override
  MapDef name(String name) => this(name: name);

  @override
  MapDef cities(List<CityDef> cities) => this(cities: cities);

  @override
  MapDef cityEdges(List<List<String>> cityEdges) => this(cityEdges: cityEdges);

  @override
  MapDef starts(List<StartSlot> starts) => this(starts: starts);

  @override
  MapDef terrain(TerrainDef terrain) => this(terrain: terrain);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MapDef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MapDef(...).copyWith(id: 12, name: "My name")
  /// ````
  MapDef call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? cities = const $CopyWithPlaceholder(),
    Object? cityEdges = const $CopyWithPlaceholder(),
    Object? starts = const $CopyWithPlaceholder(),
    Object? terrain = const $CopyWithPlaceholder(),
  }) {
    return MapDef(
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
          : cities as List<CityDef>,
      cityEdges: cityEdges == const $CopyWithPlaceholder()
          ? _value.cityEdges
          // ignore: cast_nullable_to_non_nullable
          : cityEdges as List<List<String>>,
      starts: starts == const $CopyWithPlaceholder()
          ? _value.starts
          // ignore: cast_nullable_to_non_nullable
          : starts as List<StartSlot>,
      terrain: terrain == const $CopyWithPlaceholder()
          ? _value.terrain
          // ignore: cast_nullable_to_non_nullable
          : terrain as TerrainDef,
    );
  }
}

extension $MapDefCopyWith on MapDef {
  /// Returns a callable class that can be used as follows: `instanceOfMapDef.copyWith(...)` or like so:`instanceOfMapDef.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MapDefCWProxy get copyWith => _$MapDefCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapDef _$MapDefFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MapDef', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'cities',
          'cityEdges',
          'starts',
          'terrain',
        ],
      );
      final val = MapDef(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        cities: $checkedConvert(
          'cities',
          (v) => (v as List<dynamic>)
              .map((e) => CityDef.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        cityEdges: $checkedConvert(
          'cityEdges',
          (v) => (v as List<dynamic>)
              .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
              .toList(),
        ),
        starts: $checkedConvert(
          'starts',
          (v) => (v as List<dynamic>)
              .map((e) => StartSlot.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        terrain: $checkedConvert(
          'terrain',
          (v) => TerrainDef.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MapDefToJson(MapDef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'cities': instance.cities.map((e) => e.toJson()).toList(),
  'cityEdges': instance.cityEdges,
  'starts': instance.starts.map((e) => e.toJson()).toList(),
  'terrain': instance.terrain.toJson(),
};
