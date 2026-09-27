// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LevelInfoCWProxy {
  LevelInfo id(String id);

  LevelInfo label(String label);

  LevelInfo percent(int percent);

  LevelInfo pop(int pop);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LevelInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LevelInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  LevelInfo call({String id, String label, int percent, int pop});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLevelInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLevelInfo.copyWith.fieldName(...)`
class _$LevelInfoCWProxyImpl implements _$LevelInfoCWProxy {
  const _$LevelInfoCWProxyImpl(this._value);

  final LevelInfo _value;

  @override
  LevelInfo id(String id) => this(id: id);

  @override
  LevelInfo label(String label) => this(label: label);

  @override
  LevelInfo percent(int percent) => this(percent: percent);

  @override
  LevelInfo pop(int pop) => this(pop: pop);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LevelInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LevelInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  LevelInfo call({
    Object? id = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? pop = const $CopyWithPlaceholder(),
  }) {
    return LevelInfo(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
      pop: pop == const $CopyWithPlaceholder()
          ? _value.pop
          // ignore: cast_nullable_to_non_nullable
          : pop as int,
    );
  }
}

extension $LevelInfoCopyWith on LevelInfo {
  /// Returns a callable class that can be used as follows: `instanceOfLevelInfo.copyWith(...)` or like so:`instanceOfLevelInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LevelInfoCWProxy get copyWith => _$LevelInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelInfo _$LevelInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LevelInfo', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'label', 'percent', 'pop']);
      final val = LevelInfo(
        id: $checkedConvert('id', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
        pop: $checkedConvert('pop', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$LevelInfoToJson(LevelInfo instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'percent': instance.percent,
  'pop': instance.pop,
};
