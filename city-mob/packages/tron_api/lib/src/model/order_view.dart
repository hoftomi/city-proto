//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/cost.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OrderView {
  /// Returns a new [OrderView] instance.
  OrderView({

    required  this.id,

    required  this.type,

    required  this.branch,

    required  this.label,

    required  this.cityId,

    required  this.cityName,

    required  this.cost,

    required  this.warning,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'branch',
    required: true,
    includeIfNull: false,
  )


  final String branch;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: true,
  )


  final String? cityId;



  @JsonKey(
    
    name: r'cityName',
    required: true,
    includeIfNull: true,
  )


  final String? cityName;



  @JsonKey(
    
    name: r'cost',
    required: true,
    includeIfNull: false,
  )


  final Cost cost;



  @JsonKey(
    
    name: r'warning',
    required: true,
    includeIfNull: true,
  )


  final String? warning;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OrderView &&
      other.id == id &&
      other.type == type &&
      other.branch == branch &&
      other.label == label &&
      other.cityId == cityId &&
      other.cityName == cityName &&
      other.cost == cost &&
      other.warning == warning;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        branch.hashCode +
        label.hashCode +
        (cityId == null ? 0 : cityId.hashCode) +
        (cityName == null ? 0 : cityName.hashCode) +
        cost.hashCode +
        (warning == null ? 0 : warning.hashCode);

  factory OrderView.fromJson(Map<String, dynamic> json) => _$OrderViewFromJson(json);

  Map<String, dynamic> toJson() => _$OrderViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

