# CityView

Egy városállam izometrikus, kézzel komponált, festett látképe (720 × 540). Kevesebb, de kidolgozott épületből áll: minden épület valódi 3D-s tömeg két látható fallal és tetővel, a fényt balról felülről kapja.

**Épületrészletek:**

- Tetők: nyereg-, konty- és gúlatető, cserép-, pala- és nádfedés sorokkal, gerinccel és oromdeszkával, tetőablakok.
- Falak: kőrakás, favázas és kiugró emeletek, vakolat, deszka.
- Nyílászárók: zsalus, íves és ólomüveg ablakok, virágládák, deszkás ajtók kilincsel, boltponyvák, cégérek, erkélyek.
- Kémények füsttel, vetett árnyékok.

**Kerületek:**

- **Városháza:** kupolás parlament oszlopcsarnokkal és timpanonnal, két szárny, óratorony, díszkert szökőkúttal.
- **Vásártér:** vásárcsarnok, standok, céhház, kút, szekerek, kápolna harangtoronnyal, kovácsműhely.
- **Alvilág:** éjszakai tónus, düledező házak, fogadó lámpásokkal, romos torony, köd.

**Falak és környék:** pártázatos várfal kerek tornyokkal, kaputornyok csapóráccsal, vizesárok hidakkal; szántók, legelő, pajta, szélmalom, kőbánya, folyó kőhíddal vagy kikötő.

**Mit ad a hívó:** `name`, `coast`, `stability`, `districts`, `selected`, `onSelect(kulcs)`.

- Használd `MapViewport`-ban, `aspect="720 / 540"` és 1,8× nagyítás mellett.
