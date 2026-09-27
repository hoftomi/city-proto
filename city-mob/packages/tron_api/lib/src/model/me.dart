//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'me.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Me {
  /// Returns a new [Me] instance.
  Me({

    required  this.playerId,

    required  this.houseName,

    required  this.tincture,

    required  this.background,

    required  this.estate,

    required  this.pp,

    required  this.ppMax,

    required  this.gold,

    required  this.legit,
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
    
    name: r'estate',
    required: true,
    includeIfNull: true,
  )


  final String? estate;



  @JsonKey(
    
    name: r'pp',
    required: true,
    includeIfNull: false,
  )


  final int pp;



  @JsonKey(
    
    name: r'ppMax',
    required: true,
    includeIfNull: false,
  )


  final int ppMax;



  @JsonKey(
    
    name: r'gold',
    required: true,
    includeIfNull: false,
  )


  final double gold;



  @JsonKey(
    
    name: r'legit',
    required: true,
    includeIfNull: false,
  )


  final int legit;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Me &&
      other.playerId == playerId &&
      other.houseName == houseName &&
      other.tincture == tincture &&
      other.background == background &&
      other.estate == estate &&
      other.pp == pp &&
      other.ppMax == ppMax &&
      other.gold == gold &&
      other.legit == legit;

    @override
    int get hashCode =>
        playerId.hashCode +
        houseName.hashCode +
        tincture.hashCode +
        (background == null ? 0 : background.hashCode) +
        (estate == null ? 0 : estate.hashCode) +
        pp.hashCode +
        ppMax.hashCode +
        gold.hashCode +
        legit.hashCode;

  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);

  Map<String, dynamic> toJson() => _$MeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

