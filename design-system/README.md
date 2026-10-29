The *Trón nélkül* interface is a political map table: paper, ink, heraldic colors and sealing wax. The player reads reports, makes decisions and seals their orders. The interface serves this rhythm, not the flashing of action games. The primary platform is the phone (responsive web); larger screens get the same order, in more columns.

## Tone and copy

- Hungarian language, informal address: „Lebuktál Feketerévben” (You were exposed in Feketerév), „Parancsaid lepecsételve” (Your orders are sealed).
- Button labels are verbs or verbal nouns: „Parancsok lepecsételése” (Seal orders), „Útvonal kiépítése” (Build route). Never „OK” or „Küldés” (Send).
- Game terms are the rulebook's words, capitalized where they are there: Parancspont (PP, command point), Legitimitás (L, Legitimacy), Semleges (Neutral), Ismeretlen (Unknown), Gyanú (Suspicion), Útzár (Roadblock), Kiűzetés (Banishment). Abbreviations: A, BP, KE, L, PP.
- Decimal comma and a real minus sign: `42,0`, `−2`. Ranges with an en dash: `20–30`.
- The chronicle sentence of a report is in past or present tense and matches the quality of the source. Weak source: „valószínűleg” (probably). Strong source: exact numbers, firm statements.
- No emoji. An exclamation mark appears only in the instability marker on the map.

## Color

- The page is `paper`, cards and sheets are `paper-raised`, input fields and table headers are `paper-sunk`. Separation uses a `line` hairline, not shadows.
- Text is `ink`, secondary text `ink-muted`. Both give at least 4.5:1 contrast on all three papers, in both themes.
- **Verdigris** is the only interaction accent color: links, the selected tab, the player's own routes and reachable cities, the focus ring.
- **Seal** (sealing wax) is used exclusively for sealing orders. It does not mean error and must not be used elsewhere.
- Status colors: `danger` (exposure, Banishment, cut-off city, Roadblock), `warn` (Suspicion 1–2, Unsettled), `ok` (success, Stable). `ok` is blue, so states are never distinguished by a red–green pair alone. Every status color comes with a word or an icon.
- **House colors are heraldic tinctures**: `house-voros` (red), `house-kek` (blue), `house-zold` (green), `house-arany` (gold), `house-bibor` (purple), `house-fekete` (black), `house-narancs` (orange), `house-szeder` (mulberry). A house's color is the same everywhere: crest, influence bar, estate, rival route. These are marker colors (at least 3:1 on paper), not meant for text.
- The **branches of power** (Marketplace, Town Hall, Underworld) have marker colors: `branch-vasarter` (amber), `branch-varoshaza` (azure), `branch-alvilag` (dusk violet), plus a neutral `branch-kozos` for common actions (route). Each has a `-soft` background color. These may **only** color the branch icon backgrounds (`GameIcon` tile), the underline of the selected tab and branch labels. They never appear on the influence bar, the map or crests; there, color always means a house.
- Neutral is a `share-neutral` base with `line-strong` hatching. Unknown (hidden) is a `share-unknown` base with a dot pattern. Thanks to the two patterns these can be told apart from houses in black and white too.

## Typography

- **Alegreya SC** (`display`, `map-label`, `map-label-major`): the lettering of old maps. Use it for city names, house names and screen titles, never for running text.
- **Alegreya Sans** (`title`, `heading`, `body`, `body-strong`, `label`, `caption`): all interface text. `label` is an uppercase, letter-spaced eyebrow label.
- **Alegreya italic** (`chronicle`): the chronicle sentence of reports, the voice of the world.
- **IBM Plex Mono** (`data`, `data-lg`): every compared number, i.e. influence, cost, PP, timer. With tabular figures.
- All four families have the full Hungarian accent set (ő, ű). The fonts load from Google Fonts, at the top of `components/bundle.css`.

## Spacing, corners, layout

