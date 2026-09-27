// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_template_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NewsTemplateInfoCWProxy {
  NewsTemplateInfo id(String id);

  NewsTemplateInfo label(String label);

  NewsTemplateInfo effect(int effect);

  NewsTemplateInfo needsGood(bool needsGood);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NewsTemplateInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NewsTemplateInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  NewsTemplateInfo call({String id, String label, int effect, bool needsGood});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNewsTemplateInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNewsTemplateInfo.copyWith.fieldName(...)`
class _$NewsTemplateInfoCWProxyImpl implements _$NewsTemplateInfoCWProxy {
  const _$NewsTemplateInfoCWProxyImpl(this._value);

  final NewsTemplateInfo _value;

  @override
  NewsTemplateInfo id(String id) => this(id: id);

  @override
  NewsTemplateInfo label(String label) => this(label: label);

  @override
  NewsTemplateInfo effect(int effect) => this(effect: effect);

  @override
  NewsTemplateInfo needsGood(bool needsGood) => this(needsGood: needsGood);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NewsTemplateInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NewsTemplateInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  NewsTemplateInfo call({
    Object? id = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? effect = const $CopyWithPlaceholder(),
    Object? needsGood = const $CopyWithPlaceholder(),
  }) {
    return NewsTemplateInfo(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      effect: effect == const $CopyWithPlaceholder()
          ? _value.effect
          // ignore: cast_nullable_to_non_nullable
          : effect as int,
      needsGood: needsGood == const $CopyWithPlaceholder()
          ? _value.needsGood
          // ignore: cast_nullable_to_non_nullable
          : needsGood as bool,
    );
  }
}

extension $NewsTemplateInfoCopyWith on NewsTemplateInfo {
  /// Returns a callable class that can be used as follows: `instanceOfNewsTemplateInfo.copyWith(...)` or like so:`instanceOfNewsTemplateInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NewsTemplateInfoCWProxy get copyWith => _$NewsTemplateInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsTemplateInfo _$NewsTemplateInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NewsTemplateInfo', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'label', 'effect', 'needsGood'],
      );
      final val = NewsTemplateInfo(
        id: $checkedConvert('id', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        effect: $checkedConvert('effect', (v) => (v as num).toInt()),
        needsGood: $checkedConvert('needsGood', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$NewsTemplateInfoToJson(NewsTemplateInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'effect': instance.effect,
      'needsGood': instance.needsGood,
    };
