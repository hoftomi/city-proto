// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminReportCWProxy {
  AdminReport id(String id);

  AdminReport playerId(String playerId);

  AdminReport houseName(String houseName);

  AdminReport settlement(int settlement);

  AdminReport kind(String kind);

  AdminReport confidence(String? confidence);

  AdminReport title(String title);

  AdminReport body(String body);

  AdminReport tone(String tone);

  AdminReport isPublic(bool isPublic);

  AdminReport createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminReport(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminReport(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminReport call({
    String id,
    String playerId,
    String houseName,
    int settlement,
    String kind,
    String? confidence,
    String title,
    String body,
    String tone,
    bool isPublic,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminReport.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminReport.copyWith.fieldName(...)`
class _$AdminReportCWProxyImpl implements _$AdminReportCWProxy {
  const _$AdminReportCWProxyImpl(this._value);

  final AdminReport _value;

  @override
  AdminReport id(String id) => this(id: id);

  @override
  AdminReport playerId(String playerId) => this(playerId: playerId);

  @override
  AdminReport houseName(String houseName) => this(houseName: houseName);

  @override
  AdminReport settlement(int settlement) => this(settlement: settlement);

  @override
  AdminReport kind(String kind) => this(kind: kind);

  @override
  AdminReport confidence(String? confidence) => this(confidence: confidence);

  @override
  AdminReport title(String title) => this(title: title);

  @override
  AdminReport body(String body) => this(body: body);

  @override
  AdminReport tone(String tone) => this(tone: tone);

  @override
  AdminReport isPublic(bool isPublic) => this(isPublic: isPublic);

  @override
  AdminReport createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminReport(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminReport(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminReport call({
    Object? id = const $CopyWithPlaceholder(),
    Object? playerId = const $CopyWithPlaceholder(),
    Object? houseName = const $CopyWithPlaceholder(),
    Object? settlement = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? confidence = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? tone = const $CopyWithPlaceholder(),
    Object? isPublic = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return AdminReport(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      playerId: playerId == const $CopyWithPlaceholder()
          ? _value.playerId
          // ignore: cast_nullable_to_non_nullable
          : playerId as String,
      houseName: houseName == const $CopyWithPlaceholder()
          ? _value.houseName
          // ignore: cast_nullable_to_non_nullable
          : houseName as String,
      settlement: settlement == const $CopyWithPlaceholder()
          ? _value.settlement
          // ignore: cast_nullable_to_non_nullable
          : settlement as int,
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
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      tone: tone == const $CopyWithPlaceholder()
          ? _value.tone
          // ignore: cast_nullable_to_non_nullable
          : tone as String,
      isPublic: isPublic == const $CopyWithPlaceholder()
          ? _value.isPublic
          // ignore: cast_nullable_to_non_nullable
          : isPublic as bool,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $AdminReportCopyWith on AdminReport {
  /// Returns a callable class that can be used as follows: `instanceOfAdminReport.copyWith(...)` or like so:`instanceOfAdminReport.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminReportCWProxy get copyWith => _$AdminReportCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminReport _$AdminReportFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminReport', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'playerId',
          'houseName',
          'settlement',
          'kind',
          'confidence',
          'title',
          'body',
          'tone',
          'isPublic',
          'createdAt',
        ],
      );
      final val = AdminReport(
        id: $checkedConvert('id', (v) => v as String),
        playerId: $checkedConvert('playerId', (v) => v as String),
        houseName: $checkedConvert('houseName', (v) => v as String),
        settlement: $checkedConvert('settlement', (v) => (v as num).toInt()),
        kind: $checkedConvert('kind', (v) => v as String),
        confidence: $checkedConvert('confidence', (v) => v as String?),
        title: $checkedConvert('title', (v) => v as String),
        body: $checkedConvert('body', (v) => v as String),
        tone: $checkedConvert('tone', (v) => v as String),
        isPublic: $checkedConvert('isPublic', (v) => v as bool),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminReportToJson(AdminReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'houseName': instance.houseName,
      'settlement': instance.settlement,
      'kind': instance.kind,
      'confidence': instance.confidence,
      'title': instance.title,
      'body': instance.body,
      'tone': instance.tone,
      'isPublic': instance.isPublic,
      'createdAt': instance.createdAt.toIso8601String(),
    };
