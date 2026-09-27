# Trón nélkül – A város hatalmi ágai (v0.2 tervezet)

*Véleményezés és kidolgozási javaslat a módosított alapjátékhoz*

---

## 1. Az új modell röviden

A város három intézményből áll, és mindegyikhez tartozik egy hatalmi ág:

| Intézmény | Hatalmi ág | Mit birtokol a játékos | Miből lesz aranya | Mivel hat a népszerűségre |
|---|---|---|---|---|
| **Üzletek** | Kereskedők | részesedés a város erőforrásaiból | eladás a városlakóknak | haszonkulcs (olcsóbb áru → népszerűbb) |
| **Parlament** | Politika / Nemesség | párt, tanácsi mandátumok | adó | adókulcs, fesztivál, hírek |
| **Alvilág** | Kémhálózat | felfogadott kémek | információ eladása | álhírek leleplezése |

**Induló bónuszok:**

- Kereskedő: X% részesedés a város egy erőforrásából.
- Nemes: egy megalapított párt.
- Kém: 2 felfogadott kém.

A kampányok és világok eltérő nehézségűek lesznek. Ez a dokumentum az alapszabályokat írja le.

---

## 2. Összkép

**Az irány jó, és erősebb, mint a v0.1.** A korábbi szabálykönyv legnagyobb kockázata az volt, hogy a befolyás absztrakt százalék (GDD 30. fejezet: „a befolyásrendszer túl absztrakt lehet”). Az új modellben minden szám kézzelfogható: ár, adó, mandátum, kém. A játékos érti, mit csinál, és miért változik a népszerűsége.

### Erősségek

- **Egy közös tengely.** Mindhárom ág ugyanazon a döntésen feszül: *arany most, vagy népszerűség most*. A haszonkulcs, az adókulcs és a fesztivál ugyanannak a csúszkának három változata. Ettől lesz koherens a játék.
- **Természetes ellenlépések.** A kereskedők árháborút vívnak egymással. A politikusok hírekkel támadják a kereskedőket és egymást. A kémek leleplezik a hamis híreket, és felfedik a parancsokat. Ez a kő–papír–olló jellegű háromszög magától interakciót termel.
- **Az információ kereskedhető.** A parancsok felfedése és eladása egyedi mechanika, és diplomáciát szül a játékon belül. Ez pont a GDD 4.4-es elve („az információ is erőforrás”).
- **A választás drámai csúcspontot ad.** Az időszakos választás aszinkron játékban is ad egy várt eseményt, amire készülni lehet.
- **A régi motor nagy része megmarad.** A részesedés ugyanaz a zéró összegű, 100 pontos modell, mint a v0.1 befolyása. A hálózat és az útvonalak, a körök és a jelentések is maradnak.

### Kockázatok (részletesen a 4. fejezetben)

1. **Árháború a nulláig:** a kereskedők addig licitálják le egymást, amíg senki sem keres.
2. **A kémek lepecsételt parancsokat fednek fel:** ez arra ösztönöz, hogy mindenki az utolsó pillanatban pecsételjen. Ez ütközik a „döntés számít, nem az online idő” elvvel.
3. **Mi számít igaz vagy hamis hírnek?** Ha ezt nem a játékállapot dönti el, a leleplezés nem működik.
4. **Mikromenedzsment:** sok áru × sok város × ár-beállítás mobilon könnyen táblázatkezeléssé válik.
5. **A kémág gazdasága a leggyengébb:** csak információeladásból él, ami a vevőktől függ.
6. **Nem világos a győzelem:** hogyan lesz a népszerűségből, a részesedésből és a mandátumból Legitimitás?
7. **Eltűnt a katonaság:** az Útzárnak és a fizikai fenyegetésnek új helyet kell találni.

---

## 3. Alapdöntések, amelyeket javaslok

### 3.1. Mindenki mindhárom ágban játszhat

Az „induló bónusz” szóhasználat erre utal, és ezt javaslom rögzíteni. A **háttér** (GDD 6. fejezet) csak a kezdést adja meg:

- **Kereskedőház:** részesedés.
- **Nemesi ház:** párt.
- **Árnyékrend:** 2 kém.

Később bárki alapíthat pártot, vásárolhat részesedést, és fogadhat fel kémet.

*Miért?* Ha a három ág három külön osztály lenne, kis játékosszámnál egy városban könnyen hiányozna valamelyik. Emellett a játékos egyetlen stratégiába zárulna, ami ellentmond a GDD-nek.

### 3.2. Egy népszerűségi érték városonként

