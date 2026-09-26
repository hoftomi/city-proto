# CityView

Egy városállam illusztrált alaprajza: fal bástyákkal és kapukkal, háztömbök, és a három frakció negyede a saját épületével. Felsőváros (Nemesség) a palotával, Citadella (Katonaság) a csillagerőddel, Vásártér (Kereskedők) a piaccal.

**Mit ad a hívó:** `name` (ebből generálódnak a háztömbök, így minden városnak saját, állandó rajzolata van), `coast` (kikötő, mólók, hajók), `stability` (`ingatag`: füst, `lazongo`: lángok), `districts` (`{nemesseg|kereskedok|katonasag: {dominant?: tincture, contested?: tincture}}`), `selected`, `onSelect(faction)`.

- A negyed zászlaja a Domináns ház tinktúrája. Ha egy második ház 5 pontnál közelebb van hozzá, mellette egy kisebb zászló is lóg.
- `onSelect` esetén a negyedek gombként működnek (kattintás, Enter, szóköz), és a kijelölt negyed verdigris kijelölést kap.
- A kép alatt mindig legyen szöveges frakciólista (lásd a Városnézet oldalt). Az illusztráció nem helyettesíti a számokat.
