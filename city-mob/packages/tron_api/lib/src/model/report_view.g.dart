// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportViewCWProxy {
  ReportView id(String id);

  ReportView round(int round);

  ReportView kind(String kind);

  ReportView confidence(String? confidence);

  ReportView title(String title);

  ReportView text(String text);

  ReportView tone(String tone);

  ReportView createdAt(DateTime createdAt);

  ReportView isPublic(bool isPublic);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportView(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportView call({
    String id,
    int round,
    String kind,
    String? confidence,
    String title,
    String text,
    String tone,
    DateTime createdAt,
    bool isPublic,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportView.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportView.copyWith.fieldName(...)`
class _$ReportViewCWProxyImpl implements _$ReportViewCWProxy {
  const _$ReportViewCWProxyImpl(this._value);

  final ReportView _value;

  @override
  ReportView id(String id) => this(id: id);

  @override
  ReportView round(int round) => this(round: round);

  @override
  ReportView kind(String kind) => this(kind: kind);

  @override
  ReportView confidence(String? confidence) => this(confidence: confidence);

  @override
  ReportView title(String title) => this(title: title);

  @override
  ReportView text(String text) => this(text: text);

  @override
  ReportView tone(String tone) => this(tone: tone);

  @override
  ReportView createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  ReportView isPublic(bool isPublic) => this(isPublic: isPublic);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportView(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportView(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportView call({
    Object? id = const $CopyWithPlaceholder(),
    Object? round = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? confidence = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? tone = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? isPublic = const $CopyWithPlaceholder(),
  }) {
    return ReportView(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      round: round == const $CopyWithPlaceholder()
          ? _value.round
          // ignore: cast_nullable_to_non_nullable
          : round as int,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as String,
      confidence: confidence == const $CopyWithPlaceholder()
          ? _value.confidence
          // ignore: cast_nullable_to_non_nullable
          : confidence as String?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      tone: tone == const $CopyWithPlaceholder()
          ? _value.tone
          // ignore: cast_nullable_to_non_nullable
          : tone as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      isPublic: isPublic == const $CopyWithPlaceholder()
          ? _value.isPublic
          // ignore: cast_nullable_to_non_nullable
          : isPublic as bool,
    );
  }
}

extension $ReportViewCopyWith on ReportView {
  /// Returns a callable class that can be used as follows: `instanceOfReportView.copyWith(...)` or like so:`instanceOfReportView.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportViewCWProxy get copyWith => _$ReportViewCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportView _$ReportViewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReportView', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'round',
          'kind',
          'confidence',
          'title',
          'text',
          'tone',
          'createdAt',
          'isPublic',
        ],
      );
      final val = ReportView(
        id: $checkedConvert('id', (v) => v as String),
        round: $checkedConvert('round', (v) => (v as num).toInt()),
        kind: $checkedConvert('kind', (v) => v as String),
        confidence: $checkedConvert('confidence', (v) => v as String?),
        title: $checkedConvert('title', (v) => v as String),
        text: $checkedConvert('text', (v) => v as String),
        tone: $checkedConvert('tone', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        isPublic: $checkedConvert('isPublic', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$ReportViewToJson(ReportView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'round': instance.round,
      'kind': instance.kind,
      'confidence': instance.confidence,
      'title': instance.title,
      'text': instance.text,
      'tone': instance.tone,
      'createdAt': instance.createdAt.toIso8601String(),
      'isPublic': instance.isPublic,
    };
