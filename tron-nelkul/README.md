# Trón nélkül – 0.0.1

Aszinkron, befolyás alapú stratégiai játék. Ebben a verzióban egy teljes vékony szelet működik: közösségi bejelentkezés, játékválasztó és jelentkezés, valamint a játék maga (térkép, városnézet, parancslap, jelentések, rangsor). A köröket a szerver dolgozza fel a szabálykönyv v0.1 szerint.

| Rész | Technológia |
|---|---|
| `backend/` | Spring Boot 4.1.1, Java 25, Spring Security 7 (saját JWT), Spring Data JPA, Flyway, PostgreSQL 17 |
| `mobile/` | Flutter 3.47 (Dart 3.13), Android és iOS |
| `docker-compose.yml` | PostgreSQL, igény szerint a backenddel együtt |

> **Fontos:** a 0.0.1 kódját olyan környezetben írtam, ahol a Maven Central, a Gradle-portál és a pub.dev nem volt elérhető. A szabálymotor (`game/engine`, `game/world`) lefordul, és a tesztjei lefutnak. A Spring- és a Flutter-kód fordítását viszont nem tudtam lefuttatni, csak gondos átnézéssel ellenőriztem. Az első `./gradlew build` és `flutter analyze` hibáit küldd vissza, és javítom.

---

## 1. Gyors indítás (fejlesztői belépéssel)

### Előfeltételek

- JDK 25. A Gradle toolchain automatikusan letölti, ha nincs telepítve.
- Docker (a PostgreSQL-hez).
- Flutter 3.47 stable (`flutter --version`), valamint Android Studio vagy Xcode.

### Backend

```bash
docker compose up -d db          # PostgreSQL a 5432-es porton (tron / tron / tron)
cd backend
./gradlew test                   # a szabálymotor tesztjei
./gradlew bootRun                # http://localhost:8080
```

Az első indításkor a `SeedData` létrehozza a mintajátékokat:

| Játék | Állapot | Megjegyzés |
|---|---|---|
| Délkelet · 1. szezon | **fut** | Az első 3 körben még lehet csatlakozni, így azonnal kipróbálható. |
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
flutter test
flutter run --dart-define=DEV_LOGIN=true
```

A szkript a következőket csinálja:

- lefuttatja a `flutter create . --org hu.webstar --project-name tron_nelkul --platforms android,ios` parancsot (a `--project-name` azért kell, mert a mappanév nem feltétlenül érvényes Dart-csomagnév; a meglévő `lib/` és `pubspec.yaml` nem íródik felül);
- bemásolja a `platform/android/AndroidManifest.xml` fájlt: internetjog, fejlesztői HTTP (`usesCleartextTraffic`), a Discord-belépés visszahívó activityje;
- az Android `minSdk` értékét 24-re állítja (a `flutter_secure_storage` miatt).

**Android emulátoron** a backend címe alapból `http://10.0.2.2:8080`, **valódi telefonon** a géped helyi IP-címe: `--dart-define=API_BASE=http://192.168.x.y:8080`.
**iOS szimulátoron** a backend címe `http://localhost:8080`. Más címhez: `--dart-define=API_BASE=https://…`.

### Kipróbálás

1. A belépőképernyő alján válaszd a **Fejlesztői belépés** lehetőséget, és adj meg egy nevet. A fejlesztői felhasználó ADMIN szerepet kap.
2. A játékválasztóban nyisd meg a **Délkelet** játékot, és válaszd a „Csatlakozás a futó játékhoz” gombot. Ezután jön a négy lépés: ház, háttér, kezdőhely, összegzés.
3. Nyisd meg a játékot:
   - **Térkép:** koppints egy városra. Ha nem vezet oda útvonalad, innen építhetsz egyet.
   - **Város:** koppints egy negyedre, és adj akciót a parancslapra (rejtve is lehet).
   - **Parancslap:** lepecsételés. Adminként a „Feldolgozás most” gomb azonnal lefuttatja a kört.
   - **Jelentések** és **Rangsor**.

Élesben a körök minden nap 8:00-kor és 20:00-kor futnak le (Europe/Budapest).

---

## 2. Közösségi bejelentkezés beállítása

A mobil csak a szolgáltatói azonosítót szerzi meg. A backend ellenőrzi az aláírást, a kiadót és a célközönséget, majd saját JWT-t ad ki (30 napig érvényes, a készülék biztonságos tárolójában marad). Jelszó nincs.

A környezeti változók a `.env.example` fájlban vannak. Másold le `.env` néven.

### Google

1. A Google Cloud Console-ban hozz létre OAuth-klienseket: *Web application*, *Android* (csomagnév és SHA-1) és *iOS* (bundle ID).
2. Backend: `GOOGLE_CLIENT_IDS=<web>,<android>,<ios>` (vesszővel elválasztva).
3. Mobil: `--dart-define=GOOGLE_SERVER_CLIENT_ID=<web kliens ID>`. iOS-en ezen felül `--dart-define=GOOGLE_IOS_CLIENT_ID=<ios kliens ID>`, és az `ios/Runner/Info.plist` fájlba kell a `GIDClientID` kulcs, valamint a fordított kliensazonosító URL-sémaként (a `google_sign_in` leírása szerint).

### Apple (csak iOS)

1. Az Apple Developer felületen kapcsold be a *Sign in with Apple* képességet a bundle ID-hoz, az Xcode-ban pedig adj hozzá a Runner targethez egy „Sign in with Apple” capabilityt.
2. Backend: `APPLE_AUDIENCES=hu.webstar.tronnelkul` (a bundle ID).
3. Az Apple a nevet csak az első belépéskor adja át. A kliens ekkor elküldi, és a backend elmenti.

