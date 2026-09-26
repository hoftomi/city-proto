# Trón nélkül – Befolyásrendszer szabálykönyv v0.1

*Asztali prototípus és a digitális MVP közös szabályalapja*

---

## 0. Rögzített tervezési döntések

| # | Döntés | Következmény a szabályokban |
|---|---|---|
| D1 | A befolyás zéró összegű: minden frakció 100 pontból áll, a gazdátlan rész Semleges. | 2. fejezet |
| D2 | **Bármilyen akció csak útvonallal elérhető városban hajtható végre.** | 4. fejezet |
| D3 | **Erős NPC-aktivitás**, hogy a játék kevés játékossal is élő legyen. | 9. fejezet |
| D4 | **Létezik rejtett befolyás**, amely csak kémkedéssel vagy önleleplezéssel derül ki. | 8. fejezet |
| D5 | A feldolgozás fix körökben, egyszerre történik. | 3. fejezet |
| D6 | A Legitimitás körönként halmozódik, nem a szezon végi pillanatfelvétel dönt. | 10. fejezet |

---

## 1. A prototípus kerete

### 1.1. Résztvevők

- 3–6 játékos
- 1 játékvezető (JV), aki a rejtett parancsokat feldolgozza, az NPC-ket mozgatja, és táblázatban vezeti az állást
- NPC-házak, amelyek kitöltik a hiányzó helyeket (lásd 9.1)

### 1.2. Kellékek

- Térkép csomópontokkal (városállamok, birtokok) és élekkel (utak)
- JV-táblázat: a frakciók állása, az erőforrások és a Gyanú
- Parancslapok (játékosonként és körönként egy)
- Jelentéslapok (a JV tölti ki, mindenki csak a sajátját kapja)
- 2 db hatoldalú kocka (k6)

### 1.3. Időegység

- **1 kör = 1 játéknap.** A digitális változatban ez napi 2 feldolgozásra bontható: fele PP, fele romlás körönként.
- Egy prototípus-szezon **12 körből** áll.

### 1.4. Erőforrások (csak a prototípushoz)

| Erőforrás | Rövidítés | Alap bevétel körönként | Tárolás |
|---|---|---:|---|
| Parancspont | PP | 10 | legfeljebb 20 |
| Arany | A | 10 | korlátlan |
| Befolyáspont | BP | 3 | korlátlan |
| Katonai erő | KE | 1 | legfeljebb 6 |
| Legitimitás | L | – | győzelmi pont, nem költhető |

A többi GDD-erőforrás (élelem, építőanyag, vas) a prototípusban nem szerepel.

---

## 2. A frakciók és a befolyás alapmodellje

### 2.1. Frakciók

Minden városállamban három frakció működik: **Nemesség**, **Kereskedők** és **Katonaság**.

### 2.2. Támogatás

- Minden frakció **100 támogatáspontból** áll.
- A pontok lehetnek:
  - egy szereplő (játékos vagy NPC-ház) **nyílt befolyása**,
  - egy szereplő **rejtett befolyása** (8. fejezet),
  - **Semleges** (gazdátlan) pontok.
- A pontok összege mindig pontosan 100.
- A számításokat a JV egy tizedes pontossággal végzi, a játékosoknak kerekítve jelenti.

### 2.3. Saját befolyás

Egy szereplő **teljes befolyása** egy frakcióban a nyílt és a rejtett befolyásának összege. A csökkenő hozamot ez alapján kell számolni. A kontrollszinteket viszont **csak a nyílt befolyás** alapján (lásd 6. és 8. fejezet).

---

## 3. A kör menete

1. **Jelentés.** A JV kiosztja az előző kör jelentéslapjait, és felolvassa az új városi eseményeket és frakciókéréseket.
2. **Diplomácia (kb. 10 perc).** Szabad tárgyalás a játékosok között. NPC-ajánlatok és NPC-válaszok (9.4).
3. **Parancsok.** Minden játékos titokban kitölti a parancslapját. A JV ezzel párhuzamosan dobja meg az NPC-házak parancsait (9.2).
4. **Feldolgozás.** A JV az összes parancsot egyszerre, az alábbi sorrendben hajtja végre:

