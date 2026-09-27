import 'package:injectable/injectable.dart';
import 'package:tron_api/tron_api.dart';

/// A generált Dio-kliens (packages/tron_api) vékony burka: a válasz adatát adja vissza, hibánál DioExceptiont dob.
/// A hibák Failure-ré alakítása a repositoryk dolga.

@lazySingleton
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._api);
  final AuthApi _api;

  Future<UserDto> me() async => (await _api.getMe()).data!;

  Future<String> discordCustomToken(String code, String verifier, String redirectUri) async =>
      (await _api.discordLogin(discordRequest: DiscordRequest(code: code, codeVerifier: verifier, redirectUri: redirectUri))).data!.customToken;
}

@lazySingleton
class LobbyRemoteDataSource {
  LobbyRemoteDataSource(this._api);
  final LobbyApi _api;

  Future<List<GameSummary>> games() async => (await _api.listGames()).data!;

  Future<GameDetail> game(String id) async => (await _api.getGame(id: id)).data!;

  Future<MapDef> map(String mapId) async => (await _api.getMap(mapId: mapId)).data!;

  Future<GameSummary> join(String id, JoinRequest request) async => (await _api.joinGame(id: id, joinRequest: request)).data!;

  Future<void> withdraw(String id) => _api.withdrawGame(id: id);
}

@lazySingleton
class GameRemoteDataSource {
  GameRemoteDataSource(this._api, this._admin);
  final GameApi _api;
  final AdminApi _admin;

  Future<GameState> state(String id) async => (await _api.getState(id: id)).data!;

  Future<GameState> addOrder(String id, OrderRequest order) async => (await _api.addOrder(id: id, orderRequest: order)).data!;

  Future<GameState> removeOrder(String id, String orderId) async => (await _api.removeOrder(id: id, orderId: orderId)).data!;

  Future<GameState> seal(String id) async => (await _api.seal(id: id)).data!;

  Future<GameState> offerIntel(String id, String intelId, String buyerId, int price) async =>
      (await _api.offerIntel(id: id, intelId: intelId, offerRequest: OfferRequest(buyerId: buyerId, price: price))).data!;

  Future<GameState> acceptOffer(String id, String offerId) async => (await _api.acceptOffer(id: id, offerId: offerId)).data!;

  Future<GameState> declineOffer(String id, String offerId) async => (await _api.declineOffer(id: id, offerId: offerId)).data!;

  Future<List<ReportView>> reports(String id) async => (await _api.getReports(id: id)).data!;

  Future<List<RankRow>> ranking(String id) async => (await _api.getRanking(id: id)).data!;

  Future<void> adminSettle(String id) => _admin.adminSettle(id: id);

  /// minutes = null: a következő eseményig.
  Future<void> adminAdvance(String id, int? minutes) => _admin.adminAdvance(id: id, advanceRequest: AdvanceRequest(minutes: minutes));
}
