//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/terrain_def.dart';
import 'package:tron_api/src/model/start_slot.dart';
import 'package:tron_api/src/model/city_def.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'map_def.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MapDef {
  /// Returns a new [MapDef] instance.
  MapDef({

    required  this.id,

    required  this.name,

    required  this.cities,

    required  this.cityEdges,

    required  this.starts,

    required  this.terrain,
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
    
    name: r'cities',
    required: true,
    includeIfNull: false,
  )


  final List<CityDef> cities;



  @JsonKey(
    
    name: r'cityEdges',
    required: true,
    includeIfNull: false,
  )


  final List<List<String>> cityEdges;



  @JsonKey(
    
    name: r'starts',
    required: true,
    includeIfNull: false,
  )


  final List<StartSlot> starts;



  @JsonKey(
    
    name: r'terrain',
    required: true,
    includeIfNull: false,
  )


  final TerrainDef terrain;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MapDef &&
      other.id == id &&
      other.name == name &&
      other.cities == cities &&
      other.cityEdges == cityEdges &&
      other.starts == starts &&
      other.terrain == terrain;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        cities.hashCode +
        cityEdges.hashCode +
        starts.hashCode +
        terrain.hashCode;

  factory MapDef.fromJson(Map<String, dynamic> json) => _$MapDefFromJson(json);

  Map<String, dynamic> toJson() => _$MapDefToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

