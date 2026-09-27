import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tron_api/tron_api.dart';

import '../../../../core/tr.dart';
import '../../../../domain/model/city_extensions.dart';
import '../../../../domain/model/extensions.dart';
import '../../../../domain/service/city_service.dart';
import '../../../common/notice.dart';
import '../../bloc/game_bloc.dart';

part 'city_event.dart';
part 'city_state.dart';

/// A városnézet (Vásártér, Városháza, Alvilág): a GameBloc állapotát követi, tartja a negyedek űrlapjait,
/// és a beküldött űrlapokból a CityService-szel parancsot épít, amelyet a GameBlocnak ad át.
/// Városonként új példány (a CityPage kulcsa a város).
class CityBloc extends Bloc<CityEvent, CityState> {
  CityBloc(this._game, this._service) : super(const CityState()) {
    on<CityStarted>((e, emit) {
      emit(state.copyWith(requested: e.cityId));
      _sync(_game.state, emit);
    });
    on<_CityGameUpdated>((e, emit) => _sync(e.game, emit));
    on<CityRouteRequested>((e, emit) => _order((s, cv) => _service.route(s, cv, e.from)));

    on<CityDefendRequested>((e, emit) => _order((s, cv) => _service.defend(s, cv, e.orderId)));
    on<CityMarginPicked>((e, emit) => _order((s, cv) => _service.margin(s, cv, e.goodId, e.level)));
    on<CityBuyPointsChanged>((e, emit) => _good(emit, e.goodId, (f) => f.copyWith(buyPts: e.pts)));
    on<CityBuySubmitted>((e, emit) => _goodOrder(e.goodId, _service.buyShares));
    on<CityBuyoutTargetChanged>((e, emit) => _good(emit, e.goodId, (f) => f.copyWith(target: e.target)));
    on<CityBuyoutPointsChanged>((e, emit) => _good(emit, e.goodId, (f) => f.copyWith(boPts: e.pts)));
    on<CityBuyoutSubmitted>((e, emit) => _goodOrder(e.goodId, _service.buyout));

    on<CityPartyFounded>((e, emit) => _order((s, cv) => _service.foundParty(cv)));
    on<CityProgramPicked>((e, emit) => _order((s, cv) => _service.program(s, cv, e.level)));
    on<CityFestivalRequested>((e, emit) => _order((s, cv) => _service.festival(cv)));
    on<CityNewsTemplateChanged>((e, emit) => emit(state.copyWith(news: state.news.copyWith(template: e.template))));
    on<CityNewsTargetChanged>((e, emit) => emit(state.copyWith(news: state.news.copyWith(target: e.target))));
    on<CityNewsGoodChanged>((e, emit) => emit(state.copyWith(news: state.news.copyWith(good: e.good))));
    on<CityNewsSubmitted>((e, emit) => _order((s, cv) => _service.news(cv, state.newsPlan)));

    on<CitySpyHired>((e, emit) => _order((s, cv) => _service.hireSpy(s, cv)));
    on<CityGuardPosted>((e, emit) => _order((s, cv) => _service.guard(cv)));
    on<CityMoveSpyOpened>((e, emit) {
      if (state.can && state.freeSpies > 0) emit(state.copyWith(moveSpyOpen: true));
    });
    on<CityMoveSpyPicked>((e, emit) {
      emit(state.copyWith(moveSpyOpen: false, moveSpyTarget: e.to));
      _order((s, cv) => _service.moveSpy(s, cv, e.to));
    });
    on<CitySpyRequested>((e, emit) => _order((s, cv) => _service.spy(s, cv, e.target)));
    on<CityNewsChecked>((e, emit) => _order((s, cv) => _service.checkNews(cv, e.newsId)));

    on<CityIntelSaleOpened>(_saleOpened);
    on<CityIntelBuyerChanged>((e, emit) {
      if (state.sale != null) emit(state.copyWith(sale: state.sale!.copyWith(buyer: e.buyer)));
    });
    on<CityIntelPriceChanged>((e, emit) {
      if (state.sale != null) emit(state.copyWith(sale: state.sale!.copyWith(price: e.price)));
    });
    on<CityIntelSaleSubmitted>(_saleSubmitted);
    on<CityDialogClosed>((e, emit) => emit(state.copyWith(moveSpyOpen: false, clearSale: true)));
    on<CityOfferAccepted>((e, emit) {
      final o = state.game?.offers.where((o) => o.id == e.offerId).firstOrNull;
      if (o != null) _game.add(GameOfferAccepted(o.id, success: Tr('city.sale.accepted', {'house': o.of_.name})));
    });
    on<CityOfferDeclined>((e, emit) {
      if (state.game?.offers.any((o) => o.id == e.offerId) ?? false) _game.add(GameOfferDeclined(e.offerId));
    });

    _sub = _game.stream.listen((g) => add(_CityGameUpdated(g)));
  }

  final GameBloc _game;
  final CityService _service;
  late final StreamSubscription<GameViewState> _sub;

  /// A GameBloc pillanatképe; az első ismert állapotnál feloldja a várost, és kijelöli a térképen is.
  void _sync(GameViewState g, Emitter<CityState> emit) {
    final s = g.game;
    var id = state.cityId;
    if (s != null && (id == null || s.cityOrNull(id) == null)) id = _service.resolveCity(s, state.requested, g.selectedCity);
    final first = state.cityId == null;
    emit(state.copyWith(gameId: g.gameId, game: s, now: g.now, busy: g.busy, cityId: id));
    if (first && id != null && g.selectedCity != id) _game.add(GameMapCitySelected(id));
  }

  void _order(OrderRequest? Function(GameState s, CityView cv) build) {
    final s = state.game, cv = state.city;
    if (s == null || cv == null) return;
    final o = build(s, cv);
    if (o != null) _game.add(GameOrderAdded(o));
  }

  void _good(Emitter<CityState> emit, String goodId, GoodForm Function(GoodForm) f) => emit(state.copyWith(goods: {...state.goods, goodId: f(state.goods[goodId] ?? const GoodForm())}));

  void _goodOrder(String goodId, OrderRequest? Function(CityView cv, GoodPlan p) build) => _order((s, cv) {
        final g = cv.goods.where((g) => g.id == goodId).firstOrNull;
        return g == null ? null : build(cv, state.goodPlan(g));
      });

  void _saleOpened(CityIntelSaleOpened e, Emitter<CityState> emit) {
    final s = state.game;
    if (s == null) return;
    final d = _service.saleDefaults(s, e.intelId);
    if (d == null) {
      emit(
        state.copyWith(
          notice: Notice((state.notice?.seq ?? 0) + 1, const Tr('city.sale.failed'), body: const Tr('city.sale.no_buyer'), tone: 'danger'),
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        sale: IntelSaleForm(intelId: e.intelId, buyer: d.$1, price: d.$2),
      ),
    );
  }

  void _saleSubmitted(CityIntelSaleSubmitted e, Emitter<CityState> emit) {
    final s = state.game, f = state.sale;
    emit(state.copyWith(clearSale: true));
    if (s == null || f == null || !_service.validBuyer(s, f.intelId, f.buyer)) return;
    final price = _service.salePrice(s, f.price);
    _game.add(GameIntelOffered(f.intelId, f.buyer, price, success: Tr('city.sale.offered', {'house': s.houseName(f.buyer), 'price': '$price'})));
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