| Lépés | Mi történik |
|---|---|
| 4.1 | Megszilárdítások életbe lépnek |
| 4.2 | Útzárak és útvédelem (4.5) |
| 4.3 | Támadó akciók: Lejáratás, Szálak felgöngyölítése |
| 4.4 | Nyereség-akciók (nyílt és rejtett) |
| 4.5 | Leleplezkedések |
| 4.6 | Romlás |
| 4.7 | Kontrollszintek és Gyanú frissítése |
| 4.8 | Jutalmak, bevételek, fenntartási költségek |
| 4.9 | Új útvonalak aktiválása |
| 4.10 | A következő kör eseményeinek és kéréseinek kisorsolása |

**Egyidejűség szabálya:** az ugyanabban a lépésben lévő akciók egymástól függetlenül, ugyanarról a kiinduló állásról számolódnak, és a hatásuk összeadódik.

---

## 4. Útvonalak és elérhetőség

### 4.1. A térkép

- A **csomópontok** a városállamok, valamint a játékos- és NPC-birtokok.
- Az **élek** az utak (szárazföldi vagy tengeri). Minden él két szomszédos csomópontot köt össze.
- Minden birtok legalább 2 városállammal szomszédos.

### 4.2. Útvonal

Az **útvonal** egy szereplő saját kiépített kapcsolata egy élen.

- **Hálózat:** a szereplő birtoka, valamint minden csomópont, amely a birtokhoz a szereplő saját aktív útvonalain keresztül, megszakítás nélkül kapcsolódik.
- **Kiépítés:** 1 PP + 3 A. Olyan élre építhető, amelynek egyik vége már a hálózat része.
- **Aktiválás:** az új útvonal a kör végén (4.9) válik aktívvá, a városban tehát csak a következő körtől lehet akciózni.
- **Fenntartás:** 1 A útvonalanként körönként. Ha a szereplő nem fizet, az útvonal megszűnik.
- **Korlát:** legfeljebb 4 útvonal, amely minden Városkontroll után +1-gyel nő.

### 4.3. Elérhetőség – az alapszabály

> **Egy szereplő bármilyen akciót (befolyásnövelést, támadást, kémkedést, kérés teljesítését) csak olyan városállamban hajthat végre, amely a hálózatának része.**

Kivételek:

- **Áthaladási jog:** szerződéssel egy másik szereplő átengedheti a saját útvonalait. Ilyenkor az ő hálózatán keresztül elért város is elérhetővé válik. A jog bármikor visszavonható, a visszavonás a következő körtől érvényes.
- **Szálak felgöngyölítése:** ez a kémakció végrehajtható egy olyan városban is, amely a hálózattal szomszédos, de azon kívül esik. Ilyenkor a költsége +1 PP.

### 4.4. Távolság

A **távolság** az adott város lépésszáma a birtoktól, a szereplő saját hálózatán keresztül mérve (a birtokkal szomszédos város távolsága 1). A távolság a romlást növeli (lásd 7.1).

### 4.5. Útzár

A Katonaság kontrollját is értelmes célpontnak teszi, és fizikai konfliktust ad a térképre.

- **Útzár:** 2 PP + 2 KE egy olyan élre, amelynek legalább egyik vége a hálózatod része. **2 körön át** minden más szereplő útvonala ezen az élen **zárva van**.
- **Útvédelem:** az útvonal gazdája egy 1 PP-s parancsban KE-t rendelhet az élre. Ha a védő KE-je legalább akkora, mint a támadóé, az útzár elmarad. A felhasznált KE mindkét félnél elvész.
- A zárt él mögé eső csomópontok **elvágottá** válnak.

### 4.6. Elvágott város

Ha egy város a zárás vagy egy útvonal megszűnése miatt kikerül a hálózatból:

- a meglévő befolyás megmarad,
- **új akció nem indítható** ott,
- a romlás **kétszeres**,
- a frakciójutalmak felére csökkennek (lefelé kerekítve).

### 4.7. Kereskedelmi hozam

Minden aktív útvonal után, amelynek egyik vége városállam, **az adott város Kereskedőinél +1 nyílt befolyás és +1 A** jár körönként, a nyereség-szabályok szerint (5.2).

---

## 5. Befolyásnövelés

### 5.1. Akciók

