//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'problem_detail.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProblemDetail {
  /// Returns a new [ProblemDetail] instance.
  ProblemDetail({

     this.type,

     this.title,

     this.status,

     this.detail,

     this.instance,
  });

  @JsonKey(
    
    name: r'type',
    required: false,
    includeIfNull: false,
  )


  final String? type;



  @JsonKey(
    
    name: r'title',
    required: false,
    includeIfNull: false,
  )


  final String? title;



  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final int? status;



  @JsonKey(
    
    name: r'detail',
    required: false,
    includeIfNull: false,
  )


  final String? detail;



  @JsonKey(
    
    name: r'instance',
    required: false,
    includeIfNull: false,
  )


  final String? instance;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProblemDetail &&
      other.type == type &&
      other.title == title &&
      other.status == status &&
      other.detail == detail &&
      other.instance == instance;

    @override
    int get hashCode =>
        type.hashCode +
        title.hashCode +
        status.hashCode +
        detail.hashCode +
        instance.hashCode;

  factory ProblemDetail.fromJson(Map<String, dynamic> json) => _$ProblemDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

