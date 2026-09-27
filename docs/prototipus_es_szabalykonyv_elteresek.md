# Prototípus és szabálykönyv – eltérések

2026. szeptember 27. · hoftomi

Élő, szerkeszthető változat: https://claude.ai/artifact/16YfagXQNgGWBAuPrBoYpL

## Összefoglaló

A prototípus a szabálykönyv v0.2 magját hűen megvalósítja. A legfontosabb eltérések:

- a háttér induló bónusza nem érvényesül;
- az alapár 3 A a szabálykönyv 1 A-je helyett;
- az NPC-k útvonal nélkül minden városban cselekedhetnek;
- hiányzik a kém áthelyezése;
- hiányzik az alacsony népszerűség +50%-os költségfelára;
- az információs piac automatikus, nincs megnevezett vevő;
- nincs szezonvég és Koronázási Tanács.

**Mit vetettem össze:**

- A szabálykönyv v0.2-t és a hatalmi ágakról szóló tervezetet a Krónika IV prototípus játékmotorjával. A motor mind az öt köntösben azonos.
- Az összevetett motorrészek:
  - paraméterek: `rules.js`;
  - szabálymotor: `engine.js`;
  - kezdőállapot: `world.js`;
  - képernyők: Térkép, Város, Parancslap, Jelentések, Rangsor, lobbi.

A prototípus leírásában már szereplő négy eltérést (alapár, háttérbónusz, NPC-k és kémjelentés, csak Polgár mód) is jelölöm.

## Erőforrások, idő és elszámolás

Az idő- és pontrendszer egyezik a szabálykönyvvel. Az eltérések az induló állapotban és néhány szélső esetben vannak.

| Téma | Szabálykönyv v0.2 | Prototípus | Súly |
| --- | --- | --- | --- |
| PP | +10 elszámolásonként, legfeljebb 20 | ugyanígy | egyezik |
| Induló készlet | 10 PP, 30 A, a kezdővárosban 20 N, 2 ingyenes útvonal | 10 PP, 30 A; Szélmező 20 N, Feketerév 14 N, Délkapu 12 N; **3 útvonal** | kicsi |
| Háttérbónusz (2.2) | Kereskedőház: 20 részesedés egy árucikkből; Nemesi ház: párt és +10 N; Árnyékrend: 2 kém | a jelentkezéskor választott háttér nem hat, mindenki a rögzített Kereskedőház-kezdést kapja (20 Gabona, 10 Só) | **nagy** |
| NPC-k induló aranya | nincs szabály | 80 A házanként | kicsi |
| Érlelési idő | 2 óra (Polgár), mindenkire egyformán | te: 120 perc; az NPC-k lapja 150–330 perc | közepes |
| Egyszerre egy érlelő lap | igen | igen | egyezik |
| Azonos időben lefutó lapok | lepecsételési sorrend, holtversenyben sorsolás | lepecsételési sorrend, nincs sorsolás | kicsi |
| Végrehajtáskor érvénytelen parancs | nincs szabály | elmarad, az arany visszajár, a PP nem | hiányzik a szabályból |
| Elszámolás | 8:00 és 20:00, rögzített sorrend (3.2) | 8:00 és 20:00; a népszerűségi hatás árucikkenként azonnal számolódik, a Legitimitás már a friss értékből | kicsi |
| Népszerűség kezdőértéke és visszahúzása | 10, 2 ponttal az alap felé | ugyanígy | egyezik |
| Csökkenő hozam | 60 fölött minden pozitív hatás fele | ugyanígy | egyezik |
| 20 N alatti +50% aranyköltség (4.5) | igen | **nincs megvalósítva** | közepes |
| Útvonal-fenntartás | 1 A útvonalanként | csak a játékos fizeti, az NPC-knek nincs útvonaluk | közepes |

## Városok, kerületek és ágak

A három negyed és a három ág (Vásártér, Városháza, Alvilág) és az öt példaváros árucikkei pontosan a szabálykönyv szerintiek. Az eltérések a részletekben vannak.

