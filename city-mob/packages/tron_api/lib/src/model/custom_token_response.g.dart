// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_token_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CustomTokenResponseCWProxy {
  CustomTokenResponse customToken(String customToken);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CustomTokenResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CustomTokenResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CustomTokenResponse call({String customToken});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCustomTokenResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCustomTokenResponse.copyWith.fieldName(...)`
class _$CustomTokenResponseCWProxyImpl implements _$CustomTokenResponseCWProxy {
  const _$CustomTokenResponseCWProxyImpl(this._value);

  final CustomTokenResponse _value;

  @override
  CustomTokenResponse customToken(String customToken) =>
      this(customToken: customToken);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CustomTokenResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CustomTokenResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CustomTokenResponse call({
    Object? customToken = const $CopyWithPlaceholder(),
  }) {
    return CustomTokenResponse(
      customToken: customToken == const $CopyWithPlaceholder()
          ? _value.customToken
          // ignore: cast_nullable_to_non_nullable
          : customToken as String,
    );
  }
}

extension $CustomTokenResponseCopyWith on CustomTokenResponse {
  /// Returns a callable class that can be used as follows: `instanceOfCustomTokenResponse.copyWith(...)` or like so:`instanceOfCustomTokenResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CustomTokenResponseCWProxy get copyWith =>
      _$CustomTokenResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomTokenResponse _$CustomTokenResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CustomTokenResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['customToken']);
      final val = CustomTokenResponse(
        customToken: $checkedConvert('customToken', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CustomTokenResponseToJson(
  CustomTokenResponse instance,
) => <String, dynamic>{'customToken': instance.customToken};
