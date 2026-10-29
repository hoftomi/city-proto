// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RoleRequestCWProxy {
  RoleRequest role(String role);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RoleRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RoleRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  RoleRequest call({String role});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRoleRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRoleRequest.copyWith.fieldName(...)`
class _$RoleRequestCWProxyImpl implements _$RoleRequestCWProxy {
  const _$RoleRequestCWProxyImpl(this._value);

  final RoleRequest _value;

  @override
  RoleRequest role(String role) => this(role: role);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RoleRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RoleRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  RoleRequest call({Object? role = const $CopyWithPlaceholder()}) {
    return RoleRequest(
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as String,
    );
  }
}

extension $RoleRequestCopyWith on RoleRequest {
  /// Returns a callable class that can be used as follows: `instanceOfRoleRequest.copyWith(...)` or like so:`instanceOfRoleRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RoleRequestCWProxy get copyWith => _$RoleRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleRequest _$RoleRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
  'RoleRequest',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['role']);
    final val = RoleRequest(role: $checkedConvert('role', (v) => v as String));
    return val;
  },
);

Map<String, dynamic> _$RoleRequestToJson(RoleRequest instance) =>
    <String, dynamic>{'role': instance.role};
