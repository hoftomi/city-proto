# MapViewport

Nagyítható, húzható ablak a világtérképhez és a városnézethez. Fa és bronz keretben áll, jobb alul nagyítás, kicsinyítés és „teljes nézet” gombbal.

**Mit ad a hívó:** `zoom` (1 = teljes szélesség), `onZoom(z)`, `min` (1), `max` (3), `focus` (`[x, y]` 0–1 arányban: erre a pontra áll be nagyításkor), `aspect` (az ablak képaránya, például `"360 / 260"`), `children` (egy `MapCanvas` vagy `CityView`).

- Telefonon ujjal görgethető, asztali gépen egérrel húzható. A húzás nem vált ki kattintást a térképen.
- A nagyítás 0,6-os lépésekben halad.
- A városra koppintás után a `focus` a kijelölt városra vagy negyedre áll.
- A világtérkép 2×, a városnézet 1,8× nagyítással indul, hogy a rajzok részletei látsszanak.
