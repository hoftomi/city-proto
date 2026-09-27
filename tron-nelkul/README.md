# Trón nélkül – 0.0.2

Aszinkron stratégiai játék a város három hatalmi ágával: Kereskedők (Vásártér), Politika (Városháza), Kémhálózat (Alvilág). Ebben a verzióban egy teljes vékony szelet működik: közösségi bejelentkezés, játékválasztó és jelentkezés, valamint a játék maga (térkép, városnézet, parancslap, jelentések, rangsor). A szabálymotor a **szabálykönyv v0.2** szerint fut a szerveren: a lepecsételt parancslap érlelési idő után hajtódik végre, a gazdaság 8:00-kor és 20:00-kor számol el.

| Rész | Technológia |
|---|---|
| `backend/` | Spring Boot 4.1.1, Java 25, Spring Security 7 (Firebase ID token), Spring Data JPA, Flyway, PostgreSQL 17 |
| `mobile/` | Flutter 3.47 (Dart 3.13), Android és iOS, Firebase Auth |
| `docker-compose.yml` | PostgreSQL, igény szerint a backenddel együtt |

> A 0.0.2 backendje lefordul, a szabálymotor tesztjei lefutnak (`./gradlew test`), és a mobil `flutter analyze` hibátlan. A backend által előállított állapot-JSON-t a mobil modelljei beolvassák. Valódi eszközön, bejelentkezett felhasználóval a teljes folyamat még nincs végigpróbálva.

---

## 1. Gyors indítás

### Előfeltételek

- JDK 25. A Gradle toolchain automatikusan letölti, ha nincs telepítve.
- Docker (a PostgreSQL-hez).
- Flutter 3.47 stable (`flutter --version`), valamint Android Studio vagy Xcode.
- Egy Firebase-projekt, a `firebase` CLI és a `flutterfire` CLI (`dart pub global activate flutterfire_cli`).

### Backend

```bash
docker compose up -d db          # PostgreSQL a 5432-es porton (tron / tron / tron)
cd backend
./gradlew test                   # a szabálymotor tesztjei
./gradlew bootRun                # http://localhost:8080 (Firebase-projekt: city-proto)
```

Az első indításkor a `SeedData` létrehozza a mintajátékokat:

| Játék | Állapot | Megjegyzés |
|---|---|---|
| Délkelet · 1. szezon | **fut** | Az első 3 elszámolásig még lehet csatlakozni, így azonnal kipróbálható. |
| Ködös Hegyvidék | nyitott | +2 nap múlva indul |
| Sóvidék ligája | nyitott | +5 nap múlva indul |
| Villámszezon | nyitott | +1 nap múlva indul |
| Tavaszi bajnokság | hamarosan | +12 nap múlva nyílik a jelentkezés |

Ellenőrzés: `curl localhost:8080/actuator/health`.

### Mobil

A repó nem tartalmazza a platformmappákat (`android/`, `ios/`), mert ezeket a telepített Flutter verzió generálja. Egyszer futtasd le az előkészítő szkriptet:

```bash
cd mobile
./setup_platforms.sh        # flutter create + Android-beállítások + flutter pub get
flutterfire configure       # a Firebase-projekt kiválasztása: firebase_options.dart, google-services.json, GoogleService-Info.plist
flutter test
flutter run
```

A szkript a következőket csinálja:

- lefuttatja a `flutter create . --org com.hof --project-name tron_nelkul --platforms android,ios` parancsot (a `--project-name` azért kell, mert a mappanév nem feltétlenül érvényes Dart-csomagnév; a meglévő `lib/` és `pubspec.yaml` nem íródik felül);
- bemásolja a `platform/android/AndroidManifest.xml` fájlt: internetjog, fejlesztői HTTP (`usesCleartextTraffic`), a Discord-belépés visszahívó activityje;
- az Android `minSdk` értékét 24-re állítja (a `flutter_secure_storage` miatt).

**Android emulátoron** a backend címe alapból `http://10.0.2.2:8080`, **valódi telefonon** a géped helyi IP-címe: `--dart-define=API_BASE=http://192.168.x.y:8080`.
**iOS szimulátoron** a backend címe `http://localhost:8080`. Más címhez: `--dart-define=API_BASE=https://…`.

