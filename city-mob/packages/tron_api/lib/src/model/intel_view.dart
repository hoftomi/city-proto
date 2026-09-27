//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/house_ref.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intel_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class IntelView {
  /// Returns a new [IntelView] instance.
  IntelView({

    required  this.id,

    required  this.of_,

    required  this.executeAt,

    required  this.lines,

    required  this.depth,

    required  this.live,

    required  this.offeredTo,

    required  this.bought,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'of',
    required: true,
    includeIfNull: false,
  )


  final HouseRef of_;



  @JsonKey(
    
    name: r'executeAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime executeAt;



  @JsonKey(
    
    name: r'lines',
    required: true,
    includeIfNull: false,
  )


  final List<String> lines;



  @JsonKey(
    
    name: r'depth',
    required: true,
    includeIfNull: false,
  )


  final int depth;



  @JsonKey(
    
    name: r'live',
    required: true,
    includeIfNull: false,
  )


  final bool live;



  @JsonKey(
    
    name: r'offeredTo',
    required: true,
    includeIfNull: false,
  )


  final List<String> offeredTo;



  @JsonKey(
    
    name: r'bought',
    required: true,
    includeIfNull: false,
  )


  final bool bought;





    @override
    bool operator ==(Object other) => identical(this, other) || other is IntelView &&
      other.id == id &&
      other.of_ == of_ &&
      other.executeAt == executeAt &&
      other.lines == lines &&
      other.depth == depth &&
      other.live == live &&
      other.offeredTo == offeredTo &&
      other.bought == bought;

    @override
    int get hashCode =>
        id.hashCode +
        of_.hashCode +
        executeAt.hashCode +
        lines.hashCode +
        depth.hashCode +
        live.hashCode +
        offeredTo.hashCode +
        bought.hashCode;

  factory IntelView.fromJson(Map<String, dynamic> json) => _$IntelViewFromJson(json);

  Map<String, dynamic> toJson() => _$IntelViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

