//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// House background (rulebook 2.2): merchant = shares in a home-city good (needs startGood), noble = a party and popularity at home, shadow = spies at home.
enum Background {
      @JsonValue(r'merchant')
      merchant(r'merchant'),
      @JsonValue(r'noble')
      noble(r'noble'),
      @JsonValue(r'shadow')
      shadow(r'shadow');

  const Background(this.value);

  final String value;

  @override
  String toString() => value;
}