> Ha az iOS-alkalmazásban más közösségi belépés is van, az App Store szabályai szerint az Apple-belépés kötelező.

### Discord

1. A Discord Developer Portalon hozz létre egy alkalmazást. OAuth2 alatt vedd fel a redirect URI-t: `tronnelkul://auth`.
2. Backend: `DISCORD_CLIENT_ID`, `DISCORD_CLIENT_SECRET`.
3. Mobil: `--dart-define=DISCORD_CLIENT_ID=<ID>`. A folyamat authorization code + PKCE a rendszerböngészőben (`flutter_web_auth_2`).
4. Androidon a `flutter_web_auth_2` visszahívó activityjét fel kell venni az `AndroidManifest.xml` fájlba, `tronnelkul` sémával (a csomag leírása szerint).
5. Ha a Discord nem fogadja el az egyedi sémát, használj egy https-es átirányító oldalt, és add meg `--dart-define=DISCORD_REDIRECT_URI=…` és `DISCORD_CALLBACK_SCHEME=…` alakban.

### Élesítés előtt

- `DEV_LOGIN=false` a backenden (ez kikapcsolja a fejlesztői belépést és az ADMIN szerepet).
- Hosszú, véletlen `JWT_SECRET` (legalább 32 bájt).
- A belépőgombokat cseréld a szolgáltatók hivatalos, márkairányelvek szerinti gombjaira. A 0.0.1 szándékosan semleges betűjelet használ.
- HTTPS a backend előtt.
- Több szerverpéldány esetén az ütemező csak egy példányon fusson: a többin `SCHEDULER_ENABLED=false`.

---

## 3. Felépítés

```
backend/src/main/java/hu/webstar/tronnelkul/
  auth/            bejelentkezés: Google/Apple ID token, Discord PKCE, fejlesztői belépés, JWT kiadás
  config/          biztonság (állapotmentes, Bearer JWT), beállítások
  user/            felhasználók és külső azonosítóik
  game/world/      térképek (Délkelet, Ködös Hegyvidék, Sóvidék): városok, utak, kezdőhelyek, domborzat
  game/engine/     a szabálymotor: tiszta Java, Spring nélkül, egységtesztekkel
                   Rules (a szabálykönyv 14. fejezete), Levels, Network, RoundResolver, NpcBrain
  game/model/      JPA entitások és tárolók
  game/service/    lobbi, jelentkezés, parancsok, láthatóság, kör-feldolgozás, ütemező, mintaadatok
  game/api/        REST végpontok és DTO-k
backend/src/main/resources/db/migration/V1__init.sql   a séma

mobile/lib/
  api/             HTTP kliens, modellek (a Dtos.java tükre), munkamenet
  auth/            Google, Apple, Discord
  theme/           a design system tokenjei (színek nappali és éjjeli témában, betűk, térközök)
  widgets/         design system komponensek: befolyássáv, kontrollszint, Gyanú, PP-számláló, címer,
                   jelentéskártya, térkép (domborzattal), városnézet (generált alaprajzzal)
  screens/         belépés, játékválasztó, részletek, jelentkezés, játék (5 fül)
```

A szabálymotor a szerveren fut. A kliens soha nem kapja meg mások pontos értékeit, csak a saját szintjének megfelelő sávokat (11. fejezet), és mások rejtett befolyását is csak összesítve.

## 4. API

| Metódus | Útvonal | Leírás |
|---|---|---|
| POST | `/api/auth/google` · `/apple` · `/discord` · `/dev` | belépés, válasz: `{token, user}` |
| GET | `/api/me` | a bejelentkezett felhasználó |
| GET | `/api/games` | játékok listája, saját házzal |
| GET | `/api/games/{id}` | részletek, kezdőhelyek, hátterek, tinktúrák |
| GET | `/api/games/maps/{mapId}` | térkép (városok, utak, kezdőhelyek, domborzat) |
| POST / DELETE | `/api/games/{id}/join` | jelentkezés és visszavonás |
| GET | `/api/games/{id}/state` | a játékos nézete: erőforrások, hálózat, városok, parancsok |
| POST | `/api/games/{id}/orders` | parancs felvétele (`type`: patron, grant, council, guard, smear, consolidate, route) |
| DELETE | `/api/games/{id}/orders/{orderId}` | parancs törlése |
| POST / DELETE | `/api/games/{id}/seal` | lepecsételés és a pecsét feltörése |
| GET | `/api/games/{id}/reports` · `/ranking` | jelentések, rangsor |
| POST | `/api/admin/games/{id}/start` · `/resolve` | indítás, azonnali kör (ADMIN) |

Minden hiba RFC 9457 ProblemDetail formában jön. A `detail` mező magyar, megjeleníthető szöveg.

## 5. A 0.0.1 korlátai

- **Szabályok:** nincs még Útzár, Szálak felgöngyölítése, Leleplezkedés, frakciókérés, szerződés, a Koronázási Tanács +5 bónusza, és nincsenek városi események az útlezárásra.
- **Háttértípusok:** csak a frakcióbónusz (×1,25) működik, a többi előny egyelőre leírás.
- **NPC-k:** a hálózatuk nem korlátozott.
- **Tinktúra:** nem egyedi, mert 30 játékosra nem elég a 8 szín. A házak neve egyedi.
- **Ütemezés:** minden játék napi 2 kört fut, a Villámszezon is.
- **Parancsok:** a le nem pecsételt parancsok is lefutnak a feldolgozáskor.
- **Hiányzik még:** push értesítés, szövetségek, diplomácia.
