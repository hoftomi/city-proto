// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sheet_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SheetViewCWProxy {
  SheetView id(String id);

  SheetView sealedAt(DateTime sealedAt);

  SheetView executeAt(DateTime executeAt);

  SheetView orders(List<OrderView> orders);

  SheetView cost(Cost cost);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SheetView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SheetView(...).copyWith(id: 12, name: "My name")
  /// ````
  SheetView call({
    String id,
    DateTime sealedAt,
    DateTime executeAt,
    List<OrderView> orders,
    Cost cost,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSheetView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSheetView.copyWith.fieldName(...)`
class _$SheetViewCWProxyImpl implements _$SheetViewCWProxy {
  const _$SheetViewCWProxyImpl(this._value);

  final SheetView _value;

  @override
  SheetView id(String id) => this(id: id);

  @override
  SheetView sealedAt(DateTime sealedAt) => this(sealedAt: sealedAt);

  @override
  SheetView executeAt(DateTime executeAt) => this(executeAt: executeAt);

  @override
  SheetView orders(List<OrderView> orders) => this(orders: orders);

  @override
  SheetView cost(Cost cost) => this(cost: cost);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SheetView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SheetView(...).copyWith(id: 12, name: "My name")
  /// ````
  SheetView call({
    Object? id = const $CopyWithPlaceholder(),
    Object? sealedAt = const $CopyWithPlaceholder(),
    Object? executeAt = const $CopyWithPlaceholder(),
    Object? orders = const $CopyWithPlaceholder(),
    Object? cost = const $CopyWithPlaceholder(),
  }) {
    return SheetView(
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

extension $SheetViewCopyWith on SheetView {
  /// Returns a callable class that can be used as follows: `instanceOfSheetView.copyWith(...)` or like so:`instanceOfSheetView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SheetViewCWProxy get copyWith => _$SheetViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SheetView _$SheetViewFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SheetView', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'sealedAt', 'executeAt', 'orders', 'cost'],
  );
  final val = SheetView(
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

Map<String, dynamic> _$SheetViewToJson(SheetView instance) => <String, dynamic>{
  'id': instance.id,
  'sealedAt': instance.sealedAt.toIso8601String(),
  'executeAt': instance.executeAt.toIso8601String(),
  'orders': instance.orders.map((e) => e.toJson()).toList(),
  'cost': instance.cost.toJson(),
};
