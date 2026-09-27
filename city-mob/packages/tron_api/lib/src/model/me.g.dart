// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MeCWProxy {
  Me playerId(String playerId);

  Me houseName(String houseName);

  Me tincture(String tincture);

  Me background(String? background);

  Me estate(String? estate);

  Me pp(int pp);

  Me ppMax(int ppMax);

  Me gold(double gold);

  Me legit(int legit);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Me(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Me(...).copyWith(id: 12, name: "My name")
  /// ````
  Me call({
    String playerId,
    String houseName,
    String tincture,
    String? background,
    String? estate,
    int pp,
    int ppMax,
    double gold,
    int legit,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMe.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMe.copyWith.fieldName(...)`
class _$MeCWProxyImpl implements _$MeCWProxy {
  const _$MeCWProxyImpl(this._value);

  final Me _value;

  @override
  Me playerId(String playerId) => this(playerId: playerId);

  @override
  Me houseName(String houseName) => this(houseName: houseName);

  @override
  Me tincture(String tincture) => this(tincture: tincture);

  @override
  Me background(String? background) => this(background: background);

  @override
  Me estate(String? estate) => this(estate: estate);

  @override
  Me pp(int pp) => this(pp: pp);

  @override
  Me ppMax(int ppMax) => this(ppMax: ppMax);

  @override
  Me gold(double gold) => this(gold: gold);

  @override
  Me legit(int legit) => this(legit: legit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Me(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Me(...).copyWith(id: 12, name: "My name")
  /// ````
  Me call({
    Object? playerId = const $CopyWithPlaceholder(),
    Object? houseName = const $CopyWithPlaceholder(),
    Object? tincture = const $CopyWithPlaceholder(),
    Object? background = const $CopyWithPlaceholder(),
    Object? estate = const $CopyWithPlaceholder(),
    Object? pp = const $CopyWithPlaceholder(),
    Object? ppMax = const $CopyWithPlaceholder(),
    Object? gold = const $CopyWithPlaceholder(),
    Object? legit = const $CopyWithPlaceholder(),
  }) {
    return Me(
      playerId: playerId == const $CopyWithPlaceholder()
          ? _value.playerId
          // ignore: cast_nullable_to_non_nullable
          : playerId as String,
      houseName: houseName == const $CopyWithPlaceholder()
          ? _value.houseName
          // ignore: cast_nullable_to_non_nullable
          : houseName as String,
      tincture: tincture == const $CopyWithPlaceholder()
          ? _value.tincture
          // ignore: cast_nullable_to_non_nullable
          : tincture as String,
      background: background == const $CopyWithPlaceholder()
          ? _value.background
          // ignore: cast_nullable_to_non_nullable
          : background as String?,
      estate: estate == const $CopyWithPlaceholder()
          ? _value.estate
          // ignore: cast_nullable_to_non_nullable
          : estate as String?,
      pp: pp == const $CopyWithPlaceholder()
          ? _value.pp
          // ignore: cast_nullable_to_non_nullable
          : pp as int,
      ppMax: ppMax == const $CopyWithPlaceholder()
          ? _value.ppMax
          // ignore: cast_nullable_to_non_nullable
          : ppMax as int,
      gold: gold == const $CopyWithPlaceholder()
          ? _value.gold
          // ignore: cast_nullable_to_non_nullable
          : gold as double,
      legit: legit == const $CopyWithPlaceholder()
          ? _value.legit
          // ignore: cast_nullable_to_non_nullable
          : legit as int,
    );
  }
}

extension $MeCopyWith on Me {
  /// Returns a callable class that can be used as follows: `instanceOfMe.copyWith(...)` or like so:`instanceOfMe.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MeCWProxy get copyWith => _$MeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Me _$MeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Me', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'playerId',
          'houseName',
          'tincture',
          'background',
          'estate',
          'pp',
          'ppMax',
          'gold',
          'legit',
        ],
      );
      final val = Me(
        playerId: $checkedConvert('playerId', (v) => v as String),
        houseName: $checkedConvert('houseName', (v) => v as String),
        tincture: $checkedConvert('tincture', (v) => v as String),
        background: $checkedConvert('background', (v) => v as String?),
        estate: $checkedConvert('estate', (v) => v as String?),
        pp: $checkedConvert('pp', (v) => (v as num).toInt()),
        ppMax: $checkedConvert('ppMax', (v) => (v as num).toInt()),
        gold: $checkedConvert('gold', (v) => (v as num).toDouble()),
        legit: $checkedConvert('legit', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$MeToJson(Me instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'houseName': instance.houseName,
  'tincture': instance.tincture,
  'background': instance.background,
  'estate': instance.estate,
  'pp': instance.pp,
  'ppMax': instance.ppMax,
  'gold': instance.gold,
  'legit': instance.legit,
};
