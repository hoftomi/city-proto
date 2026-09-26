A *Trón nélkül* felülete egy politikai térképasztal: papír, tinta, címerszínek és pecsétviasz. A játékos jelentéseket olvas, döntéseket hoz, és lepecsételi a parancsait. A felület ezt a ritmust szolgálja, nem az akciójátékok villogását. Elsődleges platform a telefon (reszponzív web), a nagyobb képernyő ugyanazt a rendet kapja, több oszlopban.

## Hangnem és szöveg

- Magyar nyelv, tegező megszólítás: „Lebuktál Feketerévben”, „Parancsaid lepecsételve”.
- A gombfelirat ige vagy igei főnév: „Parancsok lepecsételése”, „Útvonal kiépítése”. Soha nem „OK” vagy „Küldés”.
- A játékfogalmak a szabálykönyv szavai, nagybetűvel, ahol ott is: Parancspont (PP), Legitimitás (L), Semleges, Ismeretlen, Gyanú, Útzár, Kiűzetés. Rövidítések: A, BP, KE, L, PP.
- Tizedesvessző és valódi mínuszjel: `42,0`, `−2`. Tartomány nagykötőjellel: `20–30`.
- A jelentések krónikás mondata múlt vagy jelen idejű, és a forrás minőségéhez igazodik. Gyenge forrás: „valószínűleg”. Erős forrás: pontos számok, határozott állítás.
- Emoji nincs. Felkiáltójel csak a térképi instabilitásjelben szerepel.

## Szín

- A lap `paper`, a kártyák és lapok `paper-raised`, a beviteli mezők és a táblafejek `paper-sunk`. Elválasztásra `line` hajszálvonal szolgál, árnyék nem.
- A szöveg `ink`, a másodlagos szöveg `ink-muted`. Mindkettő legalább 4.5:1 kontrasztot ad mindhárom papíron, mindkét témában.
- A **verdigris** az egyetlen interakciós kiemelőszín: linkek, kijelölt fül, a játékos saját útvonalai és elérhető városai, fókuszgyűrű.
- A **seal** (pecsétviasz) kizárólag a parancsok lepecsételésére szolgál. Nem jelent hibát, és máshol nem használható.
- Állapotszínek: `danger` (lebukás, Kiűzetés, elvágott város, Útzár), `warn` (Gyanú 1–2, Ingatag), `ok` (siker, Stabil). Az `ok` kék, így soha nem egy piros–zöld pár különbözteti meg az állapotokat. Minden állapotszín mellé szó vagy ikon is jár.
- A **házszínek heraldikai tinktúrák**: `house-voros`, `house-kek`, `house-zold`, `house-arany`, `house-bibor`, `house-fekete`, `house-narancs`, `house-szeder`. Egy ház színe mindenhol ugyanaz: címer, befolyássáv, birtok, rivális útvonal. Ezek jelölőszínek (legalább 3:1 a papíron), szövegszínnek nem valók.
- A frakcióknak **nincs saját színük**. A Nemességet, a Kereskedőket és a Katonaságot ikon (korona, mérleg, kard) és név jelöli, így a szín mindig házat jelent.
- A Semleges `share-neutral` alap `line-strong` sraffozással. Az Ismeretlen (rejtett) `share-unknown` alap pontmintával. A két minta miatt ezek fekete-fehérben is megkülönböztethetők a házaktól.

## Tipográfia

- **Alegreya SC** (`display`, `map-label`, `map-label-major`): a régi térképek felirata. Városnevekhez, házneveken és képernyőcímeken használd, folyó szöveghez soha.
- **Alegreya Sans** (`title`, `heading`, `body`, `body-strong`, `label`, `caption`): minden felületi szöveg. A `label` nagybetűs, ritkított szemöldökcímke.
- **Alegreya dőlt** (`chronicle`): a jelentések krónikás mondata, a világ hangja.
- **IBM Plex Mono** (`data`, `data-lg`): minden összehasonlított szám, vagyis befolyás, költség, PP, időzítő. Egyenletes szélességű számjegyekkel.
- Mind a négy család teljes magyar ékezetkészlettel rendelkezik (ő, ű). A betűtípusok a Google Fontsról töltődnek, a `components/bundle.css` elején.

