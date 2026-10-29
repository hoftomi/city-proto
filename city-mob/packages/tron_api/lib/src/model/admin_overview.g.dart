// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminOverviewCWProxy {
  AdminOverview users(int users);

  AdminOverview admins(int admins);

  AdminOverview newUsers7d(int newUsers7d);

  AdminOverview announced(int announced);

  AdminOverview open(int open);

  AdminOverview running(int running);

  AdminOverview finished(int finished);

  AdminOverview humanHouses(int humanHouses);

  AdminOverview npcHouses(int npcHouses);

  AdminOverview reports24h(int reports24h);

  AdminOverview registrations(List<DailyCount> registrations);

  AdminOverview joins(List<DailyCount> joins);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminOverview(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminOverview(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminOverview call({
    int users,
    int admins,
    int newUsers7d,
    int announced,
    int open,
    int running,
    int finished,
    int humanHouses,
    int npcHouses,
    int reports24h,
    List<DailyCount> registrations,
    List<DailyCount> joins,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminOverview.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminOverview.copyWith.fieldName(...)`
class _$AdminOverviewCWProxyImpl implements _$AdminOverviewCWProxy {
  const _$AdminOverviewCWProxyImpl(this._value);

  final AdminOverview _value;

  @override
  AdminOverview users(int users) => this(users: users);

  @override
  AdminOverview admins(int admins) => this(admins: admins);

  @override
  AdminOverview newUsers7d(int newUsers7d) => this(newUsers7d: newUsers7d);

  @override
  AdminOverview announced(int announced) => this(announced: announced);

  @override
  AdminOverview open(int open) => this(open: open);

  @override
  AdminOverview running(int running) => this(running: running);

  @override
  AdminOverview finished(int finished) => this(finished: finished);

  @override
  AdminOverview humanHouses(int humanHouses) => this(humanHouses: humanHouses);

  @override
  AdminOverview npcHouses(int npcHouses) => this(npcHouses: npcHouses);

  @override
  AdminOverview reports24h(int reports24h) => this(reports24h: reports24h);

  @override
  AdminOverview registrations(List<DailyCount> registrations) =>
      this(registrations: registrations);

  @override
  AdminOverview joins(List<DailyCount> joins) => this(joins: joins);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminOverview(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminOverview(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminOverview call({
    Object? users = const $CopyWithPlaceholder(),
    Object? admins = const $CopyWithPlaceholder(),
    Object? newUsers7d = const $CopyWithPlaceholder(),
    Object? announced = const $CopyWithPlaceholder(),
    Object? open = const $CopyWithPlaceholder(),
    Object? running = const $CopyWithPlaceholder(),
    Object? finished = const $CopyWithPlaceholder(),
    Object? humanHouses = const $CopyWithPlaceholder(),
    Object? npcHouses = const $CopyWithPlaceholder(),
    Object? reports24h = const $CopyWithPlaceholder(),
    Object? registrations = const $CopyWithPlaceholder(),
    Object? joins = const $CopyWithPlaceholder(),
  }) {
    return AdminOverview(
      users: users == const $CopyWithPlaceholder()
          ? _value.users
          // ignore: cast_nullable_to_non_nullable
          : users as int,
      admins: admins == const $CopyWithPlaceholder()
          ? _value.admins
          // ignore: cast_nullable_to_non_nullable
          : admins as int,
      newUsers7d: newUsers7d == const $CopyWithPlaceholder()
          ? _value.newUsers7d
          // ignore: cast_nullable_to_non_nullable
          : newUsers7d as int,
      announced: announced == const $CopyWithPlaceholder()
          ? _value.announced
          // ignore: cast_nullable_to_non_nullable
          : announced as int,
      open: open == const $CopyWithPlaceholder()
          ? _value.open
          // ignore: cast_nullable_to_non_nullable
          : open as int,
      running: running == const $CopyWithPlaceholder()
          ? _value.running
          // ignore: cast_nullable_to_non_nullable
          : running as int,
      finished: finished == const $CopyWithPlaceholder()
          ? _value.finished
          // ignore: cast_nullable_to_non_nullable
          : finished as int,
      humanHouses: humanHouses == const $CopyWithPlaceholder()
          ? _value.humanHouses
          // ignore: cast_nullable_to_non_nullable
          : humanHouses as int,
      npcHouses: npcHouses == const $CopyWithPlaceholder()
          ? _value.npcHouses
          // ignore: cast_nullable_to_non_nullable
          : npcHouses as int,
      reports24h: reports24h == const $CopyWithPlaceholder()
          ? _value.reports24h
          // ignore: cast_nullable_to_non_nullable
          : reports24h as int,
      registrations: registrations == const $CopyWithPlaceholder()
          ? _value.registrations
          // ignore: cast_nullable_to_non_nullable
          : registrations as List<DailyCount>,
      joins: joins == const $CopyWithPlaceholder()
          ? _value.joins
          // ignore: cast_nullable_to_non_nullable
          : joins as List<DailyCount>,
    );
  }
}

extension $AdminOverviewCopyWith on AdminOverview {
  /// Returns a callable class that can be used as follows: `instanceOfAdminOverview.copyWith(...)` or like so:`instanceOfAdminOverview.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminOverviewCWProxy get copyWith => _$AdminOverviewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminOverview _$AdminOverviewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminOverview', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'users',
          'admins',
          'newUsers7d',
          'announced',
          'open',
          'running',
          'finished',
          'humanHouses',
          'npcHouses',
          'reports24h',
          'registrations',
          'joins',
        ],
      );
      final val = AdminOverview(
        users: $checkedConvert('users', (v) => (v as num).toInt()),
        admins: $checkedConvert('admins', (v) => (v as num).toInt()),
        newUsers7d: $checkedConvert('newUsers7d', (v) => (v as num).toInt()),
        announced: $checkedConvert('announced', (v) => (v as num).toInt()),
        open: $checkedConvert('open', (v) => (v as num).toInt()),
        running: $checkedConvert('running', (v) => (v as num).toInt()),
        finished: $checkedConvert('finished', (v) => (v as num).toInt()),
        humanHouses: $checkedConvert('humanHouses', (v) => (v as num).toInt()),
        npcHouses: $checkedConvert('npcHouses', (v) => (v as num).toInt()),
        reports24h: $checkedConvert('reports24h', (v) => (v as num).toInt()),
        registrations: $checkedConvert(
          'registrations',
          (v) => (v as List<dynamic>)
              .map((e) => DailyCount.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        joins: $checkedConvert(
          'joins',
          (v) => (v as List<dynamic>)
              .map((e) => DailyCount.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminOverviewToJson(AdminOverview instance) =>
    <String, dynamic>{
      'users': instance.users,
      'admins': instance.admins,
      'newUsers7d': instance.newUsers7d,
      'announced': instance.announced,
      'open': instance.open,
      'running': instance.running,
      'finished': instance.finished,
      'humanHouses': instance.humanHouses,
      'npcHouses': instance.npcHouses,
      'reports24h': instance.reports24h,
      'registrations': instance.registrations.map((e) => e.toJson()).toList(),
      'joins': instance.joins.map((e) => e.toJson()).toList(),
    };
