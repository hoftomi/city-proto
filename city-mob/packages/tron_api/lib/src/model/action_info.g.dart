// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ActionInfoCWProxy {
  ActionInfo id(String id);

  ActionInfo label(String label);

  ActionInfo branch(String branch);

  ActionInfo pp(int pp);

  ActionInfo gold(int? gold);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ActionInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ActionInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  ActionInfo call({String id, String label, String branch, int pp, int? gold});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfActionInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfActionInfo.copyWith.fieldName(...)`
class _$ActionInfoCWProxyImpl implements _$ActionInfoCWProxy {
  const _$ActionInfoCWProxyImpl(this._value);

  final ActionInfo _value;

  @override
  ActionInfo id(String id) => this(id: id);

  @override
  ActionInfo label(String label) => this(label: label);

  @override
  ActionInfo branch(String branch) => this(branch: branch);

  @override
  ActionInfo pp(int pp) => this(pp: pp);

  @override
  ActionInfo gold(int? gold) => this(gold: gold);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ActionInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ActionInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  ActionInfo call({
    Object? id = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? branch = const $CopyWithPlaceholder(),
    Object? pp = const $CopyWithPlaceholder(),
    Object? gold = const $CopyWithPlaceholder(),
  }) {
    return ActionInfo(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      branch: branch == const $CopyWithPlaceholder()
          ? _value.branch
          // ignore: cast_nullable_to_non_nullable
          : branch as String,
      pp: pp == const $CopyWithPlaceholder()
          ? _value.pp
          // ignore: cast_nullable_to_non_nullable
          : pp as int,
      gold: gold == const $CopyWithPlaceholder()
          ? _value.gold
          // ignore: cast_nullable_to_non_nullable
          : gold as int?,
    );
  }
}

extension $ActionInfoCopyWith on ActionInfo {
  /// Returns a callable class that can be used as follows: `instanceOfActionInfo.copyWith(...)` or like so:`instanceOfActionInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ActionInfoCWProxy get copyWith => _$ActionInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionInfo _$ActionInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ActionInfo', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'label', 'branch', 'pp', 'gold'],
      );
      final val = ActionInfo(
        id: $checkedConvert('id', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        branch: $checkedConvert('branch', (v) => v as String),
        pp: $checkedConvert('pp', (v) => (v as num).toInt()),
        gold: $checkedConvert('gold', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$ActionInfoToJson(ActionInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'branch': instance.branch,
      'pp': instance.pp,
      'gold': instance.gold,
    };
