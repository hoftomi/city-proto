//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_house.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MyHouse {
  /// Returns a new [MyHouse] instance.
  MyHouse({

    required  this.houseName,

    required  this.tincture,

    required  this.backgroundName,
  });

  @JsonKey(
    
    name: r'houseName',
    required: true,
    includeIfNull: false,
  )


  final String houseName;



  @JsonKey(
    
    name: r'tincture',
    required: true,
    includeIfNull: false,
  )


  final String tincture;



  @JsonKey(
    
    name: r'backgroundName',
    required: true,
    includeIfNull: true,
  )


  final String? backgroundName;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MyHouse &&
      other.houseName == houseName &&
      other.tincture == tincture &&
      other.backgroundName == backgroundName;

    @override
    int get hashCode =>
        houseName.hashCode +
        tincture.hashCode +
        (backgroundName == null ? 0 : backgroundName.hashCode);

  factory MyHouse.fromJson(Map<String, dynamic> json) => _$MyHouseFromJson(json);

  Map<String, dynamic> toJson() => _$MyHouseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

