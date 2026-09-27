//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rank_row.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RankRow {
  /// Returns a new [RankRow] instance.
  RankRow({

    required  this.rank,

    required  this.playerId,

    required  this.name,

    required  this.tincture,

    required  this.npc,

    required  this.legit,

    required  this.shares,

    required  this.seats,

    required  this.self,
  });

  @JsonKey(
    
    name: r'rank',
    required: true,
    includeIfNull: false,
  )


  final int rank;



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
    
    name: r'legit',
    required: true,
    includeIfNull: false,
  )


  final int legit;



  @JsonKey(
    
    name: r'shares',
    required: true,
    includeIfNull: false,
  )


  final int shares;



  @JsonKey(
    
    name: r'seats',
    required: true,
    includeIfNull: false,
  )


  final int seats;



  @JsonKey(
    
    name: r'self',
    required: true,
    includeIfNull: false,
  )


  final bool self;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RankRow &&
      other.rank == rank &&
      other.playerId == playerId &&
      other.name == name &&
      other.tincture == tincture &&
      other.npc == npc &&
      other.legit == legit &&
      other.shares == shares &&
      other.seats == seats &&
      other.self == self;

    @override
    int get hashCode =>
        rank.hashCode +
        playerId.hashCode +
        name.hashCode +
        tincture.hashCode +
        npc.hashCode +
        legit.hashCode +
        shares.hashCode +
        seats.hashCode +
        self.hashCode;

  factory RankRow.fromJson(Map<String, dynamic> json) => _$RankRowFromJson(json);

  Map<String, dynamic> toJson() => _$RankRowToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

