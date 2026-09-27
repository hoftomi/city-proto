//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'house_ref.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HouseRef {
  /// Returns a new [HouseRef] instance.
  HouseRef({

    required  this.playerId,

    required  this.name,

    required  this.tincture,

    required  this.npc,

    required  this.self,
  });

  @JsonKey(
    
    name: r'playerId',
    required: true,
    includeIfNull: false,
  )


  final String playerId;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'tincture',
    required: true,
    includeIfNull: false,
  )


  final String tincture;



  @JsonKey(
    
    name: r'npc',
    required: true,
    includeIfNull: false,
  )


  final bool npc;



  @JsonKey(
    
    name: r'self',
    required: true,
    includeIfNull: false,
  )


  final bool self;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HouseRef &&
      other.playerId == playerId &&
      other.name == name &&
      other.tincture == tincture &&
      other.npc == npc &&
      other.self == self;

    @override
    int get hashCode =>
        playerId.hashCode +
        name.hashCode +
        tincture.hashCode +
        npc.hashCode +
        self.hashCode;

  factory HouseRef.fromJson(Map<String, dynamic> json) => _$HouseRefFromJson(json);

  Map<String, dynamic> toJson() => _$HouseRefToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

