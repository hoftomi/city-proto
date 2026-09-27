// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buildable.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BuildableCWProxy {
  Buildable from(String from);

  Buildable to(String to);

  Buildable fromName(String fromName);

  Buildable toName(String toName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Buildable(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Buildable(...).copyWith(id: 12, name: "My name")
  /// ````
  Buildable call({String from, String to, String fromName, String toName});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBuildable.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBuildable.copyWith.fieldName(...)`
class _$BuildableCWProxyImpl implements _$BuildableCWProxy {
  const _$BuildableCWProxyImpl(this._value);

  final Buildable _value;

  @override
  Buildable from(String from) => this(from: from);

  @override
  Buildable to(String to) => this(to: to);

  @override
  Buildable fromName(String fromName) => this(fromName: fromName);

  @override
  Buildable toName(String toName) => this(toName: toName);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Buildable(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Buildable(...).copyWith(id: 12, name: "My name")
  /// ````
  Buildable call({
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? fromName = const $CopyWithPlaceholder(),
    Object? toName = const $CopyWithPlaceholder(),
  }) {
    return Buildable(
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as String,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String,
      fromName: fromName == const $CopyWithPlaceholder()
          ? _value.fromName
          // ignore: cast_nullable_to_non_nullable
          : fromName as String,
      toName: toName == const $CopyWithPlaceholder()
          ? _value.toName
          // ignore: cast_nullable_to_non_nullable
          : toName as String,
    );
  }
}

extension $BuildableCopyWith on Buildable {
  /// Returns a callable class that can be used as follows: `instanceOfBuildable.copyWith(...)` or like so:`instanceOfBuildable.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BuildableCWProxy get copyWith => _$BuildableCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Buildable _$BuildableFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Buildable',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['from', 'to', 'fromName', 'toName']);
    final val = Buildable(
      from: $checkedConvert('from', (v) => v as String),
      to: $checkedConvert('to', (v) => v as String),
      fromName: $checkedConvert('fromName', (v) => v as String),
      toName: $checkedConvert('toName', (v) => v as String),
    );
    return val;
  },
);

Map<String, dynamic> _$BuildableToJson(Buildable instance) => <String, dynamic>{
  'from': instance.from,
  'to': instance.to,
  'fromName': instance.fromName,
  'toName': instance.toName,
};
