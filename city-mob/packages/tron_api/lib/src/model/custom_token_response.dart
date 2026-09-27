//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custom_token_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CustomTokenResponse {
  /// Returns a new [CustomTokenResponse] instance.
  CustomTokenResponse({

    required  this.customToken,
  });

  @JsonKey(
    
    name: r'customToken',
    required: true,
    includeIfNull: false,
  )


  final String customToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CustomTokenResponse &&
      other.customToken == customToken;

    @override
    int get hashCode =>
        customToken.hashCode;

  factory CustomTokenResponse.fromJson(Map<String, dynamic> json) => _$CustomTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomTokenResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

