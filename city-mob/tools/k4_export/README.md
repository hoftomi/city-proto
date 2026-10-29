# Krónika IV – drawing export for the app

The map, the city view, the castles, the estates, the game icons and the login artwork are rendered from the React components of the **Krónika IV design system** (`../../../prototype-kronika4/src/ds`). The app does not redraw them; it uses the finished images from the `assets/k4/` folder.

```bash
npm install
npm run export                         # everything (about 15 minutes)
ONLY=cities,cityview npm run export    # selected parts only: icons, login, maps, cities, estates, cityview
```

Requires Google Chrome (headless screenshots), `cwebp` and internet access (the Cinzel and Nunito Sans fonts load from Google Fonts).

## Output

| Output | Source | Format |
|---|---|---|
| `icons/<name>.svg` | `GameIcon` | SVG, tokens baked in |
| `login.svg` | the prototype's login artwork | SVG |
| `map/<map>.webp` | `MapCanvas` + `MapTerrain` + compass + cartouche, without cities and roads | 360 × 260, 8× |
| `cities/<city>_on.webp`, `_off.webp` | `MapCity` with label, reachable and unreachable | 8× |
| `estates/<tincture>[_npc].webp` | `MapEstate` | 8× |
| `cityview/<city>.webp` | `CityView`, without selection | 720 × 540, 3× |
| `k4.json` | crop boxes, the district polygons and labels, the maps' cities | JSON |

- The maps' cities, start slots and terrain come from the backend `MapRegistry.java`; their display names come from the backend i18n file `world.json`. The Délkelet terrain is the prototype's more detailed version (`game/world.js`).
- File names and `k4.json` keys use the app's English ids. The prototype still uses Hungarian names, so `export.mjs` maps them (`ICON_ID`, `TINCTURE_ID`, `BRANCH_ID`, `DISTRICT_ID`).
- Small details of a city view drawing are randomised from the city's name, so every city has its own image.

## What the app draws itself

- **Roads:** in the style of `MapRoute` (`lib/widgets/map_view.dart`).
- **Selection:** the ring around the selected city and the polygon of the selected district.
- **Flags:** the flag of the district's leading house.
- **Labels:** the "Birtokod" ("Your estate") label.
- **Zoomable frame:** `lib/widgets/k4_viewport.dart`, the counterpart of `MapViewport`.

If the design system's drawings change, run the export again. If a map gets a new city or start slot, also rerun the `maps` and `cities` parts.
