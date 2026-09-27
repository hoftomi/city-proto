//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discord_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DiscordRequest {
  /// Returns a new [DiscordRequest] instance.
  DiscordRequest({

    required  this.code,

    required  this.codeVerifier,

    required  this.redirectUri,
  });

  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'codeVerifier',
    required: true,
    includeIfNull: false,
  )


  final String codeVerifier;



  @JsonKey(
    
    name: r'redirectUri',
    required: true,
    includeIfNull: false,
  )


  final String redirectUri;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DiscordRequest &&
      other.code == code &&
      other.codeVerifier == codeVerifier &&
      other.redirectUri == redirectUri;

    @override
    int get hashCode =>
        code.hashCode +
        codeVerifier.hashCode +
        redirectUri.hashCode;

  factory DiscordRequest.fromJson(Map<String, dynamic> json) => _$DiscordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DiscordRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

