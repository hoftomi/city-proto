# Trón nélkül – felhasználói kézikönyv

2026. szeptember 27. · hoftomi

Élő, szerkeszthető változat: https://claude.ai/artifact/SJMgT6Nc6Wr1uzd2Bij99s

## Bevezető

A Trón nélkül aszinkron befolyásjáték. Házad élén árucikkekkel kereskedsz, pártot vezetsz a városi tanácsban, és kémeket mozgatsz az alvilágban. A cél a legtöbb **Legitimitás** megszerzése.

- **Kinek szól:** tesztelőknek és új játékosoknak, akik a böngészős prototípust próbálják ki.
- **Melyik változat:** a szabálykönyv v0.2-re épülő prototípus, Polgár módban. A Mesevilág és a Krónika I–IV változat csak kinézetben különbözik, a játék ugyanaz.
- **Mire figyelj:** az idő a prototípusban szimulált, te tekered előre (7. szakasz). Élesben a játék a valós órához igazodik.

## Belépés és játék indítása

Három lépésben jutsz a játékba: belépsz, kiválasztasz egy játékot, majd belépsz a városokba.

1. **Belépés.** Válassz közösségi fiókot: Google, Apple vagy Discord. A prototípusban a belépés színlelt, jelszó nem kell.
2. **Játékok listája.** Három fül van:
    - **Új játékok:** a nyitott és a hamarosan induló szezonok, névvel, hosszal, játékosszámmal, városszámmal és címkékkel (például Kezdőbarát, Gyors).
    - **Saját:** azok a játékok, amelyekre jelentkeztél. Itt a futó Délkelet-szezon.
    - **Lezárult:** a befejezett szezonok a győztessel.
3. **Játék részletei.** Koppints egy játékra. Látod a régió térképét, a kezdőhelyeket és az adatait. Innen jelentkezhetsz, visszavonhatod a jelentkezést, vagy beléphetsz a futó játékba.
4. **Jelentkezés négy lépésben:**
    1. A ház neve és tinktúrája (a ház színe). A már foglalt színek nem választhatók.
    2. A háttér:
        - Kereskedőház: induló részesedés;
        - Nemesi ház: induló párt és népszerűség;
        - Árnyékrend: 2 induló kém.
    3. A kezdőhely, vagyis a birtokod helye a térképen.
    4. Összegzés és megerősítés.
5. **Belépés a játékba.** A Saját fülön válaszd a Délkelet játékot, majd a „Belépés a játékba” gombot.

A prototípusban a játék mindig a Délkelet-szezonnal, a Kékholló házzal indul, kereskedői kezdéssel. A jelentkezésnél választott háttér és kezdőhely még nem hat a játékra.

## A képernyő felépítése

Felül a házad és a készleted látszik, alul az öt fő képernyő között válthatsz.

**Fejléc:**

- **← Játékok:** vissza a játékok listájához. Mellette a régió és a mód (Délkelet · Polgár mód).
- **Házad címere és neve.**
- **Elszámolás:** a következő elszámolás időpontja és a hátralévő idő.
- **Erőforrások:** arany (A), parancspont (PP) és Legitimitás (L).
- **Idősáv:** a szimulált játékidő (nap és óra), az érlelő lapod hátralévő ideje, valamint az időugrás gombjai (7. szakasz).

**Erőforrások röviden:**

| Erőforrás | Mire kell | Honnan jön |
| --- | --- | --- |
| Parancspont (PP) | minden parancs ára | elszámolásonként +10, legfeljebb 20 |
| Arany (A) | vásárlás, párt, fesztivál, hír, kém, útvonal | eladás haszna, adó, leleplezési jutalom, információ eladása |
| Népszerűség (N) | több vevő, több szavazat | olcsó áru, alacsony adó, fesztivál, jó hír; városonként külön érték |
| Legitimitás (L) | ez a győzelmi pont | tanácsi helyek, árueladás, népszerűség, leleplezés |

**Alsó navigáció:**

- **Térkép:** a régió, a városok és az útvonalak.
- **Város:** a kiválasztott város három negyede.
- **Jelentések:** a számláló az olvasatlan jelentéseket mutatja.
- **Parancslap:** a számláló a lepecsételetlen parancsokat és a kivásárlási fenyegetéseket mutatja.
- **Rangsor:** a házak Legitimitás szerint.

Minden lépésnél felugró üzenet jelzi, mi történt: „Parancslapra került”, új jelentés, vagy hiba (például nincs elég PP).

