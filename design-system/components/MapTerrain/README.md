# MapTerrain

The copper-engraving-style terrain layer of the map: sea with coastline ripples, rivers, hatched mountains, forests, fields, marsh.

**What the caller provides:** `sea` (SVG path, closed), `rivers` (paths), `mountains` (`[x, y, size]`), `forests` (`[x, y, number of trees]`), `fields` (`[x, y, width, height, rotation]`), `marsh` (`[x, y, count]`).

- It should be the first child of `MapCanvas`, so it goes under routes and cities.
- Purely decorative (`aria-hidden`). It must never carry game information: reachability and states are shown by `MapRoute` and `MapCity`.
- Forests and marsh are generated deterministically from the coordinates, so they look the same on every load.
- Colors: `map-sea`, `map-sea-line`, `map-relief`, `map-forest`.
