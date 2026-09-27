//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/offer_view.dart';
import 'package:tron_api/src/model/intel_view.dart';
import 'package:tron_api/src/model/city_view.dart';
import 'package:tron_api/src/model/house_ref.dart';
import 'package:tron_api/src/model/me.dart';
import 'package:tron_api/src/model/buildable.dart';
import 'package:tron_api/src/model/cost.dart';
import 'package:tron_api/src/model/clock_view.dart';
import 'package:tron_api/src/model/order_view.dart';
import 'package:tron_api/src/model/catalog.dart';
import 'package:tron_api/src/model/rival_lap.dart';
import 'package:tron_api/src/model/route_view.dart';
import 'package:tron_api/src/model/lap_view.dart';
import 'package:tron_api/src/model/threat.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_state.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GameState {
  /// Returns a new [GameState] instance.
  GameState({

    required  this.gameId,

    required  this.gameName,

    required  this.mapId,

    required  this.status,

    required  this.clock,

    required  this.me,

    required  this.routes,

    required  this.buildable,

    required  this.cities,

    required  this.draft,

    required  this.draftCost,

    required  this.lap,

    required  this.rivalLaps,

    required  this.threats,

    required  this.intel,

    required  this.offers,

    required  this.houses,

    required  this.catalog,
  });

  @JsonKey(
    
    name: r'gameId',
    required: true,
    includeIfNull: false,
  )


  final String gameId;



  @JsonKey(
    
    name: r'gameName',
    required: true,
    includeIfNull: false,
  )


  final String gameName;



  @JsonKey(
    
    name: r'mapId',
    required: true,
    includeIfNull: false,
  )


  final String mapId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'clock',
    required: true,
    includeIfNull: false,
  )


  final ClockView clock;



  @JsonKey(
    
    name: r'me',
    required: true,
    includeIfNull: false,
  )


  final Me me;



  @JsonKey(
    
    name: r'routes',
    required: true,
    includeIfNull: false,
  )


  final List<RouteView> routes;



  @JsonKey(
    
    name: r'buildable',
    required: true,
    includeIfNull: false,
  )


  final List<Buildable> buildable;



  @JsonKey(
    
    name: r'cities',
    required: true,
    includeIfNull: false,
  )


  final List<CityView> cities;



  @JsonKey(
    
    name: r'draft',
    required: true,
    includeIfNull: false,
  )


  final List<OrderView> draft;



  @JsonKey(
    
    name: r'draftCost',
    required: true,
    includeIfNull: false,
  )


  final Cost draftCost;



  @JsonKey(
    
    name: r'lap',
    required: true,
    includeIfNull: true,
  )


  final LapView? lap;



  @JsonKey(
    
    name: r'rivalLaps',
    required: true,
    includeIfNull: false,
  )


  final List<RivalLap> rivalLaps;



  @JsonKey(
    
    name: r'threats',
    required: true,
    includeIfNull: false,
  )


  final List<Threat> threats;



  @JsonKey(
    
    name: r'intel',
    required: true,
    includeIfNull: false,
  )


  final List<IntelView> intel;



  @JsonKey(
    
    name: r'offers',
    required: true,
    includeIfNull: false,
  )


  final List<OfferView> offers;



  @JsonKey(
    
    name: r'houses',
    required: true,
    includeIfNull: false,
  )


  final List<HouseRef> houses;



  @JsonKey(
    
    name: r'catalog',
    required: true,
    includeIfNull: false,
  )


  final Catalog catalog;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GameState &&
      other.gameId == gameId &&
      other.gameName == gameName &&
      other.mapId == mapId &&
      other.status == status &&
      other.clock == clock &&
      other.me == me &&
      other.routes == routes &&
      other.buildable == buildable &&
      other.cities == cities &&
      other.draft == draft &&
      other.draftCost == draftCost &&
      other.lap == lap &&
      other.rivalLaps == rivalLaps &&
      other.threats == threats &&
      other.intel == intel &&
      other.offers == offers &&
      other.houses == houses &&
      other.catalog == catalog;

    @override
    int get hashCode =>
        gameId.hashCode +
        gameName.hashCode +
        mapId.hashCode +
        status.hashCode +
        clock.hashCode +
        me.hashCode +
        routes.hashCode +
        buildable.hashCode +
        cities.hashCode +
        draft.hashCode +
        draftCost.hashCode +
        (lap == null ? 0 : lap.hashCode) +
        rivalLaps.hashCode +
        threats.hashCode +
        intel.hashCode +
        offers.hashCode +
        houses.hashCode +
        catalog.hashCode;

  factory GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

