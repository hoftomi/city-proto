# MapRoute

Egy él a térképen, a rajta lévő útvonal állapotával.

**Mit ad a hívó:** `from`, `to` (`[x, y]`), `state` (`base` | `own` | `pending` | `rival` | `blocked` | `closed`), `tincture` (a `rival` állapotnál).

- `base`: pontozott, kiépítetlen út. `own`: vastag verdigris. `pending`: szaggatott verdigris, a következő körtől él. `rival`: a rivális ház tinktúrája. `blocked`: Útzár, `danger` színű, középen tiltójellel. `closed`: eseményből adódó lezárás, szürke és szaggatott.
