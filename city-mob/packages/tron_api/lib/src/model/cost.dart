//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cost.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Cost {
  /// Returns a new [Cost] instance.
  Cost({

    required  this.pp,

    required  this.gold,
  });

  @JsonKey(
    
    name: r'pp',
    required: true,
    includeIfNull: false,
  )


  final int pp;



  @JsonKey(
    
    name: r'gold',
    required: true,
    includeIfNull: false,
  )


  final int gold;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Cost &&
      other.pp == pp &&
      other.gold == gold;

    @override
    int get hashCode =>
        pp.hashCode +
        gold.hashCode;

  factory Cost.fromJson(Map<String, dynamic> json) => _$CostFromJson(json);

  Map<String, dynamic> toJson() => _$CostToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

