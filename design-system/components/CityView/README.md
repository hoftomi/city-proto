# CityView

The illustrated ground plan of a city-state: a wall with bastions and gates, building blocks, and the district of each of the three factions with its own building. Upper Town (Nobility) with the palace, Citadel (Military) with the star fort, Marketplace (Merchants) with the market.

**What the caller provides:** `name` (the building blocks are generated from it, so every city has its own, stable layout), `coast` (port, piers, ships), `stability` (`ingatag`: smoke, `lazongo`: flames), `districts` (`{nemesseg|kereskedok|katonasag: {dominant?: tincture, contested?: tincture}}`), `selected`, `onSelect(faction)`.

- A district's flag is the Dominant house's tincture. If a second house is within 5 points of it, a smaller flag hangs next to it.
- With `onSelect` the districts act as buttons (click, Enter, Space), and the selected district gets a verdigris highlight.
- Always put a textual faction list below the image (see the City view page). The illustration does not replace the numbers.
