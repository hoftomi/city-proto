//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_template_info.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class NewsTemplateInfo {
  /// Returns a new [NewsTemplateInfo] instance.
  NewsTemplateInfo({

    required  this.id,

    required  this.label,

    required  this.effect,

    required  this.needsGood,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



  @JsonKey(
    
    name: r'effect',
    required: true,
    includeIfNull: false,
  )


  final int effect;



  @JsonKey(
    
    name: r'needsGood',
    required: true,
    includeIfNull: false,
  )


  final bool needsGood;





    @override
    bool operator ==(Object other) => identical(this, other) || other is NewsTemplateInfo &&
      other.id == id &&
      other.label == label &&
      other.effect == effect &&
      other.needsGood == needsGood;

    @override
    int get hashCode =>
        id.hashCode +
        label.hashCode +
        effect.hashCode +
        needsGood.hashCode;

  factory NewsTemplateInfo.fromJson(Map<String, dynamic> json) => _$NewsTemplateInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NewsTemplateInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

