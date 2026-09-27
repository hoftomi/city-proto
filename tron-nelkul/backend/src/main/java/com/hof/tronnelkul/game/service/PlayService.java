package com.hof.tronnelkul.game.service;

import com.hof.tronnelkul.common.ApiException;
import com.hof.tronnelkul.api.model.OfferRequest;
import com.hof.tronnelkul.api.model.OrderRequest;
import com.hof.tronnelkul.game.engine.EngineState.Order;
import com.hof.tronnelkul.game.engine.Rules;
import com.hof.tronnelkul.game.model.PlayerRepository;
import org.springframework.stereotype.Service;

import java.util.UUID;

/** A játékos műveletei: vázlat, lepecsételés, információs piac. */
@Service
public class PlayService {
    private final PlayerRepository players;
    private final GameRunner runner;

    public PlayService(PlayerRepository players, GameRunner runner) { this.players = players; this.runner = runner; }

    String playerId(String gameId, UUID userId) {
        return players.findByGameIdAndUserId(gameId, userId).orElseThrow(() -> ApiException.forbidden("Nem vagy tagja ennek a játéknak.")).id.toString();
    }

    public void addOrder(String gameId, UUID userId, OrderRequest r) {
        String me = playerId(gameId, userId);
        Order o = new Order();
        o.type = r.getType(); o.city = r.getCity(); o.good = r.getGood(); o.level = r.getLevel(); o.pts = r.getPts() == null ? 0 : r.getPts();
        o.target = r.getTarget(); o.template = r.getTemplate(); o.newsId = r.getNewsId(); o.lapId = r.getLapId(); o.orderId = r.getOrderId();
        o.from = r.getFrom(); o.to = r.getTo();
        runner.mutate(gameId, (g, e) -> e.addDraft(me, o));
    }

    public void removeOrder(String gameId, UUID userId, String orderId) {
        String me = playerId(gameId, userId);
        runner.mutate(gameId, (g, e) -> { e.removeDraft(me, orderId); return null; });
    }

    public void seal(String gameId, UUID userId) {
        String me = playerId(gameId, userId);
        runner.mutate(gameId, (g, e) -> e.seal(me, e.s.clock, g.maturationMinutes));
    }

    public void offer(String gameId, UUID userId, String intelId, OfferRequest r) {
        String me = playerId(gameId, userId);
        int price = r.getPrice() == null ? Rules.INFO_PRICE : r.getPrice();
        runner.mutate(gameId, (g, e) -> { e.offerIntel(me, intelId, r.getBuyerId(), price); return null; });
    }

    public void accept(String gameId, UUID userId, String offerId) {
        String me = playerId(gameId, userId);
        runner.mutate(gameId, (g, e) -> { e.acceptOffer(me, offerId); return null; });
    }

    public void decline(String gameId, UUID userId, String offerId) {
        String me = playerId(gameId, userId);
        runner.mutate(gameId, (g, e) -> { e.declineOffer(me, offerId); return null; });
    }
}
