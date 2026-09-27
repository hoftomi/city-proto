// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_row.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RankRowCWProxy {
  RankRow rank(int rank);

  RankRow playerId(String playerId);

  RankRow name(String name);

  RankRow tincture(String tincture);

  RankRow npc(bool npc);

  RankRow legit(int legit);

  RankRow shares(int shares);

  RankRow seats(int seats);

  RankRow self(bool self);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RankRow(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RankRow(...).copyWith(id: 12, name: "My name")
  /// ````
  RankRow call({
    int rank,
    String playerId,
    String name,
    String tincture,
    bool npc,
    int legit,
    int shares,
    int seats,
    bool self,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRankRow.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRankRow.copyWith.fieldName(...)`
class _$RankRowCWProxyImpl implements _$RankRowCWProxy {
  const _$RankRowCWProxyImpl(this._value);

  final RankRow _value;

  @override
  RankRow rank(int rank) => this(rank: rank);

  @override
  RankRow playerId(String playerId) => this(playerId: playerId);

  @override
  RankRow name(String name) => this(name: name);

  @override
  RankRow tincture(String tincture) => this(tincture: tincture);

  @override
  RankRow npc(bool npc) => this(npc: npc);

  @override
  RankRow legit(int legit) => this(legit: legit);

  @override
  RankRow shares(int shares) => this(shares: shares);

  @override
  RankRow seats(int seats) => this(seats: seats);

  @override
  RankRow self(bool self) => this(self: self);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RankRow(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RankRow(...).copyWith(id: 12, name: "My name")
  /// ````
  RankRow call({
    Object? rank = const $CopyWithPlaceholder(),
    Object? playerId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? tincture = const $CopyWithPlaceholder(),
    Object? npc = const $CopyWithPlaceholder(),
    Object? legit = const $CopyWithPlaceholder(),
    Object? shares = const $CopyWithPlaceholder(),
    Object? seats = const $CopyWithPlaceholder(),
    Object? self = const $CopyWithPlaceholder(),
  }) {
    return RankRow(
      rank: rank == const $CopyWithPlaceholder()
          ? _value.rank
          // ignore: cast_nullable_to_non_nullable
          : rank as int,
      playerId: playerId == const $CopyWithPlaceholder()
          ? _value.playerId
          // ignore: cast_nullable_to_non_nullable
          : playerId as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      tincture: tincture == const $CopyWithPlaceholder()
          ? _value.tincture
          // ignore: cast_nullable_to_non_nullable
          : tincture as String,
      npc: npc == const $CopyWithPlaceholder()
          ? _value.npc
          // ignore: cast_nullable_to_non_nullable
          : npc as bool,
      legit: legit == const $CopyWithPlaceholder()
          ? _value.legit
          // ignore: cast_nullable_to_non_nullable
          : legit as int,
      shares: shares == const $CopyWithPlaceholder()
          ? _value.shares
          // ignore: cast_nullable_to_non_nullable
          : shares as int,
      seats: seats == const $CopyWithPlaceholder()
          ? _value.seats
          // ignore: cast_nullable_to_non_nullable
          : seats as int,
      self: self == const $CopyWithPlaceholder()
          ? _value.self
          // ignore: cast_nullable_to_non_nullable
          : self as bool,
    );
  }
}

extension $RankRowCopyWith on RankRow {
  /// Returns a callable class that can be used as follows: `instanceOfRankRow.copyWith(...)` or like so:`instanceOfRankRow.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RankRowCWProxy get copyWith => _$RankRowCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankRow _$RankRowFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RankRow', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'rank',
          'playerId',
          'name',
          'tincture',
          'npc',
          'legit',
          'shares',
          'seats',
          'self',
        ],
      );
      final val = RankRow(
        rank: $checkedConvert('rank', (v) => (v as num).toInt()),
        playerId: $checkedConvert('playerId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        tincture: $checkedConvert('tincture', (v) => v as String),
        npc: $checkedConvert('npc', (v) => v as bool),
        legit: $checkedConvert('legit', (v) => (v as num).toInt()),
        shares: $checkedConvert('shares', (v) => (v as num).toInt()),
        seats: $checkedConvert('seats', (v) => (v as num).toInt()),
        self: $checkedConvert('self', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$RankRowToJson(RankRow instance) => <String, dynamic>{
  'rank': instance.rank,
  'playerId': instance.playerId,
  'name': instance.name,
  'tincture': instance.tincture,
  'npc': instance.npc,
  'legit': instance.legit,
  'shares': instance.shares,
  'seats': instance.seats,
  'self': instance.self,
};
