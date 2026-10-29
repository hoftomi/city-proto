*Trón nélkül – Krónika IV* is the fourth version of Krónika's painted strategy look. The city view is isometric and hand-composed: fewer but detailed buildings with real roof shapes (gable, hip and pyramid roofs, dome), stonework, rows of tiles and slates, half-timbered jettied upper floors, shuttered and arched windows, chimneys and smoke. The city wall is crenellated, and its round towers get conical roofs. The cities on the world map are small isometric castles built from the same asset kit, and the mountains are rocky, snowy peaks. It provides the same components and component API as the earlier versions. Every drawing is our own, original work.

## Tone and copy

- Hungarian language, informal but more measured, chronicle-like voice: „A városi tanács jóváhagyta az adásvételt.” (The city council approved the sale.)
- Button labels are verbs or verbal nouns, with the cost: „Kém felfogadása · 20 A” (Hire spy · 20 gold).
- Game terms are the rulebook's words: Parancspont (PP, command point), Legitimitás (L, Legitimacy), népszerűség (N, popularity), arany (A, gold).
- No emoji. The mood comes from the drawings and the materials.

## Materials and color

- **Table:** the screen background is an old map sheet (`table-hi` → `table`), with faint 48px grid lines and a vignette darkening toward the edges.
- **Parchment:** the base of cards, reports and the order sheet is a `paper-raised` → `paper` gradient. Text is `ink` (13.8:1), secondary text `ink-muted` (at least 5:1 on every surface, the table included).
- **Wood and bronze:** the card frame, header, navigation, table header and map frame are dark wood (`wood`, `wood-hi`, `wood-lo`). A bronze line (`frame`) runs inside. On dark wood the label is light bronze (`frame-hi`, 5.9:1).
- **Depth:** a 3px solid ink rim (`outline`), plus a soft drop shadow (`shadow-card`). The outline is thinner (1–1.5px) than in Mesevilág.
- **Buttons:** matte paints with a top highlight and a bottom rim.
  - Forest green (`btn-green-*`): primary.
  - Steel blue (`btn-blue-*`): default.
  - Bronze (`btn-gold-*`, with dark label): exclusively for sealing.
  - Brick red (`btn-red-*`): dangerous step.
  - Parchment (`btn-cream-*`): quiet step.
  Light labels on colored buttons are at least 4.5:1.
- **Accent:** `verdigris` is steel blue here: link, info, own row.
- **House colors:** painted, muted heraldic tinctures (`house-*`).
- **Branch colors** (`branch-*`): the border of the icon tile and the top stripe of the selected leather tab.

## Typography

- **Cinzel** (`display`): an engraved, Roman inscriptional display face. Screen title, card and report title, tab, city name, cartouche, seal button. Its lowercase renders as small caps.
- **Nunito Sans 600–900** (`sans`): all interface text, buttons and numbers.
- Both load from Google Fonts with the full latin-ext set (ő, ű) (top of `components/bundle.css`).

## Shape and spacing

- 4px base (`space-1` … `space-8`); card padding and the page margin are `space-4`.
- Restrained corners: field 6px, card and map frame 10px, sheet 14px. Only the seal disc, dots and council seats are round.
- Touch targets are at least 44px (small button: 34px, inside cards).

## Map and city

The world map and the city view live in a **`MapViewport`** window: it can be dragged with a finger on the phone or with the mouse on desktop, and zoomed. The world map starts at 2× zoom and the city at 1.8×, so the details are visible. The "full view" button restores the full width.

- **World map:** both the landscape and the cities are richly detailed.
  - Ground: meadow color patches, grass tufts, wildflowers, an inner frame with degree marks.
  - Mountains: sunny and shaded sides, ridges, hatching, snowcaps, rocks.
  - Hills and mixed forests with forest-floor shading.
  - Patchwork fields with hedges, a farmstead and sheep; villages with church towers; windmills.
  - Mine, rivers with sandy banks, stone bridges where roads cross, a lake.
  - Sea: foam, islands, a lighthouse, ships and a whale.
  - Region and sea names in engraved lettering.
  - The cities are small walled towns, with their names on a parchment ribbon.
- **City view** (720 × 540, isometric, hand-composed):
  - Town Hall: a parliament with a copper dome, colonnade and pediment, two wings, a clock tower, a formal garden and a fountain.
  - Marketplace: a covered market hall, ten stalls with awnings and wares, a guild hall, a well, carts; burgher houses with shop awnings and signs; a chapel with a bell tower; a smithy with a glowing fire.
  - Underworld: night tone, ramshackle houses, an inn with glowing windows and lanterns, a ruined tower, fog and street lamps.
  - Outside the wall: fields in rows, grazing animals, a barn, a windmill, farmsteads, a rocky quarry with a shaft, rails, a mine cart and a crane; a river with a stone bridge or a port with piers.
- **World map:** small isometric castles (wall, corner towers, keep, houses), snowy rocky peaks, varied deciduous and pine trees, iso fields with hedges, grass texture.
- **Painted assets:** shared `kg-*` gradients, paper grain, blurred shadows and softened outlines on both the map and the city.

## Icons

- **Game icons** (`GameIcon`): filled, illustrative icons with a thin ink outline and muted paints (`ic-*`).
  - Resource: `arany`, `pp`, `legit`, `nep`, `ado`.
  - Good: 11 kinds.
  - Branch: 3 kinds.
  - Action: 14 kinds.
  - Navigation: `navTerkep`, `navVaros`, `navJel`, `navRang`.
  - Time: `homokora`.
- **Line icons** (`Icon`): 2px stroke, for controls only.

## Relation to the other styles

Component names, props and class names (`tn-*`) are the same as in the map-table and Mesevilág systems. The namespace here is `window.TronKronika4`. New here is the isometric `i4` asset kit: box, roof, cylinder, cone, window, door, house, tower, wall, rock, tree and plot.
