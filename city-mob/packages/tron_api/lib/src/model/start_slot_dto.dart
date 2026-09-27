//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/good_option.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'start_slot_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StartSlotDto {
  /// Returns a new [StartSlotDto] instance.
  StartSlotDto({

    required  this.id,

    required  this.name,

    required  this.x,

    required  this.y,

    required  this.neighbors,

    required  this.neighborNames,

    required  this.note,

    required  this.homeCity,

    required  this.homeCityName,

    required  this.homeGoods,
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
    
    name: r'neighbors',
    required: true,
    includeIfNull: false,
  )


  final List<String> neighbors;



  @JsonKey(
    
    name: r'neighborNames',
    required: true,
    includeIfNull: false,
  )


  final List<String> neighborNames;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;



  @JsonKey(
    
    name: r'homeCity',
    required: true,
    includeIfNull: false,
  )


  final String homeCity;



  @JsonKey(
    
    name: r'homeCityName',
    required: true,
    includeIfNull: false,
  )


  final String homeCityName;



  @JsonKey(
    
    name: r'homeGoods',
    required: true,
    includeIfNull: false,
  )


  final List<GoodOption> homeGoods;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StartSlotDto &&
      other.id == id &&
      other.name == name &&
      other.x == x &&
      other.y == y &&
      other.neighbors == neighbors &&
      other.neighborNames == neighborNames &&
      other.note == note &&
      other.homeCity == homeCity &&
      other.homeCityName == homeCityName &&
      other.homeGoods == homeGoods;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        x.hashCode +
        y.hashCode +
        neighbors.hashCode +
        neighborNames.hashCode +
        note.hashCode +
        homeCity.hashCode +
        homeCityName.hashCode +
        homeGoods.hashCode;

  factory StartSlotDto.fromJson(Map<String, dynamic> json) => _$StartSlotDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StartSlotDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