### Kipróbálás

1. Lépj be Google-fiókkal (a beállítást lásd a 2. fejezetben). Minden új felhasználó PLAYER szerepet kap. ADMIN szerepet (az időtekeréshez és az azonnali elszámoláshoz) az adatbázisban adhatsz:
   `update users set role = 'ADMIN' where display_name = '<neved>';` Ez a következő kérésnél már érvényes, újra belépni nem kell.
2. A játékválasztóban nyisd meg a **Délkelet** játékot, és válaszd a „Csatlakozás a futó játékhoz” gombot. Ezután jön a négy lépés: ház, háttér (Kereskedőház: válassz árucikket a kezdővárosban), kezdőhely, összegzés.
3. Nyisd meg a játékot:
   - **Térkép:** koppints egy városra: népszerűséged, árucikkek, tanács. Ha nem vezet oda útvonalad, innen építhetsz egyet.
   - **Város:** három negyed. **Vásártér:** részesedés vétele a Várostól, haszonkulcs, kivásárlás és védekező vétel. **Városháza:** pártalapítás, adóprogram, fesztivál, hírek. **Alvilág:** kémek, őrök, kifürkészés, hírek ellenőrzése és leleplezése, információ eladása.
   - **Parancslap:** a vázlatot lepecsételed, és 2 óra érlelés után lép érvénybe (a Villámszezonban 1 óra). Egyszerre egy érlelő lapod lehet.
   - **Jelentések** (saját és nyilvános) és **Rangsor** (Legitimitás, részesedés, tanácshelyek).
4. Adminként a felső sávban tekerheted az időt (+30 perc, +2 óra, következő esemény), vagy azonnal elszámolhatsz. Az előretekerés a játék saját óráját állítja (`games.time_offset_minutes`), a valódi időt nem.

Élesben az elszámolás minden nap 8:00-kor és 20:00-kor fut (Europe/Budapest), minden 6. elszámolás választás. Az ütemező félpercenként futtatja le a lejárt parancslapokat.

---

## 2. Bejelentkezés (Firebase Auth)

A belépést a Firebase Authentication végzi. A mobil a Firebase ID tokenjét küldi minden kéréssel (`Authorization: Bearer`). A backend a Google kulcsaival ellenőrzi az aláírást, a kiadót (`https://securetoken.google.com/<projekt-id>`) és a célközönséget. Az első kérésnél létrehozza a saját felhasználót (`users`, `user_identities` `provider = firebase`, `subject` = Firebase uid). Jelszó nincs, fejlesztői belépés nincs.

A környezeti változók a `.env.example` fájlban vannak. Másold le `.env` néven.

### Firebase-projekt

1. A Firebase Console-ban hozz létre egy projektet, és a mobil mappájában futtasd a `flutterfire configure` parancsot (Android: `com.hof.tron_nelkul`, iOS: `com.hof.tronNelkul`). Ez felülírja a `lib/firebase_options.dart` helyőrzőt, és elhelyezi a platformok konfigurációs fájljait.
2. Backend: `FIREBASE_PROJECT_ID` (alapértelmezés: `city-proto`).

### Google

1. Firebase Console → Authentication → Sign-in method → **Google** bekapcsolása.
2. Android: a Firebase projektbeállításaiban add meg az aláíró kulcs SHA-1 és SHA-256 ujjlenyomatát (`cd android && ./gradlew signingReport`), majd futtasd újra a `flutterfire configure` parancsot.
3. iOS: az `ios/Runner/Info.plist` fájlba vedd fel URL-sémaként a `GoogleService-Info.plist` `REVERSED_CLIENT_ID` értékét (a `google_sign_in` leírása szerint).
4. Ha Androidon a belépés „serverClientId” hibát ad: `--dart-define=GOOGLE_SERVER_CLIENT_ID=<a Firebase által létrehozott „Web client” azonosító>`.

### Apple (csak iOS)

