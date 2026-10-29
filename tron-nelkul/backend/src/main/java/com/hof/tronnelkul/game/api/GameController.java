package com.hof.tronnelkul.game.api;

import com.hof.tronnelkul.api.GameApi;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.common.CurrentUser;
import com.hof.tronnelkul.game.service.GameViewService;
import com.hof.tronnelkul.game.service.PlayService;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

/** Game endpoints (api/openapi.yaml, `game` tag). Every change returns the updated game state. */
@RestController
public class GameController implements GameApi {
    private final GameViewService view;
    private final PlayService play;

    public GameController(GameViewService view, PlayService play) { this.view = view; this.play = play; }

    @Override
    public GameState getState(String id) { return view.state(id, CurrentUser.id()); }

    @Override
    public List<ReportView> getReports(String id) { return view.reports(id, CurrentUser.id()); }

    @Override
    public List<RankRow> getRanking(String id) { return view.ranking(id, CurrentUser.id()); }

    @Override
    public GameState addOrder(String id, OrderRequest request) {
        UUID userId = CurrentUser.id();
        play.addOrder(id, userId, request);
        return view.state(id, userId);
    }

    @Override
    public GameState removeOrder(String id, String orderId) {
        UUID userId = CurrentUser.id();
        play.removeOrder(id, userId, orderId);
        return view.state(id, userId);
    }

    @Override
    public GameState seal(String id) {
        UUID userId = CurrentUser.id();
        play.seal(id, userId);
        return view.state(id, userId);
    }

    @Override
    public GameState offerIntel(String id, String intelId, OfferRequest request) {
        UUID userId = CurrentUser.id();
        play.offer(id, userId, intelId, request);
        return view.state(id, userId);
    }

    @Override
    public GameState acceptOffer(String id, String offerId) {
        UUID userId = CurrentUser.id();
        play.accept(id, userId, offerId);
        return view.state(id, userId);
    }

    @Override
    public GameState declineOffer(String id, String offerId) {
        UUID userId = CurrentUser.id();
        play.decline(id, userId, offerId);
        return view.state(id, userId);
    }
}
