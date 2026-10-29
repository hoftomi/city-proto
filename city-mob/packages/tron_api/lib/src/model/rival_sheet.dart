//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/house_ref.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rival_sheet.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RivalSheet {
  /// Returns a new [RivalSheet] instance.
  RivalSheet({

    required  this.house,

    required  this.executeAt,
  });

  @JsonKey(
    
    name: r'house',
    required: true,
    includeIfNull: false,
  )


  final HouseRef house;



  @JsonKey(
    
    name: r'executeAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime executeAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RivalSheet &&
      other.house == house &&
      other.executeAt == executeAt;

    @override
    int get hashCode =>
        house.hashCode +
        executeAt.hashCode;

  factory RivalSheet.fromJson(Map<String, dynamic> json) => _$RivalSheetFromJson(json);

  Map<String, dynamic> toJson() => _$RivalSheetToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

