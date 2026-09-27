# Button

Gomb négy változatban és egy kis méretben. Az alapváltozat a csendes, másodlagos akció.

**Mit ad a hívó:** `variant` (`default` | `primary` | `seal` | `quiet` | `danger`), `size` (`md` | `sm`), `icon` (egy `Icon` név), `children`, és a szokásos gombattribútumok.

- `primary`: tinta alapon, képernyőnként legfeljebb egy.
- `seal`: kizárólag a parancsok lepecsételése.
- `danger`: körvonalas, visszafordíthatatlan vagy lebukással járó akcióhoz (például Lejáratás).
- Az érintési cél legalább 44px magas. A `sm` méret csak kártyákon belül használható.
- A gomb felirata ige: „Lepecsételés”, „Útvonal kiépítése”.
- `art`: teli játékikon (`GameIcon`) a felirat előtt, az `icon` helyett. Akciógombokon ezt használd.
