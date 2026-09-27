//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'action_info.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ActionInfo {
  /// Returns a new [ActionInfo] instance.
  ActionInfo({

    required  this.id,

    required  this.label,

    required  this.branch,

    required  this.pp,

    required  this.gold,
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
    
    name: r'branch',
    required: true,
    includeIfNull: false,
  )


  final String branch;



  @JsonKey(
    
    name: r'pp',
    required: true,
    includeIfNull: false,
  )


  final int pp;



  @JsonKey(
    
    name: r'gold',
    required: true,
    includeIfNull: true,
  )


  final int? gold;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ActionInfo &&
      other.id == id &&
      other.label == label &&
      other.branch == branch &&
      other.pp == pp &&
      other.gold == gold;

    @override
    int get hashCode =>
        id.hashCode +
        label.hashCode +
        branch.hashCode +
        pp.hashCode +
        (gold == null ? 0 : gold.hashCode);

  factory ActionInfo.fromJson(Map<String, dynamic> json) => _$ActionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ActionInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

