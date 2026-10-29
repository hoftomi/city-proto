//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_report.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminReport {
  /// Returns a new [AdminReport] instance.
  AdminReport({

    required  this.id,

    required  this.playerId,

    required  this.houseName,

    required  this.settlement,

    required  this.kind,

    required  this.confidence,

    required  this.title,

    required  this.body,

    required  this.tone,

    required  this.isPublic,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'playerId',
    required: true,
    includeIfNull: false,
  )


  final String playerId;



  @JsonKey(
    
    name: r'houseName',
    required: true,
    includeIfNull: false,
  )


  final String houseName;



  @JsonKey(
    
    name: r'settlement',
    required: true,
    includeIfNull: false,
  )


  final int settlement;



  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final String kind;



  @JsonKey(
    
    name: r'confidence',
    required: true,
    includeIfNull: true,
  )


  final String? confidence;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;



  @JsonKey(
    
    name: r'tone',
    required: true,
    includeIfNull: false,
  )


  final String tone;



  @JsonKey(
    
    name: r'isPublic',
    required: true,
    includeIfNull: false,
  )


  final bool isPublic;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminReport &&
      other.id == id &&
      other.playerId == playerId &&
      other.houseName == houseName &&
      other.settlement == settlement &&
      other.kind == kind &&
      other.confidence == confidence &&
      other.title == title &&
      other.body == body &&
      other.tone == tone &&
      other.isPublic == isPublic &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        playerId.hashCode +
        houseName.hashCode +
        settlement.hashCode +
        kind.hashCode +
        (confidence == null ? 0 : confidence.hashCode) +
        title.hashCode +
        body.hashCode +
        tone.hashCode +
        isPublic.hashCode +
        createdAt.hashCode;

  factory AdminReport.fromJson(Map<String, dynamic> json) => _$AdminReportFromJson(json);

  Map<String, dynamic> toJson() => _$AdminReportToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

