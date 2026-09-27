//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OfferRequest {
  /// Returns a new [OfferRequest] instance.
  OfferRequest({

    required  this.buyerId,

     this.price,
  });

  @JsonKey(
    
    name: r'buyerId',
    required: true,
    includeIfNull: false,
  )


  final String buyerId;



  @JsonKey(
    
    name: r'price',
    required: false,
    includeIfNull: false,
  )


  final int? price;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OfferRequest &&
      other.buyerId == buyerId &&
      other.price == price;

    @override
    int get hashCode =>
        buyerId.hashCode +
        (price == null ? 0 : price.hashCode);

  factory OfferRequest.fromJson(Map<String, dynamic> json) => _$OfferRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OfferRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

