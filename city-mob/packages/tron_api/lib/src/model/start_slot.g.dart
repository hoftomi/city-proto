// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_slot.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StartSlotCWProxy {
  StartSlot id(String id);

  StartSlot name(String name);

  StartSlot x(int x);

  StartSlot y(int y);

  StartSlot neighbors(List<String> neighbors);

  StartSlot note(String note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartSlot(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartSlot(...).copyWith(id: 12, name: "My name")
  /// ````
  StartSlot call({
    String id,
    String name,
    int x,
    int y,
    List<String> neighbors,
    String note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStartSlot.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStartSlot.copyWith.fieldName(...)`
class _$StartSlotCWProxyImpl implements _$StartSlotCWProxy {
  const _$StartSlotCWProxyImpl(this._value);

  final StartSlot _value;

  @override
  StartSlot id(String id) => this(id: id);

  @override
  StartSlot name(String name) => this(name: name);

  @override
  StartSlot x(int x) => this(x: x);

  @override
  StartSlot y(int y) => this(y: y);

  @override
  StartSlot neighbors(List<String> neighbors) => this(neighbors: neighbors);

  @override
  StartSlot note(String note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartSlot(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartSlot(...).copyWith(id: 12, name: "My name")
  /// ````
  StartSlot call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? x = const $CopyWithPlaceholder(),
    Object? y = const $CopyWithPlaceholder(),
    Object? neighbors = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return StartSlot(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      x: x == const $CopyWithPlaceholder()
          ? _value.x
          // ignore: cast_nullable_to_non_nullable
          : x as int,
      y: y == const $CopyWithPlaceholder()
          ? _value.y
          // ignore: cast_nullable_to_non_nullable
          : y as int,
      neighbors: neighbors == const $CopyWithPlaceholder()
          ? _value.neighbors
          // ignore: cast_nullable_to_non_nullable
          : neighbors as List<String>,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
    );
  }
}

extension $StartSlotCopyWith on StartSlot {
  /// Returns a callable class that can be used as follows: `instanceOfStartSlot.copyWith(...)` or like so:`instanceOfStartSlot.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StartSlotCWProxy get copyWith => _$StartSlotCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartSlot _$StartSlotFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StartSlot', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'name', 'x', 'y', 'neighbors', 'note'],
      );
      final val = StartSlot(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        x: $checkedConvert('x', (v) => (v as num).toInt()),
        y: $checkedConvert('y', (v) => (v as num).toInt()),
        neighbors: $checkedConvert(
          'neighbors',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        note: $checkedConvert('note', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$StartSlotToJson(StartSlot instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'x': instance.x,
  'y': instance.y,
  'neighbors': instance.neighbors,
  'note': instance.note,
};
