// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminUserCWProxy {
  AdminUser id(String id);

  AdminUser name(String name);

  AdminUser role(String role);

  AdminUser email(String? email);

  AdminUser providers(List<String> providers);

  AdminUser createdAt(DateTime createdAt);

  AdminUser games(int games);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminUser(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminUser call({
    String id,
    String name,
    String role,
    String? email,
    List<String> providers,
    DateTime createdAt,
    int games,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminUser.copyWith.fieldName(...)`
class _$AdminUserCWProxyImpl implements _$AdminUserCWProxy {
  const _$AdminUserCWProxyImpl(this._value);

  final AdminUser _value;

  @override
  AdminUser id(String id) => this(id: id);

  @override
  AdminUser name(String name) => this(name: name);

  @override
  AdminUser role(String role) => this(role: role);

  @override
  AdminUser email(String? email) => this(email: email);

  @override
  AdminUser providers(List<String> providers) => this(providers: providers);

  @override
  AdminUser createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  AdminUser games(int games) => this(games: games);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminUser(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminUser call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? providers = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? games = const $CopyWithPlaceholder(),
  }) {
    return AdminUser(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      providers: providers == const $CopyWithPlaceholder()
          ? _value.providers
          // ignore: cast_nullable_to_non_nullable
          : providers as List<String>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      games: games == const $CopyWithPlaceholder()
          ? _value.games
          // ignore: cast_nullable_to_non_nullable
          : games as int,
    );
  }
}

extension $AdminUserCopyWith on AdminUser {
  /// Returns a callable class that can be used as follows: `instanceOfAdminUser.copyWith(...)` or like so:`instanceOfAdminUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminUserCWProxy get copyWith => _$AdminUserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminUser', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'role',
          'email',
          'providers',
          'createdAt',
          'games',
        ],
      );
      final val = AdminUser(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        role: $checkedConvert('role', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String?),
        providers: $checkedConvert(
          'providers',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        games: $checkedConvert('games', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AdminUserToJson(AdminUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role': instance.role,
  'email': instance.email,
  'providers': instance.providers,
  'createdAt': instance.createdAt.toIso8601String(),
  'games': instance.games,
};