| Akció | Frakció | Költség | Alaperő | Feltétel |
|---|---|---|---:|---|
| Pártfogás | bármely | 1 PP + 3 A | +4 | – |
| Nagy adomány | bármely | 2 PP + 8 A | +10 | – |
| Tanácstag megnyerése | Nemesség | 2 PP + 3 BP | +8 | legalább Jelenlét (nyílt) |
| Városőrség támogatása | Katonaság | 1 PP + 1 KE | +6 | – |
| Kereskedelmi útvonal | Kereskedők | lásd 4.2 | +1 körönként | aktív útvonal a városba |
| Kérés teljesítése | a kérés szerint | lásd 9.5 | a kérés szerint | – |

### 5.2. A nyereség képlete

> **Nyereség = Alaperő × (1 − Teljes saját befolyás / 150) × Módosítók**

**Módosítók** (szorzódnak):

| Módosító | Érték |
|---|---:|
| Háttértípus-egyezés (pl. Kereskedőház a Kereskedőknél) | ×1,25 |
| Gyanú 1 (9.3) | ×0,75 |
| Gyanú 2 | ×0,5 |
| Lázongó város (7.2) | ×0,75 |

### 5.3. Honnan jön a nyereség?

1. **Először a Semlegesből.**
2. Ha a Semleges nem elég, a hiányzó rész **a többi szereplőtől** jön, a befolyásuk (nyílt + rejtett) arányában, **fele hatékonysággal**: 1 pont elhódításához 2 pont nyereség kell.
3. Ha ugyanabban a lépésben több szereplő pályázik a Semlegesre, és az nem elég mindenkinek, a Semleges a nyereségigényük arányában oszlik el. A maradékra ezután a 2. pont vonatkozik.

**Példa.** Feketerév Kereskedői: A 10, B 55, C 12, Semleges 23.
A Nagy adományt ad: 10 × (1 − 10/150) = 9,3 pont. Ez teljes egészében a Semlegesből jön: A 19,3, Semleges 13,7.

---

## 6. Kontrollszintek

A szintek **csak a nyílt befolyás** alapján számolódnak.

| Szint | Feltétel | Hatás |
|---|---|---|
| **Jelenlét** | legalább 10 | sávos információ a frakcióról (11. fejezet) |
| **Helyi partner** | legalább 25 | frakció-alapbónusz, szavazat a városi eseményekben |
| **Domináns** | legalább 35, **és** legalább 5 ponttal az első a második előtt (a második lehet NPC is) | teljes frakcióbónusz, Legitimitás |
| **Városkontroll** | Domináns 2 frakcióban | városjutalom, +1 útvonal-korlát |
| **Protektorátus** | Domináns mindhárom frakcióban | maximális jutalom, de a város stabilitása egy fokot romlik, és Nyílt kihívás indítható ellene |

**Nyílt kihívás (Protektorátus ellen):** 3 PP + 5 BP. Egy körre megduplázza a kihívó nyereség-akcióinak alaperejét az adott városban. A kihívás ténye mindenki számára nyilvános.

**Holtverseny:** ha senki sem vezet legalább 5 ponttal, a frakciónak nincs Domináns szereplője. Ha korábban volt, az elveszíti a státuszát.

---

## 7. Romlás és stabilitás

### 7.1. Romlás

Minden kör végén (4.6) minden szereplő befolyásának egy része visszamegy a Semlegesbe.

| Tényező | Romlás körönként |
|---|---:|
| Nyílt befolyás alapértéke | 5% |
| Rejtett befolyás alapértéke | 8% |
| Távolság 1 felett lépésenként | +1% |
| Ingatag város | +2% |
| Lázongó város | +4% |
| Gyanú 2 vagy több | +2% |
| **Felső korlát** (elvágott város nélkül) | 12% |
| Elvágott város | a teljes érték ×2 |

**Tájékozódási értékek** (szimulációval ellenőrizve, zavartalan város, távolság 1):

- körönként 1 Pártfogás nagyjából 46%-on tart meg egy frakciót;
- körönként 2 Pártfogással 35% kb. 6 kör alatt érhető el.

### 7.2. Stabilitás

Minden városállamnak van egy stabilitási foka: **Stabil**, **Ingatag** vagy **Lázongó**.

| Fok | Romlás | Támadó akciók hatása | Nyereség |
|---|---:|---:|---:|
| Stabil | +0% | ×1 | ×1 |
| Ingatag | +2% | ×1,25 | ×1 |
| Lázongó | +4% | ×1,5 | ×0,75 |

A stabilitás események (9.6), Protektorátus és bizonyos kérések hatására változik.

---

## 8. Rejtett befolyás

