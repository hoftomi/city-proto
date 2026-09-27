// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discord_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DiscordRequestCWProxy {
  DiscordRequest code(String code);

  DiscordRequest codeVerifier(String codeVerifier);

  DiscordRequest redirectUri(String redirectUri);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DiscordRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DiscordRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  DiscordRequest call({String code, String codeVerifier, String redirectUri});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDiscordRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDiscordRequest.copyWith.fieldName(...)`
class _$DiscordRequestCWProxyImpl implements _$DiscordRequestCWProxy {
  const _$DiscordRequestCWProxyImpl(this._value);

  final DiscordRequest _value;

  @override
  DiscordRequest code(String code) => this(code: code);

  @override
  DiscordRequest codeVerifier(String codeVerifier) =>
      this(codeVerifier: codeVerifier);

  @override
  DiscordRequest redirectUri(String redirectUri) =>
      this(redirectUri: redirectUri);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DiscordRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DiscordRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  DiscordRequest call({
    Object? code = const $CopyWithPlaceholder(),
    Object? codeVerifier = const $CopyWithPlaceholder(),
    Object? redirectUri = const $CopyWithPlaceholder(),
  }) {
    return DiscordRequest(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      codeVerifier: codeVerifier == const $CopyWithPlaceholder()
          ? _value.codeVerifier
          // ignore: cast_nullable_to_non_nullable
          : codeVerifier as String,
      redirectUri: redirectUri == const $CopyWithPlaceholder()
          ? _value.redirectUri
          // ignore: cast_nullable_to_non_nullable
          : redirectUri as String,
    );
  }
}

extension $DiscordRequestCopyWith on DiscordRequest {
  /// Returns a callable class that can be used as follows: `instanceOfDiscordRequest.copyWith(...)` or like so:`instanceOfDiscordRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DiscordRequestCWProxy get copyWith => _$DiscordRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscordRequest _$DiscordRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DiscordRequest', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['code', 'codeVerifier', 'redirectUri'],
      );
      final val = DiscordRequest(
        code: $checkedConvert('code', (v) => v as String),
        codeVerifier: $checkedConvert('codeVerifier', (v) => v as String),
        redirectUri: $checkedConvert('redirectUri', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DiscordRequestToJson(DiscordRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'codeVerifier': instance.codeVerifier,
      'redirectUri': instance.redirectUri,
    };