1. Firebase Console → Authentication → Sign-in method → **Apple** bekapcsolása.
2. Az Apple Developer felületen kapcsold be a *Sign in with Apple* képességet a bundle ID-hoz, az Xcode-ban pedig adj hozzá a Runner targethez egy „Sign in with Apple” capabilityt.
3. Az Apple a nevet csak az első belépéskor adja át. A kliens ekkor beírja a Firebase-fiókba, így a backend az ID tokenből olvassa ki.

> Ha az iOS-alkalmazásban más közösségi belépés is van, az App Store szabályai szerint az Apple-belépés kötelező.

### Discord

A Firebase nem támogatja beépítetten. A mobil authorization code + PKCE folyamattal kér kódot a rendszerböngészőben (`flutter_web_auth_2`). A backend ezt beváltja, lekéri a Discord-profilt, és Firebase custom tokent ad vissza (uid: `discord:<Discord-azonosító>`). Ezzel lép be a kliens a Firebase-be.

1. A Discord Developer Portalon hozz létre egy alkalmazást. OAuth2 alatt vedd fel a redirect URI-t: `tronnelkul://auth`.
2. Backend: `DISCORD_CLIENT_ID`, `DISCORD_CLIENT_SECRET`, és a custom tokenek aláírásához egy Firebase service account kulcs. Ezt a Firebase Console → Projektbeállítások → Service accounts → „Generate new private key” menüpontban töltheted le. Tedd a `backend/secrets/firebase-service-account.json` helyre (a git kihagyja), és állítsd be a `GOOGLE_APPLICATION_CREDENTIALS` változót a fájl útvonalára. Dockerben a `docker-compose.yml` kikommentezett soraival csatolható.
3. Mobil: `--dart-define=DISCORD_CLIENT_ID=<ID>`. Androidon a visszahívó activity már szerepel az `AndroidManifest.xml` fájlban.
4. Ha a Discord nem fogadja el az egyedi sémát, használj egy https-es átirányító oldalt, és add meg `--dart-define=DISCORD_REDIRECT_URI=…` és `DISCORD_CALLBACK_SCHEME=…` alakban.

### Élesítés előtt

- A belépőgombokat cseréld a szolgáltatók hivatalos, márkairányelvek szerinti gombjaira. A játék egyelőre szándékosan semleges betűjelet használ.
- HTTPS a backend előtt.
- Több szerverpéldány esetén az ütemező csak egy példányon fusson: a többin `SCHEDULER_ENABLED=false`.

---

## 3. Felépítés

```
backend/src/main/java/com/hof/tronnelkul/
  auth/            Firebase ID token → saját felhasználó, Discord PKCE → Firebase custom token
  config/          biztonság (állapotmentes, Bearer Firebase ID token), beállítások
  user/            felhasználók és külső azonosítóik
  game/world/      térképek (Délkelet, Ködös Hegyvidék, Sóvidék): városok árucikkekkel, utak, kezdőhelyek, domborzat
  game/engine/     a szabálymotor: tiszta Java, Spring nélkül, egységtesztekkel
                   Rules (a szabálykönyv v0.2 11. fejezete), EngineState (az állapot), Engine (érlelés, elszámolás,
                   választás, kémek, hírek, információs piac, NPC-k), Setup (induló állás, háttérbónusz)
  game/model/      JPA entitások; a játék állapota egy JSON-dokumentum a games.state oszlopban
  game/service/    lobbi, jelentkezés, parancsok, nézet, ütemező, mintaadatok (GameRunner: zárolás, előrevitel, mentés)
  game/api/        REST vezérlők (a generált API-interfészek megvalósításai)
backend/src/main/resources/db/migration/   a séma (V2: v0.2, a régi játékokat törli)

mobile/lib/
  api/             HTTP kliens, modellek (a Dtos.java tükre), munkamenet
  auth/            Google, Apple, Discord (Firebase Auth)
  theme/           a design system tokenjei (színek nappali és éjjeli témában, betűk, térközök)
  widgets/         design system komponensek: részesedéssáv, tanácsülések, PP-számláló, címer, jelentéskártya,
                   térkép (domborzattal), városnézet (Városháza, Vásártér, Alvilág)
  screens/         belépés, játékválasztó, részletek, jelentkezés, játék (5 fül; city_tab.dart: a három negyed)
```

