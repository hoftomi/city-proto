// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kind_count.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$KindCountCWProxy {
  KindCount kind(String kind);

  KindCount count(int count);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KindCount(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KindCount(...).copyWith(id: 12, name: "My name")
  /// ````
  KindCount call({String kind, int count});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfKindCount.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfKindCount.copyWith.fieldName(...)`
class _$KindCountCWProxyImpl implements _$KindCountCWProxy {
  const _$KindCountCWProxyImpl(this._value);

  final KindCount _value;

  @override
  KindCount kind(String kind) => this(kind: kind);

  @override
  KindCount count(int count) => this(count: count);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KindCount(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KindCount(...).copyWith(id: 12, name: "My name")
  /// ````
  KindCount call({
    Object? kind = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
  }) {
    return KindCount(
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as String,
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int,
    );
  }
}

extension $KindCountCopyWith on KindCount {
  /// Returns a callable class that can be used as follows: `instanceOfKindCount.copyWith(...)` or like so:`instanceOfKindCount.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$KindCountCWProxy get copyWith => _$KindCountCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KindCount _$KindCountFromJson(Map<String, dynamic> json) =>
    $checkedCreate('KindCount', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['kind', 'count']);
      final val = KindCount(
        kind: $checkedConvert('kind', (v) => v as String),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$KindCountToJson(KindCount instance) => <String, dynamic>{
  'kind': instance.kind,
  'count': instance.count,
};
