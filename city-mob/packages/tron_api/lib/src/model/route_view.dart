//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RouteView {
  /// Returns a new [RouteView] instance.
  RouteView({

    required  this.from,

    required  this.to,

    required  this.state,
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
    
    name: r'state',
    required: true,
    includeIfNull: false,
  )


  final String state;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RouteView &&
      other.from == from &&
      other.to == to &&
      other.state == state;

    @override
    int get hashCode =>
        from.hashCode +
        to.hashCode +
        state.hashCode;

  factory RouteView.fromJson(Map<String, dynamic> json) => _$RouteViewFromJson(json);

  Map<String, dynamic> toJson() => _$RouteViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

