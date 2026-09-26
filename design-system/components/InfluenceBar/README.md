# InfluenceBar

A frakció 100 támogatáspontjának megoszlása: házak, Ismeretlen (rejtett) és Semleges, a 10 / 25 / 35-ös küszöbökkel.

**Mit ad a hívó:** `faction` (`nemesseg` | `kereskedok` | `katonasag`), `segments` (`[{name, tincture, value, self?}]`, nyílt befolyás), `unknown` (az összes rejtett pont), `precision` (`exact` | `band5` | `band10`, a láthatósági szint szerint), opcionálisan `aside` (például egy `ControlBadge`), `thresholds={false}`, `legend={false}`.

- A Semleges érték a maradék: a komponens számolja, nem a hívó.
- A saját szegmens (`self`) verdigris kontúrt kap, és a jelmagyarázatban mindig pontos értékkel jelenik meg.
- A szegmenseket 2px papírrés választja el, így két hasonló tinktúra is elkülönül, és a jelmagyarázat szövegesen is megadja a neveket.
- Ne színezd frakció szerint: a sáv színei mindig **házakat** jelentenek.
- Az `Ismeretlen` sor minden jelenléttel rendelkező játékosnak látszik. Hogy kié, azt a sáv soha nem mondja meg.
