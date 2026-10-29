//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kind_count.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class KindCount {
  /// Returns a new [KindCount] instance.
  KindCount({

    required  this.kind,

    required  this.count,
  });

  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final String kind;



  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final int count;





    @override
    bool operator ==(Object other) => identical(this, other) || other is KindCount &&
      other.kind == kind &&
      other.count == count;

    @override
    int get hashCode =>
        kind.hashCode +
        count.hashCode;

  factory KindCount.fromJson(Map<String, dynamic> json) => _$KindCountFromJson(json);

  Map<String, dynamic> toJson() => _$KindCountToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

