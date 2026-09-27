// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advance_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdvanceRequestCWProxy {
  AdvanceRequest minutes(int? minutes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdvanceRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdvanceRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AdvanceRequest call({int? minutes});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdvanceRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdvanceRequest.copyWith.fieldName(...)`
class _$AdvanceRequestCWProxyImpl implements _$AdvanceRequestCWProxy {
  const _$AdvanceRequestCWProxyImpl(this._value);

  final AdvanceRequest _value;

  @override
  AdvanceRequest minutes(int? minutes) => this(minutes: minutes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdvanceRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdvanceRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AdvanceRequest call({Object? minutes = const $CopyWithPlaceholder()}) {
    return AdvanceRequest(
      minutes: minutes == const $CopyWithPlaceholder()
          ? _value.minutes
          // ignore: cast_nullable_to_non_nullable
          : minutes as int?,
    );
  }
}

extension $AdvanceRequestCopyWith on AdvanceRequest {
  /// Returns a callable class that can be used as follows: `instanceOfAdvanceRequest.copyWith(...)` or like so:`instanceOfAdvanceRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdvanceRequestCWProxy get copyWith => _$AdvanceRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvanceRequest _$AdvanceRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdvanceRequest', json, ($checkedConvert) {
      final val = AdvanceRequest(
        minutes: $checkedConvert('minutes', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AdvanceRequestToJson(AdvanceRequest instance) =>
    <String, dynamic>{'minutes': ?instance.minutes};
