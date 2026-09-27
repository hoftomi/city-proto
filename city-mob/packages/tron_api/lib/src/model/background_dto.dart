//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'background_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BackgroundDto {
  /// Returns a new [BackgroundDto] instance.
  BackgroundDto({

    required  this.id,

    required  this.name,

    required  this.icon,

    required  this.perks,
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
    
    name: r'icon',
    required: true,
    includeIfNull: false,
  )


  final String icon;



  @JsonKey(
    
    name: r'perks',
    required: true,
    includeIfNull: false,
  )


  final List<String> perks;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BackgroundDto &&
      other.id == id &&
      other.name == name &&
      other.icon == icon &&
      other.perks == perks;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        icon.hashCode +
        perks.hashCode;

  factory BackgroundDto.fromJson(Map<String, dynamic> json) => _$BackgroundDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BackgroundDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

