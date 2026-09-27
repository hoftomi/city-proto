//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_house.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MyHouse {
  /// Returns a new [MyHouse] instance.
  MyHouse({

    required  this.playerId,

    required  this.houseName,

    required  this.tincture,

    required  this.background,

    required  this.backgroundName,

    required  this.startSlot,
  });

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
    
    name: r'tincture',
    required: true,
    includeIfNull: false,
  )


  final String tincture;



  @JsonKey(
    
    name: r'background',
    required: true,
    includeIfNull: true,
  )


  final String? background;



  @JsonKey(
    
    name: r'backgroundName',
    required: true,
    includeIfNull: true,
  )


  final String? backgroundName;



  @JsonKey(
    
    name: r'startSlot',
    required: true,
    includeIfNull: true,
  )


  final String? startSlot;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MyHouse &&
      other.playerId == playerId &&
      other.houseName == houseName &&
      other.tincture == tincture &&
      other.background == background &&
      other.backgroundName == backgroundName &&
      other.startSlot == startSlot;

    @override
    int get hashCode =>
        playerId.hashCode +
        houseName.hashCode +
        tincture.hashCode +
        (background == null ? 0 : background.hashCode) +
        (backgroundName == null ? 0 : backgroundName.hashCode) +
        (startSlot == null ? 0 : startSlot.hashCode);

  factory MyHouse.fromJson(Map<String, dynamic> json) => _$MyHouseFromJson(json);

  Map<String, dynamic> toJson() => _$MyHouseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

