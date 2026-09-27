//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OrderRequest {
  /// Returns a new [OrderRequest] instance.
  OrderRequest({

    required  this.type,

     this.city,

     this.good,

     this.level,

     this.pts,

     this.target,

     this.template,

     this.newsId,

     this.lapId,

     this.orderId,

     this.from,

     this.to,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'city',
    required: false,
    includeIfNull: false,
  )


  final String? city;



  @JsonKey(
    
    name: r'good',
    required: false,
    includeIfNull: false,
  )


  final String? good;



  @JsonKey(
    
    name: r'level',
    required: false,
    includeIfNull: false,
  )


  final String? level;



  @JsonKey(
    
    name: r'pts',
    required: false,
    includeIfNull: false,
  )


  final int? pts;



  @JsonKey(
    
    name: r'target',
    required: false,
    includeIfNull: false,
  )


  final String? target;



  @JsonKey(
    
    name: r'template',
    required: false,
    includeIfNull: false,
  )


  final String? template;



  @JsonKey(
    
    name: r'newsId',
    required: false,
    includeIfNull: false,
  )


  final String? newsId;



  @JsonKey(
    
    name: r'lapId',
    required: false,
    includeIfNull: false,
  )


  final String? lapId;



  @JsonKey(
    
    name: r'orderId',
    required: false,
    includeIfNull: false,
  )


  final String? orderId;



  @JsonKey(
    
    name: r'from',
    required: false,
    includeIfNull: false,
  )


  final String? from;



  @JsonKey(
    
    name: r'to',
    required: false,
    includeIfNull: false,
  )


  final String? to;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OrderRequest &&
      other.type == type &&
      other.city == city &&
      other.good == good &&
      other.level == level &&
      other.pts == pts &&
      other.target == target &&
      other.template == template &&
      other.newsId == newsId &&
      other.lapId == lapId &&
      other.orderId == orderId &&
      other.from == from &&
      other.to == to;

    @override
    int get hashCode =>
        type.hashCode +
        (city == null ? 0 : city.hashCode) +
        (good == null ? 0 : good.hashCode) +
        (level == null ? 0 : level.hashCode) +
        (pts == null ? 0 : pts.hashCode) +
        (target == null ? 0 : target.hashCode) +
        (template == null ? 0 : template.hashCode) +
        (newsId == null ? 0 : newsId.hashCode) +
        (lapId == null ? 0 : lapId.hashCode) +
        (orderId == null ? 0 : orderId.hashCode) +
        (from == null ? 0 : from.hashCode) +
        (to == null ? 0 : to.hashCode);

  factory OrderRequest.fromJson(Map<String, dynamic> json) => _$OrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

