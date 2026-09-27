part of 'city_bloc.dart';

sealed class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object?> get props => [];
}

/// A városnézet indul; [cityId] az URL-ből jön (null: a kijelölt vagy az első elérhető város).
class CityStarted extends CityEvent {
  const CityStarted(this.cityId);
  final String? cityId;

  @override
  List<Object?> get props => [cityId];
}

/// A GameBloc új állapota (belső esemény).
class _CityGameUpdated extends CityEvent {
  const _CityGameUpdated(this.game);
  final GameViewState game;

  @override
  List<Object?> get props => [game];
}

/// Útvonalépítés ide a megadott városból.
class CityRouteRequested extends CityEvent {
  const CityRouteRequested(this.from);
  final String from;

  @override
  List<Object?> get props => [from];
}

// ---------------------------------------------------------------- Vásártér

/// Védekező vétel egy kivásárlási fenyegetés (az ajánlat parancsa) ellen.
class CityDefendRequested extends CityEvent {
  const CityDefendRequested(this.orderId);
  final String orderId;

  @override
  List<Object?> get props => [orderId];
}

class CityMarginPicked extends CityEvent {
  const CityMarginPicked(this.goodId, this.level);
  final String goodId, level;

  @override
  List<Object?> get props => [goodId, level];
}

/// Vétel a Várostól: a pontok választása.
class CityBuyPointsChanged extends CityEvent {
  const CityBuyPointsChanged(this.goodId, this.pts);
  final String goodId;
  final int pts;

  @override
  List<Object?> get props => [goodId, pts];
}

class CityBuySubmitted extends CityEvent {
  const CityBuySubmitted(this.goodId);
  final String goodId;

  @override
  List<Object?> get props => [goodId];
}

/// Kivásárlás: a célpont (playerId) választása.
class CityBuyoutTargetChanged extends CityEvent {
  const CityBuyoutTargetChanged(this.goodId, this.target);
  final String goodId, target;

  @override
  List<Object?> get props => [goodId, target];
}

class CityBuyoutPointsChanged extends CityEvent {
  const CityBuyoutPointsChanged(this.goodId, this.pts);
  final String goodId;
  final int pts;

  @override
  List<Object?> get props => [goodId, pts];
}

class CityBuyoutSubmitted extends CityEvent {
  const CityBuyoutSubmitted(this.goodId);
  final String goodId;

  @override
  List<Object?> get props => [goodId];
}

// ---------------------------------------------------------------- Városháza

class CityPartyFounded extends CityEvent {
  const CityPartyFounded();
}

class CityProgramPicked extends CityEvent {
  const CityProgramPicked(this.level);
  final String level;

  @override
  List<Object?> get props => [level];
}

class CityFestivalRequested extends CityEvent {
  const CityFestivalRequested();
}

class CityNewsTemplateChanged extends CityEvent {
  const CityNewsTemplateChanged(this.template);
  final String template;

  @override
  List<Object?> get props => [template];
}

class CityNewsTargetChanged extends CityEvent {
  const CityNewsTargetChanged(this.target);
  final String target;

  @override
  List<Object?> get props => [target];
}

class CityNewsGoodChanged extends CityEvent {
  const CityNewsGoodChanged(this.good);
  final String good;

  @override
  List<Object?> get props => [good];
}

class CityNewsSubmitted extends CityEvent {
  const CityNewsSubmitted();
}

// ---------------------------------------------------------------- Alvilág

class CitySpyHired extends CityEvent {
  const CitySpyHired();
}

class CityGuardPosted extends CityEvent {
  const CityGuardPosted();
}

/// A „Kém áthelyezése” párbeszéd megnyitása.
class CityMoveSpyOpened extends CityEvent {
  const CityMoveSpyOpened();
}

/// A kém célvárosa kiválasztva: a parancs a vázlatra kerül, a párbeszéd bezárul.
class CityMoveSpyPicked extends CityEvent {
  const CityMoveSpyPicked(this.to);
  final String to;

  @override
  List<Object?> get props => [to];
}

/// Kifürkészés egy rivális érlelő parancslapja ellen.
class CitySpyRequested extends CityEvent {
  const CitySpyRequested(this.target);
  final String target;

  @override
  List<Object?> get props => [target];
}

/// Hír ellenőrzése vagy (ha hamisnak bizonyult) leleplezése.
class CityNewsChecked extends CityEvent {
  const CityNewsChecked(this.newsId);
  final String newsId;

  @override
  List<Object?> get props => [newsId];
}

/// Egy kifürkészett terv eladásának párbeszéde.
class CityIntelSaleOpened extends CityEvent {
  const CityIntelSaleOpened(this.intelId);
  final String intelId;

  @override
  List<Object?> get props => [intelId];
}

class CityIntelBuyerChanged extends CityEvent {
  const CityIntelBuyerChanged(this.buyer);
  final String buyer;

  @override
  List<Object?> get props => [buyer];
}

class CityIntelPriceChanged extends CityEvent {
  const CityIntelPriceChanged(this.price);
  final String price;

  @override
  List<Object?> get props => [price];
}

class CityIntelSaleSubmitted extends CityEvent {
  const CityIntelSaleSubmitted();
}

/// Egy párbeszéd (kém áthelyezése, eladás) bezárult választás nélkül.
class CityDialogClosed extends CityEvent {
  const CityDialogClosed();
}

class CityOfferAccepted extends CityEvent {
  const CityOfferAccepted(this.offerId);
  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

class CityOfferDeclined extends CityEvent {
  const CityOfferDeclined(this.offerId);
  final String offerId;

  @override
  List<Object?> get props => [offerId];
}
