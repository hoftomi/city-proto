//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'good_def.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoodDef {
  /// Returns a new [GoodDef] instance.
  GoodDef({

    required  this.id,

    required  this.name,

    required  this.supply,

    required  this.demand,
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
    
    name: r'supply',
    required: true,
    includeIfNull: false,
  )


  final int supply;



  @JsonKey(
    
    name: r'demand',
    required: true,
    includeIfNull: false,
  )


  final int demand;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoodDef &&
      other.id == id &&
      other.name == name &&
      other.supply == supply &&
      other.demand == demand;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        supply.hashCode +
        demand.hashCode;

  factory GoodDef.fromJson(Map<String, dynamic> json) => _$GoodDefFromJson(json);

  Map<String, dynamic> toJson() => _$GoodDefToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

