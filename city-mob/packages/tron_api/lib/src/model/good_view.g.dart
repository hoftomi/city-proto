// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'good_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoodViewCWProxy {
  GoodView id(String id);

  GoodView name(String name);

  GoodView supply(int supply);

  GoodView demand(int demand);

  GoodView cityShares(int cityShares);

  GoodView marketValue(double marketValue);

  GoodView myShares(int myShares);

  GoodView myMargin(String? myMargin);

  GoodView sellers(List<Seller> sellers);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoodView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoodView(...).copyWith(id: 12, name: "My name")
  /// ````
  GoodView call({
    String id,
    String name,
    int supply,
    int demand,
    int cityShares,
    double marketValue,
    int myShares,
    String? myMargin,
    List<Seller> sellers,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGoodView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGoodView.copyWith.fieldName(...)`
class _$GoodViewCWProxyImpl implements _$GoodViewCWProxy {
  const _$GoodViewCWProxyImpl(this._value);

  final GoodView _value;

  @override
  GoodView id(String id) => this(id: id);

  @override
  GoodView name(String name) => this(name: name);

  @override
  GoodView supply(int supply) => this(supply: supply);

  @override
  GoodView demand(int demand) => this(demand: demand);

  @override
  GoodView cityShares(int cityShares) => this(cityShares: cityShares);

  @override
  GoodView marketValue(double marketValue) => this(marketValue: marketValue);

  @override
  GoodView myShares(int myShares) => this(myShares: myShares);

  @override
  GoodView myMargin(String? myMargin) => this(myMargin: myMargin);

  @override
  GoodView sellers(List<Seller> sellers) => this(sellers: sellers);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoodView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoodView(...).copyWith(id: 12, name: "My name")
  /// ````
  GoodView call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? supply = const $CopyWithPlaceholder(),
    Object? demand = const $CopyWithPlaceholder(),
    Object? cityShares = const $CopyWithPlaceholder(),
    Object? marketValue = const $CopyWithPlaceholder(),
    Object? myShares = const $CopyWithPlaceholder(),
    Object? myMargin = const $CopyWithPlaceholder(),
    Object? sellers = const $CopyWithPlaceholder(),
  }) {
    return GoodView(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      supply: supply == const $CopyWithPlaceholder()
          ? _value.supply
          // ignore: cast_nullable_to_non_nullable
          : supply as int,
      demand: demand == const $CopyWithPlaceholder()
          ? _value.demand
          // ignore: cast_nullable_to_non_nullable
          : demand as int,
      cityShares: cityShares == const $CopyWithPlaceholder()
          ? _value.cityShares
          // ignore: cast_nullable_to_non_nullable
          : cityShares as int,
      marketValue: marketValue == const $CopyWithPlaceholder()
          ? _value.marketValue
          // ignore: cast_nullable_to_non_nullable
          : marketValue as double,
      myShares: myShares == const $CopyWithPlaceholder()
          ? _value.myShares
          // ignore: cast_nullable_to_non_nullable
          : myShares as int,
      myMargin: myMargin == const $CopyWithPlaceholder()
          ? _value.myMargin
          // ignore: cast_nullable_to_non_nullable
          : myMargin as String?,
      sellers: sellers == const $CopyWithPlaceholder()
          ? _value.sellers
          // ignore: cast_nullable_to_non_nullable
          : sellers as List<Seller>,
    );
  }
}

extension $GoodViewCopyWith on GoodView {
  /// Returns a callable class that can be used as follows: `instanceOfGoodView.copyWith(...)` or like so:`instanceOfGoodView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoodViewCWProxy get copyWith => _$GoodViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodView _$GoodViewFromJson(Map<String, dynamic> json) => $checkedCreate(
  'GoodView',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'name',
        'supply',
        'demand',
        'cityShares',
        'marketValue',
        'myShares',
        'myMargin',
        'sellers',
      ],
    );
    final val = GoodView(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      supply: $checkedConvert('supply', (v) => (v as num).toInt()),
      demand: $checkedConvert('demand', (v) => (v as num).toInt()),
      cityShares: $checkedConvert('cityShares', (v) => (v as num).toInt()),
      marketValue: $checkedConvert('marketValue', (v) => (v as num).toDouble()),
      myShares: $checkedConvert('myShares', (v) => (v as num).toInt()),
      myMargin: $checkedConvert('myMargin', (v) => v as String?),
      sellers: $checkedConvert(
        'sellers',
        (v) => (v as List<dynamic>)
            .map((e) => Seller.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$GoodViewToJson(GoodView instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'supply': instance.supply,
  'demand': instance.demand,
  'cityShares': instance.cityShares,
  'marketValue': instance.marketValue,
  'myShares': instance.myShares,
  'myMargin': instance.myMargin,
  'sellers': instance.sellers.map((e) => e.toJson()).toList(),
};
