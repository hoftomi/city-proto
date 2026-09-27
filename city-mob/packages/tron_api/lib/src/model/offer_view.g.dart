// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OfferViewCWProxy {
  OfferView id(String id);

  OfferView seller(HouseRef seller);

  OfferView of_(HouseRef of_);

  OfferView price(int price);

  OfferView executeAt(DateTime executeAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferView(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferView call({
    String id,
    HouseRef seller,
    HouseRef of_,
    int price,
    DateTime executeAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOfferView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOfferView.copyWith.fieldName(...)`
class _$OfferViewCWProxyImpl implements _$OfferViewCWProxy {
  const _$OfferViewCWProxyImpl(this._value);

  final OfferView _value;

  @override
  OfferView id(String id) => this(id: id);

  @override
  OfferView seller(HouseRef seller) => this(seller: seller);

  @override
  OfferView of_(HouseRef of_) => this(of_: of_);

  @override
  OfferView price(int price) => this(price: price);

  @override
  OfferView executeAt(DateTime executeAt) => this(executeAt: executeAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferView(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferView call({
    Object? id = const $CopyWithPlaceholder(),
    Object? seller = const $CopyWithPlaceholder(),
    Object? of_ = const $CopyWithPlaceholder(),
    Object? price = const $CopyWithPlaceholder(),
    Object? executeAt = const $CopyWithPlaceholder(),
  }) {
    return OfferView(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      seller: seller == const $CopyWithPlaceholder()
          ? _value.seller
          // ignore: cast_nullable_to_non_nullable
          : seller as HouseRef,
      of_: of_ == const $CopyWithPlaceholder()
          ? _value.of_
          // ignore: cast_nullable_to_non_nullable
          : of_ as HouseRef,
      price: price == const $CopyWithPlaceholder()
          ? _value.price
          // ignore: cast_nullable_to_non_nullable
          : price as int,
      executeAt: executeAt == const $CopyWithPlaceholder()
          ? _value.executeAt
          // ignore: cast_nullable_to_non_nullable
          : executeAt as DateTime,
    );
  }
}

extension $OfferViewCopyWith on OfferView {
  /// Returns a callable class that can be used as follows: `instanceOfOfferView.copyWith(...)` or like so:`instanceOfOfferView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OfferViewCWProxy get copyWith => _$OfferViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferView _$OfferViewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OfferView', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'seller', 'of', 'price', 'executeAt'],
      );
      final val = OfferView(
        id: $checkedConvert('id', (v) => v as String),
        seller: $checkedConvert(
          'seller',
          (v) => HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        of_: $checkedConvert(
          'of',
          (v) => HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        price: $checkedConvert('price', (v) => (v as num).toInt()),
        executeAt: $checkedConvert(
          'executeAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    }, fieldKeyMap: const {'of_': 'of'});

Map<String, dynamic> _$OfferViewToJson(OfferView instance) => <String, dynamic>{
  'id': instance.id,
  'seller': instance.seller.toJson(),
  'of': instance.of_.toJson(),
  'price': instance.price,
  'executeAt': instance.executeAt.toIso8601String(),
};
