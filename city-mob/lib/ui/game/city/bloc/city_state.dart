part of 'city_bloc.dart';

/// Egy árucikk kártyájának űrlapja: vétel a Várostól és kivásárlás (a választott, még nem szorított értékek).
class GoodForm extends Equatable {
  const GoodForm({this.buyPts = 5, this.boPts = 5, this.target});
  final int buyPts, boPts;
  final String? target;

  GoodForm copyWith({int? buyPts, int? boPts, String? target}) =>
      GoodForm(buyPts: buyPts ?? this.buyPts, boPts: boPts ?? this.boPts, target: target ?? this.target);

  @override
  List<Object?> get props => [buyPts, boPts, target];
}

/// A hírszerkesztő választásai (null: az első lehetőség).
class NewsForm extends Equatable {
  const NewsForm({this.template, this.target, this.good});
  final String? template, target, good;

  NewsForm copyWith({String? template, String? target, String? good}) =>
      NewsForm(template: template ?? this.template, target: target ?? this.target, good: good ?? this.good);

  @override
  List<Object?> get props => [template, target, good];
}

/// Az eladás párbeszédének értékei; a beírt ár szövegként (a CityService értelmezi).
class IntelSaleForm extends Equatable {
  const IntelSaleForm({required this.intelId, required this.buyer, required this.price});
  final String intelId, buyer, price;

  IntelSaleForm copyWith({String? buyer, String? price}) => IntelSaleForm(intelId: intelId, buyer: buyer ?? this.buyer, price: price ?? this.price);

  @override
  List<Object?> get props => [intelId, buyer, price];
}

/// A városnézet állapota: a GameBloc pillanatképe (játék, óra, busy), a megjelenített város, és a három negyed
/// űrlapjai. A számolt értékek getterek (lib/domain/model/city_extensions.dart), a widgetek csak ezeket olvassák.
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

  /// Az URL-ben kért város (null: a kijelölt vagy az első elérhető).
  final String? requested;
  final String? gameId;
  final GameState? game;
  final DateTime? now;
  final bool busy;

  /// A megjelenített város.
  final String? cityId;

  /// Árucikkenként a Vásártér űrlapja.
  final Map<String, GoodForm> goods;
  final NewsForm news;

  /// Nyitott eladási párbeszéd.
  final IntelSaleForm? sale;

  /// Nyitva van a „Kém áthelyezése” párbeszéd.
  final bool moveSpyOpen;

  /// Az utoljára választott célváros a kém áthelyezéséhez.
  final String? moveSpyTarget;

  /// Egyszeri üzenet (toast).
  final Notice? notice;

  // ------------------------------------------------------------ számolt értékek

  CityView? get city => game?.cityOrNull(cityId);
  bool get ready => city != null;

  /// Elérhető-e a város (a hálózatodban van: cselekedni csak itt lehet).
  bool get can => city?.reachable ?? false;
  RulesInfo get rules => game!.rules;
  Catalog get catalog => game!.catalog;
  ClockView get clock => game!.clock;

  List<CityStat> get stats => game!.cityStats(city!);
  Map<String, String?> get dominants => game!.districtDominants(city!);
  List<Buildable> get routes => game!.routesTo(cityId!);
  List<Threat> get threats => game!.threatsIn(cityId!);
  bool defendOnlyInDraft(Threat t) => game!.defendOnlyInDraft(t);
  bool get lowPop => can && city!.lowPop(rules);

  GoodPlan goodPlan(GoodView g) {
    final f = goods[g.id] ?? const GoodForm();
    return GoodPlan.of(g, rules, buyPts: f.buyPts, boPts: f.boPts, target: f.target);
  }

  NewsPlan get newsPlan => NewsPlan.of(catalog, city!, template: news.template, target: news.target, good: news.good);

  /// Hírszerkesztő: csak elérhető városban, ahol más ház is jelen van.
  bool get canCompose => can && city!.present.isNotEmpty;

  int get freeSpies => city!.freeSpies;
  bool get spiesFull => city!.spiesFull(rules);
  List<NewsView> get checkable => city!.checkable;
  NewsCheck newsCheck(NewsView n) => city!.newsCheck(n);

  /// A kém lehetséges célvárosai, és hogy tele van-e már.
  List<(CityView, bool full)> get spyDestinations => [for (final x in game!.spyDestinations(cityId!)) (x, x.spiesFull(rules))];

  IntelView? get saleIntel => sale == null ? null : game?.intel.where((i) => i.id == sale!.intelId).firstOrNull;
  List<HouseRef> get saleBuyers => saleIntel == null ? const [] : game!.intelBuyers(saleIntel!);

  String houseName(String id) => game!.houseName(id);

  /// Hátralévő idő a játék órájához mérve.
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
