//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReportView {
  /// Returns a new [ReportView] instance.
  ReportView({

    required  this.id,

    required  this.round,

    required  this.kind,

    required  this.confidence,

    required  this.title,

    required  this.text,

    required  this.tone,

    required  this.createdAt,

    required  this.isPublic,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'round',
    required: true,
    includeIfNull: false,
  )


  final int round;



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
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;



  @JsonKey(
    
    name: r'tone',
    required: true,
    includeIfNull: false,
  )


  final String tone;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'isPublic',
    required: true,
    includeIfNull: false,
  )


  final bool isPublic;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReportView &&
      other.id == id &&
      other.round == round &&
      other.kind == kind &&
      other.confidence == confidence &&
      other.title == title &&
      other.text == text &&
      other.tone == tone &&
      other.createdAt == createdAt &&
      other.isPublic == isPublic;

    @override
    int get hashCode =>
        id.hashCode +
        round.hashCode +
        kind.hashCode +
        (confidence == null ? 0 : confidence.hashCode) +
        title.hashCode +
        text.hashCode +
        tone.hashCode +
        createdAt.hashCode +
        isPublic.hashCode;

  factory ReportView.fromJson(Map<String, dynamic> json) => _$ReportViewFromJson(json);

  Map<String, dynamic> toJson() => _$ReportViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

