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

/// The clock ticks every 15 seconds (for countdowns and auto-refresh).
class GameTicked extends GameEvent {
  const GameTicked();
}

/// The city selected on the map.
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

/// Offering an intel to a named house (7.5).
class GameIntelOffered extends GameEvent {
  const GameIntelOffered(this.intelId, this.buyerId, this.price, {this.success});
  final String intelId, buyerId;
  final int price;

  /// The success message (e.g. "Offered: Crowcastle, 12 G."); defaults to "Offer sent".
  final Tr? success;

  @override
  List<Object?> get props => [intelId, buyerId, price, success];
}

class GameOfferAccepted extends GameEvent {
  const GameOfferAccepted(this.offerId, {this.success});
  final String offerId;

  /// The success message (e.g. "Bought: Crowcastle's plans."); defaults to "Information bought".
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