## Térköz, sarkok, elrendezés

- 4px-es alap: `space-1` … `space-8`. A telefonos oldalmargó `space-4`, a kártyák belső térköze is `space-4`.
- A térképek szögletesek: `radius-xs` a chipeknek, `radius-sm` a gomboknak, mezőknek, kártyáknak, `radius-md` a lapoknak. Kerek csak a pecsét és a pötty: `radius-full` (pecsét gomb, PP-pötty, városjelölő).
- Az érintési célok legalább 44px magasak.
- Telefonon egy oszlop és alul nyíló lap (`Sheet`). 720px felett a lap középre kerül, a nézetek két oszlopra bonthatók (például térkép és jelentések).
- Egy képernyőn egy `primary` gomb legyen. A lepecsételés a `seal` gomb.
- Fókusz: `focus-ring`, azaz 2px papírrés, majd 2px tömör verdigris. Minden felületen legalább 3:1 kontrasztú.

## Térkép

A térkép rézmetszetű tartománytérkép, nem műholdkép.

- **Rétegek alulról felfelé:** papír és fokhálózat (`MapCanvas`), domborzat (`MapTerrain`), útvonalak (`MapRoute`), birtokok (`MapEstate`), városok (`MapCity`), végül a szélrózsa (`MapCompass`) és a címkeret (`MapCartouche`).
- **Domborzat:** tenger partvonal-hullámokkal (`map-sea`, `map-sea-line`), folyók, csíkozott hegyek, erdőfoltok (`map-forest`), szántók és mocsár szántóbarázdaszerű vonalakkal (`map-relief`). A domborzat mindig halkabb, mint a játékinformáció: vékony vonalak, tompa színek.
- **Útvonalállapotok:** kiépítetlen (pontozott), saját (vastag verdigris), épülő (szaggatott verdigris), rivális (a ház tinktúrája), Útzár (`danger`, tiltójel), eseményből adódó lezárás (szürke, szaggatott).
- **Városállapotok:** elérhető (verdigris udvar), elérhetetlen (szaggatott, halvány), elvágott (`danger`). A kulcsváros nagyobb, telt maggal. Instabil városnál „!”, lázongónál „!!” jel áll a pont fölött.
- A léptéket a kartus napi járóföldben adja meg, mert a játékban a távolság lépés, nem kilométer.

## Városnézet

A városállam madártávlati alaprajz (`CityView`): fal bástyákkal és négy kapuval, háztömbök (`map-block`), és a három frakció negyede a saját épületével.

- **Felsőváros (Nemesség):** a palota udvarral és négy saroktoronnyal.
- **Citadella (Katonaság):** a csillagerőd.
- **Vásártér (Kereskedők):** a piactér standokkal és kúttal. Kikötővárosban mólók és hajók is vannak.
- A negyed fölött a Domináns ház zászlaja leng. Szoros versenyben a második ház kisebb zászlaja is ott van.
- Az Ingatag városban füst, a Lázongóban lángok látszanak.
- A negyedre koppintva az kijelölődik (verdigris), és alatta megnyílik a frakció kártyája. Ugyanez a fülekkel (`Tabs`) is elérhető, mert az illusztráció nem lehet az egyetlen út.
- A háztömbök a város nevéből generálódnak, így minden városnak saját, állandó rajzolata van.

## Nézetek

A **Térkép nézet** és a **Város nézet** oldal a telefonos képernyőket mutatja összerakva: `AppBar` felül, `NavBar` alul, közöttük a nézet tartalma `space-4` térközzel.

## Ikonok

Saját vonalikon-készlet a bundle-ben (`Icon`): 24-es rács, 1,75-ös vonal, lekerekített végek, `currentColor`. A frakció-, erőforrás- és jelentéstípus-ikonok itt vannak. Új ikon ugyanebben a stílusban készüljön. Emoji és külső ikonkészlet nem használható.

## Logó

Még nincs logó. A játék neve Alegreya SC betűvel, szövegként jelenik meg.
