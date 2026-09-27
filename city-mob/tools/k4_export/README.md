# Krónika IV – rajzok exportja az apphoz

A térkép, a városkép, a várak, a birtokok, a játékikonok és a belépőkép a **Krónika IV design system** React-komponenseiből készül (`../../../prototype-kronika4/src/ds`). Az app nem rajzolja újra őket, hanem a kész képeket használja az `assets/k4/` mappából.

```bash
npm install
npm run export                         # minden (kb. 15 perc)
ONLY=cities,cityview npm run export    # csak egyes részek: icons, login, maps, cities, estates, cityview
```

Kell hozzá Google Chrome (headless képkészítés), `cwebp` és internet (a Cinzel és a Nunito Sans betű a Google Fontsról töltődik).

## Mit készít

| Kimenet | Forrás | Formátum |
|---|---|---|
| `icons/<név>.svg` | `GameIcon` | SVG, a tokenek beégetve |
| `login.svg` | a prototípus belépőképe | SVG |
| `map/<térkép>.webp` | `MapCanvas` + `MapTerrain` + iránytű + kartus, városok és utak nélkül | 360 × 260, 8× |
| `cities/<város>_on.webp`, `_off.webp` | `MapCity` felirattal, elérhető és nem elérhető | 8× |
| `estates/<tinktúra>[_npc].webp` | `MapEstate` | 8× |
| `cityview/<város>.webp` | `CityView`, kijelölés nélkül | 720 × 540, 3× |
| `k4.json` | kivágási keretek, a negyedek sokszögei és feliratai, a térképek városai | JSON |

- A térképek városai és domborzata a backend `MapRegistry.java` fájljából jönnek. A Délkelet domborzata a prototípus részletesebb változata (`game/world.js`).
- A városkép rajzának apró részletei a város nevéből véletlenszerűek, ezért minden városnak saját képe van.

## Mit rajzol az app maga

- **Utak:** a `MapRoute` stílusában (`lib/widgets/map_view.dart`).
- **Kijelölés:** a kijelölt város gyűrűje és a kijelölt negyed sokszöge.
- **Zászlók:** a negyed vezető házának zászlója.
- **Feliratok:** a „Birtokod” felirat.
- **Nagyítható keret:** `lib/widgets/k4_viewport.dart`, a `MapViewport` megfelelője.

Ha a design system rajza változik, futtasd újra az exportot. Ha a térképen új város vagy kezdőhely van, a `maps` és a `cities` részt is futtasd újra.
