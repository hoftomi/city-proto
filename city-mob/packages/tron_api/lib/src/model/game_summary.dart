//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/my_house.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_summary.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GameSummary {
  /// Returns a new [GameSummary] instance.
  GameSummary({

    required  this.id,

    required  this.name,

    required  this.season,

    required  this.status,

    required  this.mapId,

    required  this.startsAt,

    required  this.opensAt,

    required  this.days,

    required  this.roundsPerDay,

    required  this.round,

    required  this.maxRounds,

    required  this.players,

    required  this.maxPlayers,

    required  this.cities,

    required  this.npcCount,

    required  this.tags,

    required  this.winner,

    required  this.myPlace,

    required  this.myHouse,
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
    
    name: r'season',
    required: true,
    includeIfNull: false,
  )


  final String season;



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
    
    name: r'startsAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? startsAt;



  @JsonKey(
    
    name: r'opensAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? opensAt;



  @JsonKey(
    
    name: r'days',
    required: true,
    includeIfNull: false,
  )


  final int days;



  @JsonKey(
    
    name: r'roundsPerDay',
    required: true,
    includeIfNull: false,
  )


  final int roundsPerDay;



  @JsonKey(
    
    name: r'round',
    required: true,
    includeIfNull: false,
  )


  final int round;



  @JsonKey(
    
    name: r'maxRounds',
    required: true,
    includeIfNull: false,
  )


  final int maxRounds;



  @JsonKey(
    
    name: r'players',
    required: true,
    includeIfNull: false,
  )


  final int players;



  @JsonKey(
    
    name: r'maxPlayers',
    required: true,
    includeIfNull: false,
  )


  final int maxPlayers;



  @JsonKey(
    
    name: r'cities',
    required: true,
    includeIfNull: false,
  )


  final int cities;



  @JsonKey(
    
    name: r'npcCount',
    required: true,
    includeIfNull: false,
  )


  final int npcCount;



  @JsonKey(
    
    name: r'tags',
    required: true,
    includeIfNull: false,
  )


  final List<String> tags;



  @JsonKey(
    
    name: r'winner',
    required: true,
    includeIfNull: true,
  )


  final String? winner;



  @JsonKey(
    
    name: r'myPlace',
    required: true,
    includeIfNull: true,
  )


  final int? myPlace;



  @JsonKey(
    
    name: r'myHouse',
    required: true,
    includeIfNull: true,
  )


  final MyHouse? myHouse;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GameSummary &&
      other.id == id &&
      other.name == name &&
      other.season == season &&
      other.status == status &&
      other.mapId == mapId &&
      other.startsAt == startsAt &&
      other.opensAt == opensAt &&
      other.days == days &&
      other.roundsPerDay == roundsPerDay &&
      other.round == round &&
      other.maxRounds == maxRounds &&
      other.players == players &&
      other.maxPlayers == maxPlayers &&
      other.cities == cities &&
      other.npcCount == npcCount &&
      other.tags == tags &&
      other.winner == winner &&
      other.myPlace == myPlace &&
      other.myHouse == myHouse;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        season.hashCode +
        status.hashCode +
        mapId.hashCode +
        (startsAt == null ? 0 : startsAt.hashCode) +
        (opensAt == null ? 0 : opensAt.hashCode) +
        days.hashCode +
        roundsPerDay.hashCode +
        round.hashCode +
        maxRounds.hashCode +
        players.hashCode +
        maxPlayers.hashCode +
        cities.hashCode +
        npcCount.hashCode +
        tags.hashCode +
        (winner == null ? 0 : winner.hashCode) +
        (myPlace == null ? 0 : myPlace.hashCode) +
        (myHouse == null ? 0 : myHouse.hashCode);

  factory GameSummary.fromJson(Map<String, dynamic> json) => _$GameSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$GameSummaryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

