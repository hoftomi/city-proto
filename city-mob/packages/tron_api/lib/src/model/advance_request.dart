//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'advance_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdvanceRequest {
  /// Returns a new [AdvanceRequest] instance.
  AdvanceRequest({

    required  this.minutes,
  });

      /// 1 minute to 7 days; null = to the next event (maturing sheet or settlement)
  @JsonKey(
    
    name: r'minutes',
    required: true,
    includeIfNull: true,
  )


  final int? minutes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdvanceRequest &&
      other.minutes == minutes;

    @override
    int get hashCode =>
        (minutes == null ? 0 : minutes.hashCode);

  factory AdvanceRequest.fromJson(Map<String, dynamic> json) => _$AdvanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AdvanceRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

