# GameIcon

Teli, illusztratív ikon a játék dolgaihoz: erőforrás, árucikk, hatalmi ág és akció. A vezérlőikonok (navigáció, állapot) továbbra is az `Icon` vonalikonjai.

**Mit ad a hívó:** `name`, `size` (alapérték 20), `label` (ha az ikon önállóan hordoz jelentést), `tile` (`true` = az akció ágának csempéje; vagy `vasarter` | `varoshaza` | `alvilag` | `kozos`).

- Erőforrás: `arany`, `pp`, `legit`, `nep`, `ado`.
- Árucikk: `gabona`, `bor`, `vas`, `ko`, `so`, `hal`, `fuszer`, `tozeg`, `csempesz`, `gyapju`, `lo`.
- Ág: `vasarter`, `varoshaza`, `alvilag`.
- Akció: `route`, `margin`, `buyShares`, `buyout`, `defend`, `foundParty`, `program`, `festival`, `news`, `hireSpy`, `guard`, `spy`, `verify`, `debunk`.

Ismeretlen névnél a vonalikonra esik vissza. A festékek az `ic-*` tokenek, a csempe színe a `branch-*` tokenekből jön.

Kapcsolódó propok más komponensekben:

- `Button`: `art` (játékikon a felirat előtt, az `icon` helyett).
- `Tabs`: fülenként `art` (ikon) és `tone` (ágszínű aláhúzás).
- `OrderSheet`: parancsonként `art` (az akció csempés ikonja).
- `ResourceChip`: az `arany`, `pp`, `legit`, `nep`, `ado` fajta automatikusan játékikont kap.