### 8.1. Rejtett akció

Bármely nyereség-akció (5.1) **rejtve** is végrehajtható:

- **Többletköltség:** +1 PP, és +50% a többi költségből (felfelé kerekítve).
- A nyereség a szereplő **rejtett készletébe** kerül az adott frakcióban.
- A Kereskedelmi útvonal passzív hozama nem lehet rejtett, mert az útvonal nyilvános.

### 8.2. Mit látnak a többiek?

- A frakció állásában a rejtett pontok egy közös **„Ismeretlen”** sorban jelennek meg, mindenki számára. Azt tehát látják, hogy valaki mozgatja a szálakat, azt viszont nem, hogy ki, és hány szereplő.
- A saját rejtett befolyását mindenki pontosan látja.

### 8.3. Mit ad a rejtett befolyás?

- Beleszámít a **teljes befolyásba** a csökkenő hozam szempontjából (5.2).
- **Nem** számít bele a kontrollszintekbe, és **nem** ad Legitimitást.
- **Titkos haszon:** frakciónként minden megkezdett 10 rejtett pont után +1 A körönként.
- **Információ:** 10 rejtett pont felett a szereplő Jelenlét-szintű információt kap a frakcióról, akkor is, ha nyílt befolyása nincs.
- **Árnyékvédelem:** a rejtett pontokat a Lejáratás nem érheti, amíg ki nem derül, kié.

### 8.4. Leleplezkedés

- **Költség:** 1 PP. A szereplő a rejtett befolyását egy frakcióban teljes egészében nyílttá alakítja.
- A 4.5. lépésben hajtódik végre, vagyis még a kontrollszintek kiszámítása előtt. Így váratlan hatalomátvétel is lehetséges.
- **Ára:** a szereplő +1 Gyanút kap ennél a frakciónál (9.3).

### 8.5. Szálak felgöngyölítése (kémakció)

- **Költség:** 2 PP + 2 BP (a hálózaton kívüli szomszédos városban +1 PP).
- **Próba:** k6. Siker 4 vagy több esetén. +1 jár, ha a kémkedő Domináns az adott frakcióban. −1 jár, ha a célpont ugyanabban a körben Megszilárdítást hajtott végre.
- **Siker:** a kémkedő megtudja, hogy az „Ismeretlen” pontok kik között és milyen arányban oszlanak meg. Ezután választhat:
  - **Megtartja az információt.** Ez diplomáciai alkualap, például zsarolásra.
  - **Nyilvánosságra hozza.** A leleplezett rejtett befolyás azonnal nyílttá válik, a gazdája +1 Gyanút kap, és elveszíti a Titkos hasznot abban a frakcióban.
- **Kudarc 1-es dobással:** a kémkedő lebukik (lásd 12.2).

---

## 9. NPC-rendszer

Az NPC-réteg célja kettős: kis játékosszám mellett is legyen verseny, és a városállamok ne passzív tárgyak legyenek, hanem reagáló politikai rendszerek.

### 9.1. NPC-házak

Az NPC-házak a játékosokhoz hasonló szereplők: van birtokuk, hálózatuk, befolyásuk és Legitimitásuk.

**Számuk:** összesen legyen **8 hatalmi ház** (játékos és NPC együtt). Ha 3 játékos van, 5 NPC-ház kell, 6 játékosnál 2. Legalább 2 NPC-ház mindig legyen.
*(A digitális változatban a cél: frakciónként átlagosan 2–3 aktív szereplő.)*

**Erőforrásaik:** körönként 8 PP, 8 A, 3 BP, 1 KE. Kicsivel gyengébbek a játékosoknál, de nem fáradnak el.

**Jellemtípusok:**

| Típus | Kedvenc frakció | Stílus | Különleges szokás |
|---|---|---|---|
| Kalmárház | Kereskedők | útvonalépítés, adományok | minden 2. körben új útvonalat épít, amíg lehet |
| Ősi nemzetség | Nemesség | lassú, stabil terjeszkedés | soha nem használ rejtett akciót, és gyakran ad Megszilárdítást |
| Zsoldoskapitány | Katonaság | agresszív | Útzárat tesz a legerősebb szomszédja útvonalára |
| Árnyékszövő | változó | rejtett akciók, Lejáratás | minden nyereség-akciója rejtett, és 3 körönként Szálak felgöngyölítését végzi |