- 4px base: `space-1` … `space-8`. The phone side margin is `space-4`, and so is the card padding.
- Maps are angular: `radius-xs` for chips, `radius-sm` for buttons, fields and cards, `radius-md` for sheets. Only the seal and dots are round: `radius-full` (seal button, PP dot, city marker).
- Touch targets are at least 44px tall.
- On the phone: one column and a bottom sheet (`Sheet`). Above 720px the sheet is centered, and views can be split into two columns (for example map and reports).
- One `primary` button per screen. Sealing is the `seal` button.
- Focus: `focus-ring`, i.e. a 2px paper gap, then 2px solid verdigris. At least 3:1 contrast on every surface.

## Map

The map is a copper-engraved regional map, not a satellite image.

- **Layers from bottom to top:** paper and graticule (`MapCanvas`), terrain (`MapTerrain`), routes (`MapRoute`), estates (`MapEstate`), cities (`MapCity`), and finally the compass rose (`MapCompass`) and the cartouche (`MapCartouche`).
- **Terrain:** sea with coastline ripples (`map-sea`, `map-sea-line`), rivers, hatched mountains, forest patches (`map-forest`), fields and marsh with furrow-like lines (`map-relief`). Terrain is always quieter than game information: thin lines, muted colors.
- **Route states:** unbuilt (dotted), own (thick verdigris), under construction (dashed verdigris), rival (the house's tincture), Roadblock (`danger`, prohibition sign), closure caused by an event (grey, dashed).
- **City states:** reachable (verdigris halo), unreachable (dashed, faint), cut off (`danger`). A key city is larger, with a filled core. An unstable city has a „!” mark above the dot, a rioting one „!!”.
- The cartouche gives the scale in days of travel, because in the game distance is measured in steps, not kilometers.

## City view

The city-state is a bird's-eye ground plan (`CityView`): a wall with bastions and four gates, building blocks (`map-block`), and the district of each of the three branches of power with its own building.

- **Town Hall (Politics):** the palace with a courtyard and four corner towers.
- **Underworld (Spy Network):** the star fort, the hideout of the city's underworld.
- **Marketplace (Merchants):** the market square with stalls and a well. Port cities also have piers and ships.
- The Dominant house's flag flies above the district. In a close race the second house's smaller flag is there too.
- An Unsettled city shows smoke, a Rioting one shows flames.
- Tapping a district selects it (verdigris) and opens the branch's card below. The same is reachable through the tabs (`Tabs`), because the illustration must not be the only path.
- The building blocks are generated from the city's name, so every city has its own, stable layout.

## Views

The **Map view** and **City view** pages show the phone screens assembled: `AppBar` on top, `NavBar` at the bottom, and the view content in between with `space-4` spacing.

## Icons

Own line icon set in the bundle (`Icon`): 24 grid, 1.75 stroke, rounded caps, `currentColor`. These are the interface's control icons (navigation, status, close, clock).

The game's things have their own **filled, illustrative** icon set too (`GameIcon`): resources, goods, actions and the three branches. Style: 24 grid, dark brown (`ic-line`) 1.1 outline, filled color areas from the `ic-*` paints, a single white highlight. The paints are theme-independent; in dark theme the icon gets a thin light halo so the outline does not get lost.

- Resource: `arany` (gold), `pp`, `legit`, `nep` (popularity), `ado` (tax).
- Good: `gabona`, `bor`, `vas`, `ko`, `so`, `hal`, `fuszer`, `tozeg`, `csempesz`, `gyapju`, `lo`.
- Branch: `vasarter`, `varoshaza`, `alvilag`.
- Action (by the action id): `route`, `margin`, `buyShares`, `buyout`, `defend`, `foundParty`, `program`, `festival`, `news`, `hireSpy`, `guard`, `spy`, `verify`, `debunk`.

`tile` draws a tile behind the icon. With `tile: true` the action gets its own branch's color, so on the order sheet you can see at a glance which branch you are acting in. New game icons should be made in the same style. Emoji and external icon sets are still not allowed.

## Logo

There is no logo yet. The game's name appears as text in Alegreya SC.
