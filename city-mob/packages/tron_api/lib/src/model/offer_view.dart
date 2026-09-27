//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/house_ref.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OfferView {
  /// Returns a new [OfferView] instance.
  OfferView({

    required  this.id,

    required  this.seller,

    required  this.of_,

    required  this.price,

    required  this.executeAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'seller',
    required: true,
    includeIfNull: false,
  )


  final HouseRef seller;



  @JsonKey(
    
    name: r'of',
    required: true,
    includeIfNull: false,
  )


  final HouseRef of_;



  @JsonKey(
    
    name: r'price',
    required: true,
    includeIfNull: false,
  )


  final int price;



  @JsonKey(
    
    name: r'executeAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime executeAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OfferView &&
      other.id == id &&
      other.seller == seller &&
      other.of_ == of_ &&
      other.price == price &&
      other.executeAt == executeAt;

    @override
    int get hashCode =>
        id.hashCode +
        seller.hashCode +
        of_.hashCode +
        price.hashCode +
        executeAt.hashCode;

  factory OfferView.fromJson(Map<String, dynamic> json) => _$OfferViewFromJson(json);

  Map<String, dynamic> toJson() => _$OfferViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

