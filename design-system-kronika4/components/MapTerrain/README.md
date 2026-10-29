# MapTerrain

The detailed, painted landscape layer: every element is its own drawing, with shadow and light.

**What the caller provides** (all optional):

- `sea`: sea path; along the coast sand, shallow and deep water, three rows of foam and wave marks.
- `rivers`: a path or `{d, w}` (width); sandy banks, deep channel, current line.
- `bridges` (`[x, y, angle]`): stone bridge with arches.
- `lakes` (`[x, y, rx, ry]`), `islands` (`[x, y, size]`).
- `mountains` (`[x, y, size]`): a mountain with sunny and shaded sides, ridge lines, hatching, a snowcap and rocks at its foot.
- `hills`: hills.
- `forests` (`[x, y, size, pine ratio]`): dense, mixed forest with forest-floor shading.
- `farms` (`[x, y, columns, rows, rotation, farmstead]`): patchwork fields with hedges, bushes, grazing sheep and a farmstead.
- `fields`, `villages` (`[x, y, number of houses]`), `windmills`, `mines`, `lighthouses`, `ships`, `whales`, `marsh`.
- `labels` (`[x, y, text, 'sea' | 'region', rotation]`): region name, sea name.
