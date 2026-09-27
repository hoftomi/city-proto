//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'start_slot.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StartSlot {
  /// Returns a new [StartSlot] instance.
  StartSlot({

    required  this.id,

    required  this.name,

    required  this.x,

    required  this.y,

    required  this.neighbors,

    required  this.note,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'x',
    required: true,
    includeIfNull: false,
  )


  final int x;



  @JsonKey(
    
    name: r'y',
    required: true,
    includeIfNull: false,
  )


  final int y;



  @JsonKey(
    
    name: r'neighbors',
    required: true,
    includeIfNull: false,
  )


  final List<String> neighbors;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StartSlot &&
      other.id == id &&
      other.name == name &&
      other.x == x &&
      other.y == y &&
      other.neighbors == neighbors &&
      other.note == note;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        x.hashCode +
        y.hashCode +
        neighbors.hashCode +
        note.hashCode;

  factory StartSlot.fromJson(Map<String, dynamic> json) => _$StartSlotFromJson(json);

  Map<String, dynamic> toJson() => _$StartSlotToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

