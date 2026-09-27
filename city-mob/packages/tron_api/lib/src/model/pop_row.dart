//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/house_ref.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pop_row.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PopRow {
  /// Returns a new [PopRow] instance.
  PopRow({

    required  this.house,

    required  this.value,
  });

  @JsonKey(
    
    name: r'house',
    required: true,
    includeIfNull: false,
  )


  final HouseRef house;



  @JsonKey(
    
    name: r'value',
    required: true,
    includeIfNull: false,
  )


  final double value;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PopRow &&
      other.house == house &&
      other.value == value;

    @override
    int get hashCode =>
        house.hashCode +
        value.hashCode;

  factory PopRow.fromJson(Map<String, dynamic> json) => _$PopRowFromJson(json);

  Map<String, dynamic> toJson() => _$PopRowToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

