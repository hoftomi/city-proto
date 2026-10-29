//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_count.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DailyCount {
  /// Returns a new [DailyCount] instance.
  DailyCount({

    required  this.date,

    required  this.count,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final DateTime date;



  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final int count;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DailyCount &&
      other.date == date &&
      other.count == count;

    @override
    int get hashCode =>
        date.hashCode +
        count.hashCode;

  factory DailyCount.fromJson(Map<String, dynamic> json) => _$DailyCountFromJson(json);

  Map<String, dynamic> toJson() => _$DailyCountToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

