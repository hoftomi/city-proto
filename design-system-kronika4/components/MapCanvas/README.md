# MapCanvas

The base of the painted map:

- a meadow-green gradient with blurred color patches and relief light-and-shadow patches, so the ground is not a single color;
- sparse grass tufts and wildflowers;
- dense grass texture and paper grain (`kg-grain`) over the whole sheet, which makes it look painted rather than drawn in a vector tool;
- warm light coming from the top left corner and a vignette darkening toward the edges;
- an inner frame line with degree marks.

The sheet also loads the shared `kg-*` painted asset kit (gradients, filters), used by the mountains, trees and fields. The outlines are a softened ink brown.

**What the caller provides:** `width`, `height`, `title`, `children`.

The sheet also loads the isometric `i4` gradients, so the map's cities, mountains, trees and fields are drawn with the same material as the city view.
