// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_house.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MyHouseCWProxy {
  MyHouse houseName(String houseName);

  MyHouse backgroundName(String? backgroundName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyHouse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyHouse(...).copyWith(id: 12, name: "My name")
  /// ````
  MyHouse call({String houseName, String? backgroundName});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMyHouse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMyHouse.copyWith.fieldName(...)`
class _$MyHouseCWProxyImpl implements _$MyHouseCWProxy {
  const _$MyHouseCWProxyImpl(this._value);

  final MyHouse _value;

  @override
  MyHouse houseName(String houseName) => this(houseName: houseName);

  @override
  MyHouse backgroundName(String? backgroundName) =>
      this(backgroundName: backgroundName);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyHouse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyHouse(...).copyWith(id: 12, name: "My name")
  /// ````
  MyHouse call({
    Object? houseName = const $CopyWithPlaceholder(),
    Object? backgroundName = const $CopyWithPlaceholder(),
  }) {
    return MyHouse(
      houseName: houseName == const $CopyWithPlaceholder()
          ? _value.houseName
          // ignore: cast_nullable_to_non_nullable
          : houseName as String,
      backgroundName: backgroundName == const $CopyWithPlaceholder()
          ? _value.backgroundName
          // ignore: cast_nullable_to_non_nullable
          : backgroundName as String?,
    );
  }
}

extension $MyHouseCopyWith on MyHouse {
  /// Returns a callable class that can be used as follows: `instanceOfMyHouse.copyWith(...)` or like so:`instanceOfMyHouse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MyHouseCWProxy get copyWith => _$MyHouseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyHouse _$MyHouseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MyHouse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['houseName', 'backgroundName']);
      final val = MyHouse(
        houseName: $checkedConvert('houseName', (v) => v as String),
        backgroundName: $checkedConvert('backgroundName', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MyHouseToJson(MyHouse instance) => <String, dynamic>{
  'houseName': instance.houseName,
  'backgroundName': instance.backgroundName,
};
