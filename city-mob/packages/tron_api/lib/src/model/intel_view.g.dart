// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intel_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IntelViewCWProxy {
  IntelView id(String id);

  IntelView of_(HouseRef of_);

  IntelView executeAt(DateTime executeAt);

  IntelView lines(List<String> lines);

  IntelView depth(int depth);

  IntelView live(bool live);

  IntelView offeredTo(List<String> offeredTo);

  IntelView bought(bool bought);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IntelView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IntelView(...).copyWith(id: 12, name: "My name")
  /// ````
  IntelView call({
    String id,
    HouseRef of_,
    DateTime executeAt,
    List<String> lines,
    int depth,
    bool live,
    List<String> offeredTo,
    bool bought,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIntelView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIntelView.copyWith.fieldName(...)`
class _$IntelViewCWProxyImpl implements _$IntelViewCWProxy {
  const _$IntelViewCWProxyImpl(this._value);

  final IntelView _value;

  @override
  IntelView id(String id) => this(id: id);

  @override
  IntelView of_(HouseRef of_) => this(of_: of_);

  @override
  IntelView executeAt(DateTime executeAt) => this(executeAt: executeAt);

  @override
  IntelView lines(List<String> lines) => this(lines: lines);

  @override
  IntelView depth(int depth) => this(depth: depth);

  @override
  IntelView live(bool live) => this(live: live);

  @override
  IntelView offeredTo(List<String> offeredTo) => this(offeredTo: offeredTo);

  @override
  IntelView bought(bool bought) => this(bought: bought);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IntelView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IntelView(...).copyWith(id: 12, name: "My name")
  /// ````
  IntelView call({
    Object? id = const $CopyWithPlaceholder(),
    Object? of_ = const $CopyWithPlaceholder(),
    Object? executeAt = const $CopyWithPlaceholder(),
    Object? lines = const $CopyWithPlaceholder(),
    Object? depth = const $CopyWithPlaceholder(),
    Object? live = const $CopyWithPlaceholder(),
    Object? offeredTo = const $CopyWithPlaceholder(),
    Object? bought = const $CopyWithPlaceholder(),
  }) {
    return IntelView(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      of_: of_ == const $CopyWithPlaceholder()
          ? _value.of_
          // ignore: cast_nullable_to_non_nullable
          : of_ as HouseRef,
      executeAt: executeAt == const $CopyWithPlaceholder()
          ? _value.executeAt
          // ignore: cast_nullable_to_non_nullable
          : executeAt as DateTime,
      lines: lines == const $CopyWithPlaceholder()
          ? _value.lines
          // ignore: cast_nullable_to_non_nullable
          : lines as List<String>,
      depth: depth == const $CopyWithPlaceholder()
          ? _value.depth
          // ignore: cast_nullable_to_non_nullable
          : depth as int,
      live: live == const $CopyWithPlaceholder()
          ? _value.live
          // ignore: cast_nullable_to_non_nullable
          : live as bool,
      offeredTo: offeredTo == const $CopyWithPlaceholder()
          ? _value.offeredTo
          // ignore: cast_nullable_to_non_nullable
          : offeredTo as List<String>,
      bought: bought == const $CopyWithPlaceholder()
          ? _value.bought
          // ignore: cast_nullable_to_non_nullable
          : bought as bool,
    );
  }
}

extension $IntelViewCopyWith on IntelView {
  /// Returns a callable class that can be used as follows: `instanceOfIntelView.copyWith(...)` or like so:`instanceOfIntelView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IntelViewCWProxy get copyWith => _$IntelViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntelView _$IntelViewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('IntelView', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'of',
          'executeAt',
          'lines',
          'depth',
          'live',
          'offeredTo',
          'bought',
        ],
      );
      final val = IntelView(
        id: $checkedConvert('id', (v) => v as String),
        of_: $checkedConvert(
          'of',
          (v) => HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        executeAt: $checkedConvert(
          'executeAt',
          (v) => DateTime.parse(v as String),
        ),
        lines: $checkedConvert(
          'lines',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        depth: $checkedConvert('depth', (v) => (v as num).toInt()),
        live: $checkedConvert('live', (v) => v as bool),
        offeredTo: $checkedConvert(
          'offeredTo',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        bought: $checkedConvert('bought', (v) => v as bool),
      );
      return val;
    }, fieldKeyMap: const {'of_': 'of'});

Map<String, dynamic> _$IntelViewToJson(IntelView instance) => <String, dynamic>{
  'id': instance.id,
  'of': instance.of_.toJson(),
  'executeAt': instance.executeAt.toIso8601String(),
  'lines': instance.lines,
  'depth': instance.depth,
  'live': instance.live,
  'offeredTo': instance.offeredTo,
  'bought': instance.bought,
};
