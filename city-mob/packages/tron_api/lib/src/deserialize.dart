import 'package:tron_api/src/model/action_info.dart';
import 'package:tron_api/src/model/admin_result.dart';
import 'package:tron_api/src/model/advance_request.dart';
import 'package:tron_api/src/model/background_dto.dart';
import 'package:tron_api/src/model/buildable.dart';
import 'package:tron_api/src/model/catalog.dart';
import 'package:tron_api/src/model/city_def.dart';
import 'package:tron_api/src/model/city_view.dart';
import 'package:tron_api/src/model/clock_view.dart';
import 'package:tron_api/src/model/cost.dart';
import 'package:tron_api/src/model/custom_token_response.dart';
import 'package:tron_api/src/model/discord_request.dart';
import 'package:tron_api/src/model/game_detail.dart';
import 'package:tron_api/src/model/game_state.dart';
import 'package:tron_api/src/model/game_summary.dart';
import 'package:tron_api/src/model/good_def.dart';
import 'package:tron_api/src/model/good_option.dart';
import 'package:tron_api/src/model/good_view.dart';
import 'package:tron_api/src/model/house_ref.dart';
import 'package:tron_api/src/model/intel_view.dart';
import 'package:tron_api/src/model/join_request.dart';
import 'package:tron_api/src/model/lap_view.dart';
import 'package:tron_api/src/model/level_info.dart';
import 'package:tron_api/src/model/map_def.dart';
import 'package:tron_api/src/model/me.dart';
import 'package:tron_api/src/model/my_house.dart';
import 'package:tron_api/src/model/news_template_info.dart';
import 'package:tron_api/src/model/news_view.dart';
import 'package:tron_api/src/model/offer_request.dart';
import 'package:tron_api/src/model/offer_view.dart';
import 'package:tron_api/src/model/order_request.dart';
import 'package:tron_api/src/model/order_view.dart';
import 'package:tron_api/src/model/party_view.dart';
import 'package:tron_api/src/model/pop_row.dart';
import 'package:tron_api/src/model/problem_detail.dart';
import 'package:tron_api/src/model/rank_row.dart';
import 'package:tron_api/src/model/report_view.dart';
import 'package:tron_api/src/model/rival_lap.dart';
import 'package:tron_api/src/model/route_view.dart';
import 'package:tron_api/src/model/rules_info.dart';
import 'package:tron_api/src/model/seller.dart';
import 'package:tron_api/src/model/start_slot.dart';
import 'package:tron_api/src/model/start_slot_dto.dart';
import 'package:tron_api/src/model/terrain_def.dart';
import 'package:tron_api/src/model/threat.dart';
import 'package:tron_api/src/model/user_dto.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'ActionInfo':
          return ActionInfo.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminResult':
          return AdminResult.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdvanceRequest':
          return AdvanceRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BackgroundDto':
          return BackgroundDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Buildable':
          return Buildable.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Catalog':
          return Catalog.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CityDef':
          return CityDef.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CityView':
          return CityView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ClockView':
          return ClockView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Cost':
          return Cost.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CustomTokenResponse':
          return CustomTokenResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DiscordRequest':
          return DiscordRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GameDetail':
          return GameDetail.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GameState':
          return GameState.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GameSummary':
          return GameSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoodDef':
          return GoodDef.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoodOption':
          return GoodOption.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoodView':
          return GoodView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HouseRef':
          return HouseRef.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'IntelView':
          return IntelView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'JoinRequest':
          return JoinRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LapView':
          return LapView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LevelInfo':
          return LevelInfo.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MapDef':
          return MapDef.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Me':
          return Me.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MyHouse':
          return MyHouse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'NewsTemplateInfo':
          return NewsTemplateInfo.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'NewsView':
          return NewsView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OfferRequest':
          return OfferRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OfferView':
          return OfferView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OrderRequest':
          return OrderRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OrderView':
          return OrderView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PartyView':
          return PartyView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PopRow':
          return PopRow.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProblemDetail':
          return ProblemDetail.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RankRow':
          return RankRow.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReportView':
          return ReportView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RivalLap':
          return RivalLap.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RouteView':
          return RouteView.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RulesInfo':
          return RulesInfo.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Seller':
          return Seller.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StartSlot':
          return StartSlot.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StartSlotDto':
          return StartSlotDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TerrainDef':
          return TerrainDef.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Threat':
          return Threat.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserDto':
          return UserDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }