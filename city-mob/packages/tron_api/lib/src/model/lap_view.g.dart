// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lap_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LapViewCWProxy {
  LapView id(String id);

  LapView sealedAt(DateTime sealedAt);

  LapView executeAt(DateTime executeAt);

  LapView orders(List<OrderView> orders);

  LapView cost(Cost cost);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LapView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LapView(...).copyWith(id: 12, name: "My name")
  /// ````
  LapView call({
    String id,
    DateTime sealedAt,
    DateTime executeAt,
    List<OrderView> orders,
    Cost cost,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLapView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLapView.copyWith.fieldName(...)`
class _$LapViewCWProxyImpl implements _$LapViewCWProxy {
  const _$LapViewCWProxyImpl(this._value);

  final LapView _value;

  @override
  LapView id(String id) => this(id: id);

  @override
  LapView sealedAt(DateTime sealedAt) => this(sealedAt: sealedAt);

  @override
  LapView executeAt(DateTime executeAt) => this(executeAt: executeAt);

  @override
  LapView orders(List<OrderView> orders) => this(orders: orders);

  @override
  LapView cost(Cost cost) => this(cost: cost);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LapView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LapView(...).copyWith(id: 12, name: "My name")
  /// ````
  LapView call({
    Object? id = const $CopyWithPlaceholder(),
    Object? sealedAt = const $CopyWithPlaceholder(),
    Object? executeAt = const $CopyWithPlaceholder(),
    Object? orders = const $CopyWithPlaceholder(),
    Object? cost = const $CopyWithPlaceholder(),
  }) {
    return LapView(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      sealedAt: sealedAt == const $CopyWithPlaceholder()
          ? _value.sealedAt
          // ignore: cast_nullable_to_non_nullable
          : sealedAt as DateTime,
      executeAt: executeAt == const $CopyWithPlaceholder()
          ? _value.executeAt
          // ignore: cast_nullable_to_non_nullable
          : executeAt as DateTime,
      orders: orders == const $CopyWithPlaceholder()
          ? _value.orders
          // ignore: cast_nullable_to_non_nullable
          : orders as List<OrderView>,
      cost: cost == const $CopyWithPlaceholder()
          ? _value.cost
          // ignore: cast_nullable_to_non_nullable
          : cost as Cost,
    );
  }
}

extension $LapViewCopyWith on LapView {
  /// Returns a callable class that can be used as follows: `instanceOfLapView.copyWith(...)` or like so:`instanceOfLapView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LapViewCWProxy get copyWith => _$LapViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LapView _$LapViewFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LapView', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'sealedAt', 'executeAt', 'orders', 'cost'],
  );
  final val = LapView(
    id: $checkedConvert('id', (v) => v as String),
    sealedAt: $checkedConvert('sealedAt', (v) => DateTime.parse(v as String)),
    executeAt: $checkedConvert('executeAt', (v) => DateTime.parse(v as String)),
    orders: $checkedConvert(
      'orders',
      (v) => (v as List<dynamic>)
          .map((e) => OrderView.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    cost: $checkedConvert(
      'cost',
      (v) => Cost.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$LapViewToJson(LapView instance) => <String, dynamic>{
  'id': instance.id,
  'sealedAt': instance.sealedAt.toIso8601String(),
  'executeAt': instance.executeAt.toIso8601String(),
  'orders': instance.orders.map((e) => e.toJson()).toList(),
  'cost': instance.cost.toJson(),
};
