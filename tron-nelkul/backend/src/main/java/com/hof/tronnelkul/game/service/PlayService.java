package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.api.model.OfferRequest;
import com.hof.tronnelkul.api.model.OrderRequest;
import com.hof.tronnelkul.game.engine.EngineState.Order;
import com.hof.tronnelkul.game.engine.Rules;
import com.hof.tronnelkul.game.model.GameEntity;
import com.hof.tronnelkul.game.model.PlayerRepository;
import org.springframework.stereotype.Service;

import java.util.UUID;

/** Player operations: draft, sealing, information market. */
@Service
public class PlayService {
    private final PlayerRepository playerRepository;
    private final GameRunner runner;

    public PlayService(PlayerRepository playerRepository, GameRunner runner) { this.playerRepository = playerRepository; this.runner = runner; }

    String playerId(String gameId, UUID userId) {
        return playerRepository.findByGameIdAndUserId(gameId, userId).orElseThrow(() -> ApiException.forbidden("server.not_a_member")).getId().toString();
    }

    public void addOrder(String gameId, UUID userId, OrderRequest request) {
        String me = playerId(gameId, userId);
        Order order = new Order();
        order.type = request.getType(); order.city = request.getCity(); order.good = request.getGood(); order.level = request.getLevel(); order.pts = request.getPts() == null ? 0 : request.getPts();
        order.target = request.getTarget(); order.template = request.getTemplate(); order.newsId = request.getNewsId(); order.sheetId = request.getSheetId(); order.orderId = request.getOrderId();
        order.from = request.getFrom(); order.to = request.getTo();
        runner.mutate(gameId, (game, engine) -> engine.addDraft(me, order));
    }

    public void removeOrder(String gameId, UUID userId, String orderId) {
        String me = playerId(gameId, userId);
        runner.mutate(gameId, (game, engine) -> { engine.removeDraft(me, orderId); return null; });
    }

    public void seal(String gameId, UUID userId) {
        String me = playerId(gameId, userId);
        runner.mutate(gameId, (game, engine) -> engine.seal(me, engine.state.clock, GameEntity.MATURATION_MINUTES));
    }

    public void offer(String gameId, UUID userId, String intelId, OfferRequest request) {
        String me = playerId(gameId, userId);
        int price = request.getPrice() == null ? Rules.INFO_PRICE : request.getPrice();
        runner.mutate(gameId, (game, engine) -> { engine.offerIntel(me, intelId, request.getBuyerId(), price); return null; });
    }

    public void accept(String gameId, UUID userId, String offerId) {
        String me = playerId(gameId, userId);
        runner.mutate(gameId, (game, engine) -> { engine.acceptOffer(me, offerId); return null; });
    }

    public void decline(String gameId, UUID userId, String offerId) {
        String me = playerId(gameId, userId);
        runner.mutate(gameId, (game, engine) -> { engine.declineOffer(me, offerId); return null; });
    }
}
