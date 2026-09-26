# MapTerrain

A térkép rézmetszet-hangulatú domborzati rétege: tenger partvonal-hullámokkal, folyók, hegyek csíkozással, erdők, szántóföldek, mocsár.

**Mit ad a hívó:** `sea` (SVG path, zárt), `rivers` (path-ok), `mountains` (`[x, y, méret]`), `forests` (`[x, y, fák száma]`), `fields` (`[x, y, szélesség, magasság, forgatás]`), `marsh` (`[x, y, darab]`).

- A `MapCanvas` első gyermeke legyen, az útvonalak és városok alá kerül.
- Tisztán dekoratív (`aria-hidden`). Játékinformációt soha ne hordozzon: az elérhetőséget és az állapotokat a `MapRoute` és a `MapCity` mutatja.
- Az erdők és a mocsár a koordinátákból determinisztikusan generálódik, így minden betöltéskor ugyanúgy néz ki.
- Színei: `map-sea`, `map-sea-line`, `map-relief`, `map-forest`.
