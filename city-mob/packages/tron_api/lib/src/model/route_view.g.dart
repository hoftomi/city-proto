// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RouteViewCWProxy {
  RouteView from(String from);

  RouteView to(String to);

  RouteView state(String state);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RouteView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RouteView(...).copyWith(id: 12, name: "My name")
  /// ````
  RouteView call({String from, String to, String state});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRouteView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRouteView.copyWith.fieldName(...)`
class _$RouteViewCWProxyImpl implements _$RouteViewCWProxy {
  const _$RouteViewCWProxyImpl(this._value);

  final RouteView _value;

  @override
  RouteView from(String from) => this(from: from);

  @override
  RouteView to(String to) => this(to: to);

  @override
  RouteView state(String state) => this(state: state);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RouteView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RouteView(...).copyWith(id: 12, name: "My name")
  /// ````
  RouteView call({
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
  }) {
    return RouteView(
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as String,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String,
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as String,
    );
  }
}

extension $RouteViewCopyWith on RouteView {
  /// Returns a callable class that can be used as follows: `instanceOfRouteView.copyWith(...)` or like so:`instanceOfRouteView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RouteViewCWProxy get copyWith => _$RouteViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteView _$RouteViewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RouteView', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['from', 'to', 'state']);
      final val = RouteView(
        from: $checkedConvert('from', (v) => v as String),
        to: $checkedConvert('to', (v) => v as String),
        state: $checkedConvert('state', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RouteViewToJson(RouteView instance) => <String, dynamic>{
  'from': instance.from,
  'to': instance.to,
  'state': instance.state,
};
