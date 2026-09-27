//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/house_ref.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_view.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class NewsView {
  /// Returns a new [NewsView] instance.
  NewsView({

    required  this.id,

    required  this.text,

    required  this.template,

    required  this.effect,

    required  this.author,

    required  this.target,

    required  this.createdAt,

    required  this.debunked,

    required  this.verified,

    required  this.mine,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;



  @JsonKey(
    
    name: r'template',
    required: true,
    includeIfNull: false,
  )


  final String template;



  @JsonKey(
    
    name: r'effect',
    required: true,
    includeIfNull: false,
  )


  final int effect;



  @JsonKey(
    
    name: r'author',
    required: true,
    includeIfNull: false,
  )


  final HouseRef author;



  @JsonKey(
    
    name: r'target',
    required: true,
    includeIfNull: false,
  )


  final HouseRef target;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'debunked',
    required: true,
    includeIfNull: false,
  )


  final bool debunked;



  @JsonKey(
    
    name: r'verified',
    required: true,
    includeIfNull: true,
  )


  final bool? verified;



  @JsonKey(
    
    name: r'mine',
    required: true,
    includeIfNull: false,
  )


  final bool mine;





    @override
    bool operator ==(Object other) => identical(this, other) || other is NewsView &&
      other.id == id &&
      other.text == text &&
      other.template == template &&
      other.effect == effect &&
      other.author == author &&
      other.target == target &&
      other.createdAt == createdAt &&
      other.debunked == debunked &&
      other.verified == verified &&
      other.mine == mine;

    @override
    int get hashCode =>
        id.hashCode +
        text.hashCode +
        template.hashCode +
        effect.hashCode +
        author.hashCode +
        target.hashCode +
        createdAt.hashCode +
        debunked.hashCode +
        (verified == null ? 0 : verified.hashCode) +
        mine.hashCode;

  factory NewsView.fromJson(Map<String, dynamic> json) => _$NewsViewFromJson(json);

  Map<String, dynamic> toJson() => _$NewsViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

