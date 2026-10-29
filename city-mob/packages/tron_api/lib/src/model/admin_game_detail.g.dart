// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_game_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminGameDetailCWProxy {
  AdminGameDetail game(AdminGame game);

  AdminGameDetail houses(List<AdminHouse> houses);

  AdminGameDetail reportCounts(List<KindCount> reportCounts);

  AdminGameDetail nextSettlementAt(DateTime? nextSettlementAt);

  AdminGameDetail maturingSheets(int maturingSheets);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminGameDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminGameDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminGameDetail call({
    AdminGame game,
    List<AdminHouse> houses,
    List<KindCount> reportCounts,
    DateTime? nextSettlementAt,
    int maturingSheets,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminGameDetail.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminGameDetail.copyWith.fieldName(...)`
class _$AdminGameDetailCWProxyImpl implements _$AdminGameDetailCWProxy {
  const _$AdminGameDetailCWProxyImpl(this._value);

  final AdminGameDetail _value;

  @override
  AdminGameDetail game(AdminGame game) => this(game: game);

  @override
  AdminGameDetail houses(List<AdminHouse> houses) => this(houses: houses);

  @override
  AdminGameDetail reportCounts(List<KindCount> reportCounts) =>
      this(reportCounts: reportCounts);

  @override
  AdminGameDetail nextSettlementAt(DateTime? nextSettlementAt) =>
      this(nextSettlementAt: nextSettlementAt);

  @override
  AdminGameDetail maturingSheets(int maturingSheets) =>
      this(maturingSheets: maturingSheets);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminGameDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminGameDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminGameDetail call({
    Object? game = const $CopyWithPlaceholder(),
    Object? houses = const $CopyWithPlaceholder(),
    Object? reportCounts = const $CopyWithPlaceholder(),
    Object? nextSettlementAt = const $CopyWithPlaceholder(),
    Object? maturingSheets = const $CopyWithPlaceholder(),
  }) {
    return AdminGameDetail(
      game: game == const $CopyWithPlaceholder()
          ? _value.game
          // ignore: cast_nullable_to_non_nullable
          : game as AdminGame,
      houses: houses == const $CopyWithPlaceholder()
          ? _value.houses
          // ignore: cast_nullable_to_non_nullable
          : houses as List<AdminHouse>,
      reportCounts: reportCounts == const $CopyWithPlaceholder()
          ? _value.reportCounts
          // ignore: cast_nullable_to_non_nullable
          : reportCounts as List<KindCount>,
      nextSettlementAt: nextSettlementAt == const $CopyWithPlaceholder()
          ? _value.nextSettlementAt
          // ignore: cast_nullable_to_non_nullable
          : nextSettlementAt as DateTime?,
      maturingSheets: maturingSheets == const $CopyWithPlaceholder()
          ? _value.maturingSheets
          // ignore: cast_nullable_to_non_nullable
          : maturingSheets as int,
    );
  }
}

extension $AdminGameDetailCopyWith on AdminGameDetail {
  /// Returns a callable class that can be used as follows: `instanceOfAdminGameDetail.copyWith(...)` or like so:`instanceOfAdminGameDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminGameDetailCWProxy get copyWith => _$AdminGameDetailCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminGameDetail _$AdminGameDetailFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminGameDetail', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'game',
          'houses',
          'reportCounts',
          'nextSettlementAt',
          'maturingSheets',
        ],
      );
      final val = AdminGameDetail(
        game: $checkedConvert(
          'game',
          (v) => AdminGame.fromJson(v as Map<String, dynamic>),
        ),
        houses: $checkedConvert(
          'houses',
          (v) => (v as List<dynamic>)
              .map((e) => AdminHouse.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        reportCounts: $checkedConvert(
          'reportCounts',
          (v) => (v as List<dynamic>)
              .map((e) => KindCount.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextSettlementAt: $checkedConvert(
          'nextSettlementAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        maturingSheets: $checkedConvert(
          'maturingSheets',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminGameDetailToJson(AdminGameDetail instance) =>
    <String, dynamic>{
      'game': instance.game.toJson(),
      'houses': instance.houses.map((e) => e.toJson()).toList(),
      'reportCounts': instance.reportCounts.map((e) => e.toJson()).toList(),
      'nextSettlementAt': instance.nextSettlementAt?.toIso8601String(),
      'maturingSheets': instance.maturingSheets,
    };
