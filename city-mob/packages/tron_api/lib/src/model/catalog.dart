//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/level_info.dart';
import 'package:tron_api/src/model/rules_info.dart';
import 'package:tron_api/src/model/action_info.dart';
import 'package:tron_api/src/model/news_template_info.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'catalog.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Catalog {
  /// Returns a new [Catalog] instance.
  Catalog({

    required  this.actions,

    required  this.margins,

    required  this.programs,

    required  this.news,

    required  this.rules,
  });

  @JsonKey(
    
    name: r'actions',
    required: true,
    includeIfNull: false,
  )


  final List<ActionInfo> actions;



  @JsonKey(
    
    name: r'margins',
    required: true,
    includeIfNull: false,
  )


  final List<LevelInfo> margins;



  @JsonKey(
    
    name: r'programs',
    required: true,
    includeIfNull: false,
  )


  final List<LevelInfo> programs;



  @JsonKey(
    
    name: r'news',
    required: true,
    includeIfNull: false,
  )


  final List<NewsTemplateInfo> news;



  @JsonKey(
    
    name: r'rules',
    required: true,
    includeIfNull: false,
  )


  final RulesInfo rules;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Catalog &&
      other.actions == actions &&
      other.margins == margins &&
      other.programs == programs &&
      other.news == news &&
      other.rules == rules;

    @override
    int get hashCode =>
        actions.hashCode +
        margins.hashCode +
        programs.hashCode +
        news.hashCode +
        rules.hashCode;

  factory Catalog.fromJson(Map<String, dynamic> json) => _$CatalogFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

