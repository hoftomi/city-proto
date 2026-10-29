//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/start_slot_dto.dart';
import 'package:tron_api/src/model/background_dto.dart';
import 'package:tron_api/src/model/game_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_detail.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GameDetail {
  /// Returns a new [GameDetail] instance.
  GameDetail({

    required  this.game,

    required  this.mapId,

    required  this.round,

    required  this.maxRounds,

    required  this.players,

    required  this.maxPlayers,

    required  this.cities,

    required  this.npcCount,

    required  this.starts,

    required  this.backgrounds,

    required  this.tinctures,
  });

  @JsonKey(
    
    name: r'game',
    required: true,
    includeIfNull: false,
  )


  final GameSummary game;



  @JsonKey(
    
    name: r'mapId',
    required: true,
    includeIfNull: false,
  )


  final String mapId;



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
    
    name: r'starts',
    required: true,
    includeIfNull: false,
  )


  final List<StartSlotDto> starts;



  @JsonKey(
    
    name: r'backgrounds',
    required: true,
    includeIfNull: false,
  )


  final List<BackgroundDto> backgrounds;



  @JsonKey(
    
    name: r'tinctures',
    required: true,
    includeIfNull: false,
  )


  final List<String> tinctures;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GameDetail &&
      other.game == game &&
      other.mapId == mapId &&
      other.round == round &&
      other.maxRounds == maxRounds &&
      other.players == players &&
      other.maxPlayers == maxPlayers &&
      other.cities == cities &&
      other.npcCount == npcCount &&
      other.starts == starts &&
      other.backgrounds == backgrounds &&
      other.tinctures == tinctures;

    @override
    int get hashCode =>
        game.hashCode +
        mapId.hashCode +
        round.hashCode +
        maxRounds.hashCode +
        players.hashCode +
        maxPlayers.hashCode +
        cities.hashCode +
        npcCount.hashCode +
        starts.hashCode +
        backgrounds.hashCode +
        tinctures.hashCode;

  factory GameDetail.fromJson(Map<String, dynamic> json) => _$GameDetailFromJson(json);

  Map<String, dynamic> toJson() => _$GameDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