Minden játékosnak városonként egy **Népszerűség** értéke van (0–100). Mindhárom ág ebbe ír:

- olcsó áru: +
- magas adó: −
- fesztivál: +
- rossz hír rólad: −
- lelepleződött álhír: −

A népszerűség dönti el:

- mennyit vesznek tőled a városlakók,
- hány szavazatot kap a pártod,
- mennyire drága egy városi akció.

*Alternatíva:* ágankénti népszerűség (kereskedői hírnév és politikai népszerűség külön). Ez pontosabb, de nehezebb átlátni. Az MVP-be az egyetlen érték javasolt.

### 3.3. A körök két fázisban futnak

A kémkedés miatt kell egy új fázis:

| Fázis | Hossz (napi 2 körnél) | Mi történik |
|---|---|---|
| **Tervezés** | kb. 10 óra | Parancsok, árazás, hírek, ajánlatok. |
| **Zárás** | automatikus | Minden parancslap lepecsételődik, akkor is, ha a játékos nem pecsételte le. |
| **Hírszerzés** | 2 óra | A kémek felfedik a lezárt parancsokat, és az információ eladható. Csak *reakciók* adhatók: árkorrekció, ellenhír, védekezés. |
| **Végrehajtás** | 8:00 / 20:00 | Minden egyszerre fut le. |

Így nem éri meg az utolsó percben pecsételni, mert a zárás mindenkinél egyszerre történik. A kémek információja is értékes marad, mert van idő reagálni rá.

---

## 4. Az ágak kidolgozása

### 4.1. Kereskedők – Üzletek

**Az alapmodell**

- Minden város **2–4 árucikket** termel (például Feketerév: hal, só; Szélmező: gabona, bor). Egy árucikk körönként **Kínálat** mennyiséget termel, például 100 egységet.
- Minden árucikk **100 részesedési pontból** áll, ez ugyanaz a zéró összegű modell, mint a v0.1-ben. Akinek 20 pontja van, az a kínálat 20%-át árulhatja.
- A tulajdonos **haszonkulcsot** állít árucikkenként. Nem százalékos mezőt, hanem ötfokú csúszkát:

| Fokozat | Haszonkulcs | Népszerűség körönként |
|---|---:|---:|
| Nagyon olcsó | 5% | +3 |
| Olcsó | 15% | +1 |
| Piaci | 30% | 0 |
| Drága | 50% | −1 |
| Uzsora | 80% | −3 |

**Kereslet: a városlakók nem mindent vesznek meg**

- A város **Kereslete** árucikkenként véges, például 80 egység körönként, szemben a 100 egység kínálattal.
- A kereslet az eladók között **ár és népszerűség szerint** oszlik el. Az olcsóbb és népszerűbb eladó nagyobb részt kap, de a drágább is elad valamennyit.
- A javasolt képlet:

> vásárlási súly = részesedés × (1 + Népszerűség/100) / (1 + haszonkulcs)

- Így a legolcsóbb sem viszi el az egész piacot, és a drága, de népszerű eladó is megél. **Ezzel megakad az árháború a nulláig.**
- Az **alsó korlát** (5%) és a népszerűség **csökkenő hozama** (100 felett nem nő) tovább fékezi a leárazást.

**Láthatóság és alákínálás**

- A városban mindenki látja az árucikkenkénti **haszonkulcsokat** és az eladók nevét. Ez a „licitálás” alapja.
- Az alákínálás egyszerűen annyi, hogy a saját fokozatodat a rivális alá állítod. Opcionálisan: *„Tartsd egy fokkal a legolcsóbb alatt”* állandó utasítás. Ez csökkenti a mikromenedzsmentet.

**Részesedés vásárlása és kivásárlás**

- **Semleges részesedés vásárlása:** a Semleges pontokat a város árulja, fix áron. Ez árucikkenként és pontonként kerül meghatározott aranyba, például 5 aranyba.
- **Szomszédos város:** csak útvonallal elérhető városban lehet vásárolni. Ez a v0.1 4.3-as szabálya, változatlanul.
- **Kivásárlás:** egy rivális részesedése **felárral** vehető meg, például a piaci érték 150%-áért. A pénz a rivális kapja.
  - A rivális a következő fázisban **visszautasíthatja**, ha ugyanannyit fizet a városnak („védekező vétel”).
  - Aki kivásárolt, az adott árucikkből 3 körig nem vásárolható ki újra.
  - Így a kivásárlás lehetséges, de nem lehet vele egy játékost egy éjszaka alatt kiforgatni.

