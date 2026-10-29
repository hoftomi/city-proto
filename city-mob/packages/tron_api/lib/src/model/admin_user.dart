//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_user.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminUser {
  /// Returns a new [AdminUser] instance.
  AdminUser({

    required  this.id,

    required  this.name,

    required  this.role,

    required  this.email,

    required  this.providers,

    required  this.createdAt,

    required  this.games,
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
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: true,
  )


  final String? email;



  @JsonKey(
    
    name: r'providers',
    required: true,
    includeIfNull: false,
  )


  final List<String> providers;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



      /// Live and archived games the user joined
  @JsonKey(
    
    name: r'games',
    required: true,
    includeIfNull: false,
  )


  final int games;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminUser &&
      other.id == id &&
      other.name == name &&
      other.role == role &&
      other.email == email &&
      other.providers == providers &&
      other.createdAt == createdAt &&
      other.games == games;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        role.hashCode +
        (email == null ? 0 : email.hashCode) +
        providers.hashCode +
        createdAt.hashCode +
        games.hashCode;

  factory AdminUser.fromJson(Map<String, dynamic> json) => _$AdminUserFromJson(json);

  Map<String, dynamic> toJson() => _$AdminUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

