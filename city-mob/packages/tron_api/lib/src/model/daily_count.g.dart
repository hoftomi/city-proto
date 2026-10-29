// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_count.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyCountCWProxy {
  DailyCount date(DateTime date);

  DailyCount count(int count);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyCount(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyCount(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyCount call({DateTime date, int count});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyCount.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyCount.copyWith.fieldName(...)`
class _$DailyCountCWProxyImpl implements _$DailyCountCWProxy {
  const _$DailyCountCWProxyImpl(this._value);

  final DailyCount _value;

  @override
  DailyCount date(DateTime date) => this(date: date);

  @override
  DailyCount count(int count) => this(count: count);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyCount(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyCount(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyCount call({
    Object? date = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
  }) {
    return DailyCount(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime,
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int,
    );
  }
}

extension $DailyCountCopyWith on DailyCount {
  /// Returns a callable class that can be used as follows: `instanceOfDailyCount.copyWith(...)` or like so:`instanceOfDailyCount.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyCountCWProxy get copyWith => _$DailyCountCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyCount _$DailyCountFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DailyCount', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['date', 'count']);
      final val = DailyCount(
        date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$DailyCountToJson(DailyCount instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'count': instance.count,
    };
