//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/daily_count.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_overview.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminOverview {
  /// Returns a new [AdminOverview] instance.
  AdminOverview({

    required  this.users,

    required  this.admins,

    required  this.newUsers7d,

    required  this.announced,

    required  this.open,

    required  this.running,

    required  this.finished,

    required  this.humanHouses,

    required  this.npcHouses,

    required  this.reports24h,

    required  this.registrations,

    required  this.joins,
  });

  @JsonKey(
    
    name: r'users',
    required: true,
    includeIfNull: false,
  )


  final int users;



  @JsonKey(
    
    name: r'admins',
    required: true,
    includeIfNull: false,
  )


  final int admins;



  @JsonKey(
    
    name: r'newUsers7d',
    required: true,
    includeIfNull: false,
  )


  final int newUsers7d;



  @JsonKey(
    
    name: r'announced',
    required: true,
    includeIfNull: false,
  )


  final int announced;



  @JsonKey(
    
    name: r'open',
    required: true,
    includeIfNull: false,
  )


  final int open;



  @JsonKey(
    
    name: r'running',
    required: true,
    includeIfNull: false,
  )


  final int running;



  @JsonKey(
    
    name: r'finished',
    required: true,
    includeIfNull: false,
  )


  final int finished;



      /// Human houses in live games
  @JsonKey(
    
    name: r'humanHouses',
    required: true,
    includeIfNull: false,
  )


  final int humanHouses;



      /// NPC houses in live games
  @JsonKey(
    
    name: r'npcHouses',
    required: true,
    includeIfNull: false,
  )


  final int npcHouses;



  @JsonKey(
    
    name: r'reports24h',
    required: true,
    includeIfNull: false,
  )


  final int reports24h;



  @JsonKey(
    
    name: r'registrations',
    required: true,
    includeIfNull: false,
  )


  final List<DailyCount> registrations;



  @JsonKey(
    
    name: r'joins',
    required: true,
    includeIfNull: false,
  )


  final List<DailyCount> joins;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminOverview &&
      other.users == users &&
      other.admins == admins &&
      other.newUsers7d == newUsers7d &&
      other.announced == announced &&
      other.open == open &&
      other.running == running &&
      other.finished == finished &&
      other.humanHouses == humanHouses &&
      other.npcHouses == npcHouses &&
      other.reports24h == reports24h &&
      other.registrations == registrations &&
      other.joins == joins;

    @override
    int get hashCode =>
        users.hashCode +
        admins.hashCode +
        newUsers7d.hashCode +
        announced.hashCode +
        open.hashCode +
        running.hashCode +
        finished.hashCode +
        humanHouses.hashCode +
        npcHouses.hashCode +
        reports24h.hashCode +
        registrations.hashCode +
        joins.hashCode;

  factory AdminOverview.fromJson(Map<String, dynamic> json) => _$AdminOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$AdminOverviewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

