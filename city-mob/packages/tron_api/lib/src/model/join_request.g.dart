// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JoinRequestCWProxy {
  JoinRequest houseName(String houseName);

  JoinRequest tincture(String tincture);

  JoinRequest background(String background);

  JoinRequest startSlot(String startSlot);

  JoinRequest startGood(String? startGood);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JoinRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JoinRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  JoinRequest call({
    String houseName,
    String tincture,
    String background,
    String startSlot,
    String? startGood,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJoinRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJoinRequest.copyWith.fieldName(...)`
class _$JoinRequestCWProxyImpl implements _$JoinRequestCWProxy {
  const _$JoinRequestCWProxyImpl(this._value);

  final JoinRequest _value;

  @override
  JoinRequest houseName(String houseName) => this(houseName: houseName);

  @override
  JoinRequest tincture(String tincture) => this(tincture: tincture);

  @override
  JoinRequest background(String background) => this(background: background);

  @override
  JoinRequest startSlot(String startSlot) => this(startSlot: startSlot);

  @override
  JoinRequest startGood(String? startGood) => this(startGood: startGood);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JoinRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JoinRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  JoinRequest call({
    Object? houseName = const $CopyWithPlaceholder(),
    Object? tincture = const $CopyWithPlaceholder(),
    Object? background = const $CopyWithPlaceholder(),
    Object? startSlot = const $CopyWithPlaceholder(),
    Object? startGood = const $CopyWithPlaceholder(),
  }) {
    return JoinRequest(
      houseName: houseName == const $CopyWithPlaceholder()
          ? _value.houseName
          // ignore: cast_nullable_to_non_nullable
          : houseName as String,
      tincture: tincture == const $CopyWithPlaceholder()
          ? _value.tincture
          // ignore: cast_nullable_to_non_nullable
          : tincture as String,
      background: background == const $CopyWithPlaceholder()
          ? _value.background
          // ignore: cast_nullable_to_non_nullable
          : background as String,
      startSlot: startSlot == const $CopyWithPlaceholder()
          ? _value.startSlot
          // ignore: cast_nullable_to_non_nullable
          : startSlot as String,
      startGood: startGood == const $CopyWithPlaceholder()
          ? _value.startGood
          // ignore: cast_nullable_to_non_nullable
          : startGood as String?,
    );
  }
}

extension $JoinRequestCopyWith on JoinRequest {
  /// Returns a callable class that can be used as follows: `instanceOfJoinRequest.copyWith(...)` or like so:`instanceOfJoinRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JoinRequestCWProxy get copyWith => _$JoinRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinRequest _$JoinRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
  'JoinRequest',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['houseName', 'tincture', 'background', 'startSlot'],
    );
    final val = JoinRequest(
      houseName: $checkedConvert('houseName', (v) => v as String),
      tincture: $checkedConvert('tincture', (v) => v as String),
      background: $checkedConvert('background', (v) => v as String),
      startSlot: $checkedConvert('startSlot', (v) => v as String),
      startGood: $checkedConvert('startGood', (v) => v as String?),
    );
    return val;
  },
);

Map<String, dynamic> _$JoinRequestToJson(JoinRequest instance) =>
    <String, dynamic>{
      'houseName': instance.houseName,
      'tincture': instance.tincture,
      'background': instance.background,
      'startSlot': instance.startSlot,
      'startGood': ?instance.startGood,
    };
