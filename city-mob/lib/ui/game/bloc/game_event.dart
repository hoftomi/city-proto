part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  const GameStarted(this.gameId);
  final String gameId;

  @override
  List<Object?> get props => [gameId];
}

class GameRefreshRequested extends GameEvent {
  const GameRefreshRequested();
}

/// Az óra 15 másodpercenként üt (a visszaszámlálókhoz és az automatikus frissítéshez).
class GameTicked extends GameEvent {
  const GameTicked();
}

/// A térképen kijelölt város.
class GameMapCitySelected extends GameEvent {
  const GameMapCitySelected(this.cityId);
  final String cityId;

  @override
  List<Object?> get props => [cityId];
}

class GameOrderAdded extends GameEvent {
  const GameOrderAdded(this.order);
  final OrderRequest order;

  @override
  List<Object?> get props => [order];
}

class GameOrderRemoved extends GameEvent {
  const GameOrderRemoved(this.orderId);
  final String orderId;

  @override
  List<Object?> get props => [orderId];
}

class GameSealRequested extends GameEvent {
  const GameSealRequested();
}

/// Kifürkészett terv felkínálása egy megnevezett háznak (7.5).
class GameIntelOffered extends GameEvent {
  const GameIntelOffered(this.intelId, this.buyerId, this.price, {this.success});
  final String intelId, buyerId;
  final int price;

  /// A sikerüzenet (például „Felkínálva: Varjúvár, 12 A.”); alapból „Ajánlat elküldve”.
  final Tr? success;

  @override
  List<Object?> get props => [intelId, buyerId, price, success];
}

class GameOfferAccepted extends GameEvent {
  const GameOfferAccepted(this.offerId, {this.success});
  final String offerId;

  /// A sikerüzenet (például „Megvetted: Varjúvár tervei.”); alapból „Megvetted az információt”.
  final Tr? success;

  @override
  List<Object?> get props => [offerId, success];
}

class GameOfferDeclined extends GameEvent {
  const GameOfferDeclined(this.offerId);
  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

class GameAdminSettleRequested extends GameEvent {
  const GameAdminSettleRequested();
}

/// minutes = null: a következő eseményig.
class GameAdminAdvanceRequested extends GameEvent {
  const GameAdminAdvanceRequested(this.minutes);
  final int? minutes;

  @override
  List<Object?> get props => [minutes];
}
