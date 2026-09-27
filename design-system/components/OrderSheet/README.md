# OrderSheet

A kör parancslapja: a sorba állított akciók költséggel, a PP-összeg és a lepecsételés.

**Mit ad a hívó:** `orders` (`[{label, city, faction?, note?, cost: {pp, arany, bp, ke}, hidden?}]`), `available` (PP), `round`, `sealed`, `onSeal`.

- A lepecsételés a `seal` gombbal történik. Ez az egyetlen hely, ahol pecsétviasz szín jelenik meg.
- PP-túllépésnél az összeg `danger` színű lesz, és a pecsét gomb letiltódik.
- A rejtett akciót szürke „Rejtett” címke jelzi, a `share-unknown` színnel, ugyanazzal, amivel a befolyássáv Ismeretlen sora is készül.
- Parancsonként `art`: az akció azonosítója, ágszínű csempés ikont kap a sor elején.
