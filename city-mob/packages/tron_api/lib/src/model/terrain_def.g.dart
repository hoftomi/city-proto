// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terrain_def.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TerrainDefCWProxy {
  TerrainDef sea(String? sea);

  TerrainDef rivers(List<String> rivers);

  TerrainDef mountains(List<List<double>> mountains);

  TerrainDef forests(List<List<double>> forests);

  TerrainDef fields(List<List<double>> fields);

  TerrainDef marsh(List<List<double>> marsh);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TerrainDef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TerrainDef(...).copyWith(id: 12, name: "My name")
  /// ````
  TerrainDef call({
    String? sea,
    List<String> rivers,
    List<List<double>> mountains,
    List<List<double>> forests,
    List<List<double>> fields,
    List<List<double>> marsh,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTerrainDef.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTerrainDef.copyWith.fieldName(...)`
class _$TerrainDefCWProxyImpl implements _$TerrainDefCWProxy {
  const _$TerrainDefCWProxyImpl(this._value);

  final TerrainDef _value;

  @override
  TerrainDef sea(String? sea) => this(sea: sea);

  @override
  TerrainDef rivers(List<String> rivers) => this(rivers: rivers);

  @override
  TerrainDef mountains(List<List<double>> mountains) =>
      this(mountains: mountains);

  @override
  TerrainDef forests(List<List<double>> forests) => this(forests: forests);

  @override
  TerrainDef fields(List<List<double>> fields) => this(fields: fields);

  @override
  TerrainDef marsh(List<List<double>> marsh) => this(marsh: marsh);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TerrainDef(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TerrainDef(...).copyWith(id: 12, name: "My name")
  /// ````
  TerrainDef call({
    Object? sea = const $CopyWithPlaceholder(),
    Object? rivers = const $CopyWithPlaceholder(),
    Object? mountains = const $CopyWithPlaceholder(),
    Object? forests = const $CopyWithPlaceholder(),
    Object? fields = const $CopyWithPlaceholder(),
    Object? marsh = const $CopyWithPlaceholder(),
  }) {
    return TerrainDef(
      sea: sea == const $CopyWithPlaceholder()
          ? _value.sea
          // ignore: cast_nullable_to_non_nullable
          : sea as String?,
      rivers: rivers == const $CopyWithPlaceholder()
          ? _value.rivers
          // ignore: cast_nullable_to_non_nullable
          : rivers as List<String>,
      mountains: mountains == const $CopyWithPlaceholder()
          ? _value.mountains
          // ignore: cast_nullable_to_non_nullable
          : mountains as List<List<double>>,
      forests: forests == const $CopyWithPlaceholder()
          ? _value.forests
          // ignore: cast_nullable_to_non_nullable
          : forests as List<List<double>>,
      fields: fields == const $CopyWithPlaceholder()
          ? _value.fields
          // ignore: cast_nullable_to_non_nullable
          : fields as List<List<double>>,
      marsh: marsh == const $CopyWithPlaceholder()
          ? _value.marsh
          // ignore: cast_nullable_to_non_nullable
          : marsh as List<List<double>>,
    );
  }
}

extension $TerrainDefCopyWith on TerrainDef {
  /// Returns a callable class that can be used as follows: `instanceOfTerrainDef.copyWith(...)` or like so:`instanceOfTerrainDef.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TerrainDefCWProxy get copyWith => _$TerrainDefCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TerrainDef _$TerrainDefFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TerrainDef', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'sea',
      'rivers',
      'mountains',
      'forests',
      'fields',
      'marsh',
    ],
  );
  final val = TerrainDef(
    sea: $checkedConvert('sea', (v) => v as String?),
    rivers: $checkedConvert(
      'rivers',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    mountains: $checkedConvert(
      'mountains',
      (v) => (v as List<dynamic>)
          .map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
    ),
    forests: $checkedConvert(
      'forests',
      (v) => (v as List<dynamic>)
          .map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
    ),
    fields: $checkedConvert(
      'fields',
      (v) => (v as List<dynamic>)
          .map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
    ),
    marsh: $checkedConvert(
      'marsh',
      (v) => (v as List<dynamic>)
          .map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$TerrainDefToJson(TerrainDef instance) =>
    <String, dynamic>{
      'sea': instance.sea,
      'rivers': instance.rivers,
      'mountains': instance.mountains,
      'forests': instance.forests,
      'fields': instance.fields,
      'marsh': instance.marsh,
    };
