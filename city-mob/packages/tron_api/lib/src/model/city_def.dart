//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/good_def.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_def.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CityDef {
  /// Returns a new [CityDef] instance.
  CityDef({

    required  this.id,

    required  this.name,

    required  this.x,

    required  this.y,

    required  this.key,

    required  this.coast,

    required  this.profile,

    required  this.goods,
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
    
    name: r'x',
    required: true,
    includeIfNull: false,
  )


  final int x;



  @JsonKey(
    
    name: r'y',
    required: true,
    includeIfNull: false,
  )


  final int y;



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
    
    name: r'profile',
    required: true,
    includeIfNull: false,
  )


  final String profile;



  @JsonKey(
    
    name: r'goods',
    required: true,
    includeIfNull: false,
  )


  final List<GoodDef> goods;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CityDef &&
      other.id == id &&
      other.name == name &&
      other.x == x &&
      other.y == y &&
      other.key == key &&
      other.coast == coast &&
      other.profile == profile &&
      other.goods == goods;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        x.hashCode +
        y.hashCode +
        key.hashCode +
        coast.hashCode +
        profile.hashCode +
        goods.hashCode;

  factory CityDef.fromJson(Map<String, dynamic> json) => _$CityDefFromJson(json);

  Map<String, dynamic> toJson() => _$CityDefToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

