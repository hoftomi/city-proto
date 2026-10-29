//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_result.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminResult {
  /// Returns a new [AdminResult] instance.
  AdminResult({

     this.started,

     this.settlements,

     this.advancedMinutes,

     this.created,
  });

  @JsonKey(
    
    name: r'started',
    required: false,
    includeIfNull: false,
  )


  final String? started;



  @JsonKey(
    
    name: r'settlements',
    required: false,
    includeIfNull: false,
  )


  final int? settlements;



  @JsonKey(
    
    name: r'advancedMinutes',
    required: false,
    includeIfNull: false,
  )


  final int? advancedMinutes;



      /// Sample games created by the seed
  @JsonKey(
    
    name: r'created',
    required: false,
    includeIfNull: false,
  )


  final int? created;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminResult &&
      other.started == started &&
      other.settlements == settlements &&
      other.advancedMinutes == advancedMinutes &&
      other.created == created;

    @override
    int get hashCode =>
        (started == null ? 0 : started.hashCode) +
        (settlements == null ? 0 : settlements.hashCode) +
        (advancedMinutes == null ? 0 : advancedMinutes.hashCode) +
        (created == null ? 0 : created.hashCode);

  factory AdminResult.fromJson(Map<String, dynamic> json) => _$AdminResultFromJson(json);

  Map<String, dynamic> toJson() => _$AdminResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

