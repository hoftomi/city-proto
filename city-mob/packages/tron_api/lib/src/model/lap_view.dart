//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/order_view.dart';
import 'package:tron_api/src/model/cost.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lap_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LapView {
  /// Returns a new [LapView] instance.
  LapView({

    required  this.id,

    required  this.sealedAt,

    required  this.executeAt,

    required  this.orders,

    required  this.cost,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'sealedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime sealedAt;



  @JsonKey(
    
    name: r'executeAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime executeAt;



  @JsonKey(
    
    name: r'orders',
    required: true,
    includeIfNull: false,
  )


  final List<OrderView> orders;



  @JsonKey(
    
    name: r'cost',
    required: true,
    includeIfNull: false,
  )


  final Cost cost;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LapView &&
      other.id == id &&
      other.sealedAt == sealedAt &&
      other.executeAt == executeAt &&
      other.orders == orders &&
      other.cost == cost;

    @override
    int get hashCode =>
        id.hashCode +
        sealedAt.hashCode +
        executeAt.hashCode +
        orders.hashCode +
        cost.hashCode;

  factory LapView.fromJson(Map<String, dynamic> json) => _$LapViewFromJson(json);

  Map<String, dynamic> toJson() => _$LapViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

