// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CatalogCWProxy {
  Catalog actions(List<ActionInfo> actions);

  Catalog margins(List<LevelInfo> margins);

  Catalog programs(List<LevelInfo> programs);

  Catalog news(List<NewsTemplateInfo> news);

  Catalog rules(RulesInfo rules);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Catalog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Catalog(...).copyWith(id: 12, name: "My name")
  /// ````
  Catalog call({
    List<ActionInfo> actions,
    List<LevelInfo> margins,
    List<LevelInfo> programs,
    List<NewsTemplateInfo> news,
    RulesInfo rules,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCatalog.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCatalog.copyWith.fieldName(...)`
class _$CatalogCWProxyImpl implements _$CatalogCWProxy {
  const _$CatalogCWProxyImpl(this._value);

  final Catalog _value;

  @override
  Catalog actions(List<ActionInfo> actions) => this(actions: actions);

  @override
  Catalog margins(List<LevelInfo> margins) => this(margins: margins);

  @override
  Catalog programs(List<LevelInfo> programs) => this(programs: programs);

  @override
  Catalog news(List<NewsTemplateInfo> news) => this(news: news);

  @override
  Catalog rules(RulesInfo rules) => this(rules: rules);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Catalog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Catalog(...).copyWith(id: 12, name: "My name")
  /// ````
  Catalog call({
    Object? actions = const $CopyWithPlaceholder(),
    Object? margins = const $CopyWithPlaceholder(),
    Object? programs = const $CopyWithPlaceholder(),
    Object? news = const $CopyWithPlaceholder(),
    Object? rules = const $CopyWithPlaceholder(),
  }) {
    return Catalog(
      actions: actions == const $CopyWithPlaceholder()
          ? _value.actions
          // ignore: cast_nullable_to_non_nullable
          : actions as List<ActionInfo>,
      margins: margins == const $CopyWithPlaceholder()
          ? _value.margins
          // ignore: cast_nullable_to_non_nullable
          : margins as List<LevelInfo>,
      programs: programs == const $CopyWithPlaceholder()
          ? _value.programs
          // ignore: cast_nullable_to_non_nullable
          : programs as List<LevelInfo>,
      news: news == const $CopyWithPlaceholder()
          ? _value.news
          // ignore: cast_nullable_to_non_nullable
          : news as List<NewsTemplateInfo>,
      rules: rules == const $CopyWithPlaceholder()
          ? _value.rules
          // ignore: cast_nullable_to_non_nullable
          : rules as RulesInfo,
    );
  }
}

extension $CatalogCopyWith on Catalog {
  /// Returns a callable class that can be used as follows: `instanceOfCatalog.copyWith(...)` or like so:`instanceOfCatalog.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CatalogCWProxy get copyWith => _$CatalogCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catalog _$CatalogFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Catalog', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['actions', 'margins', 'programs', 'news', 'rules'],
      );
      final val = Catalog(
        actions: $checkedConvert(
          'actions',
          (v) => (v as List<dynamic>)
              .map((e) => ActionInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        margins: $checkedConvert(
          'margins',
          (v) => (v as List<dynamic>)
              .map((e) => LevelInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        programs: $checkedConvert(
          'programs',
          (v) => (v as List<dynamic>)
              .map((e) => LevelInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        news: $checkedConvert(
          'news',
          (v) => (v as List<dynamic>)
              .map((e) => NewsTemplateInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        rules: $checkedConvert(
          'rules',
          (v) => RulesInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CatalogToJson(Catalog instance) => <String, dynamic>{
  'actions': instance.actions.map((e) => e.toJson()).toList(),
  'margins': instance.margins.map((e) => e.toJson()).toList(),
  'programs': instance.programs.map((e) => e.toJson()).toList(),
  'news': instance.news.map((e) => e.toJson()).toList(),
  'rules': instance.rules.toJson(),
};
