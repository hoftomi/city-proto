//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/house_ref.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'threat.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Threat {
  /// Returns a new [Threat] instance.
  Threat({

    required  this.lapId,

    required  this.orderId,

    required  this.by,

    required  this.cityId,

    required  this.cityName,

    required  this.goodId,

    required  this.goodName,

    required  this.pts,

    required  this.executeAt,

    required  this.defendCost,

    required  this.defending,
  });

  @JsonKey(
    
    name: r'lapId',
    required: true,
    includeIfNull: false,
  )


  final String lapId;



  @JsonKey(
    
    name: r'orderId',
    required: true,
    includeIfNull: false,
  )


  final String orderId;



  @JsonKey(
    
    name: r'by',
    required: true,
    includeIfNull: false,
  )


  final HouseRef by;



  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: false,
  )


  final String cityId;



  @JsonKey(
    
    name: r'cityName',
    required: true,
    includeIfNull: false,
  )


  final String cityName;



  @JsonKey(
    
    name: r'goodId',
    required: true,
    includeIfNull: false,
  )


  final String goodId;



  @JsonKey(
    
    name: r'goodName',
    required: true,
    includeIfNull: false,
  )


  final String goodName;



  @JsonKey(
    
    name: r'pts',
    required: true,
    includeIfNull: false,
  )


  final int pts;



  @JsonKey(
    
    name: r'executeAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime executeAt;



  @JsonKey(
    
    name: r'defendCost',
    required: true,
    includeIfNull: false,
  )


  final int defendCost;



  @JsonKey(
    
    name: r'defending',
    required: true,
    includeIfNull: false,
  )


  final bool defending;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Threat &&
      other.lapId == lapId &&
      other.orderId == orderId &&
      other.by == by &&
      other.cityId == cityId &&
      other.cityName == cityName &&
      other.goodId == goodId &&
      other.goodName == goodName &&
      other.pts == pts &&
      other.executeAt == executeAt &&
      other.defendCost == defendCost &&
      other.defending == defending;

    @override
    int get hashCode =>
        lapId.hashCode +
        orderId.hashCode +
        by.hashCode +
        cityId.hashCode +
        cityName.hashCode +
        goodId.hashCode +
        goodName.hashCode +
        pts.hashCode +
        executeAt.hashCode +
        defendCost.hashCode +
        defending.hashCode;

  factory Threat.fromJson(Map<String, dynamic> json) => _$ThreatFromJson(json);

  Map<String, dynamic> toJson() => _$ThreatToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

