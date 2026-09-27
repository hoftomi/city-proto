// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_slot_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StartSlotDtoCWProxy {
  StartSlotDto id(String id);

  StartSlotDto name(String name);

  StartSlotDto x(int x);

  StartSlotDto y(int y);

  StartSlotDto neighbors(List<String> neighbors);

  StartSlotDto neighborNames(List<String> neighborNames);

  StartSlotDto note(String note);

  StartSlotDto homeCity(String homeCity);

  StartSlotDto homeCityName(String homeCityName);

  StartSlotDto homeGoods(List<GoodOption> homeGoods);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartSlotDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartSlotDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StartSlotDto call({
    String id,
    String name,
    int x,
    int y,
    List<String> neighbors,
    List<String> neighborNames,
    String note,
    String homeCity,
    String homeCityName,
    List<GoodOption> homeGoods,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStartSlotDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStartSlotDto.copyWith.fieldName(...)`
class _$StartSlotDtoCWProxyImpl implements _$StartSlotDtoCWProxy {
  const _$StartSlotDtoCWProxyImpl(this._value);

  final StartSlotDto _value;

  @override
  StartSlotDto id(String id) => this(id: id);

  @override
  StartSlotDto name(String name) => this(name: name);

  @override
  StartSlotDto x(int x) => this(x: x);

  @override
  StartSlotDto y(int y) => this(y: y);

  @override
  StartSlotDto neighbors(List<String> neighbors) => this(neighbors: neighbors);

  @override
  StartSlotDto neighborNames(List<String> neighborNames) =>
      this(neighborNames: neighborNames);

  @override
  StartSlotDto note(String note) => this(note: note);

  @override
  StartSlotDto homeCity(String homeCity) => this(homeCity: homeCity);

  @override
  StartSlotDto homeCityName(String homeCityName) =>
      this(homeCityName: homeCityName);

  @override
  StartSlotDto homeGoods(List<GoodOption> homeGoods) =>
      this(homeGoods: homeGoods);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartSlotDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartSlotDto(...).copyWith(id: 12, name: "My name")
  /// ````
  StartSlotDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? x = const $CopyWithPlaceholder(),
    Object? y = const $CopyWithPlaceholder(),
    Object? neighbors = const $CopyWithPlaceholder(),
    Object? neighborNames = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? homeCity = const $CopyWithPlaceholder(),
    Object? homeCityName = const $CopyWithPlaceholder(),
    Object? homeGoods = const $CopyWithPlaceholder(),
  }) {
    return StartSlotDto(
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
      neighbors: neighbors == const $CopyWithPlaceholder()
          ? _value.neighbors
          // ignore: cast_nullable_to_non_nullable
          : neighbors as List<String>,
      neighborNames: neighborNames == const $CopyWithPlaceholder()
          ? _value.neighborNames
          // ignore: cast_nullable_to_non_nullable
          : neighborNames as List<String>,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
      homeCity: homeCity == const $CopyWithPlaceholder()
          ? _value.homeCity
          // ignore: cast_nullable_to_non_nullable
          : homeCity as String,
      homeCityName: homeCityName == const $CopyWithPlaceholder()
          ? _value.homeCityName
          // ignore: cast_nullable_to_non_nullable
          : homeCityName as String,
      homeGoods: homeGoods == const $CopyWithPlaceholder()
          ? _value.homeGoods
          // ignore: cast_nullable_to_non_nullable
          : homeGoods as List<GoodOption>,
    );
  }
}

extension $StartSlotDtoCopyWith on StartSlotDto {
  /// Returns a callable class that can be used as follows: `instanceOfStartSlotDto.copyWith(...)` or like so:`instanceOfStartSlotDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StartSlotDtoCWProxy get copyWith => _$StartSlotDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartSlotDto _$StartSlotDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StartSlotDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'x',
          'y',
          'neighbors',
          'neighborNames',
          'note',
          'homeCity',
          'homeCityName',
          'homeGoods',
        ],
      );
      final val = StartSlotDto(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        x: $checkedConvert('x', (v) => (v as num).toInt()),
        y: $checkedConvert('y', (v) => (v as num).toInt()),
        neighbors: $checkedConvert(
          'neighbors',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        neighborNames: $checkedConvert(
          'neighborNames',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        note: $checkedConvert('note', (v) => v as String),
        homeCity: $checkedConvert('homeCity', (v) => v as String),
        homeCityName: $checkedConvert('homeCityName', (v) => v as String),
        homeGoods: $checkedConvert(
          'homeGoods',
          (v) => (v as List<dynamic>)
              .map((e) => GoodOption.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StartSlotDtoToJson(StartSlotDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'x': instance.x,
      'y': instance.y,
      'neighbors': instance.neighbors,
      'neighborNames': instance.neighborNames,
      'note': instance.note,
      'homeCity': instance.homeCity,
      'homeCityName': instance.homeCityName,
      'homeGoods': instance.homeGoods.map((e) => e.toJson()).toList(),
    };
