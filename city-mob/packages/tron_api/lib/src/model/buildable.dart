//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'buildable.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Buildable {
  /// Returns a new [Buildable] instance.
  Buildable({

    required  this.from,

    required  this.to,

    required  this.fromName,

    required  this.toName,
  });

  @JsonKey(
    
    name: r'from',
    required: true,
    includeIfNull: false,
  )


  final String from;



  @JsonKey(
    
    name: r'to',
    required: true,
    includeIfNull: false,
  )


  final String to;



  @JsonKey(
    
    name: r'fromName',
    required: true,
    includeIfNull: false,
  )


  final String fromName;



  @JsonKey(
    
    name: r'toName',
    required: true,
    includeIfNull: false,
  )


  final String toName;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Buildable &&
      other.from == from &&
      other.to == to &&
      other.fromName == fromName &&
      other.toName == toName;

    @override
    int get hashCode =>
        from.hashCode +
        to.hashCode +
        fromName.hashCode +
        toName.hashCode;

  factory Buildable.fromJson(Map<String, dynamic> json) => _$BuildableFromJson(json);

  Map<String, dynamic> toJson() => _$BuildableToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