A szabálymotor a szerveren fut. Nyilvános: az eladók neve, részesedése és fokozata (5.2), a népszerűség, a pártok, a tanács és a hírek. Mások parancslapját csak kifürkészéssel láthatod, mások kémeinek számát pedig nem, csak azt, hogy vannak.

## 4. API

A szerződés a repó gyökerében van: [`api/openapi.yaml`](../api/openapi.yaml). A backend minden fordításkor ebből generálja az interfészeket (`com.hof.tronnelkul.api`) és a modelleket (`com.hof.tronnelkul.api.model`, openapi-generator `spring`). A vezérlők ezeket valósítják meg, a mobil kliens pedig ugyanebből a fájlból generál. Részletek: [`api/README.md`](../api/README.md).


| Metódus | Útvonal | Leírás |
|---|---|---|
| POST | `/api/auth/discord` | Discord-kód cseréje, válasz: `{customToken}` (a Google és az Apple közvetlenül a Firebase-en megy) |
| GET | `/api/me` | a bejelentkezett felhasználó (az első hívás létrehozza) |
| GET | `/api/games` | játékok listája, saját házzal |
| GET | `/api/games/{id}` | részletek, kezdőhelyek, hátterek, tinktúrák |
| GET | `/api/games/maps/{mapId}` | térkép (városok, utak, kezdőhelyek, domborzat) |
| POST / DELETE | `/api/games/{id}/join` | jelentkezés és visszavonás |
| GET | `/api/games/{id}/state` | a játékos nézete: óra, erőforrások, hálózat, városok, vázlat, érlelő lap, fenyegetések, kifürkészett tervek, ajánlatok, katalógus |
| POST | `/api/games/{id}/orders` | parancs a vázlatra (`type`: route, margin, buyShares, buyout, defend, foundParty, program, festival, news, hireSpy, moveSpy, guard, spy, verify, debunk) |
| DELETE | `/api/games/{id}/orders/{orderId}` | parancs törlése a vázlatról |
| POST | `/api/games/{id}/seal` | lepecsételés (visszavonni nem lehet) |
| POST | `/api/games/{id}/intel/{intelId}/offer` | kifürkészett terv felkínálása: `{buyerId, price}` |
| POST | `/api/games/{id}/offers/{offerId}/accept` · `/decline` | ajánlat elfogadása (letét) vagy elutasítása |
| GET | `/api/games/{id}/reports` · `/ranking` | jelentések, rangsor |
| POST | `/api/admin/games/{id}/start` · `/settle` · `/advance` | indítás, azonnali elszámolás, időtekerés `{minutes}` vagy a következő eseményig (ADMIN) |

Minden hiba RFC 9457 ProblemDetail formában jön. A `detail` mező magyar, megjeleníthető szöveg.

## 5. A 0.0.2 korlátai és eltérései

- **Alapár:** 3 A egységenként, a prototípus szerint. A szabálykönyv 1 A-t javasol, de azzal túl szűkös a gazdaság.
- **Védekező vétel:** akkor hat, ha lepecsételed, mielőtt a kivásárlás lefut. Nem kell előbb lefutnia, különben egyenlő érlelési idő mellett a célpont soha nem tudna védekezni.
- **Kifürkészés:** csak az adott városban kiadott parancsokat fedi fel (7.2; a prototípus a teljes lapot mutatja). Minden kémakció lebukhat, a hír ellenőrzése és leleplezése is (7.4).
- **NPC-k:** ugyanazzal az érlelési idővel játszanak, mint a játékosok, és bármikor pecsételhetnek (elszámolás után 6 órán belül, illetve a lapjuk lefutása után).
- **Hiányzik még:** a nehézségi szintek és modulok (9.), valamint a push értesítés. Az NPC-k hálózata nem korlátozott (nincs birtokuk és útvonaluk), és a kémjelentésekre még nem reagálnak.
- **Tinktúra:** nem egyedi, mert 30 játékosra nem elég a 8 szín. A házak neve egyedi.
- **Tesztelni kell:** egy passzív Árnyékrend-játékos 3 nap alatt elfogy az aranyából (2 kém és 2 útvonal fenntartása elszámolásonként 6 A). A kémágnak korán bevétel kell, különben ez a szabálykönyv 12.3-as kérdése.
