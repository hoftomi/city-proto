//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/news_view.dart';
import 'package:tron_api/src/model/good_view.dart';
import 'package:tron_api/src/model/house_ref.dart';
import 'package:tron_api/src/model/party_view.dart';
import 'package:tron_api/src/model/pop_row.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CityView {
  /// Returns a new [CityView] instance.
  CityView({

    required  this.id,

    required  this.name,

    required  this.profile,

    required  this.key,

    required  this.coast,

    required  this.reach,

    required  this.distance,

    required  this.myPop,

    required  this.taxRate,

    required  this.lastTaxPool,

    required  this.councilSeats,

    required  this.goods,

    required  this.pop,

    required  this.parties,

    required  this.myProgram,

    required  this.mySpies,

    required  this.myGuards,

    required  this.foreignSpies,

    required  this.present,

    required  this.news,
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
    
    name: r'profile',
    required: true,
    includeIfNull: false,
  )


  final String profile;



  @JsonKey(
    
    name: r'key',
    required: true,
    includeIfNull: false,
  )


  final bool key;



  @JsonKey(
    
    name: r'coast',
    required: true,
    includeIfNull: false,
  )


  final bool coast;



  @JsonKey(
    
    name: r'reach',
    required: true,
    includeIfNull: false,
  )


  final String reach;



  @JsonKey(
    
    name: r'distance',
    required: true,
    includeIfNull: true,
  )


  final int? distance;



  @JsonKey(
    
    name: r'myPop',
    required: true,
    includeIfNull: false,
  )


  final double myPop;



  @JsonKey(
    
    name: r'taxRate',
    required: true,
    includeIfNull: false,
  )


  final double taxRate;



  @JsonKey(
    
    name: r'lastTaxPool',
    required: true,
    includeIfNull: true,
  )


  final double? lastTaxPool;



  @JsonKey(
    
    name: r'councilSeats',
    required: true,
    includeIfNull: false,
  )


  final int councilSeats;



  @JsonKey(
    
    name: r'goods',
    required: true,
    includeIfNull: false,
  )


  final List<GoodView> goods;



  @JsonKey(
    
    name: r'pop',
    required: true,
    includeIfNull: false,
  )


  final List<PopRow> pop;



  @JsonKey(
    
    name: r'parties',
    required: true,
    includeIfNull: false,
  )


  final List<PartyView> parties;



  @JsonKey(
    
    name: r'myProgram',
    required: true,
    includeIfNull: true,
  )


  final String? myProgram;



  @JsonKey(
    
    name: r'mySpies',
    required: true,
    includeIfNull: false,
  )


  final int mySpies;



  @JsonKey(
    
    name: r'myGuards',
    required: true,
    includeIfNull: false,
  )


  final int myGuards;



  @JsonKey(
    
    name: r'foreignSpies',
    required: true,
    includeIfNull: false,
  )


  final List<HouseRef> foreignSpies;



  @JsonKey(
    
    name: r'present',
    required: true,
    includeIfNull: false,
  )


  final List<HouseRef> present;



  @JsonKey(
    
    name: r'news',
    required: true,
    includeIfNull: false,
  )


  final List<NewsView> news;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CityView &&
      other.id == id &&
      other.name == name &&
      other.profile == profile &&
      other.key == key &&
      other.coast == coast &&
      other.reach == reach &&
      other.distance == distance &&
      other.myPop == myPop &&
      other.taxRate == taxRate &&
      other.lastTaxPool == lastTaxPool &&
      other.councilSeats == councilSeats &&
      other.goods == goods &&
      other.pop == pop &&
      other.parties == parties &&
      other.myProgram == myProgram &&
      other.mySpies == mySpies &&
      other.myGuards == myGuards &&
      other.foreignSpies == foreignSpies &&
      other.present == present &&
      other.news == news;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        profile.hashCode +
        key.hashCode +
        coast.hashCode +
        reach.hashCode +
        (distance == null ? 0 : distance.hashCode) +
        myPop.hashCode +
        taxRate.hashCode +
        (lastTaxPool == null ? 0 : lastTaxPool.hashCode) +
        councilSeats.hashCode +
        goods.hashCode +
        pop.hashCode +
        parties.hashCode +
        (myProgram == null ? 0 : myProgram.hashCode) +
        mySpies.hashCode +
        myGuards.hashCode +
        foreignSpies.hashCode +
        present.hashCode +
        news.hashCode;

  factory CityView.fromJson(Map<String, dynamic> json) => _$CityViewFromJson(json);

  Map<String, dynamic> toJson() => _$CityViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

