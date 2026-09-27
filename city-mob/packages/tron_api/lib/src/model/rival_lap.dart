//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/house_ref.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rival_lap.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RivalLap {
  /// Returns a new [RivalLap] instance.
  RivalLap({

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
    bool operator ==(Object other) => identical(this, other) || other is RivalLap &&
      other.house == house &&
      other.executeAt == executeAt;

    @override
    int get hashCode =>
        house.hashCode +
        executeAt.hashCode;

  factory RivalLap.fromJson(Map<String, dynamic> json) => _$RivalLapFromJson(json);

  Map<String, dynamic> toJson() => _$RivalLapToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