### 9.2. Az NPC-házak döntési sorrendje

A JV minden körben minden NPC-háznál ebben a sorrendben dönt, amíg a PP el nem fogy:

1. **Védekezés:** ha az NPC Domináns egy frakcióban, és a második legerősebb szereplő 8 pontnál közelebb van hozzá, Megszilárdítást és Pártfogást ad ott.
2. **Kérés:** ha van a hálózatában teljesíthető frakciókérés (9.5), teljesíti.
3. **Terjeszkedés:** Nagy adományt vagy Pártfogást ad a kedvenc frakciójának abban az elérhető városban, ahol a legtöbb Semleges van.
4. **Útvonal:** ha kevesebb mint 3 elérhető városa van, útvonalat épít.
5. **Intrika (k6):**
   - 5–6: Lejáratás az ellen a játékos ellen, aki a legközelebb van hozzá a Legitimitás-listán. A Zsoldoskapitány és az Árnyékszövő 4–6-ra is ezt teszi.
   - 1–4: a maradék PP-t Pártfogásra költi.

### 9.3. Frakció-reakciók: a Gyanú

Minden szereplőnek frakciónként van egy **Gyanú** értéke (0–3), amely az adott frakció hozzáállását mutatja.

**Gyanúnövelő események (+1):**

- egyetlen körben legalább 15 pont nyílt nyereség egy frakcióban;
- Városkontroll megszerzése az adott városban (a város mindhárom frakciójában);
- lebukás az adott városban;
- Leleplezkedés vagy lelepleződés az adott frakcióban.

**Hatás:**

| Gyanú | Hatás |
|---:|---|
| 0 | nincs |
| 1 | nyereség ×0,75 |
| 2 | nyereség ×0,5 és romlás +2% |
| 3 | **Kiűzetés:** a nyílt és rejtett befolyás fele azonnal Semlegessé válik, a Gyanú pedig 1-re áll vissza |

**Csökkentés:**

- Magától −1, ha a szereplő 2 egymást követő körben nem kap új Gyanút az adott frakcióban.
- **Engesztelés:** 1 PP + 5 A, −1 Gyanú egy frakcióban. Ez nem számít nyereség-akciónak.

Az NPC-házakra ugyanezek a szabályok vonatkoznak.

### 9.4. NPC-diplomácia

Az NPC-házakkal a Diplomácia fázisban lehet tárgyalni. A JV k6-tal dönt az elfogadásról:

| Ajánlat | Alap célszám (legalább) |
|---|---:|
| Megnemtámadás (Lejáratás és Útzár tilalma, 3 kör) | 3 |
| Áthaladási jog (3 kör, 1 A körönként az NPC-nek) | 4 |
| Befolyásmegosztás (egy város frakcióinak felosztása) | 5 |

**Módosítók:** −1 (könnyebb), ha a játékosnak nincs szerződésszegése. +1, ha a játékos a Legitimitás-lista élén áll. +2, ha a játékos korábban megszegett szerződést ezzel az NPC-vel.

Az NPC-házak **maguk is tesznek ajánlatot**: minden körben 1 véletlen NPC-ház ajánlatot tesz annak a játékosnak, akivel a legtöbb városban versenyez.

### 9.5. Frakciókérések

Minden kör végén (4.10) a JV k6-tal **1–2 kérést** sorsol a városállamokban. Egy kérést **csak egy szereplő** teljesíthet: az, aki a legtöbbet ajánlja. Döntetlennél a nagyobb nyílt befolyással rendelkező.

| k6 | Kérés | Ár | Jutalom |
|---:|---|---|---|
| 1 | A Katonaság zsoldot kér | 2 KE + 1 PP | +8 Katonaság, +1 L |
| 2 | A Kereskedők kikötői beruházást kérnek | 10 A + 1 PP | +8 Kereskedők, +1 útvonal-korlát a szezon végéig |
| 3 | A Nemesség tanácsi támogatást kér | 4 BP + 1 PP | +8 Nemesség, +2 L |
| 4 | A város segélyt kér | 8 A + 1 PP | a város stabilitása 1 fokot javul, +1 L |
| 5 | Két frakció viszálya: az egyik a másik ellen kér segítséget | 2 PP | +10 a kérő frakciónál, −5 a másiknál (Semlegessé) |
| 6 | Titkos kérés | 2 PP + 5 A | +10 rejtett befolyás egy véletlen frakcióban |

