//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clock_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ClockView {
  /// Returns a new [ClockView] instance.
  ClockView({

    required  this.now,

    required  this.nextSettlementAt,

    required  this.settlements,

    required  this.maxSettlements,

    required  this.nextElectionIn,

    required  this.campaign,

    required  this.maturationMinutes,
  });

  @JsonKey(
    
    name: r'now',
    required: true,
    includeIfNull: false,
  )


  final DateTime now;



  @JsonKey(
    
    name: r'nextSettlementAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime nextSettlementAt;



  @JsonKey(
    
    name: r'settlements',
    required: true,
    includeIfNull: false,
  )


  final int settlements;



  @JsonKey(
    
    name: r'maxSettlements',
    required: true,
    includeIfNull: false,
  )


  final int maxSettlements;



  @JsonKey(
    
    name: r'nextElectionIn',
    required: true,
    includeIfNull: false,
  )


  final int nextElectionIn;



  @JsonKey(
    
    name: r'campaign',
    required: true,
    includeIfNull: false,
  )


  final bool campaign;



  @JsonKey(
    
    name: r'maturationMinutes',
    required: true,
    includeIfNull: false,
  )


  final int maturationMinutes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ClockView &&
      other.now == now &&
      other.nextSettlementAt == nextSettlementAt &&
      other.settlements == settlements &&
      other.maxSettlements == maxSettlements &&
      other.nextElectionIn == nextElectionIn &&
      other.campaign == campaign &&
      other.maturationMinutes == maturationMinutes;

    @override
    int get hashCode =>
        now.hashCode +
        nextSettlementAt.hashCode +
        settlements.hashCode +
        maxSettlements.hashCode +
        nextElectionIn.hashCode +
        campaign.hashCode +
        maturationMinutes.hashCode;

  factory ClockView.fromJson(Map<String, dynamic> json) => _$ClockViewFromJson(json);

  Map<String, dynamic> toJson() => _$ClockViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

