//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/house_ref.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'party_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartyView {
  /// Returns a new [PartyView] instance.
  PartyView({

    required  this.house,

    required  this.program,

    required  this.votes,

    required  this.seats,
  });

  @JsonKey(
    
    name: r'house',
    required: true,
    includeIfNull: false,
  )


  final HouseRef house;



  @JsonKey(
    
    name: r'program',
    required: true,
    includeIfNull: false,
  )


  final String program;



  @JsonKey(
    
    name: r'votes',
    required: true,
    includeIfNull: false,
  )


  final int votes;



  @JsonKey(
    
    name: r'seats',
    required: true,
    includeIfNull: false,
  )


  final int seats;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartyView &&
      other.house == house &&
      other.program == program &&
      other.votes == votes &&
      other.seats == seats;

    @override
    int get hashCode =>
        house.hashCode +
        program.hashCode +
        votes.hashCode +
        seats.hashCode;

  factory PartyView.fromJson(Map<String, dynamic> json) => _$PartyViewFromJson(json);

  Map<String, dynamic> toJson() => _$PartyViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

