//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/background.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_house.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminHouse {
  /// Returns a new [AdminHouse] instance.
  AdminHouse({

    required  this.playerId,

    required  this.userId,

    required  this.userName,

    required  this.houseName,

    required  this.background,

    required  this.npc,

    required  this.persona,

    required  this.legit,

    required  this.gold,

    required  this.pp,

    required  this.place,

    required  this.joinedAt,
  });

  @JsonKey(
    
    name: r'playerId',
    required: true,
    includeIfNull: false,
  )


  final String playerId;



  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: true,
  )


  final String? userId;



  @JsonKey(
    
    name: r'userName',
    required: true,
    includeIfNull: true,
  )


  final String? userName;



  @JsonKey(
    
    name: r'houseName',
    required: true,
    includeIfNull: false,
  )


  final String houseName;



  @JsonKey(
    
    name: r'background',
    required: true,
    includeIfNull: true,
  )


  final Background? background;



  @JsonKey(
    
    name: r'npc',
    required: true,
    includeIfNull: false,
  )


  final bool npc;



  @JsonKey(
    
    name: r'persona',
    required: true,
    includeIfNull: true,
  )


  final String? persona;



  @JsonKey(
    
    name: r'legit',
    required: true,
    includeIfNull: false,
  )


  final int legit;



      /// Money in bronze (1 gold = 100 bronze).
  @JsonKey(
    
    name: r'gold',
    required: true,
    includeIfNull: true,
  )


  final int? gold;



  @JsonKey(
    
    name: r'pp',
    required: true,
    includeIfNull: true,
  )


  final int? pp;



  @JsonKey(
    
    name: r'place',
    required: true,
    includeIfNull: true,
  )


  final int? place;



  @JsonKey(
    
    name: r'joinedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime joinedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminHouse &&
      other.playerId == playerId &&
      other.userId == userId &&
      other.userName == userName &&
      other.houseName == houseName &&
      other.background == background &&
      other.npc == npc &&
      other.persona == persona &&
      other.legit == legit &&
      other.gold == gold &&
      other.pp == pp &&
      other.place == place &&
      other.joinedAt == joinedAt;

    @override
    int get hashCode =>
        playerId.hashCode +
        (userId == null ? 0 : userId.hashCode) +
        (userName == null ? 0 : userName.hashCode) +
        houseName.hashCode +
        (background == null ? 0 : background.hashCode) +
        npc.hashCode +
        (persona == null ? 0 : persona.hashCode) +
        legit.hashCode +
        (gold == null ? 0 : gold.hashCode) +
        (pp == null ? 0 : pp.hashCode) +
        (place == null ? 0 : place.hashCode) +
        joinedAt.hashCode;

  factory AdminHouse.fromJson(Map<String, dynamic> json) => _$AdminHouseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminHouseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

