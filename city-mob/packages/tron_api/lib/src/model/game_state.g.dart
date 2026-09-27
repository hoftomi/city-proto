// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GameStateCWProxy {
  GameState gameId(String gameId);

  GameState gameName(String gameName);

  GameState mapId(String mapId);

  GameState status(String status);

  GameState clock(ClockView clock);

  GameState me(Me me);

  GameState routes(List<RouteView> routes);

  GameState buildable(List<Buildable> buildable);

  GameState cities(List<CityView> cities);

  GameState draft(List<OrderView> draft);

  GameState draftCost(Cost draftCost);

  GameState lap(LapView? lap);

  GameState rivalLaps(List<RivalLap> rivalLaps);

  GameState threats(List<Threat> threats);

  GameState intel(List<IntelView> intel);

  GameState offers(List<OfferView> offers);

  GameState houses(List<HouseRef> houses);

  GameState catalog(Catalog catalog);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GameState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GameState(...).copyWith(id: 12, name: "My name")
  /// ````
  GameState call({
    String gameId,
    String gameName,
    String mapId,
    String status,
    ClockView clock,
    Me me,
    List<RouteView> routes,
    List<Buildable> buildable,
    List<CityView> cities,
    List<OrderView> draft,
    Cost draftCost,
    LapView? lap,
    List<RivalLap> rivalLaps,
    List<Threat> threats,
    List<IntelView> intel,
    List<OfferView> offers,
    List<HouseRef> houses,
    Catalog catalog,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGameState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGameState.copyWith.fieldName(...)`
class _$GameStateCWProxyImpl implements _$GameStateCWProxy {
  const _$GameStateCWProxyImpl(this._value);

  final GameState _value;

  @override
  GameState gameId(String gameId) => this(gameId: gameId);

  @override
  GameState gameName(String gameName) => this(gameName: gameName);

  @override
  GameState mapId(String mapId) => this(mapId: mapId);

  @override
  GameState status(String status) => this(status: status);

  @override
  GameState clock(ClockView clock) => this(clock: clock);

  @override
  GameState me(Me me) => this(me: me);

  @override
  GameState routes(List<RouteView> routes) => this(routes: routes);

  @override
  GameState buildable(List<Buildable> buildable) => this(buildable: buildable);

  @override
  GameState cities(List<CityView> cities) => this(cities: cities);

  @override
  GameState draft(List<OrderView> draft) => this(draft: draft);

  @override
  GameState draftCost(Cost draftCost) => this(draftCost: draftCost);

  @override
  GameState lap(LapView? lap) => this(lap: lap);

  @override
  GameState rivalLaps(List<RivalLap> rivalLaps) => this(rivalLaps: rivalLaps);

  @override
  GameState threats(List<Threat> threats) => this(threats: threats);

  @override
  GameState intel(List<IntelView> intel) => this(intel: intel);

  @override
  GameState offers(List<OfferView> offers) => this(offers: offers);

  @override
  GameState houses(List<HouseRef> houses) => this(houses: houses);

  @override
  GameState catalog(Catalog catalog) => this(catalog: catalog);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GameState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GameState(...).copyWith(id: 12, name: "My name")
  /// ````
  GameState call({
    Object? gameId = const $CopyWithPlaceholder(),
    Object? gameName = const $CopyWithPlaceholder(),
    Object? mapId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? clock = const $CopyWithPlaceholder(),
    Object? me = const $CopyWithPlaceholder(),
    Object? routes = const $CopyWithPlaceholder(),
    Object? buildable = const $CopyWithPlaceholder(),
    Object? cities = const $CopyWithPlaceholder(),
    Object? draft = const $CopyWithPlaceholder(),
    Object? draftCost = const $CopyWithPlaceholder(),
    Object? lap = const $CopyWithPlaceholder(),
    Object? rivalLaps = const $CopyWithPlaceholder(),
    Object? threats = const $CopyWithPlaceholder(),
    Object? intel = const $CopyWithPlaceholder(),
    Object? offers = const $CopyWithPlaceholder(),
    Object? houses = const $CopyWithPlaceholder(),
    Object? catalog = const $CopyWithPlaceholder(),
  }) {
    return GameState(
      gameId: gameId == const $CopyWithPlaceholder()
          ? _value.gameId
          // ignore: cast_nullable_to_non_nullable
          : gameId as String,
      gameName: gameName == const $CopyWithPlaceholder()
          ? _value.gameName
          // ignore: cast_nullable_to_non_nullable
          : gameName as String,
      mapId: mapId == const $CopyWithPlaceholder()
          ? _value.mapId
          // ignore: cast_nullable_to_non_nullable
          : mapId as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      clock: clock == const $CopyWithPlaceholder()
          ? _value.clock
          // ignore: cast_nullable_to_non_nullable
          : clock as ClockView,
      me: me == const $CopyWithPlaceholder()
          ? _value.me
          // ignore: cast_nullable_to_non_nullable
          : me as Me,
      routes: routes == const $CopyWithPlaceholder()
          ? _value.routes
          // ignore: cast_nullable_to_non_nullable
          : routes as List<RouteView>,
      buildable: buildable == const $CopyWithPlaceholder()
          ? _value.buildable
          // ignore: cast_nullable_to_non_nullable
          : buildable as List<Buildable>,
      cities: cities == const $CopyWithPlaceholder()
          ? _value.cities
          // ignore: cast_nullable_to_non_nullable
          : cities as List<CityView>,
      draft: draft == const $CopyWithPlaceholder()
          ? _value.draft
          // ignore: cast_nullable_to_non_nullable
          : draft as List<OrderView>,
      draftCost: draftCost == const $CopyWithPlaceholder()
          ? _value.draftCost
          // ignore: cast_nullable_to_non_nullable
          : draftCost as Cost,
      lap: lap == const $CopyWithPlaceholder()
          ? _value.lap
          // ignore: cast_nullable_to_non_nullable
          : lap as LapView?,
      rivalLaps: rivalLaps == const $CopyWithPlaceholder()
          ? _value.rivalLaps
          // ignore: cast_nullable_to_non_nullable
          : rivalLaps as List<RivalLap>,
      threats: threats == const $CopyWithPlaceholder()
          ? _value.threats
          // ignore: cast_nullable_to_non_nullable
          : threats as List<Threat>,
      intel: intel == const $CopyWithPlaceholder()
          ? _value.intel
          // ignore: cast_nullable_to_non_nullable
          : intel as List<IntelView>,
      offers: offers == const $CopyWithPlaceholder()
          ? _value.offers
          // ignore: cast_nullable_to_non_nullable
          : offers as List<OfferView>,
      houses: houses == const $CopyWithPlaceholder()
          ? _value.houses
          // ignore: cast_nullable_to_non_nullable
          : houses as List<HouseRef>,
      catalog: catalog == const $CopyWithPlaceholder()
          ? _value.catalog
          // ignore: cast_nullable_to_non_nullable
          : catalog as Catalog,
    );
  }
}

extension $GameStateCopyWith on GameState {
  /// Returns a callable class that can be used as follows: `instanceOfGameState.copyWith(...)` or like so:`instanceOfGameState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GameStateCWProxy get copyWith => _$GameStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) => $checkedCreate(
  'GameState',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'gameId',
        'gameName',
        'mapId',
        'status',
        'clock',
        'me',
        'routes',
        'buildable',
        'cities',
        'draft',
        'draftCost',
        'lap',
        'rivalLaps',
        'threats',
        'intel',
        'offers',
        'houses',
        'catalog',
      ],
    );
    final val = GameState(
      gameId: $checkedConvert('gameId', (v) => v as String),
      gameName: $checkedConvert('gameName', (v) => v as String),
      mapId: $checkedConvert('mapId', (v) => v as String),
      status: $checkedConvert('status', (v) => v as String),
      clock: $checkedConvert(
        'clock',
        (v) => ClockView.fromJson(v as Map<String, dynamic>),
      ),
      me: $checkedConvert('me', (v) => Me.fromJson(v as Map<String, dynamic>)),
      routes: $checkedConvert(
        'routes',
        (v) => (v as List<dynamic>)
            .map((e) => RouteView.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      buildable: $checkedConvert(
        'buildable',
        (v) => (v as List<dynamic>)
            .map((e) => Buildable.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      cities: $checkedConvert(
        'cities',
        (v) => (v as List<dynamic>)
            .map((e) => CityView.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      draft: $checkedConvert(
        'draft',
        (v) => (v as List<dynamic>)
            .map((e) => OrderView.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      draftCost: $checkedConvert(
        'draftCost',
        (v) => Cost.fromJson(v as Map<String, dynamic>),
      ),
      lap: $checkedConvert(
        'lap',
        (v) => v == null ? null : LapView.fromJson(v as Map<String, dynamic>),
      ),
      rivalLaps: $checkedConvert(
        'rivalLaps',
        (v) => (v as List<dynamic>)
            .map((e) => RivalLap.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      threats: $checkedConvert(
        'threats',
        (v) => (v as List<dynamic>)
            .map((e) => Threat.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      intel: $checkedConvert(
        'intel',
        (v) => (v as List<dynamic>)
            .map((e) => IntelView.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      offers: $checkedConvert(
        'offers',
        (v) => (v as List<dynamic>)
            .map((e) => OfferView.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      houses: $checkedConvert(
        'houses',
        (v) => (v as List<dynamic>)
            .map((e) => HouseRef.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      catalog: $checkedConvert(
        'catalog',
        (v) => Catalog.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
  'gameId': instance.gameId,
  'gameName': instance.gameName,
  'mapId': instance.mapId,
  'status': instance.status,
  'clock': instance.clock.toJson(),
  'me': instance.me.toJson(),
  'routes': instance.routes.map((e) => e.toJson()).toList(),
  'buildable': instance.buildable.map((e) => e.toJson()).toList(),
  'cities': instance.cities.map((e) => e.toJson()).toList(),
  'draft': instance.draft.map((e) => e.toJson()).toList(),
  'draftCost': instance.draftCost.toJson(),
  'lap': instance.lap?.toJson(),
  'rivalLaps': instance.rivalLaps.map((e) => e.toJson()).toList(),
  'threats': instance.threats.map((e) => e.toJson()).toList(),
  'intel': instance.intel.map((e) => e.toJson()).toList(),
  'offers': instance.offers.map((e) => e.toJson()).toList(),
  'houses': instance.houses.map((e) => e.toJson()).toList(),
  'catalog': instance.catalog.toJson(),
};
