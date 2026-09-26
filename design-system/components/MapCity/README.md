# MapCity

Egy városállam jelölője és felirata a térképen.

**Mit ad a hívó:** `x`, `y`, `name`, `keyCity`, `state` (`reachable` | `unreachable` | `cut`), `stability`, `labelSide` (`right` | `left`).

- `reachable`: verdigris udvar, vagyis a hálózatod része, akciózhatsz.
- `unreachable`: szaggatott, halvány. Nem vezet oda útvonalad (4.3).
- `cut`: `danger` színű. Elvágott város, ahol a befolyásod megmaradt, de új akció nem indítható (4.6).
- A kulcsváros nagyobb, telt maggal és `map-label-major` felirattal jelenik meg. Instabil városnál „!” vagy „!!” jel áll a pont fölött.