**Kereskedők (5. fejezet):**

- A keresleti képlet, a haszonkulcs-fokozatok és a népszerűségi hatásuk egyezik. A túlkínálás újraosztása is egyezik.
- **Alapár:** 3 A/egység (szabálykönyv: 1 A). Minden haszon és adó háromszoros. A párt megtérülésének 6–10 elszámolásos célja ezzel az értékkel teljesül.
- **Legolcsóbb eladó bónusz:** a prototípus csak akkor adja, ha legalább két játékos árul, és a Várost nem számítja. A szabálykönyv erre nem tér ki.
- **Piaci érték:** a prototípusban legalább 2 A/pont, előzmény nélkül 3 A/pont. A szabálykönyvben nincs alsó határ.

**Politika (6. fejezet):**

- A párt, a programok, a D'Hondt-elosztás, a 9 hely, az 5%-os küszöb, a 6 elszámolásonkénti választás és a kampány egyezik.
- **Új párt programja:** a prototípusban mindig Közepes adó. A szabálykönyv nem mondja meg.
- **Adó tanács nélkül:** a szabálykönyv 20%-os kulcsot ír. A prototípus 20%-ot mutat, de nem vonja le, mert nincs, aki megkapja. A szabálykönyvnek ki kell mondania, hová megy ilyenkor az adó.
- **Fesztivál:** a prototípusban csak párttal tartható. A szabálykönyv nem köti párthoz.

**Kémhálózat (7. fejezet):**

- A felfogadás, a fenntartás, a városonkénti 3 kém, az őrök, a lebukás és a leleplezési jutalom egyezik.
- **Hiányzik:** a kém áthelyezése (1 PP).
- **Kifürkészés:** a prototípus a célpont bármely érlelő lapját felfedi. A szabálykönyv szerint csak az adott városban kiadott parancsokat.
- **Ellenőrzés és leleplezés:** a prototípus mindkettőhöz kémet követel a városban, és a leleplezés csak sikeres ellenőrzés után adható ki. Így a teljes folyamat két lap, azaz legalább 4 óra. A szabálykönyv szerint a két lépés egymás után jön, de az időt nem rögzíti.
- **Lebukás:** a prototípusban csak a kifürkészés bukhat le. A szabálykönyv szerint minden ellened indított kémakció.
- **Információs piac:** a prototípusban fix 10 A az ár, és a vevő az első NPC, akinek van elég aranya. A szabálykönyv szerint a játékos maga választ vevőt és árat, és az ajánlat lejár.

## Akciók és költségek

A 16 akcióból 14 elérhető, és a PP-árak mind egyeznek. A kém áthelyezése hiányzik, az információ eladása pedig lapon kívüli, azonnali lépés.

| Ág | Akció | Szabálykönyv | Prototípus |
| --- | --- | --- | --- |
| Közös | Útvonal kiépítése | 1 PP + 3 A | egyezik |
| Kereskedők | Fokozatváltás | 1 PP | egyezik |
| Kereskedők | Vásárlás a Várostól | 1 PP + 3 A/pont, legfeljebb 10 | egyezik |
| Kereskedők | Kivásárlási ajánlat | 2 PP + piaci érték × 150% | egyezik, a választható pont legfeljebb 10 |
| Kereskedők | Védekező vétel | 1 PP + a vételár 100%-a | egyezik; csak akkor hat, ha a te lapod fut le előbb |
| Politika | Pártalapítás | 2 PP + 40 A | egyezik |
| Politika | Programváltás | 1 PP | egyezik |
| Politika | Fesztivál | 2 PP + 15 A, kampányban dupla | egyezik, de párt kell hozzá |
| Politika | Hír terjesztése | 2 PP + 5 A | egyezik; célpont csak a városban jelen lévő ház lehet |
| Kémek | Kém felfogadása | 1 PP + 20 A | egyezik |
| Kémek | Kém áthelyezése | 1 PP | **hiányzik** |
| Kémek | Kifürkészés | 1 PP | egyezik, de nem városhoz kötött |
| Kémek | Hír ellenőrzése | 1 PP | egyezik, kém kell hozzá |
| Kémek | Leleplezés | 1 PP | egyezik, előbb ellenőrizni kell |
| Kémek | Őr beállítása | 1 PP | egyezik |
| Kémek | Információ eladása | 0 PP, szabad ár, megnevezett vevő | 0 PP, fix 10 A, automatikus vevő, azonnal |

