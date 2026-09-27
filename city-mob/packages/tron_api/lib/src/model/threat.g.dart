// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threat.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThreatCWProxy {
  Threat lapId(String lapId);

  Threat orderId(String orderId);

  Threat by(HouseRef by);

  Threat cityId(String cityId);

  Threat cityName(String cityName);

  Threat goodId(String goodId);

  Threat goodName(String goodName);

  Threat pts(int pts);

  Threat executeAt(DateTime executeAt);

  Threat defendCost(int defendCost);

  Threat defending(bool defending);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Threat(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Threat(...).copyWith(id: 12, name: "My name")
  /// ````
  Threat call({
    String lapId,
    String orderId,
    HouseRef by,
    String cityId,
    String cityName,
    String goodId,
    String goodName,
    int pts,
    DateTime executeAt,
    int defendCost,
    bool defending,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThreat.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThreat.copyWith.fieldName(...)`
class _$ThreatCWProxyImpl implements _$ThreatCWProxy {
  const _$ThreatCWProxyImpl(this._value);

  final Threat _value;

  @override
  Threat lapId(String lapId) => this(lapId: lapId);

  @override
  Threat orderId(String orderId) => this(orderId: orderId);

  @override
  Threat by(HouseRef by) => this(by: by);

  @override
  Threat cityId(String cityId) => this(cityId: cityId);

  @override
  Threat cityName(String cityName) => this(cityName: cityName);

  @override
  Threat goodId(String goodId) => this(goodId: goodId);

  @override
  Threat goodName(String goodName) => this(goodName: goodName);

  @override
  Threat pts(int pts) => this(pts: pts);

  @override
  Threat executeAt(DateTime executeAt) => this(executeAt: executeAt);

  @override
  Threat defendCost(int defendCost) => this(defendCost: defendCost);

  @override
  Threat defending(bool defending) => this(defending: defending);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Threat(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Threat(...).copyWith(id: 12, name: "My name")
  /// ````
  Threat call({
    Object? lapId = const $CopyWithPlaceholder(),
    Object? orderId = const $CopyWithPlaceholder(),
    Object? by = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? cityName = const $CopyWithPlaceholder(),
    Object? goodId = const $CopyWithPlaceholder(),
    Object? goodName = const $CopyWithPlaceholder(),
    Object? pts = const $CopyWithPlaceholder(),
    Object? executeAt = const $CopyWithPlaceholder(),
    Object? defendCost = const $CopyWithPlaceholder(),
    Object? defending = const $CopyWithPlaceholder(),
  }) {
    return Threat(
      lapId: lapId == const $CopyWithPlaceholder()
          ? _value.lapId
          // ignore: cast_nullable_to_non_nullable
          : lapId as String,
      orderId: orderId == const $CopyWithPlaceholder()
          ? _value.orderId
          // ignore: cast_nullable_to_non_nullable
          : orderId as String,
      by: by == const $CopyWithPlaceholder()
          ? _value.by
          // ignore: cast_nullable_to_non_nullable
          : by as HouseRef,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String,
      cityName: cityName == const $CopyWithPlaceholder()
          ? _value.cityName
          // ignore: cast_nullable_to_non_nullable
          : cityName as String,
      goodId: goodId == const $CopyWithPlaceholder()
          ? _value.goodId
          // ignore: cast_nullable_to_non_nullable
          : goodId as String,
      goodName: goodName == const $CopyWithPlaceholder()
          ? _value.goodName
          // ignore: cast_nullable_to_non_nullable
          : goodName as String,
      pts: pts == const $CopyWithPlaceholder()
          ? _value.pts
          // ignore: cast_nullable_to_non_nullable
          : pts as int,
      executeAt: executeAt == const $CopyWithPlaceholder()
          ? _value.executeAt
          // ignore: cast_nullable_to_non_nullable
          : executeAt as DateTime,
      defendCost: defendCost == const $CopyWithPlaceholder()
          ? _value.defendCost
          // ignore: cast_nullable_to_non_nullable
          : defendCost as int,
      defending: defending == const $CopyWithPlaceholder()
          ? _value.defending
          // ignore: cast_nullable_to_non_nullable
          : defending as bool,
    );
  }
}

extension $ThreatCopyWith on Threat {
  /// Returns a callable class that can be used as follows: `instanceOfThreat.copyWith(...)` or like so:`instanceOfThreat.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThreatCWProxy get copyWith => _$ThreatCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Threat _$ThreatFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Threat', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'lapId',
          'orderId',
          'by',
          'cityId',
          'cityName',
          'goodId',
          'goodName',
          'pts',
          'executeAt',
          'defendCost',
          'defending',
        ],
      );
      final val = Threat(
        lapId: $checkedConvert('lapId', (v) => v as String),
        orderId: $checkedConvert('orderId', (v) => v as String),
        by: $checkedConvert(
          'by',
          (v) => HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        cityId: $checkedConvert('cityId', (v) => v as String),
        cityName: $checkedConvert('cityName', (v) => v as String),
        goodId: $checkedConvert('goodId', (v) => v as String),
        goodName: $checkedConvert('goodName', (v) => v as String),
        pts: $checkedConvert('pts', (v) => (v as num).toInt()),
        executeAt: $checkedConvert(
          'executeAt',
          (v) => DateTime.parse(v as String),
        ),
        defendCost: $checkedConvert('defendCost', (v) => (v as num).toInt()),
        defending: $checkedConvert('defending', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$ThreatToJson(Threat instance) => <String, dynamic>{
  'lapId': instance.lapId,
  'orderId': instance.orderId,
  'by': instance.by.toJson(),
  'cityId': instance.cityId,
  'cityName': instance.cityName,
  'goodId': instance.goodId,
  'goodName': instance.goodName,
  'pts': instance.pts,
  'executeAt': instance.executeAt.toIso8601String(),
  'defendCost': instance.defendCost,
  'defending': instance.defending,
};