A kérés sorsolásakor a JV azt is kisorsolja, melyik városban történik.

### 9.6. Városi események

Minden kör végén k6: ha az eredmény 5 vagy 6, egy városi esemény történik egy véletlen városban (második k6):

| k6 | Esemény | Hatás |
|---:|---|---|
| 1 | Lázadás | a stabilitás 1 fokot romlik |
| 2 | Nemesi viszály | a Nemesség Domináns szereplője 5 pontot veszít (Semlegessé) |
| 3 | Kereskedelmi fellendülés | 2 körig a városba vezető útvonalak dupla hozamot adnak |
| 4 | Járhatatlan utak | a várost érintő egyik él 2 körig zárva van |
| 5 | Új követ | új NPC-ház jelenik meg a térkép szélén (legfeljebb 10 ház) |
| 6 | Nyugalom | a stabilitás 1 fokot javul |

---

## 10. Jutalmak és Legitimitás

### 10.1. Frakciójutalmak körönként

| Frakció | Helyi partner | Domináns |
|---|---|---|
| Nemesség | +1 BP | +2 BP, **+3 L** |
| Kereskedők | +2 A | +4 A, +1 L |
| Katonaság | +1 KE a szezon folyamán legfeljebb 1 alkalommal | +1 KE körönként, +1 L, a hálózatodba eső éleken Útzárad a támadó ellen +1 KE-t ér |

### 10.2. Városjutalmak körönként

| Szint | Jutalom |
|---|---|
| Városkontroll | +5 L |
| Protektorátus | a Városkontroll helyett +8 L |

**Városérték szorzó:** a kulcsvárosok (prototípusban 2 darab, például Fehérkolostor és Feketerév) jutalma ×1,5 (felfelé kerekítve).

### 10.3. Koronázási Tanács (a 12. kör végén)

- Minden városállam Nemességének Domináns szereplője +5 L-t kap: ez a tanácsi szavazat.
- A legtöbb Legitimitással rendelkező **játékos** nyer.
- **Bitorló-változat (opcionális):** ha egy NPC-ház áll az élen, a játékosok közösen veszítenek. Ez együttműködésre ösztönöz, de csak akkor érdemes bekapcsolni, ha a tesztek szerint az NPC-k nem túl erősek.

---

## 11. Láthatóság

| Játékos helyzete az adott frakcióban | Amit lát |
|---|---|
| Nincs jelenlét, de a város elérhető | csak a Semleges és az „Ismeretlen” arányát, 10 pontos sávokban |
| Jelenlét (nyílt ≥10, vagy rejtett ≥10) | a rivális szereplők számát és értékeit 10 pontos sávokban (például „20–30”) |
| Helyi partner | neveket és 5-re kerekített értékeket |
| Domináns | pontos értékeket, és a frakciót érintő, feldolgozásra váró nyílt akciók **számát** |

A saját értékeit, a Semleges arányát és a saját rejtett készletét mindenki pontosan látja. Egy sikeres Szálak felgöngyölítése a következő körben egy szinttel pontosabb képet ad az adott frakcióról.

---

## 12. Támadó és védekező akciók

### 12.1. Akciók

| Akció | Költség | Hatás |
|---|---|---|
| Lejáratás | 2 PP + 2 BP | a célpont nyílt befolyása −8 (a stabilitás szorzójával), ami **Semlegessé** válik |
| Megszilárdítás | 1 PP | a kör végéig egy frakcióban felére csökkenti a saját befolyásodat érő támadó akciók hatását |
| Engesztelés | 1 PP + 5 A | −1 Gyanú (9.3) |
| Útzár / Útvédelem | lásd 4.5 | |
| Szálak felgöngyölítése | lásd 8.5 | |

### 12.2. Lebukás

A Lejáratás minden esetben kockázatos: **k6, 1-es eredmény esetén lebukás.** Ha a célpont Megszilárdítást hajtott végre, már 1–2 is lebukás.

**A lebukás következményei:**

- a sértett fél megtudja, ki támadta;
- a támadó +1 Gyanút kap az adott frakcióban;
- a sértett fél **casus bellit** kap, vagyis a következő 3 körben a támadó ellen indított Lejáratásai nem járnak lebukási kockázattal.

---

## 13. Kezdőállás (példatérkép, 8 városállam)

### 13.1. Városok

