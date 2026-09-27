// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OrderViewCWProxy {
  OrderView id(String id);

  OrderView type(String type);

  OrderView branch(String branch);

  OrderView label(String label);

  OrderView cityId(String? cityId);

  OrderView cityName(String? cityName);

  OrderView cost(Cost cost);

  OrderView warning(String? warning);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OrderView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OrderView(...).copyWith(id: 12, name: "My name")
  /// ````
  OrderView call({
    String id,
    String type,
    String branch,
    String label,
    String? cityId,
    String? cityName,
    Cost cost,
    String? warning,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOrderView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOrderView.copyWith.fieldName(...)`
class _$OrderViewCWProxyImpl implements _$OrderViewCWProxy {
  const _$OrderViewCWProxyImpl(this._value);

  final OrderView _value;

  @override
  OrderView id(String id) => this(id: id);

  @override
  OrderView type(String type) => this(type: type);

  @override
  OrderView branch(String branch) => this(branch: branch);

  @override
  OrderView label(String label) => this(label: label);

  @override
  OrderView cityId(String? cityId) => this(cityId: cityId);

  @override
  OrderView cityName(String? cityName) => this(cityName: cityName);

  @override
  OrderView cost(Cost cost) => this(cost: cost);

  @override
  OrderView warning(String? warning) => this(warning: warning);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OrderView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OrderView(...).copyWith(id: 12, name: "My name")
  /// ````
  OrderView call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? branch = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? cityName = const $CopyWithPlaceholder(),
    Object? cost = const $CopyWithPlaceholder(),
    Object? warning = const $CopyWithPlaceholder(),
  }) {
    return OrderView(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      branch: branch == const $CopyWithPlaceholder()
          ? _value.branch
          // ignore: cast_nullable_to_non_nullable
          : branch as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String?,
      cityName: cityName == const $CopyWithPlaceholder()
          ? _value.cityName
          // ignore: cast_nullable_to_non_nullable
          : cityName as String?,
      cost: cost == const $CopyWithPlaceholder()
          ? _value.cost
          // ignore: cast_nullable_to_non_nullable
          : cost as Cost,
      warning: warning == const $CopyWithPlaceholder()
          ? _value.warning
          // ignore: cast_nullable_to_non_nullable
          : warning as String?,
    );
  }
}

extension $OrderViewCopyWith on OrderView {
  /// Returns a callable class that can be used as follows: `instanceOfOrderView.copyWith(...)` or like so:`instanceOfOrderView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OrderViewCWProxy get copyWith => _$OrderViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderView _$OrderViewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OrderView', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'type',
          'branch',
          'label',
          'cityId',
          'cityName',
          'cost',
          'warning',
        ],
      );
      final val = OrderView(
        id: $checkedConvert('id', (v) => v as String),
        type: $checkedConvert('type', (v) => v as String),
        branch: $checkedConvert('branch', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        cityId: $checkedConvert('cityId', (v) => v as String?),
        cityName: $checkedConvert('cityName', (v) => v as String?),
        cost: $checkedConvert(
          'cost',
          (v) => Cost.fromJson(v as Map<String, dynamic>),
        ),
        warning: $checkedConvert('warning', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$OrderViewToJson(OrderView instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'branch': instance.branch,
  'label': instance.label,
  'cityId': instance.cityId,
  'cityName': instance.cityName,
  'cost': instance.cost.toJson(),
  'warning': instance.warning,
};
