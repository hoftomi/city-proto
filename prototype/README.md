# Trón nélkül – kódalapú prototípus v0.2

Kattintható mobil prototípus a **szabálykönyv v0.2** (három hatalmi ág) és a design system alapján. Hamis adatokkal, egy régióval (Délkelet, 5 városállam, 4 NPC-ház, Polgár mód), de valódi szabálylogikával.

## Futtatás

```bash
npm install
npm run dev          # fejlesztői szerver, http://localhost:5173
npm run build        # éles build a dist/ mappába
npm run build:single # egyetlen HTML fájl: dist-single/index.html
```

Build nélkül is kipróbálható: nyisd meg a `dist-single/index.html` fájlt böngészőben (a betűtípusokhoz internet kell).

## Mit tud

- **Bejelentkezés:** csak közösségi fiókkal (Google, Apple, Discord). A prototípusban színlelt: bármelyik gomb azonnal belép.
- **Játékválasztó (lobbi):** új, saját és lezárult játékok; állapot (fut, jelentkezés nyitva, majdnem tele, hamarosan), kezdés, hossz, helyek, címkék. A futó játékba innen lehet belépni.
- **Játék részletei:** térképelőnézet, adatok, jelentkezés vagy visszavonás.
- **Jelentkezés 4 lépésben:** ház neve és tinktúrája (a foglaltak nem választhatók), háttér (GDD 6. fejezet), kezdőhely a térképen, összegzés.

- **Szimulált idő:** a felső sávban +30 perc, +2 óra vagy „Következő esemény”. Elszámolás 8:00-kor és 20:00-kor.
- **Térkép:** domborzat, hálózat, elérhető városok. Városra koppintva népszerűség, árucikkek, tanács (9 hely), útvonalépítés.
- **Vásártér:** árucikkenként véges kínálat és kereslet, 100 pontos részesedés (a gazdátlan rész a Városé), eladók táblája fokozattal, 5 haszonkulcs-fokozat, vétel a Várostól, kivásárlási ajánlat (150%), védekező vétel a fenyegetés ellen.
- **Városháza:** pártalapítás, adóprogram (10/20/30%), fesztivál (kampányban dupla ár), hírsablonok az igazságtartalom jelzésével, hírfolyam. Választás 6 elszámolásonként (D'Hondt, 5% küszöb).
- **Alvilág:** kémek (városonként max. 3, fenntartás), őrök, a rivális érlelő parancslapok kifürkészése (1/2/3 kém: típus/célpont/költség), információ eladása, hírek ellenőrzése és leleplezése jutalommal.
- **Parancslap:** vázlat PP- és aranyellenőrzéssel, lepecsételés, **120 perc érlelés** folyamatjelzővel, kivásárlási fenyegetések figyelmeztetése.
- **Elszámolás:** eladás (népszerűség- és árérzékeny kereslet, kapacitáskorlát), adó a tanácspártoknak, népszerűség-sodródás, Legitimitás, fenntartás, +10 PP. Az NPC-k minden elszámolás után pecsételnek (150–330 perces lefutással).
- **Jelentések** (saját / nyilvános szűrő) és **Rangsor** (Legitimitás, részesedés, tanácshelyek, népszerűség városonként).
- Az állás a böngészőben megmarad (localStorage, `tron-nelkul-proto-v2`). Újraindítás: Rangsor → „Prototípus újraindítása”.

## Szerkezet

```
src/
  ds/            design system (a design-system/components/bundle.js ES modul változata, tokens.css, components.css)
  game/
    rules.js     a v0.2 szabálykönyv számai (11. fejezet), fokozatok, programok, hírsablonok, akciók
    world.js     a példavilág: házak, városok, utak, kezdőállás
    engine.js    szabálylogika: idő, érlelés, parancsvégrehajtás, elszámolás, választás, kémek, NPC-k
  store.js       állapotkezelés (useReducer + mentés)
  screens/       Térkép, Város (Vásártér / Városháza / Alvilág), Parancslap, Jelentések, Rangsor, parts.jsx
  lobby/         bejelentkezés, játékválasztó, részletek, jelentkezés (data.js: hamis játékok, hátterek, kezdőhelyek)
  Root.jsx       útvonalak: bejelentkezés → lobbi → részletek → jelentkezés → játék
```

A `game/` mappa független a felülettől: később változtatás nélkül átvihető szerverre, ahol a kör feldolgozása ténylegesen fut.

## Egyszerűsítések a szabálykönyvhöz képest

- Egy játékos, a többi ház NPC. Az NPC-k hálózatát nem korlátozzuk, és a kémjelentésekre még nem reagálnak.
- **Alapár: 3 A / egység** (a szabálykönyv 1 A-val számol; 1 A mellett a gazdaság túl szűkös volt).
- A háttér induló bónusza (2.2) még nem érvényesül: minden háttér ugyanonnan indul.
- Nincsenek még nehézségi modulok; a prototípus a Polgár módot mutatja. Katonaság és diplomácia nincs.

## Bejelentkezés élesben

- A gombokat a szolgáltatók hivatalos márkairányelvei szerint kell lecserélni (Google „Sign in with Google”, Apple „Sign in with Apple”, Discord). A prototípus szándékosan semleges betűjeleket használ, logók nélkül.
- iOS-alkalmazásban, ha más közösségi belépés is van, az Apple-belépés kötelező.
- Ajánlott: OAuth 2.0 / OpenID Connect egy hitelesítési szolgáltatón át (például Supabase Auth, Firebase Auth, Auth0), így a szerver csak a saját munkamenet-tokent kezeli.
