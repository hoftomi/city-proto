//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_map.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminMap {
  /// Returns a new [AdminMap] instance.
  AdminMap({

    required  this.id,

    required  this.name,

    required  this.cities,

    required  this.starts,
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


  final int cities;



  @JsonKey(
    
    name: r'starts',
    required: true,
    includeIfNull: false,
  )


  final int starts;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminMap &&
      other.id == id &&
      other.name == name &&
      other.cities == cities &&
      other.starts == starts;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        cities.hashCode +
        starts.hashCode;

  factory AdminMap.fromJson(Map<String, dynamic> json) => _$AdminMapFromJson(json);

  Map<String, dynamic> toJson() => _$AdminMapToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

