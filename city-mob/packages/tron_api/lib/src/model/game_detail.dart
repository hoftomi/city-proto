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
      other.starts == starts &&
      other.backgrounds == backgrounds &&
      other.tinctures == tinctures;

    @override
    int get hashCode =>
        game.hashCode +
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

