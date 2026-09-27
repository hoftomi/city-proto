//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rules_info.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RulesInfo {
  /// Returns a new [RulesInfo] instance.
  RulesInfo({

    required  this.basePrice,

    required  this.cityShareCost,

    required  this.maxSharesPerOrder,

    required  this.buyoutPremiumPercent,

    required  this.partyCost,

    required  this.festivalGold,

    required  this.festivalPop,

    required  this.newsGold,

    required  this.spyCost,

    required  this.spyUpkeep,

    required  this.spiesPerCity,

    required  this.guardChancePercent,

    required  this.debunkRewardPop,

    required  this.debunkRewardGold,

    required  this.debunkRewardLegit,

    required  this.routeCost,

    required  this.routeUpkeep,

    required  this.councilSeats,

    required  this.infoPrice,

    required  this.lowPopThreshold,
  });

  @JsonKey(
    
    name: r'basePrice',
    required: true,
    includeIfNull: false,
  )


  final int basePrice;



  @JsonKey(
    
    name: r'cityShareCost',
    required: true,
    includeIfNull: false,
  )


  final int cityShareCost;



  @JsonKey(
    
    name: r'maxSharesPerOrder',
    required: true,
    includeIfNull: false,
  )


  final int maxSharesPerOrder;



  @JsonKey(
    
    name: r'buyoutPremiumPercent',
    required: true,
    includeIfNull: false,
  )


  final int buyoutPremiumPercent;



  @JsonKey(
    
    name: r'partyCost',
    required: true,
    includeIfNull: false,
  )


  final int partyCost;



  @JsonKey(
    
    name: r'festivalGold',
    required: true,
    includeIfNull: false,
  )


  final int festivalGold;



  @JsonKey(
    
    name: r'festivalPop',
    required: true,
    includeIfNull: false,
  )


  final int festivalPop;



  @JsonKey(
    
    name: r'newsGold',
    required: true,
    includeIfNull: false,
  )


  final int newsGold;



  @JsonKey(
    
    name: r'spyCost',
    required: true,
    includeIfNull: false,
  )


  final int spyCost;



  @JsonKey(
    
    name: r'spyUpkeep',
    required: true,
    includeIfNull: false,
  )


  final int spyUpkeep;



  @JsonKey(
    
    name: r'spiesPerCity',
    required: true,
    includeIfNull: false,
  )


  final int spiesPerCity;



  @JsonKey(
    
    name: r'guardChancePercent',
    required: true,
    includeIfNull: false,
  )


  final int guardChancePercent;



  @JsonKey(
    
    name: r'debunkRewardPop',
    required: true,
    includeIfNull: false,
  )


  final int debunkRewardPop;



  @JsonKey(
    
    name: r'debunkRewardGold',
    required: true,
    includeIfNull: false,
  )


  final int debunkRewardGold;



  @JsonKey(
    
    name: r'debunkRewardLegit',
    required: true,
    includeIfNull: false,
  )


  final int debunkRewardLegit;



  @JsonKey(
    
    name: r'routeCost',
    required: true,
    includeIfNull: false,
  )


  final int routeCost;



  @JsonKey(
    
    name: r'routeUpkeep',
    required: true,
    includeIfNull: false,
  )


  final int routeUpkeep;



  @JsonKey(
    
    name: r'councilSeats',
    required: true,
    includeIfNull: false,
  )


  final int councilSeats;



  @JsonKey(
    
    name: r'infoPrice',
    required: true,
    includeIfNull: false,
  )


  final int infoPrice;



  @JsonKey(
    
    name: r'lowPopThreshold',
    required: true,
    includeIfNull: false,
  )


  final int lowPopThreshold;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RulesInfo &&
      other.basePrice == basePrice &&
      other.cityShareCost == cityShareCost &&
      other.maxSharesPerOrder == maxSharesPerOrder &&
      other.buyoutPremiumPercent == buyoutPremiumPercent &&
      other.partyCost == partyCost &&
      other.festivalGold == festivalGold &&
      other.festivalPop == festivalPop &&
      other.newsGold == newsGold &&
      other.spyCost == spyCost &&
      other.spyUpkeep == spyUpkeep &&
      other.spiesPerCity == spiesPerCity &&
      other.guardChancePercent == guardChancePercent &&
      other.debunkRewardPop == debunkRewardPop &&
      other.debunkRewardGold == debunkRewardGold &&
      other.debunkRewardLegit == debunkRewardLegit &&
      other.routeCost == routeCost &&
      other.routeUpkeep == routeUpkeep &&
      other.councilSeats == councilSeats &&
      other.infoPrice == infoPrice &&
      other.lowPopThreshold == lowPopThreshold;

    @override
    int get hashCode =>
        basePrice.hashCode +
        cityShareCost.hashCode +
        maxSharesPerOrder.hashCode +
        buyoutPremiumPercent.hashCode +
        partyCost.hashCode +
        festivalGold.hashCode +
        festivalPop.hashCode +
        newsGold.hashCode +
        spyCost.hashCode +
        spyUpkeep.hashCode +
        spiesPerCity.hashCode +
        guardChancePercent.hashCode +
        debunkRewardPop.hashCode +
        debunkRewardGold.hashCode +
        debunkRewardLegit.hashCode +
        routeCost.hashCode +
        routeUpkeep.hashCode +
        councilSeats.hashCode +
        infoPrice.hashCode +
        lowPopThreshold.hashCode;

  factory RulesInfo.fromJson(Map<String, dynamic> json) => _$RulesInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RulesInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

