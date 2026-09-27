//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'level_info.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LevelInfo {
  /// Returns a new [LevelInfo] instance.
  LevelInfo({

    required  this.id,

    required  this.label,

    required  this.percent,

    required  this.pop,
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
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;



  @JsonKey(
    
    name: r'pop',
    required: true,
    includeIfNull: false,
  )


  final int pop;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LevelInfo &&
      other.id == id &&
      other.label == label &&
      other.percent == percent &&
      other.pop == pop;

    @override
    int get hashCode =>
        id.hashCode +
        label.hashCode +
        percent.hashCode +
        pop.hashCode;

  factory LevelInfo.fromJson(Map<String, dynamic> json) => _$LevelInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LevelInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

