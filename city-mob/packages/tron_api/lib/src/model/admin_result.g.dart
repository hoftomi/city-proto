// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_result.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminResultCWProxy {
  AdminResult started(String? started);

  AdminResult settlements(int? settlements);

  AdminResult advancedMinutes(int? advancedMinutes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminResult(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminResult call({String? started, int? settlements, int? advancedMinutes});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminResult.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminResult.copyWith.fieldName(...)`
class _$AdminResultCWProxyImpl implements _$AdminResultCWProxy {
  const _$AdminResultCWProxyImpl(this._value);

  final AdminResult _value;

  @override
  AdminResult started(String? started) => this(started: started);

  @override
  AdminResult settlements(int? settlements) => this(settlements: settlements);

  @override
  AdminResult advancedMinutes(int? advancedMinutes) =>
      this(advancedMinutes: advancedMinutes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminResult(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminResult call({
    Object? started = const $CopyWithPlaceholder(),
    Object? settlements = const $CopyWithPlaceholder(),
    Object? advancedMinutes = const $CopyWithPlaceholder(),
  }) {
    return AdminResult(
      started: started == const $CopyWithPlaceholder()
          ? _value.started
          // ignore: cast_nullable_to_non_nullable
          : started as String?,
      settlements: settlements == const $CopyWithPlaceholder()
          ? _value.settlements
          // ignore: cast_nullable_to_non_nullable
          : settlements as int?,
      advancedMinutes: advancedMinutes == const $CopyWithPlaceholder()
          ? _value.advancedMinutes
          // ignore: cast_nullable_to_non_nullable
          : advancedMinutes as int?,
    );
  }
}

extension $AdminResultCopyWith on AdminResult {
  /// Returns a callable class that can be used as follows: `instanceOfAdminResult.copyWith(...)` or like so:`instanceOfAdminResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminResultCWProxy get copyWith => _$AdminResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminResult _$AdminResultFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AdminResult',
  json,
  ($checkedConvert) {
    final val = AdminResult(
      started: $checkedConvert('started', (v) => v as String?),
      settlements: $checkedConvert('settlements', (v) => (v as num?)?.toInt()),
      advancedMinutes: $checkedConvert(
        'advancedMinutes',
        (v) => (v as num?)?.toInt(),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$AdminResultToJson(AdminResult instance) =>
    <String, dynamic>{
      'started': ?instance.started,
      'settlements': ?instance.settlements,
      'advancedMinutes': ?instance.advancedMinutes,
    };
