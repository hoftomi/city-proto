// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NewsViewCWProxy {
  NewsView id(String id);

  NewsView text(String text);

  NewsView template(String template);

  NewsView effect(int effect);

  NewsView author(HouseRef author);

  NewsView target(HouseRef target);

  NewsView createdAt(DateTime createdAt);

  NewsView debunked(bool debunked);

  NewsView verified(bool? verified);

  NewsView mine(bool mine);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NewsView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NewsView(...).copyWith(id: 12, name: "My name")
  /// ````
  NewsView call({
    String id,
    String text,
    String template,
    int effect,
    HouseRef author,
    HouseRef target,
    DateTime createdAt,
    bool debunked,
    bool? verified,
    bool mine,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNewsView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNewsView.copyWith.fieldName(...)`
class _$NewsViewCWProxyImpl implements _$NewsViewCWProxy {
  const _$NewsViewCWProxyImpl(this._value);

  final NewsView _value;

  @override
  NewsView id(String id) => this(id: id);

  @override
  NewsView text(String text) => this(text: text);

  @override
  NewsView template(String template) => this(template: template);

  @override
  NewsView effect(int effect) => this(effect: effect);

  @override
  NewsView author(HouseRef author) => this(author: author);

  @override
  NewsView target(HouseRef target) => this(target: target);

  @override
  NewsView createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  NewsView debunked(bool debunked) => this(debunked: debunked);

  @override
  NewsView verified(bool? verified) => this(verified: verified);

  @override
  NewsView mine(bool mine) => this(mine: mine);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NewsView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NewsView(...).copyWith(id: 12, name: "My name")
  /// ````
  NewsView call({
    Object? id = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? template = const $CopyWithPlaceholder(),
    Object? effect = const $CopyWithPlaceholder(),
    Object? author = const $CopyWithPlaceholder(),
    Object? target = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? debunked = const $CopyWithPlaceholder(),
    Object? verified = const $CopyWithPlaceholder(),
    Object? mine = const $CopyWithPlaceholder(),
  }) {
    return NewsView(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      template: template == const $CopyWithPlaceholder()
          ? _value.template
          // ignore: cast_nullable_to_non_nullable
          : template as String,
      effect: effect == const $CopyWithPlaceholder()
          ? _value.effect
          // ignore: cast_nullable_to_non_nullable
          : effect as int,
      author: author == const $CopyWithPlaceholder()
          ? _value.author
          // ignore: cast_nullable_to_non_nullable
          : author as HouseRef,
      target: target == const $CopyWithPlaceholder()
          ? _value.target
          // ignore: cast_nullable_to_non_nullable
          : target as HouseRef,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      debunked: debunked == const $CopyWithPlaceholder()
          ? _value.debunked
          // ignore: cast_nullable_to_non_nullable
          : debunked as bool,
      verified: verified == const $CopyWithPlaceholder()
          ? _value.verified
          // ignore: cast_nullable_to_non_nullable
          : verified as bool?,
      mine: mine == const $CopyWithPlaceholder()
          ? _value.mine
          // ignore: cast_nullable_to_non_nullable
          : mine as bool,
    );
  }
}

extension $NewsViewCopyWith on NewsView {
  /// Returns a callable class that can be used as follows: `instanceOfNewsView.copyWith(...)` or like so:`instanceOfNewsView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NewsViewCWProxy get copyWith => _$NewsViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsView _$NewsViewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NewsView', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'text',
          'template',
          'effect',
          'author',
          'target',
          'createdAt',
          'debunked',
          'verified',
          'mine',
        ],
      );
      final val = NewsView(
        id: $checkedConvert('id', (v) => v as String),
        text: $checkedConvert('text', (v) => v as String),
        template: $checkedConvert('template', (v) => v as String),
        effect: $checkedConvert('effect', (v) => (v as num).toInt()),
        author: $checkedConvert(
          'author',
          (v) => HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        target: $checkedConvert(
          'target',
          (v) => HouseRef.fromJson(v as Map<String, dynamic>),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        debunked: $checkedConvert('debunked', (v) => v as bool),
        verified: $checkedConvert('verified', (v) => v as bool?),
        mine: $checkedConvert('mine', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$NewsViewToJson(NewsView instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'template': instance.template,
  'effect': instance.effect,
  'author': instance.author.toJson(),
  'target': instance.target.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'debunked': instance.debunked,
  'verified': instance.verified,
  'mine': instance.mine,
};
