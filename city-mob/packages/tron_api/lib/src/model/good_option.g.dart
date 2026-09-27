// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'good_option.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoodOptionCWProxy {
  GoodOption id(String id);

  GoodOption name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoodOption(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoodOption(...).copyWith(id: 12, name: "My name")
  /// ````
  GoodOption call({String id, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGoodOption.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGoodOption.copyWith.fieldName(...)`
class _$GoodOptionCWProxyImpl implements _$GoodOptionCWProxy {
  const _$GoodOptionCWProxyImpl(this._value);

  final GoodOption _value;

  @override
  GoodOption id(String id) => this(id: id);

  @override
  GoodOption name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoodOption(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoodOption(...).copyWith(id: 12, name: "My name")
  /// ````
  GoodOption call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return GoodOption(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $GoodOptionCopyWith on GoodOption {
  /// Returns a callable class that can be used as follows: `instanceOfGoodOption.copyWith(...)` or like so:`instanceOfGoodOption.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoodOptionCWProxy get copyWith => _$GoodOptionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodOption _$GoodOptionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GoodOption', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name']);
      final val = GoodOption(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$GoodOptionToJson(GoodOption instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
