//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RoleRequest {
  /// Returns a new [RoleRequest] instance.
  RoleRequest({

    required  this.role,
  });

      /// PLAYER or ADMIN
  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RoleRequest &&
      other.role == role;

    @override
    int get hashCode =>
        role.hashCode;

  factory RoleRequest.fromJson(Map<String, dynamic> json) => _$RoleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RoleRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

