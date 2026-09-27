//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'terrain_def.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TerrainDef {
  /// Returns a new [TerrainDef] instance.
  TerrainDef({

    required  this.sea,

    required  this.rivers,

    required  this.mountains,

    required  this.forests,

    required  this.fields,

    required  this.marsh,
  });

  @JsonKey(
    
    name: r'sea',
    required: true,
    includeIfNull: true,
  )


  final String? sea;



  @JsonKey(
    
    name: r'rivers',
    required: true,
    includeIfNull: false,
  )


  final List<String> rivers;



  @JsonKey(
    
    name: r'mountains',
    required: true,
    includeIfNull: false,
  )


  final List<List<double>> mountains;



  @JsonKey(
    
    name: r'forests',
    required: true,
    includeIfNull: false,
  )


  final List<List<double>> forests;



  @JsonKey(
    
    name: r'fields',
    required: true,
    includeIfNull: false,
  )


  final List<List<double>> fields;



  @JsonKey(
    
    name: r'marsh',
    required: true,
    includeIfNull: false,
  )


  final List<List<double>> marsh;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TerrainDef &&
      other.sea == sea &&
      other.rivers == rivers &&
      other.mountains == mountains &&
      other.forests == forests &&
      other.fields == fields &&
      other.marsh == marsh;

    @override
    int get hashCode =>
        (sea == null ? 0 : sea.hashCode) +
        rivers.hashCode +
        mountains.hashCode +
        forests.hashCode +
        fields.hashCode +
        marsh.hashCode;

  factory TerrainDef.fromJson(Map<String, dynamic> json) => _$TerrainDefFromJson(json);

  Map<String, dynamic> toJson() => _$TerrainDefToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

