package com.hof.tronnelkul.game.api;

import com.hof.tronnelkul.api.GameApi;
import com.hof.tronnelkul.api.model.*;
import com.hof.tronnelkul.common.CurrentUser;
import com.hof.tronnelkul.game.service.GameViewService;
import com.hof.tronnelkul.game.service.PlayService;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

/** A játék végpontjai (api/openapi.yaml, `game` tag). Minden módosítás a frissített játékállapotot adja vissza. */
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
    public GameState addOrder(String id, OrderRequest r) {
        UUID u = CurrentUser.id();
        play.addOrder(id, u, r);
        return view.state(id, u);
    }

    @Override
    public GameState removeOrder(String id, String orderId) {
        UUID u = CurrentUser.id();
        play.removeOrder(id, u, orderId);
        return view.state(id, u);
    }

    @Override
    public GameState seal(String id) {
        UUID u = CurrentUser.id();
        play.seal(id, u);
        return view.state(id, u);
    }

    @Override
    public GameState offerIntel(String id, String intelId, OfferRequest r) {
        UUID u = CurrentUser.id();
        play.offer(id, u, intelId, r);
        return view.state(id, u);
    }

    @Override
    public GameState acceptOffer(String id, String offerId) {
        UUID u = CurrentUser.id();
        play.accept(id, u, offerId);
        return view.state(id, u);
    }

    @Override
    public GameState declineOffer(String id, String offerId) {
        UUID u = CurrentUser.id();
        play.decline(id, u, offerId);
        return view.state(id, u);
    }
}
