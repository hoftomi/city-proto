# MapViewport

A zoomable, draggable window for the world map and the city view. It sits in a wood and bronze frame, with zoom in, zoom out and "full view" buttons at the bottom right.

**What the caller provides:** `zoom` (1 = full width), `onZoom(z)`, `min` (1), `max` (3), `focus` (`[x, y]` as 0–1 fractions: the point it centers on when zooming), `aspect` (the window's aspect ratio, for example `"360 / 260"`), `children` (a `MapCanvas` or `CityView`).

- Scrollable with a finger on the phone, draggable with the mouse on desktop. Dragging does not trigger a click on the map.
- Zoom moves in steps of 0.6.
- After tapping a city, `focus` moves to the selected city or district.
- The world map starts at 2× zoom and the city view at 1.8×, so the details of the drawings are visible.
