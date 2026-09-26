package hu.webstar.tronnelkul.game.engine;

/** Egy ház (játékos vagy NPC) állapota a kör feldolgozása alatt. */
public final class PlayerState {
    public final String id;
    public final String name;
    public final String tincture;
    public final boolean npc;
    public final String persona;      // NPC-jellem: kalmar, nemzetseg, zsoldos, arnyek
    public final Faction favorite;    // NPC kedvenc frakciója
    public final Faction bonusFaction; // háttértípusból adódó ×1,25 (null, ha nincs)
    public final String estateNode;   // "birtok:<id>" vagy null (az NPC-k hálózata nem korlátozott)
    public int pp, arany, bp, ke, legit;
    public int npcCooldown;
    public int sealedRound;

    public PlayerState(String id, String name, String tincture, boolean npc, String persona, Faction favorite,
                       Faction bonusFaction, String estateNode) {
        this.id = id; this.name = name; this.tincture = tincture; this.npc = npc; this.persona = persona;
        this.favorite = favorite; this.bonusFaction = bonusFaction; this.estateNode = estateNode;
    }
}
