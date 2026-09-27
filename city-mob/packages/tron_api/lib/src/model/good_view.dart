//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/seller.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'good_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoodView {
  /// Returns a new [GoodView] instance.
  GoodView({

    required  this.id,

    required  this.name,

    required  this.supply,

    required  this.demand,

    required  this.cityShares,

    required  this.marketValue,

    required  this.myShares,

    required  this.myMargin,

    required  this.sellers,
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



  @JsonKey(
    
    name: r'cityShares',
    required: true,
    includeIfNull: false,
  )


  final int cityShares;



  @JsonKey(
    
    name: r'marketValue',
    required: true,
    includeIfNull: false,
  )


  final double marketValue;



  @JsonKey(
    
    name: r'myShares',
    required: true,
    includeIfNull: false,
  )


  final int myShares;



  @JsonKey(
    
    name: r'myMargin',
    required: true,
    includeIfNull: true,
  )


  final String? myMargin;



  @JsonKey(
    
    name: r'sellers',
    required: true,
    includeIfNull: false,
  )


  final List<Seller> sellers;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoodView &&
      other.id == id &&
      other.name == name &&
      other.supply == supply &&
      other.demand == demand &&
      other.cityShares == cityShares &&
      other.marketValue == marketValue &&
      other.myShares == myShares &&
      other.myMargin == myMargin &&
      other.sellers == sellers;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        supply.hashCode +
        demand.hashCode +
        cityShares.hashCode +
        marketValue.hashCode +
        myShares.hashCode +
        (myMargin == null ? 0 : myMargin.hashCode) +
        sellers.hashCode;

  factory GoodView.fromJson(Map<String, dynamic> json) => _$GoodViewFromJson(json);

  Map<String, dynamic> toJson() => _$GoodViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