| Város | Profil | Stabilitás | Kulcsváros |
|---|---|---|---|
| Feketerév | kikötő, erős Kereskedők | Stabil | igen |
| Vaskapu | erődváros, erős Katonaság | Stabil | – |
| Fehérkolostor | vallási központ, magas legitimitás | Stabil | igen |
| Szélmező | gabonavidék | Ingatag | – |
| Délkapu | határváros | Ingatag | – |
| Ködvár | hegyi nemesi fészek | Stabil | – |
| Sóhegy | bányaváros | Ingatag | – |
| Holtág | mocsári csempészváros | Lázongó | – |

### 13.2. Utak (élek)

Feketerév–Szélmező, Feketerév–Holtág, Feketerév–Fehérkolostor, Fehérkolostor–Ködvár, Fehérkolostor–Szélmező, Szélmező–Délkapu, Délkapu–Vaskapu, Vaskapu–Sóhegy, Sóhegy–Ködvár, Ködvár–Holtág, Holtág–Délkapu.

A 8 birtokhely (játékosok és NPC-k) a gyűrű külső oldalán helyezkedik el, mindegyik 2 szomszédos várossal van összekötve, így minden város 2 birtokhellyel szomszédos.

### 13.3. Induló befolyás

- Minden frakció 100% Semlegessel indul.
- **Kivétel a városprofil:** minden városban egy „helyi erő” előny van. Az a frakció, amely a profil alapján erős, 20 pontot kap egy **helyi NPC-klánnál**. A helyi klán nem cselekszik, csak romlik, és elhódítható.
- Minden NPC-ház a kedvenc frakciójában 10 ponttal indul a két szomszédos városában.
- A játékosok kezdő készlete: 10 PP, 15 A, 5 BP, 2 KE, valamint 2 ingyenes, azonnal aktív útvonal a birtokkal szomszédos két városba.

### 13.4. Kezdővédelem

Az első 2 körben senki ellen nem indítható Lejáratás, Útzár vagy Szálak felgöngyölítése.

---

## 14. Hangolandó paraméterek (összesítő)

Minden szám egy helyen, a szimulációhoz és a tesztek utáni hangoláshoz.

| Paraméter | Érték |
|---|---:|
| PP körönként / tárolási felső korlát | 10 / 20 |
| Alap bevétel: A / BP / KE | 10 / 3 / 1 |
| Csökkenő hozam osztója | 150 |
| Hatékonyság a riválisoktól való elhódításnál | 0,5 |
| Nyílt / rejtett romlás | 5% / 8% |
| Romlás távolság szerint (1 felett lépésenként) | +1% |
| Romlás felső korlátja | 12% |
| Kontrollküszöbök (Jelenlét / Partner / Domináns) | 10 / 25 / 35 |
| A Domináns szinthez szükséges minimális előny | 5 |
| Rejtett akció többletköltsége | +1 PP és +50% |
| Útvonal ára / fenntartása / alap korlátja | 1 PP + 3 A / 1 A / 4 |
| Útzár ára / időtartama | 2 PP + 2 KE / 2 kör |
| Lejáratás hatása | −8 |
| Gyanú-küszöb nyereség alapján | 15 pont körönként |
| Hatalmi házak száma | 8 |
| NPC PP körönként | 8 |
| Szezonhossz | 12 kör |

---

## 15. Amit az első tesztek alapján mérni kell

1. **Elfogy-e a Semleges**, és ha igen, hányadik körben? A cél az, hogy a 4–6. kör körül forduljon át a játék kiszorításos szakaszba.
2. **Mennyi PP megy fenntartásra** (Pártfogás, útvonalak) és mennyi terjeszkedésre? Ha a fenntartás több mint 60%, a romlás túl erős.
3. **Használják-e a rejtett befolyást**, és megéri-e? Ha senki sem használja, a többletköltség túl nagy. Ha mindenki mindig, akkor túl kicsi.
4. **Hány Gyanú-kiűzetés történik?** Szezononként 0–2 a cél.
5. **Mennyire erősek az NPC-házak?** Az NPC-knek a Legitimitás-lista középmezőnyében kell végezniük.
6. **Kialakulnak-e szerződések** a játékosok között, illetve játékosok és NPC-k között?
7. **Stratégiailag fontos-e a térkép?** Kiderül-e, hogy vannak kulcsfontosságú élek, és használják-e az Útzárat?