## Térkép

A térképen látod, mely városokban cselekedhetsz. Akciót csak olyan városban indíthatsz, ahová a birtokodból útvonalad vezet.

**Mit látsz:**

- **Öt város:** Szélmező, Vaskapu, Feketerév (kulcsváros), Holtág és Délkapu. A szürke város nem elérhető, a színes igen.
- **Birtokod:** a kék zászlós tábor. Innen indul a hálózatod. A rivális birtokok a házuk színét viselik.
- **Útvonalak:**
    - a saját útvonalad széles bronz vonal;
    - a tervezett útvonal szaggatott;
    - a rivális birtokhoz tartozó út a ház színét viseli;
    - a többi földút.
- **Parancspont-sáv:** a térkép fölött jelzi, mennyi PP-d van, és mennyi már le van foglalva a parancslapon.

**Mit csinálhatsz:**

- **Nagyítás és mozgatás:** a + és − gombbal nagyítasz, a térképgombbal a teljes nézetre váltasz. Húzva mozgatod a térképet.
- **Város kiválasztása:** koppints egy városra. Alul megjelenik a kártyája:
    - profil és távolság lépésekben;
    - a népszerűséged;
    - az árucikkek kínálata és kereslete, valamint a részesedésed;
    - a tanács összetétele.
- **Útvonal építése:** ha a város szomszédos a hálózatoddal, az „Útvonal innen: …” gomb parancslapra teszi az építést (1 PP + 3 A). Az útvonal a lap lefutásakor él, és elszámolásonként 1 A a fenntartása.
- **Város megnyitása:** a gomb átvisz a Város képernyőre.

## Város

A városban adod ki a parancsok nagy részét, három negyedben. Egy negyedet a városképen koppintva vagy az alatta lévő fülön választasz.

A fejlécben látod:

- a város profilját és távolságát;
- a népszerűségedet;
- az adókulcsot;
- hogy hány elszámolás múlva lesz választás.

A városkép nagyítható és mozgatható, mint a térkép. Ha a városba nem vezet útvonalad, nézelődhetsz, de parancsot nem adhatsz. Ilyenkor itt is építhetsz útvonalat.

### Vásártér (kereskedők)

Minden árucikknek külön kártyája van.

- **A kártya adatai:**
    - kínálat és kereslet elszámolásonként;
    - a pontonkénti piaci érték;
    - a részesedés-sáv;
    - az eladók táblázata: részesedés, fokozat, legutóbb eladott mennyiség, és a „legolcsóbb” jelölés.
- **Haszonkulcs (1 PP):** ha van részesedésed, öt fokozat közül választasz. A drágább aranyat hoz, az olcsóbb népszerűséget.

| Fokozat | Haszonkulcs | N elszámolásonként |
| --- | --- | --- |
| Nagyon olcsó | 5% | +3 |
| Olcsó | 15% | +1 |
| Piaci | 30% | 0 |
| Drága | 50% | −1 |
| Uzsora | 80% | −3 |

- **Vétel a Várostól:** válaszd ki a pontszámot (1–10), ára 3 A pontonként, plusz 1 PP.
- **Kivásárlás:** válaszd ki a riválist és a pontszámot. Az ár a piaci érték 150%-a, plusz 2 PP. A pénzt a rivális kapja. Akit kivásároltak, 3 elszámolásig védett.
- **Védekezés:** ha valaki téged akar kivásárolni, piros figyelmeztetés jelenik meg a lefutás idejével. A „Védekező vétel” gomb a piaci érték 100%-áért kiváltja a részesedésedet, plusz 1 PP. Csak akkor hat, ha a te lapod előbb fut le, mint az ajánlat.

A haszon képlete: eladott egység × 3 A alapár × haszonkulcs. A városiak kereslete véges. Az olcsóbb és népszerűbb eladó többet ad el, de a drága is elad valamennyit.

### Városháza (politika)

- **Városi tanács:**
    - a 9 hely eloszlása;
    - az adókulcs és a legutóbb szétosztott adó;
    - a pártok programja, szavazata (a népszerűségük) és helyeik száma.
- **Pártalapítás (2 PP + 40 A):** párt nélkül nem jutsz be a tanácsba, és nem kapsz adót. Városonként egy pártod lehet, és Közepes adó programmal indul.
- **Program (1 PP):**
    - Alacsony adó: 10%, +1 N elszámolásonként;
    - Közepes adó: 20%, 0 N;
    - Magas adó: 30%, −1 N.