### 4.2. Politika / Nemesség – Parlament

**Párt és tanács**

- **Pártalapítás:** aranyért, például 40 aranyért. Egy játékosnak városonként legfeljebb 1 pártja lehet.
- **Választás:** minden **6. körben** (napi 2 körnél háromnaponta).
  - A tanács helyei (például 9) a pártok népszerűsége szerint oszlanak el, **D'Hondt-módszerrel**.
  - **5%-os küszöb** alatt a párt kiesik a tanácsból.
- A választás előtti körben a pártok **kampányolhatnak**: dupla hatású fesztivál, de dupla ára is van.

**Adó**

- A város **adóalapja** körönként a piaci forgalom egy része, például a kereskedői bevételek 20%-a. **A kereskedők fizetik az adót, a politikusok kapják.** Ez erős, természetes feszültség a két ág között.
- Minden pártnak van egy **programadókulcsa** (alacsony / közepes / magas).
  - A tényleges városi adókulcs a tanácsi pártok **mandátumokkal súlyozott átlaga**.
  - A pártok az adóbevételt a mandátumaik arányában kapják.
  - A saját programadókulcs a párt népszerűségét módosítja: az alacsony adó népszerű, a magas népszerűtlen.
- Ettől az adó politikai kérdés lesz: a népszerű, alacsony adót ígérő párt kevesebbet kap, de több mandátumot szerez.

**Fesztivál:** aranyért népszerűséget ad. A hatás csökkenő, és ugyanabban a városban 3 körig kevesebbet ér.

**Hírek (a politikai ág fő fegyvere)**

A hír nem szabad szöveg, hanem **sablon a játékállapotról**, így a motor el tudja dönteni, igaz-e:

| Hírsablon | Mikor igaz? |
|---|---|
| „X uzsoraáron árulja a sót.” | X haszonkulcsa legalább „Drága”. |
| „X pártja az adóemelést támogatja.” | X programadókulcsa „magas”. |
| „X kivásárolta Y-t.” | Volt ilyen tranzakció az elmúlt 3 körben. |
| „X megszegte a szerződését.” | Volt szerződésszegés. |
| „X a városlakók barátja.” (pozitív) | X népszerűsége az átlag fölött van. |

- **Igaz hír:** a hatás teljes (−5 vagy +5 népszerűség a célpontnak).
- **Hamis hír:** a hatás ugyanaz, **amíg ki nem derül**. A terjesztő tudja, hogy hazudik. Ez a kockázata.
- **Leleplezés** (lásd a kémeknél): a hatás visszafordul, a terjesztő −10 népszerűséget kap, és az eset nyilvánossá válik.

### 4.3. Kémhálózat – Alvilág

**Kémek**

- Egy kém felfogadása aranyba kerül (például 20), és körönként 2 arany a fenntartása.
- A kém **egy városban** dolgozik, a hálózatodban.
- A kémnek **Rejtettsége** van. A lebukott kém elvész.

**Kémakciók**

| Akció | Hatás | Kockázat |
|---|---|---|
| **Parancsok kifürkészése** | A Hírszerzés fázisban felfedi egy kiválasztott játékos lezárt parancsait az adott városban. Egy kém: az akció típusa. Két kém: típus és célpont. | Ellenkém esetén lebukás |
| **Hír ellenőrzése** | Megmondja, igaz-e egy hír. Ha hamis, **nyilvános leleplezés** kezdeményezhető. | alacsony |
| **Ellenkémkedés** | Az adott városban védi a saját parancsaidat, és lebuktathatja az idegen kémeket. | nincs |
| **Információ eladása** | A kifürkészett parancsot rendszerszintű letéttel eladod: a vevő fizet, a rendszer adja át az információt. Így nem lehet csalni. | nincs |

**A kémág gazdasága:** csak az információeladásból a kémág gyenge lenne. Két javaslat:

- A **leleplezésért jutalom** jár: a leleplező népszerűséget kap, a város pedig „jutalmat fizet” aranyban.
- **Zsarolás** (későbbi kiegészítésként): egy felfedett parancsért vagy hamis hírért a kém aranyat kérhet a lebukottól, cserébe hallgat. Ez a döntés a célpontra van bízva, és kiváló diplomáciai helyzeteket teremt.

### 4.4. Mi lesz a katonasággal?

Az új modellben nincs katonai ág. Ez illik az „ez nem hadijáték” iránnyal, de két szerepe hiányozni fog:

