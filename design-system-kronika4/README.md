A *Trón nélkül – Krónika IV* a Krónika festett stratégiai köntösének negyedik változata. A városnézet izometrikus és kézzel komponált: kevesebb, de kidolgozott épület valódi tetőformákkal (nyereg-, konty- és gúlatető, kupola), kőrakással, cserép- és palasorokkal, favázas, kiugró emeletekkel, zsalus és íves ablakokkal, kéménnyel és füsttel. A várfal pártázatos, kerek tornyai kúpos tetőt kapnak. A világtérkép városai ugyanebből az eszközkészletből épülő, izometrikus kis várak, a hegyek sziklás, havas csúcsok. Ugyanazokat a komponenseket és komponens-API-t adja, mint a korábbi változatok. Minden rajz saját, eredeti munka.

## Hangnem és szöveg

- Magyar nyelv, tegező, de kimértebb, krónikás hang: „A városi tanács jóváhagyta az adásvételt.”
- A gombfelirat ige vagy igei főnév, a költséggel: „Kém felfogadása · 20 A”.
- A játékfogalmak a szabálykönyv szavai: Parancspont (PP), Legitimitás (L), népszerűség (N), arany (A).
- Emoji nincs. A hangulatot a rajzok és az anyagok adják.

## Anyagok és szín

- **Asztal:** a képernyő háttere régi térképlap (`table-hi` → `table`), halvány 48px-es rácsvonalakkal és széleken sötétedő vignettával.
- **Pergamen:** kártya, jelentés és parancslap alapja `paper-raised` → `paper` átmenet. A szöveg `ink` (13,8:1), a másodlagos `ink-muted` (legalább 5:1 minden felületen, az asztalon is).
- **Fa és bronz:** a kártyakeret, a fejléc, a navigáció, a táblafej és a térképkeret sötét fa (`wood`, `wood-hi`, `wood-lo`). Belül egy bronz vonal (`frame`) fut. Sötét fán a felirat világos bronz (`frame-hi`, 5,9:1).
- **Mélység:** 3px-es tömör tintaperem (`outline`), plusz lágy vetett árnyék (`shadow-card`). A kontúr vékonyabb (1–1,5px), mint a Mesevilágban.
- **Gombok:** matt festékek felső fénnyel és alsó peremmel.
  - Erdőzöld (`btn-green-*`): elsődleges.
  - Acélkék (`btn-blue-*`): alap.
  - Bronz (`btn-gold-*`, sötét felirattal): kizárólag a lepecsételés.
  - Téglavörös (`btn-red-*`): veszélyes lépés.
  - Pergamen (`btn-cream-*`): csendes lépés.
  A világos felirat a színes gombokon legalább 4,5:1.
- **Kiemelés:** a `verdigris` itt acélkék: link, info, saját sor.
- **Házszínek:** festett, tompított heraldikai tinktúrák (`house-*`).
- **Ágszínek** (`branch-*`): az ikoncsempe szegélye és a kijelölt bőrfül felső csíkja.

## Tipográfia

- **Cinzel** (`display`): vésett, római feliratos címbetű. Képernyőcím, kártya- és jelentéscím, fül, városnév, kartus, lepecsételés gomb. A kisbetűi kiskapitálisként jelennek meg.
- **Nunito Sans 600–900** (`sans`): minden felületi szöveg, gomb és szám.
- Mindkettő teljes latin-ext (ő, ű) készlettel töltődik a Google Fontsról (`components/bundle.css` eleje).

## Forma és térköz

- 4px-es alap (`space-1` … `space-8`), a kártya belső térköze és az oldalmargó `space-4`.
- Visszafogott sarkok: mező 6px, kártya és térképkeret 10px, lap 14px. Kerek csak a pecsétkorong, a pötty és a tanácshely.
- Az érintési cél legalább 44px (kis gomb: 34px, kártyán belül).

## Térkép és város

A világtérkép és a városnézet egy **`MapViewport`** ablakban él: telefonon ujjal, asztali gépen egérrel húzható, és nagyítható. A világtérkép 2×, a város 1,8× nagyítással indul, így a részletek látszanak. A „teljes nézet” gomb visszaállítja a teljes szélességet.

- **Világtérkép:** a táj és a városok is részletesen kidolgozottak.
  - Talaj: réti színfoltok, fűcsomók, vadvirágok, fokbeosztásos belső keret.
  - Hegyek: napos és árnyékos oldal, gerincek, sraffozás, hósapka, kövek.
  - Dombok és vegyes erdők erdőtalaj-árnyékkal.
  - Mozaikos szántók sövénnyel, tanyával és birkákkal; falvak templomtoronnyal; szélmalmok.
  - Bánya, folyók homokparttal, kőhidak az utak kereszteződésénél, tó.
  - Tenger: tajték, szigetek, világítótorony, hajók és egy bálna.
  - Tájnevek és tengernév vésett betűvel.
  - A városok fallal körülvett kisvárosok, a nevük pergamenszalagon áll.
- **Városnézet** (720 × 540, izometrikus, kézzel komponált):
  - Városháza: parlament rézkupolával, oszlopcsarnokkal és timpanonnal, két szárnnyal, óratoronnyal, díszkerttel és szökőkúttal.
  - Vásártér: fedett vásárcsarnok, tíz stand ponyvával és áruval, céhház, kút, szekerek; polgárházak boltponyvával és cégérrel; kápolna harangtoronnyal; kovácsműhely izzó tűzzel.
  - Alvilág: éjszakai tónus, düledező házak, izzó ablakú fogadó lámpásokkal, romos torony, köd és utcai lámpák.
  - A falon kívül: szántók sorokkal, legelő állatokkal, pajta, szélmalom, tanyák, sziklás kőbánya aknával, sínnel, csillével és daruval; folyó kőhíddal vagy kikötő mólókkal.
- **Világtérkép:** izometrikus kis várak (fal, saroktornyok, lakótorony, házak), havas sziklacsúcsok, változatos lombos és fenyőfák, iso szántók sövénnyel, fűtextúra.
- **Festett eszközök:** közös `kg-*` színátmenetek, papírszemcse, elmosott árnyékok és lágyított kontúr a térképen és a városban is.

## Ikonok

- **Játékikonok** (`GameIcon`): teli, illusztratív ikonok vékony tintakontúrral és tompított festékekkel (`ic-*`).
  - Erőforrás: `arany`, `pp`, `legit`, `nep`, `ado`.
  - Árucikk: 11 fajta.
  - Ág: 3 fajta.
  - Akció: 14 fajta.
  - Navigáció: `navTerkep`, `navVaros`, `navJel`, `navRang`.
  - Idő: `homokora`.
- **Vonalikonok** (`Icon`): 2px vonal, csak vezérlőkhöz.

## Kapcsolat a többi stílussal

A komponensnevek, propok és osztálynevek (`tn-*`) azonosak a térképasztal és a Mesevilág rendszerrel. A névtér itt `window.TronKronika4`. Új itt az izometrikus `i4` eszközkészlet: doboz, tető, henger, kúp, ablak, ajtó, ház, torony, fal, szikla, fa és parcella.