- **Fesztivál (2 PP + 15 A):** +6 N. Ha 3 elszámoláson belül ismétled, csak +3 N. A választás előtti kampányidőszakban dupla hatás, dupla ár. A prototípusban párt kell hozzá.
- **Hír terjesztése (2 PP + 5 A):**
    - Válaszd ki az állítást, a célpontot, és ha kell, az árucikket.
    - A felület megmondja, hogy az állítás most igaz-e.
    - A hatás azonnali: −4 vagy −5 N a célpontnak, dicséretnél +4 N.
    - Ha a hamis híredet leleplezik, −10 N-et kapsz.
- **Terjedő hírek:** a város legutóbbi hírei a terjesztővel, az időponttal és az ellenőrzés eredményével.

Választás minden 6. elszámoláskor van. A 9 hely D'Hondt-módszerrel oszlik el, 5%-os küszöbbel.

### Alvilág (kémhálózat)

- **Kémeid:** az itteni kémeid száma (legfeljebb 3), a szabad ügynökök és az őrök. Látod azt is, kinek van még kéme a városban.
- **Kém felfogadása (1 PP + 20 A):** a fenntartás 2 A kémenként elszámolásonként.
- **Őr beállítása (1 PP):** egy szabad kém őrré válik. Minden őr 25% eséllyel buktatja le az ellened indított kifürkészést, legfeljebb 75%-ig. Az őr más kémakciót nem végezhet.
- **Kifürkészés (1 PP):**
    - A listában minden rivális érlelő lapja látszik a lefutás idejével.
    - A jelentés a saját lapod lefutásakor érkezik. Egy szabad kém az akciók típusát, kettő a célpontot is, három a költséget is felfedi.
    - Csak akkor ér valamit, ha a célpont később fut le, mint a te lapod.
- **Kifürkészett tervek:** a megszerzett jelentéseket eladhatod 10 A-ért, amíg a célpont lapja le nem fut. A vevőt a prototípus választja. Legfeljebb 3 elszámolásonként egyszer +1 L jár érte.
- **Hírek ellenőrzése (1 PP):** a mások által terjesztett hírekről megtudod, igazak voltak-e. Ehhez kém kell a városban.
- **Leleplezés (1 PP):** ha az ellenőrzés szerint a hír hamis, leleplezheted.
    - A hír hatása visszafordul, a terjesztő −10 N-et kap.
    - Te +3 N-et, +10 A-t és +3 L-t kapsz.
    - Az ellenőrzés és a leleplezés két külön parancslap, így összesen legalább 4 óra.

## Parancslap, jelentések, rangsor

### Parancslap

A parancsaid itt gyűlnek. Csak lepecsételve és 2 óra érlelés után lépnek életbe.

1. **Gyűjtés:** a Városban és a Térképen minden gomb a parancslapra teszi a parancsot. Ekkor még semmi sem történik.
2. **Áttekintés:**
    - a parancsok listája ág szerint, PP- és aranyköltséggel;
    - a lefoglalt arany és a PP-sáv;
    - bármelyik parancsot törölheted.
3. **Lepecsételés:**
    - A költségek ekkor válódnak le.
    - A lap 2 óra múlva fut le, a lepecsételés sorrendjében.
    - Ez alatt nem módosítható, és a rivális kémek kifürkészhetik.
4. **Érlelés:** a folyamatsáv mutatja, mikor fut le a lap.
    - Egyszerre egy érlelő lapod lehet.
    - Az újat összeállíthatod, de csak a régi lefutása után pecsételheted le.
5. **Lefutás:** a parancsok egyenként hajtódnak végre.
    - Ha valamelyik közben érvénytelenné vált, elmarad. Ilyen például, ha a Városnál elfogyott a részesedés.
    - Az elmaradt parancs aranya visszajár, a PP-je nem.

A Parancslapon jelennek meg a rád irányuló kivásárlási ajánlatok is, egy gombbal, amely a Vásártérre visz védekezni.

### Jelentések

Minden eseményről jelentés készül, időbélyeggel. Szűrhetsz: Mind, Saját, Nyilvános.

- **Saját jelentések:**
    - a parancsaid eredménye;
    - az elszámolás összegzése: bevétel, Legitimitás, PP;
    - kémjelentések megbízhatósági jelöléssel;
    - lebukások;
    - kivásárlási fenyegetések.
