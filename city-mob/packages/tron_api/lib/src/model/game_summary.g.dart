// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_summary.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GameSummaryCWProxy {
  GameSummary id(String id);

  GameSummary name(String name);

  GameSummary status(String status);

  GameSummary closesAt(DateTime? closesAt);

  GameSummary opensAt(DateTime? opensAt);

  GameSummary tags(List<String> tags);

  GameSummary canJoin(bool canJoin);

  GameSummary winner(String? winner);

  GameSummary myPlace(int? myPlace);

  GameSummary myHouse(MyHouse? myHouse);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GameSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GameSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  GameSummary call({
    String id,
    String name,
    String status,
    DateTime? closesAt,
    DateTime? opensAt,
    List<String> tags,
    bool canJoin,
    String? winner,
    int? myPlace,
    MyHouse? myHouse,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGameSummary.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGameSummary.copyWith.fieldName(...)`
class _$GameSummaryCWProxyImpl implements _$GameSummaryCWProxy {
  const _$GameSummaryCWProxyImpl(this._value);

  final GameSummary _value;

  @override
  GameSummary id(String id) => this(id: id);

  @override
  GameSummary name(String name) => this(name: name);

  @override
  GameSummary status(String status) => this(status: status);

  @override
  GameSummary closesAt(DateTime? closesAt) => this(closesAt: closesAt);

  @override
  GameSummary opensAt(DateTime? opensAt) => this(opensAt: opensAt);

  @override
  GameSummary tags(List<String> tags) => this(tags: tags);

  @override
  GameSummary canJoin(bool canJoin) => this(canJoin: canJoin);

  @override
  GameSummary winner(String? winner) => this(winner: winner);

  @override
  GameSummary myPlace(int? myPlace) => this(myPlace: myPlace);

  @override
  GameSummary myHouse(MyHouse? myHouse) => this(myHouse: myHouse);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GameSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GameSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  GameSummary call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? closesAt = const $CopyWithPlaceholder(),
    Object? opensAt = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? canJoin = const $CopyWithPlaceholder(),
    Object? winner = const $CopyWithPlaceholder(),
    Object? myPlace = const $CopyWithPlaceholder(),
    Object? myHouse = const $CopyWithPlaceholder(),
  }) {
    return GameSummary(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      closesAt: closesAt == const $CopyWithPlaceholder()
          ? _value.closesAt
          // ignore: cast_nullable_to_non_nullable
          : closesAt as DateTime?,
      opensAt: opensAt == const $CopyWithPlaceholder()
          ? _value.opensAt
          // ignore: cast_nullable_to_non_nullable
          : opensAt as DateTime?,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>,
      canJoin: canJoin == const $CopyWithPlaceholder()
          ? _value.canJoin
          // ignore: cast_nullable_to_non_nullable
          : canJoin as bool,
      winner: winner == const $CopyWithPlaceholder()
          ? _value.winner
          // ignore: cast_nullable_to_non_nullable
          : winner as String?,
      myPlace: myPlace == const $CopyWithPlaceholder()
          ? _value.myPlace
          // ignore: cast_nullable_to_non_nullable
          : myPlace as int?,
      myHouse: myHouse == const $CopyWithPlaceholder()
          ? _value.myHouse
          // ignore: cast_nullable_to_non_nullable
          : myHouse as MyHouse?,
    );
  }
}

extension $GameSummaryCopyWith on GameSummary {
  /// Returns a callable class that can be used as follows: `instanceOfGameSummary.copyWith(...)` or like so:`instanceOfGameSummary.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GameSummaryCWProxy get copyWith => _$GameSummaryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSummary _$GameSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GameSummary', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'status',
          'closesAt',
          'opensAt',
          'tags',
          'canJoin',
          'winner',
          'myPlace',
          'myHouse',
        ],
      );
      final val = GameSummary(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        closesAt: $checkedConvert(
          'closesAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        opensAt: $checkedConvert(
          'opensAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        canJoin: $checkedConvert('canJoin', (v) => v as bool),
        winner: $checkedConvert('winner', (v) => v as String?),
        myPlace: $checkedConvert('myPlace', (v) => (v as num?)?.toInt()),
        myHouse: $checkedConvert(
          'myHouse',
          (v) => v == null ? null : MyHouse.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GameSummaryToJson(GameSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'closesAt': instance.closesAt?.toIso8601String(),
      'opensAt': instance.opensAt?.toIso8601String(),
      'tags': instance.tags,
      'canJoin': instance.canJoin,
      'winner': instance.winner,
      'myPlace': instance.myPlace,
      'myHouse': instance.myHouse?.toJson(),
    };
