//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tron_api/src/model/admin_game.dart';
import 'package:tron_api/src/model/kind_count.dart';
import 'package:tron_api/src/model/admin_house.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_game_detail.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminGameDetail {
  /// Returns a new [AdminGameDetail] instance.
  AdminGameDetail({

    required  this.game,

    required  this.houses,

    required  this.reportCounts,

    required  this.nextSettlementAt,

    required  this.maturingSheets,
  });

  @JsonKey(
    
    name: r'game',
    required: true,
    includeIfNull: false,
  )


  final AdminGame game;



  @JsonKey(
    
    name: r'houses',
    required: true,
    includeIfNull: false,
  )


  final List<AdminHouse> houses;



  @JsonKey(
    
    name: r'reportCounts',
    required: true,
    includeIfNull: false,
  )


  final List<KindCount> reportCounts;



  @JsonKey(
    
    name: r'nextSettlementAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? nextSettlementAt;



  @JsonKey(
    
    name: r'maturingSheets',
    required: true,
    includeIfNull: false,
  )


  final int maturingSheets;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminGameDetail &&
      other.game == game &&
      other.houses == houses &&
      other.reportCounts == reportCounts &&
      other.nextSettlementAt == nextSettlementAt &&
      other.maturingSheets == maturingSheets;

    @override
    int get hashCode =>
        game.hashCode +
        houses.hashCode +
        reportCounts.hashCode +
        (nextSettlementAt == null ? 0 : nextSettlementAt.hashCode) +
        maturingSheets.hashCode;

  factory AdminGameDetail.fromJson(Map<String, dynamic> json) => _$AdminGameDetailFromJson(json);

  Map<String, dynamic> toJson() => _$AdminGameDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

