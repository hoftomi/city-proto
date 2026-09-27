// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OrderRequestCWProxy {
  OrderRequest type(String type);

  OrderRequest city(String? city);

  OrderRequest good(String? good);

  OrderRequest level(String? level);

  OrderRequest pts(int? pts);

  OrderRequest target(String? target);

  OrderRequest template(String? template);

  OrderRequest newsId(String? newsId);

  OrderRequest lapId(String? lapId);

  OrderRequest orderId(String? orderId);

  OrderRequest from(String? from);

  OrderRequest to(String? to);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OrderRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OrderRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  OrderRequest call({
    String type,
    String? city,
    String? good,
    String? level,
    int? pts,
    String? target,
    String? template,
    String? newsId,
    String? lapId,
    String? orderId,
    String? from,
    String? to,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOrderRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOrderRequest.copyWith.fieldName(...)`
class _$OrderRequestCWProxyImpl implements _$OrderRequestCWProxy {
  const _$OrderRequestCWProxyImpl(this._value);

  final OrderRequest _value;

  @override
  OrderRequest type(String type) => this(type: type);

  @override
  OrderRequest city(String? city) => this(city: city);

  @override
  OrderRequest good(String? good) => this(good: good);

  @override
  OrderRequest level(String? level) => this(level: level);

  @override
  OrderRequest pts(int? pts) => this(pts: pts);

  @override
  OrderRequest target(String? target) => this(target: target);

  @override
  OrderRequest template(String? template) => this(template: template);

  @override
  OrderRequest newsId(String? newsId) => this(newsId: newsId);

  @override
  OrderRequest lapId(String? lapId) => this(lapId: lapId);

  @override
  OrderRequest orderId(String? orderId) => this(orderId: orderId);

  @override
  OrderRequest from(String? from) => this(from: from);

  @override
  OrderRequest to(String? to) => this(to: to);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OrderRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OrderRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  OrderRequest call({
    Object? type = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? good = const $CopyWithPlaceholder(),
    Object? level = const $CopyWithPlaceholder(),
    Object? pts = const $CopyWithPlaceholder(),
    Object? target = const $CopyWithPlaceholder(),
    Object? template = const $CopyWithPlaceholder(),
    Object? newsId = const $CopyWithPlaceholder(),
    Object? lapId = const $CopyWithPlaceholder(),
    Object? orderId = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
  }) {
    return OrderRequest(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      city: city == const $CopyWithPlaceholder()
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as String?,
      good: good == const $CopyWithPlaceholder()
          ? _value.good
          // ignore: cast_nullable_to_non_nullable
          : good as String?,
      level: level == const $CopyWithPlaceholder()
          ? _value.level
          // ignore: cast_nullable_to_non_nullable
          : level as String?,
      pts: pts == const $CopyWithPlaceholder()
          ? _value.pts
          // ignore: cast_nullable_to_non_nullable
          : pts as int?,
      target: target == const $CopyWithPlaceholder()
          ? _value.target
          // ignore: cast_nullable_to_non_nullable
          : target as String?,
      template: template == const $CopyWithPlaceholder()
          ? _value.template
          // ignore: cast_nullable_to_non_nullable
          : template as String?,
      newsId: newsId == const $CopyWithPlaceholder()
          ? _value.newsId
          // ignore: cast_nullable_to_non_nullable
          : newsId as String?,
      lapId: lapId == const $CopyWithPlaceholder()
          ? _value.lapId
          // ignore: cast_nullable_to_non_nullable
          : lapId as String?,
      orderId: orderId == const $CopyWithPlaceholder()
          ? _value.orderId
          // ignore: cast_nullable_to_non_nullable
          : orderId as String?,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as String?,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String?,
    );
  }
}

extension $OrderRequestCopyWith on OrderRequest {
  /// Returns a callable class that can be used as follows: `instanceOfOrderRequest.copyWith(...)` or like so:`instanceOfOrderRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OrderRequestCWProxy get copyWith => _$OrderRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequest _$OrderRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OrderRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['type']);
      final val = OrderRequest(
        type: $checkedConvert('type', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String?),
        good: $checkedConvert('good', (v) => v as String?),
        level: $checkedConvert('level', (v) => v as String?),
        pts: $checkedConvert('pts', (v) => (v as num?)?.toInt()),
        target: $checkedConvert('target', (v) => v as String?),
        template: $checkedConvert('template', (v) => v as String?),
        newsId: $checkedConvert('newsId', (v) => v as String?),
        lapId: $checkedConvert('lapId', (v) => v as String?),
        orderId: $checkedConvert('orderId', (v) => v as String?),
        from: $checkedConvert('from', (v) => v as String?),
        to: $checkedConvert('to', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$OrderRequestToJson(OrderRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'city': ?instance.city,
      'good': ?instance.good,
      'level': ?instance.level,
      'pts': ?instance.pts,
      'target': ?instance.target,
      'template': ?instance.template,
      'newsId': ?instance.newsId,
      'lapId': ?instance.lapId,
      'orderId': ?instance.orderId,
      'from': ?instance.from,
      'to': ?instance.to,
    };
