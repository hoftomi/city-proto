//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/house_ref.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seller.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Seller {
  /// Returns a new [Seller] instance.
  Seller({

    required  this.house,

    required  this.city,

    required  this.shares,

    required  this.margin,

    required  this.sold,

    required  this.cheapest,

    required  this.protectedNow,
  });

  @JsonKey(
    
    name: r'house',
    required: true,
    includeIfNull: true,
  )


  final HouseRef? house;



  @JsonKey(
    
    name: r'city',
    required: true,
    includeIfNull: false,
  )


  final bool city;



  @JsonKey(
    
    name: r'shares',
    required: true,
    includeIfNull: false,
  )


  final int shares;



  @JsonKey(
    
    name: r'margin',
    required: true,
    includeIfNull: false,
  )


  final String margin;



  @JsonKey(
    
    name: r'sold',
    required: true,
    includeIfNull: true,
  )


  final double? sold;



  @JsonKey(
    
    name: r'cheapest',
    required: true,
    includeIfNull: false,
  )


  final bool cheapest;



  @JsonKey(
    
    name: r'protectedNow',
    required: true,
    includeIfNull: false,
  )


  final bool protectedNow;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Seller &&
      other.house == house &&
      other.city == city &&
      other.shares == shares &&
      other.margin == margin &&
      other.sold == sold &&
      other.cheapest == cheapest &&
      other.protectedNow == protectedNow;

    @override
    int get hashCode =>
        (house == null ? 0 : house.hashCode) +
        city.hashCode +
        shares.hashCode +
        margin.hashCode +
        (sold == null ? 0 : sold.hashCode) +
        cheapest.hashCode +
        protectedNow.hashCode;

  factory Seller.fromJson(Map<String, dynamic> json) => _$SellerFromJson(json);

  Map<String, dynamic> toJson() => _$SellerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

