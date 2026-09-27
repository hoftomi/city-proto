// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ClockViewCWProxy {
  ClockView now(DateTime now);

  ClockView nextSettlementAt(DateTime nextSettlementAt);

  ClockView settlements(int settlements);

  ClockView maxSettlements(int maxSettlements);

  ClockView nextElectionIn(int nextElectionIn);

  ClockView campaign(bool campaign);

  ClockView maturationMinutes(int maturationMinutes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ClockView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ClockView(...).copyWith(id: 12, name: "My name")
  /// ````
  ClockView call({
    DateTime now,
    DateTime nextSettlementAt,
    int settlements,
    int maxSettlements,
    int nextElectionIn,
    bool campaign,
    int maturationMinutes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfClockView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfClockView.copyWith.fieldName(...)`
class _$ClockViewCWProxyImpl implements _$ClockViewCWProxy {
  const _$ClockViewCWProxyImpl(this._value);

  final ClockView _value;

  @override
  ClockView now(DateTime now) => this(now: now);

  @override
  ClockView nextSettlementAt(DateTime nextSettlementAt) =>
      this(nextSettlementAt: nextSettlementAt);

  @override
  ClockView settlements(int settlements) => this(settlements: settlements);

  @override
  ClockView maxSettlements(int maxSettlements) =>
      this(maxSettlements: maxSettlements);

  @override
  ClockView nextElectionIn(int nextElectionIn) =>
      this(nextElectionIn: nextElectionIn);

  @override
  ClockView campaign(bool campaign) => this(campaign: campaign);

  @override
  ClockView maturationMinutes(int maturationMinutes) =>
      this(maturationMinutes: maturationMinutes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ClockView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ClockView(...).copyWith(id: 12, name: "My name")
  /// ````
  ClockView call({
    Object? now = const $CopyWithPlaceholder(),
    Object? nextSettlementAt = const $CopyWithPlaceholder(),
    Object? settlements = const $CopyWithPlaceholder(),
    Object? maxSettlements = const $CopyWithPlaceholder(),
    Object? nextElectionIn = const $CopyWithPlaceholder(),
    Object? campaign = const $CopyWithPlaceholder(),
    Object? maturationMinutes = const $CopyWithPlaceholder(),
  }) {
    return ClockView(
      now: now == const $CopyWithPlaceholder()
          ? _value.now
          // ignore: cast_nullable_to_non_nullable
          : now as DateTime,
      nextSettlementAt: nextSettlementAt == const $CopyWithPlaceholder()
          ? _value.nextSettlementAt
          // ignore: cast_nullable_to_non_nullable
          : nextSettlementAt as DateTime,
      settlements: settlements == const $CopyWithPlaceholder()
          ? _value.settlements
          // ignore: cast_nullable_to_non_nullable
          : settlements as int,
      maxSettlements: maxSettlements == const $CopyWithPlaceholder()
          ? _value.maxSettlements
          // ignore: cast_nullable_to_non_nullable
          : maxSettlements as int,
      nextElectionIn: nextElectionIn == const $CopyWithPlaceholder()
          ? _value.nextElectionIn
          // ignore: cast_nullable_to_non_nullable
          : nextElectionIn as int,
      campaign: campaign == const $CopyWithPlaceholder()
          ? _value.campaign
          // ignore: cast_nullable_to_non_nullable
          : campaign as bool,
      maturationMinutes: maturationMinutes == const $CopyWithPlaceholder()
          ? _value.maturationMinutes
          // ignore: cast_nullable_to_non_nullable
          : maturationMinutes as int,
    );
  }
}

extension $ClockViewCopyWith on ClockView {
  /// Returns a callable class that can be used as follows: `instanceOfClockView.copyWith(...)` or like so:`instanceOfClockView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ClockViewCWProxy get copyWith => _$ClockViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClockView _$ClockViewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ClockView', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'now',
          'nextSettlementAt',
          'settlements',
          'maxSettlements',
          'nextElectionIn',
          'campaign',
          'maturationMinutes',
        ],
      );
      final val = ClockView(
        now: $checkedConvert('now', (v) => DateTime.parse(v as String)),
        nextSettlementAt: $checkedConvert(
          'nextSettlementAt',
          (v) => DateTime.parse(v as String),
        ),
        settlements: $checkedConvert('settlements', (v) => (v as num).toInt()),
        maxSettlements: $checkedConvert(
          'maxSettlements',
          (v) => (v as num).toInt(),
        ),
        nextElectionIn: $checkedConvert(
          'nextElectionIn',
          (v) => (v as num).toInt(),
        ),
        campaign: $checkedConvert('campaign', (v) => v as bool),
        maturationMinutes: $checkedConvert(
          'maturationMinutes',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ClockViewToJson(ClockView instance) => <String, dynamic>{
  'now': instance.now.toIso8601String(),
  'nextSettlementAt': instance.nextSettlementAt.toIso8601String(),
  'settlements': instance.settlements,
  'maxSettlements': instance.maxSettlements,
  'nextElectionIn': instance.nextElectionIn,
  'campaign': instance.campaign,
  'maturationMinutes': instance.maturationMinutes,
};
