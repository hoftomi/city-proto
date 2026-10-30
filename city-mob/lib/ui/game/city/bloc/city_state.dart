part of 'city_bloc.dart';

/// A good card's form: buy from the City and buyout (the chosen, not yet clamped values).
class GoodForm extends Equatable {
  const GoodForm({this.buyPts = 5, this.boPts = 5, this.target});
  final int buyPts, boPts;
  final String? target;

  GoodForm copyWith({int? buyPts, int? boPts, String? target}) => GoodForm(buyPts: buyPts ?? this.buyPts, boPts: boPts ?? this.boPts, target: target ?? this.target);

  @override
  List<Object?> get props => [buyPts, boPts, target];
}

/// The news editor's choices (null: the first option).
class NewsForm extends Equatable {
  const NewsForm({this.template, this.target, this.good});
  final String? template, target, good;

  NewsForm copyWith({String? template, String? target, String? good}) => NewsForm(template: template ?? this.template, target: target ?? this.target, good: good ?? this.good);

  @override
  List<Object?> get props => [template, target, good];
}

/// The sale dialog's values; the entered price as text (parsed by the CityService).
class IntelSaleForm extends Equatable {
  const IntelSaleForm({required this.intelId, required this.buyer, required this.price});
  final String intelId, buyer, price;

  IntelSaleForm copyWith({String? buyer, String? price}) => IntelSaleForm(intelId: intelId, buyer: buyer ?? this.buyer, price: price ?? this.price);

  @override
  List<Object?> get props => [intelId, buyer, price];
}

/// The city view state: the GameBloc snapshot (game, clock, busy), the displayed city, and the three districts'
/// forms. Computed values are getters (lib/domain/model/city_extensions.dart); widgets only read these.
class CityState extends Equatable {
  const CityState({
    this.requested,
    this.gameId,
    this.game,
    this.now,
    this.busy = false,
    this.cityId,
    this.goods = const {},
    this.news = const NewsForm(),
    this.sale,
    this.moveSpyOpen = false,
    this.moveSpyTarget,
    this.notice,
  });

  /// The city requested in the URL (null: the selected or first reachable).
  final String? requested;
  final String? gameId;
  final GameState? game;
  final DateTime? now;
  final bool busy;

  /// The displayed city.
  final String? cityId;

  /// The Marketplace form per good.
  final Map<String, GoodForm> goods;
  final NewsForm news;

  /// Open sale dialog.
  final IntelSaleForm? sale;

  /// The "Relocate spy" dialog is open.
  final bool moveSpyOpen;

  /// The last chosen target city for relocating a spy.
  final String? moveSpyTarget;

  /// One-off message (toast).
  final Notice? notice;

  // ------------------------------------------------------------ computed values

  CityView? get city => game?.cityOrNull(cityId);
  bool get ready => city != null;

  /// Whether the city is reachable (in your network: you can only act here).
  bool get can => city?.reachable ?? false;
  RulesInfo get rules => game!.rules;
  Catalog get catalog => game!.catalog;
  ClockView get clock => game!.clock;

  List<CityStat> get stats => game!.cityStats(city!);
  Map<String, HouseRef?> get dominants => game!.districtDominants(city!);
  List<Buildable> get routes => game!.routesTo(cityId!);
  List<Threat> get threats => game!.threatsIn(cityId!);
  bool defendOnlyInDraft(Threat t) => game!.defendOnlyInDraft(t);

  GoodPlan goodPlan(GoodView g) {
    final f = goods[g.id] ?? const GoodForm();
    return GoodPlan.of(g, rules, buyPts: f.buyPts, boPts: f.boPts, target: f.target);
  }

  /// Margin level waiting on the draft for the good (blue in the picker), if any.
  String? pendingMargin(GoodView g) => game!.pendingMargin(cityId!, g.id);

  NewsPlan get newsPlan => NewsPlan.of(catalog, city!, template: news.template, target: news.target, good: news.good);

  /// News editor: only in a reachable city where another house is present.
  bool get canCompose => can && city!.present.isNotEmpty;

  int get freeSpies => city!.freeSpies;
  bool get spiesFull => city!.spiesFull(rules);
  List<NewsView> get checkable => city!.checkable;
  NewsCheck newsCheck(NewsView n) => city!.newsCheck(n);

  /// The spy's possible target cities, and whether each is already full.
  List<(CityView, bool full)> get spyDestinations => [for (final x in game!.spyDestinations(cityId!)) (x, x.spiesFull(rules))];

  IntelView? get saleIntel => sale == null ? null : game?.intel.where((i) => i.id == sale!.intelId).firstOrNull;
  List<HouseRef> get saleBuyers => saleIntel == null ? const [] : game!.intelBuyers(saleIntel!);

  String houseName(String id) => game!.houseName(id);

  /// Remaining time measured against the game clock.
  Duration until(DateTime? t) => t == null || now == null ? Duration.zero : t.difference(now!);

  CityState copyWith({
    String? requested,
    String? gameId,
    GameState? game,
    DateTime? now,
    bool? busy,
    String? cityId,
    Map<String, GoodForm>? goods,
    NewsForm? news,
    IntelSaleForm? sale,
    bool clearSale = false,
    bool? moveSpyOpen,
    String? moveSpyTarget,
    Notice? notice,
  }) {
    return CityState(
      requested: requested ?? this.requested,
      gameId: gameId ?? this.gameId,
      game: game ?? this.game,
      now: now ?? this.now,
      busy: busy ?? this.busy,
      cityId: cityId ?? this.cityId,
      goods: goods ?? this.goods,
      news: news ?? this.news,
      sale: clearSale ? null : sale ?? this.sale,
      moveSpyOpen: moveSpyOpen ?? this.moveSpyOpen,
      moveSpyTarget: moveSpyTarget ?? this.moveSpyTarget,
      notice: notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [requested, gameId, game, now, busy, cityId, goods, news, sale, moveSpyOpen, moveSpyTarget, notice];
}
