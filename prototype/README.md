# Trón nélkül – kódalapú prototípus v0.1

Kattintható mobil prototípus a befolyásrendszer szabálykönyve (v0.1) és a design system alapján. Hamis adatokkal, egy régióval (Délkelet, 5 városállam, 4 NPC-ház), de valódi szabálylogikával.

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

- **Térkép:** domborzat, a saját hálózatod, elérhető / elérhetetlen városok. Városra koppintva frakcióállás, útvonalépítés.
- **Város:** illusztrált alaprajz, negyedenként (Felsőváros, Vásártér, Citadella) befolyássáv, Gyanú, romlás és akciók. Akció csak hálózatban lévő városban indítható (4.3).
- **Parancslap:** PP- és erőforrás-ellenőrzés, törlés, lepecsételés, majd „Feldolgozás most” (csak a prototípusban).
- **Kör feldolgozása:** Lejáratás, nyereség (csökkenő hozam, először a Semlegesből, riválistól fele hatékonysággal), rejtett befolyás, útvonalak, romlás, Gyanú, kontrollszintek, jutalmak, bevétel, NPC-lépések és városi események.
- **Jelentések** és **Rangsor** (Legitimitás).
- Az állás a böngészőben megmarad (localStorage). Újraindítás: Rangsor → „Prototípus újraindítása”.

## Szerkezet

```
src/
  ds/            design system (a design-system/components/bundle.js ES modul változata, tokens.css, components.css)
  game/
    rules.js     a szabálykönyv számai (14. fejezet) és az akciók
    world.js     a példavilág: házak, városok, utak, kezdőállás
    engine.js    szabálylogika: hálózat, kontrollszintek, a kör feldolgozása, NPC-k
  store.js       állapotkezelés (useReducer + mentés)
  view.js        játékállapot → komponensprops
  screens/       Térkép, Város, Parancslap, Jelentések, Rangsor
  lobby/         bejelentkezés, játékválasztó, részletek, jelentkezés (data.js: hamis játékok, hátterek, kezdőhelyek)
  Root.jsx       útvonalak: bejelentkezés → lobbi → részletek → jelentkezés → játék
```

A `game/` mappa független a felülettől: később változtatás nélkül átvihető szerverre, ahol a kör feldolgozása ténylegesen fut.

## Egyszerűsítések a szabálykönyvhöz képest

- Egy játékos, a többi ház NPC. Az NPC-k hálózatát nem korlátozzuk.
- Nincs még: Útzár, Szálak felgöngyölítése, Leleplezkedés, frakciókérések, szerződések, szezonvég.
- A Városkontroll-jutalom és a partnerbónuszok számolása egyszerűsített.

## Bejelentkezés élesben

- A gombokat a szolgáltatók hivatalos márkairányelvei szerint kell lecserélni (Google „Sign in with Google”, Apple „Sign in with Apple”, Discord). A prototípus szándékosan semleges betűjeleket használ, logók nélkül.
- iOS-alkalmazásban, ha más közösségi belépés is van, az Apple-belépés kötelező.
- Ajánlott: OAuth 2.0 / OpenID Connect egy hitelesítési szolgáltatón át (például Supabase Auth, Firebase Auth, Auth0), így a szerver csak a saját munkamenet-tokent kezeli.
- A háttértípusok közül a prototípusban csak a frakcióbónusz (×1,25) működik, a többi előny csak leírás.
