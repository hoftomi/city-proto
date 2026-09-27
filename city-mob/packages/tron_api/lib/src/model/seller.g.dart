// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SellerCWProxy {
  Seller house(HouseRef? house);

  Seller city(bool city);

  Seller shares(int shares);

  Seller margin(String margin);

  Seller sold(double? sold);

  Seller cheapest(bool cheapest);

  Seller protectedNow(bool protectedNow);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Seller(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Seller(...).copyWith(id: 12, name: "My name")
  /// ````
  Seller call({
    HouseRef? house,
    bool city,
    int shares,
    String margin,
    double? sold,
    bool cheapest,
    bool protectedNow,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSeller.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSeller.copyWith.fieldName(...)`
class _$SellerCWProxyImpl implements _$SellerCWProxy {
  const _$SellerCWProxyImpl(this._value);

  final Seller _value;

  @override
  Seller house(HouseRef? house) => this(house: house);

  @override
  Seller city(bool city) => this(city: city);

  @override
  Seller shares(int shares) => this(shares: shares);

  @override
  Seller margin(String margin) => this(margin: margin);

  @override
  Seller sold(double? sold) => this(sold: sold);

  @override
  Seller cheapest(bool cheapest) => this(cheapest: cheapest);

  @override
  Seller protectedNow(bool protectedNow) => this(protectedNow: protectedNow);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Seller(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Seller(...).copyWith(id: 12, name: "My name")
  /// ````
  Seller call({
    Object? house = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? shares = const $CopyWithPlaceholder(),
    Object? margin = const $CopyWithPlaceholder(),
    Object? sold = const $CopyWithPlaceholder(),
    Object? cheapest = const $CopyWithPlaceholder(),
    Object? protectedNow = const $CopyWithPlaceholder(),
  }) {
    return Seller(
      house: house == const $CopyWithPlaceholder()
          ? _value.house
          // ignore: cast_nullable_to_non_nullable
          : house as HouseRef?,
      city: city == const $CopyWithPlaceholder()
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as bool,
      shares: shares == const $CopyWithPlaceholder()
          ? _value.shares
          // ignore: cast_nullable_to_non_nullable
          : shares as int,
      margin: margin == const $CopyWithPlaceholder()
          ? _value.margin
          // ignore: cast_nullable_to_non_nullable
          : margin as String,
      sold: sold == const $CopyWithPlaceholder()
          ? _value.sold
          // ignore: cast_nullable_to_non_nullable
          : sold as double?,
      cheapest: cheapest == const $CopyWithPlaceholder()
          ? _value.cheapest
          // ignore: cast_nullable_to_non_nullable
          : cheapest as bool,
      protectedNow: protectedNow == const $CopyWithPlaceholder()
          ? _value.protectedNow
          // ignore: cast_nullable_to_non_nullable
          : protectedNow as bool,
    );
  }
}

extension $SellerCopyWith on Seller {
  /// Returns a callable class that can be used as follows: `instanceOfSeller.copyWith(...)` or like so:`instanceOfSeller.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SellerCWProxy get copyWith => _$SellerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seller _$SellerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Seller', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'house',
          'city',
          'shares',
          'margin',
          'sold',
          'cheapest',
          'protectedNow',
        ],
      );
      final val = Seller(
        house: $checkedConvert(
          'house',
          (v) =>
              v == null ? null : HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        city: $checkedConvert('city', (v) => v as bool),
        shares: $checkedConvert('shares', (v) => (v as num).toInt()),
        margin: $checkedConvert('margin', (v) => v as String),
        sold: $checkedConvert('sold', (v) => (v as num?)?.toDouble()),
        cheapest: $checkedConvert('cheapest', (v) => v as bool),
        protectedNow: $checkedConvert('protectedNow', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$SellerToJson(Seller instance) => <String, dynamic>{
  'house': instance.house?.toJson(),
  'city': instance.city,
  'shares': instance.shares,
  'margin': instance.margin,
  'sold': instance.sold,
  'cheapest': instance.cheapest,
  'protectedNow': instance.protectedNow,
};
