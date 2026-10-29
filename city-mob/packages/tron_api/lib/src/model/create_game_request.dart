//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_game_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateGameRequest {
  /// Returns a new [CreateGameRequest] instance.
  CreateGameRequest({

    required  this.id,

    required  this.name,

    required  this.mapId,

    required  this.opensAt,

    required  this.closesAt,

    required  this.maxPlayers,

    required  this.npcCount,

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
    
    name: r'mapId',
    required: true,
    includeIfNull: false,
  )


  final String mapId;



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
    
    name: r'tags',
    required: true,
    includeIfNull: false,
  )


  final List<String> tags;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateGameRequest &&
      other.id == id &&
      other.name == name &&
      other.mapId == mapId &&
      other.opensAt == opensAt &&
      other.closesAt == closesAt &&
      other.maxPlayers == maxPlayers &&
      other.npcCount == npcCount &&
      other.tags == tags;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        mapId.hashCode +
        (opensAt == null ? 0 : opensAt.hashCode) +
        (closesAt == null ? 0 : closesAt.hashCode) +
        maxPlayers.hashCode +
        npcCount.hashCode +
        tags.hashCode;

  factory CreateGameRequest.fromJson(Map<String, dynamic> json) => _$CreateGameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGameRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