A prototípus felhasználói felületén minden gomb kiírja a PP- és aranyköltséget. A kivásárlás ára a gombon a mostani piaci értékből számolódik. A tényleges ár a parancslapra kerüléskor rögzül.

## Térkép, mozgás, útvonalak

A hálózati szabály a játékosra egyezik: akciót csak olyan városban indíthatsz, ahová a birtokodból útvonal vezet. Az útvonal a végrehajtáskor él.

- **NPC-k:** a motor az NPC-házakat minden városban elérhetőnek veszi, útvonal és fenntartás nélkül. Ez a legnagyobb aszimmetria a prototípusban.
- **Idegen birtok:** a térképen látszó rivális birtokból (Ezüstpart) nem indíthatsz útvonalat. A szabálykönyv v0.2 erre nem tér ki.
- **Kezdő hálózat:** 3 útvonal (Birtok–Szélmező, Birtok–Délkapu, Szélmező–Feketerév). A szabálykönyvben 2 ingyenes van.
- **Kezdőhely:** a jelentkezéskor választott kezdőhely nem hat a játékra, a birtok mindig ugyanott van.
- **Útzár:** mindkét helyen kimaradt az alapjátékból.
- **Lobbi szövege:** a kezdőhelyek leírásában még szerepel az „Erős katonai városok a közelben” mondat. Ez a v0.1-ből maradt, v0.2-ben nincs katonaság.

## Győzelem, rangsor, választás

A Legitimitás elszámolásonkénti forrásai egyeznek, de a szezonnak nincs vége. Nincs Koronázási Tanács, így a játékot nem lehet megnyerni.

| Forrás | Szabálykönyv | Prototípus |
| --- | --- | --- |
| Tanácsi mandátum | +1 L mandátumonként | egyezik |
| Tanácsi többség (legalább 5 hely) | +3 L | egyezik |
| Árucikk legnagyobb eladója | +2 L árucikkenként | egyezik; holtversenyben az első kapja, nem senki |
| A város legnépszerűbb szereplője | +2 L | egyezik, holtversenyben senki |
| Sikeres leleplezés | +3 L | egyezik |
| Eladott információ | +1 L, legfeljebb 3 elszámolásonként | egyezik |
| Koronázási Tanács | +10 L tanácsi szavazatonként a szezon végén | **hiányzik** |

- **Rangsor:** a prototípus Legitimitás szerint rangsorol. Mellette mutatja az összes részesedést és a tanácsi helyeket, valamint a saját népszerűségedet városonként.
- **Stabilitás:** a városnézet és a térkép ismeri a stabil, ingatag és lázongó állapotot. A v0.2 szabálykönyvben nincs stabilitás, a prototípus mindig stabilnak rajzolja a várost. A stabilitás a Vallás és a Világesemények modulhoz tartozik.

## Csak a prototípusban

Ezek tudatos egyszerűsítések vagy tesztelőeszközök. A szabálykönyvbe nem kell átvinni őket, de a tesztek értékelésénél számolni kell velük.

- **Szimulált idő:** +30 perc, +2 óra és „Következő esemény” gomb. Egy nap percek alatt lejátszható.
- **Négy NPC-ház rögzített személyiséggel:**
  - Ezüstpart-ház: kalmár, áraz és részesedést vesz;
  - Ősi Tölgy: politikus, pártot alapít, fesztivált tart, hírt terjeszt rólad;
  - Bíbor Kéz: kém, kifürkészi a lapodat, és gyakran hamis uzsorahírt terjeszt;
  - Varjúvár: felvásárló, kivásárlási ajánlatot tesz a részesedésedre.