- **Nyilvános jelentések:** a választási eredmények, a terjedő hírek és a leleplezések. Ezeket mindenki látja.

### Rangsor

- **Házak Legitimitás szerint:** helyezés, ház, összes részesedés, tanácsi helyek és L.
- **Népszerűséged városonként:** a tanácsi helyeiddel.
- **Legitimitás elszámolásonként és városonként:**
    - tanácsi helyenként +1;
    - többség (legalább 5 hely) +3;
    - egy árucikk legnagyobb eladója +2;
    - a legnépszerűbb szereplő +2.
- **Prototípus újraindítása:** a gomb visszaállítja a kezdőállapotot. A mentett állás elvész.

## Idő és elszámolás

Kétféle óra jár a játékban. A saját parancslapod 2 órás érlelés után fut le. A város gazdasága naponta kétszer, 8:00-kor és 20:00-kor számol el.

**Időugrás a prototípusban:** az idősávban három gomb van.

- **+30 p:** fél órával előre.
- **+2 ó:** két órával előre, ez pont egy érlelés.
- **Következő esemény:** a legközelebbi lap-lefutásig vagy elszámolásig ugrik. Ez a leggyorsabb mód a játék tesztelésére.

**Mi történik az elszámoláskor:**

1. A városiak megveszik az árut. A keresletet az eladók között a részesedés, az ár és a népszerűség osztja el. Kialakul a haszon.
2. Az árazás népszerűséget ad vagy vesz el. A legolcsóbb eladó +1 N-et kap.
3. A kereskedők megfizetik az adót, a tanácsi pártok a helyeik arányában kapják meg.
4. A pártprogram népszerűséget ad vagy vesz el.
5. Jóváíródik a Legitimitás.
6. Levonják a kémek (2 A) és az útvonalak (1 A) fenntartását.
7. A népszerűség 2 ponttal a 10-es alapérték felé húzódik.
8. +10 PP érkezik (legfeljebb 20).
9. Minden 6. elszámoláskor választás van.

Az elszámolás után az NPC-házak is lepecsételik a lapjukat. A lapjuk 2,5–5,5 óra múlva fut le, ezért a kivásárlásuk ellen van idő védekezni.

## Tippek és gyakori kérdések

**Első lépések:**

1. Nézd meg Feketerév Vásárterét. Van 10 pont Sód, állíts rá fokozatot, és végy hozzá részesedést a Várostól.
2. Szélmezőben van 20 pont Gabonád és 20 népszerűséged. Jó hely az első pártnak.
3. Pecsételd le a lapot, majd nyomd meg a „Következő esemény” gombot, és olvasd el a jelentéseket.

**Tippek:**

- Az olcsóság népszerűséget ad, nem aranyat. A népszerűség több vevőt és több szavazatot hoz, és Legitimitást, ha a városban te vagy a legnépszerűbb.
- A népszerűség minden elszámoláskor visszahúzódik a 10-es alapérték felé. Folyamatosan ápold.
- A választás előtt kampányidőszak van: a fesztivál ekkor dupla hatású, de dupla árú is.
- Ha kivásárlási ajánlatot kapsz, azonnal pecsételj le egy védekező vételt. A lapodnak előbb kell lefutnia, mint az ajánlatnak.
- A kulcsvárosban minden őr 25%-kal növeli az esélyét, hogy lebukjon a Bíbor Kéz kifürkészése.
- Bíbor Kéz gyakran terjeszt rólad hamis uzsorahírt. Egy kém, egy ellenőrzés és egy leleplezés +10 A-t és +3 L-t hoz.
- Hamis hírt csak akkor terjessz, ha a városban nincs kéme annak, aki leleplezhetne.

**Gyakori kérdések:**

- **Miért nem tudok parancsot adni egy városban?** Mert nem vezet oda útvonalad. Építs egyet egy szomszédos városból.
- **Miért nem tudok lepecsételni?** Vagy üres a lap, vagy még érlelődik az előző.
- **Hová lett a parancsom?** Ha lefutáskor már érvénytelen volt, elmaradt. Az arany visszajárt, a jelentésekben látod az okát.
- **Hogyan lehet nyerni?** A legtöbb Legitimitás nyer. A szezonvég és a Koronázási Tanács még nincs a prototípusban.
- **Elveszik a játékom, ha bezárom?** Nem. A prototípus a böngészőben menti az állást, a Rangsor képernyőn pedig újraindíthatod.
