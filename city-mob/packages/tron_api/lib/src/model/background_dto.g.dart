// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BackgroundDtoCWProxy {
  BackgroundDto id(String id);

  BackgroundDto name(String name);

  BackgroundDto icon(String icon);

  BackgroundDto perks(List<String> perks);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BackgroundDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BackgroundDto(...).copyWith(id: 12, name: "My name")
  /// ````
  BackgroundDto call({String id, String name, String icon, List<String> perks});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBackgroundDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBackgroundDto.copyWith.fieldName(...)`
class _$BackgroundDtoCWProxyImpl implements _$BackgroundDtoCWProxy {
  const _$BackgroundDtoCWProxyImpl(this._value);

  final BackgroundDto _value;

  @override
  BackgroundDto id(String id) => this(id: id);

  @override
  BackgroundDto name(String name) => this(name: name);

  @override
  BackgroundDto icon(String icon) => this(icon: icon);

  @override
  BackgroundDto perks(List<String> perks) => this(perks: perks);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BackgroundDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BackgroundDto(...).copyWith(id: 12, name: "My name")
  /// ````
  BackgroundDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? icon = const $CopyWithPlaceholder(),
    Object? perks = const $CopyWithPlaceholder(),
  }) {
    return BackgroundDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      icon: icon == const $CopyWithPlaceholder()
          ? _value.icon
          // ignore: cast_nullable_to_non_nullable
          : icon as String,
      perks: perks == const $CopyWithPlaceholder()
          ? _value.perks
          // ignore: cast_nullable_to_non_nullable
          : perks as List<String>,
    );
  }
}

extension $BackgroundDtoCopyWith on BackgroundDto {
  /// Returns a callable class that can be used as follows: `instanceOfBackgroundDto.copyWith(...)` or like so:`instanceOfBackgroundDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BackgroundDtoCWProxy get copyWith => _$BackgroundDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackgroundDto _$BackgroundDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BackgroundDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'icon', 'perks']);
      final val = BackgroundDto(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        icon: $checkedConvert('icon', (v) => v as String),
        perks: $checkedConvert(
          'perks',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BackgroundDtoToJson(BackgroundDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'perks': instance.perks,
    };