- **NPC-k és kémjelentések:** az NPC-k nem reagálnak a kémjelentésekre.
- **NPC-k időzítése:** az NPC-k csak elszámolás után pecsételnek, eltérő, hosszabb érleléssel. Így a kivásárlás ellen mindig van idő védekezni.
- **Kivásárlási riasztás:** a célpont azonnal jelentést kap a rá irányuló ajánlatról, a Parancslapon és a Vásártéren is. A szabálykönyv ezt csak következményként tartalmazza, hiszen a védekező vételhez tudni kell róla.
- **Hír igazságjelzője:** hírterjesztés előtt a felület mutatja, hogy az állítás most igaz-e. Ez egyezik a szabálykönyv 6.5 pontjával.
- **Látható érlelő lapok:** az Alvilágban mindenki érlelő lapja és lejárati ideje látszik, de a tartalma csak kifürkészéssel. A szabálykönyv nem mondja ki, hogy a lejárati idő nyilvános-e.
- **Csak Polgár mód:** nincsenek nehézségi szintek és modulok.
- **Lobbi:** a játéklista, a játék részletei és a jelentkezés (ház, tinktúra, háttér, kezdőhely) csak bemutató célú. A játékba mindig ugyanaz a Délkelet-játék indul.
- **Belépés:** csak színlelt közösségi belépés van (Google, Apple, Discord).

## Javaslatok

Először azt a hat pontot érdemes rendbe tenni, amely a tesztek eredményét torzítja. Ezeket a prototípusban kell javítani.

**A prototípusban javítandó:**

1. A háttér és a kezdőhely hasson a kezdőállapotra (2.2). Enélkül a három ág egyensúlya nem mérhető (12. fejezet, 6. pont).
2. Az NPC-k is útvonalakkal játsszanak, és fizessék a fenntartást.
3. Az NPC-k érlelési ideje legyen 2 óra, és bármikor pecsételhessenek. Így mérhető, mikor éri meg pecsételni (12. fejezet, 5. pont).
4. Készüljön el a 20 N alatti +50%-os aranyfelár.
5. Készüljön el a kém áthelyezése.
6. A kifürkészés csak az adott városban kiadott parancsokat fedje fel, és a lebukás minden kémakcióra érvényes legyen.

**Utána, szintén a prototípusban:** készüljön el a szezonvég és a Koronázási Tanács, hogy egy teljes játszma lejátszható legyen.

**A szabálykönyvben rögzítendő:**

- **Alapár:** 1 A vagy 3 A? A prototípus 3 A-val számol, és a párt megtérülése ezzel áll be. Javaslat: 3 A, a 11. fejezetben frissítve.
- **Adó tanács nélkül:** ki kapja? Javaslat: nincs adó, amíg nincs tanács. Ez a prototípus mostani működése.
- **Fesztivál:** kell-e hozzá párt? A prototípus szerint igen.
- **Érvénytelenné vált parancs:** mi történik vele végrehajtáskor? A prototípusban az arany visszajár, a PP nem.
- **Holtverseny:** hogyan dől el „az árucikk legnagyobb eladója” cím?
- **Idegen birtok:** kiindulhat-e onnan útvonal?
- **Érlelő lapok:** nyilvános-e, hogy kinek van érlelő lapja, és mikor jár le?
- **Új párt:** milyen programmal indul?

**A lobbiban:** frissüljön a kezdőhelyek katonai utalása.

**A tervezetből már nem aktuális:** a hatalmi ágak tervezete kétfázisú kört javasolt (tervezés, zárás, hírszerzés, végrehajtás). A szabálykönyv és a prototípus is az érlelési időt választotta. Ezt a tervezetben lezártnak lehetne jelölni.