- **Útvonalak veszélyeztetése (Útzár).** Javaslat: átkerül az Alvilágba, **„Csempészek és útonállók bérlése”** néven, kémakcióként.
- **Fizikai fenyegetés a késői játékban.** Ez maradhat a kampányok világeseményeinek dolga, például barbár betörés vagy zsoldosok. Ez már nehézségi paraméter, nem az alapszabály része.

---

## 5. Győzelem: hogyan lesz mindebből Legitimitás?

A három ágnak **egyenrangú utat** kell adnia a győzelemhez. A javasolt pontforrások körönként, városonként:

| Forrás | Legitimitás |
|---|---:|
| Tanácsi mandátum | +1 mandátumonként |
| Tanácsi többség (párt vagy koalíció) | +3 |
| Árucikk vezető eladója (legnagyobb forgalom) | +2 árucikkenként |
| A város legnépszerűbb szereplője | +2 |
| Sikeres leleplezés | +3 egyszeri |
| Eladott információ | +1 egyszeri |

A **Koronázási Tanács** a szezon végén az összes városi tanács szavazataiból áll. Minden városi tanács a benne legtöbb mandátummal rendelkező jelöltre szavaz. Ez +10 Legitimitást ad szavazatonként. Így a politikai ág adja a végső csúcspontot, de egyedül nem elég.

---

## 6. Kampányok és nehézség

Az alapszabályok változatlanok. A kampányok **paraméterekkel** térnek el:

| Paraméter | Könnyű | Normál | Nehéz |
|---|---|---|---|
| Városok száma | 3 | 5 | 8+ |
| NPC-házak aktivitása | passzív | kiegyensúlyozott | agresszív (álhír, kivásárlás) |
| A kereslet árérzékenysége | alacsony | közepes | magas (árháború) |
| Választások gyakorisága | 8 körönként | 6 körönként | 4 körönként |
| Kémek hatékonysága | típus és célpont | típus | csak típus, gyakori lebukás |
| Világesemények | ritka | közepes | gyakori (éhínség, zendülés) |

---

## 7. Mit jelent ez a meglévő kódra nézve?

| Rész | Változás |
|---|---|
| Hálózat, útvonalak, körök, jelentések | **megmarad** |
| Zéró összegű 100 pontos modell | **megmarad**, de nem befolyásként, hanem árucikk-részesedésként |
| Frakciók (Nemesség, Kereskedők, Katonaság) | **lecserélődik** az Üzletek / Parlament / Alvilág hármasra |
| Gyanú, rejtett befolyás | **átalakul**: a Gyanú helyére a népszerűség, a rejtett befolyás helyére a kémek és a hírek lépnek |
| Új rendszerek | kereslet és árazás, adó, választás és D'Hondt, hírsablonok és igazságvizsgálat, kémek, információs letét, kétfázisú kör |
| Városnézet | a három negyed már most is Felsőváros / Vásártér / Citadella. Javaslat: **Parlament / Vásártér / Alvilág** (a palota helyén városháza, a csillagerőd helyén a kikötői zug vagy a katakombák) |

---

## 8. Nyitott kérdések

1. **Szerepek:** mindenki mindhárom ágban játszhat (javaslat), vagy a játékos egy ágat választ?
2. **Népszerűség:** egy érték városonként (javaslat), vagy ágankénti hírnév?
3. **Parancsok felfedése:** belefér a kétfázisú kör (tervezés, zárás, hírszerzés, végrehajtás)?
4. **Hírek:** jó irány, hogy csak sablonos, ellenőrizhető állítás lehet (javaslat), vagy szabad szöveget is szeretnél?
5. **Kivásárlás:** legyen védekezési lehetőség (javaslat), vagy maradjon a kíméletlen piac?
6. **Adó:** a kereskedők fizetik és a politikusok kapják (javaslat), vagy a város saját bevételéből jön?
7. **Katonaság:** átkerüljön az Útzár az Alvilágba, vagy maradjon egy negyedik, szűkebb ág?
8. **Árucikkek:** városonként 2–4 elég, vagy kell egy közös, régiós piac is (szállítás városok között)?

---

## 9. Javasolt következő lépés

Ha a nyitott kérdésekre megvan a válasz:

1. **Szabálykönyv v0.2** a számokkal, a v0.1 szerkezetében.
2. **A prototípus frissítése:** a böngészős prototípusban ki lehet próbálni az árazást, a választást és a kémeket, mielőtt a Spring- és a Flutter-kód átíródna.
3. **Árháború-szimuláció:** néhány bot eltérő árazási stratégiával, hogy kiderüljön, jó-e a keresleti képlet.
