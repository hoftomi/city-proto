//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'join_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JoinRequest {
  /// Returns a new [JoinRequest] instance.
  JoinRequest({

    required  this.houseName,

    required  this.tincture,

    required  this.background,

    required  this.startSlot,

     this.startGood,
  });

  @JsonKey(
    
    name: r'houseName',
    required: true,
    includeIfNull: false,
  )


  final String houseName;



  @JsonKey(
    
    name: r'tincture',
    required: true,
    includeIfNull: false,
  )


  final String tincture;



  @JsonKey(
    
    name: r'background',
    required: true,
    includeIfNull: false,
  )


  final String background;



  @JsonKey(
    
    name: r'startSlot',
    required: true,
    includeIfNull: false,
  )


  final String startSlot;



  @JsonKey(
    
    name: r'startGood',
    required: false,
    includeIfNull: false,
  )


  final String? startGood;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JoinRequest &&
      other.houseName == houseName &&
      other.tincture == tincture &&
      other.background == background &&
      other.startSlot == startSlot &&
      other.startGood == startGood;

    @override
    int get hashCode =>
        houseName.hashCode +
        tincture.hashCode +
        background.hashCode +
        startSlot.hashCode +
        (startGood == null ? 0 : startGood.hashCode);

  factory JoinRequest.fromJson(Map<String, dynamic> json) => _$JoinRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JoinRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

