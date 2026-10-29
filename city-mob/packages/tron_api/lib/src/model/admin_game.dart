//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_game.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminGame {
  /// Returns a new [AdminGame] instance.
  AdminGame({

    required  this.id,

    required  this.name,

    required  this.status,

    required  this.mapId,

    required  this.mapName,

    required  this.mode,

    required  this.opensAt,

    required  this.closesAt,

    required  this.createdAt,

    required  this.maxPlayers,

    required  this.npcCount,

    required  this.humans,

    required  this.settlements,

    required  this.maxSettlements,

    required  this.clock,

    required  this.timeOffsetMinutes,

    required  this.winner,

    required  this.tags,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'mapId',
    required: true,
    includeIfNull: false,
  )


  final String mapId;



  @JsonKey(
    
    name: r'mapName',
    required: true,
    includeIfNull: false,
  )


  final String mapName;



  @JsonKey(
    
    name: r'mode',
    required: true,
    includeIfNull: false,
  )


  final String mode;



  @JsonKey(
    
    name: r'opensAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? opensAt;



  @JsonKey(
    
    name: r'closesAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? closesAt;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'maxPlayers',
    required: true,
    includeIfNull: false,
  )


  final int maxPlayers;



  @JsonKey(
    
    name: r'npcCount',
    required: true,
    includeIfNull: false,
  )


  final int npcCount;



  @JsonKey(
    
    name: r'humans',
    required: true,
    includeIfNull: false,
  )


  final int humans;



  @JsonKey(
    
    name: r'settlements',
    required: true,
    includeIfNull: true,
  )


  final int? settlements;



  @JsonKey(
    
    name: r'maxSettlements',
    required: true,
    includeIfNull: false,
  )


  final int maxSettlements;



  @JsonKey(
    
    name: r'clock',
    required: true,
    includeIfNull: true,
  )


  final DateTime? clock;



  @JsonKey(
    
    name: r'timeOffsetMinutes',
    required: true,
    includeIfNull: false,
  )


  final int timeOffsetMinutes;



  @JsonKey(
    
    name: r'winner',
    required: true,
    includeIfNull: true,
  )


  final String? winner;



  @JsonKey(
    
    name: r'tags',
    required: true,
    includeIfNull: false,
  )


  final List<String> tags;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminGame &&
      other.id == id &&
      other.name == name &&
      other.status == status &&
      other.mapId == mapId &&
      other.mapName == mapName &&
      other.mode == mode &&
      other.opensAt == opensAt &&
      other.closesAt == closesAt &&
      other.createdAt == createdAt &&
      other.maxPlayers == maxPlayers &&
      other.npcCount == npcCount &&
      other.humans == humans &&
      other.settlements == settlements &&
      other.maxSettlements == maxSettlements &&
      other.clock == clock &&
      other.timeOffsetMinutes == timeOffsetMinutes &&
      other.winner == winner &&
      other.tags == tags;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        status.hashCode +
        mapId.hashCode +
        mapName.hashCode +
        mode.hashCode +
        (opensAt == null ? 0 : opensAt.hashCode) +
        (closesAt == null ? 0 : closesAt.hashCode) +
        createdAt.hashCode +
        maxPlayers.hashCode +
        npcCount.hashCode +
        humans.hashCode +
        (settlements == null ? 0 : settlements.hashCode) +
        maxSettlements.hashCode +
        (clock == null ? 0 : clock.hashCode) +
        timeOffsetMinutes.hashCode +
        (winner == null ? 0 : winner.hashCode) +
        tags.hashCode;

  factory AdminGame.fromJson(Map<String, dynamic> json) => _$AdminGameFromJson(json);

  Map<String, dynamic> toJson() => _$AdminGameToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

