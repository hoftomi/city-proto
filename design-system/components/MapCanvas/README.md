# MapCanvas

The map sheet: a paper base, a graticule and an SVG canvas that holds the `MapRoute`, `MapEstate` and `MapCity` elements (in this order, so cities are on top).

**What the caller provides:** `width`, `height` (the viewBox size), `grid` (graticule spacing, default 40), `title`, `children`.

- The canvas fills the width and scales proportionally. On the phone it gets the full width, with a 16px margin.
