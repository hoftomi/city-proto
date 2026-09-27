// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OfferRequestCWProxy {
  OfferRequest buyerId(String buyerId);

  OfferRequest price(int? price);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferRequest call({String buyerId, int? price});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOfferRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOfferRequest.copyWith.fieldName(...)`
class _$OfferRequestCWProxyImpl implements _$OfferRequestCWProxy {
  const _$OfferRequestCWProxyImpl(this._value);

  final OfferRequest _value;

  @override
  OfferRequest buyerId(String buyerId) => this(buyerId: buyerId);

  @override
  OfferRequest price(int? price) => this(price: price);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferRequest call({
    Object? buyerId = const $CopyWithPlaceholder(),
    Object? price = const $CopyWithPlaceholder(),
  }) {
    return OfferRequest(
      buyerId: buyerId == const $CopyWithPlaceholder()
          ? _value.buyerId
          // ignore: cast_nullable_to_non_nullable
          : buyerId as String,
      price: price == const $CopyWithPlaceholder()
          ? _value.price
          // ignore: cast_nullable_to_non_nullable
          : price as int?,
    );
  }
}

extension $OfferRequestCopyWith on OfferRequest {
  /// Returns a callable class that can be used as follows: `instanceOfOfferRequest.copyWith(...)` or like so:`instanceOfOfferRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OfferRequestCWProxy get copyWith => _$OfferRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferRequest _$OfferRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OfferRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['buyerId']);
      final val = OfferRequest(
        buyerId: $checkedConvert('buyerId', (v) => v as String),
        price: $checkedConvert('price', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$OfferRequestToJson(OfferRequest instance) =>
    <String, dynamic>{'buyerId': instance.buyerId, 'price': ?instance.price};
