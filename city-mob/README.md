# Trón nélkül – mobil kliens

Flutter 3.47 (Dart 3.13), Android és iOS. A látvány a Krónika IV design system (lásd `tools/k4_export`).

## Architektúra

A rétegek felülről lefelé csak az alattuk lévőt ismerik:

```
widget  →  bloc  →  service  →  repository  →  datasource  →  (Dio / Firebase / secure storage)
```

| Réteg | Hol | Feladat |
|---|---|---|
| datasource | `lib/data/datasource/` | A külső rendszerek vékony burka: a generált API-kliens (`remote/`), a Firebase, Google, Apple és Discord SDK (`auth/`), a biztonságos tároló (`local/`). Hibánál kivételt dob. |
| repository | `lib/data/repository/` | Összefogja az adatforrásokat, és `Either<Failure, T>`-t ad vissza (either_dart). A kivételből `Failure` lesz, a ProblemDetail `detail` mezőjével. A térképeket gyorsítótárazza. |
| service | `lib/domain/service/` | Üzleti és származtatott logika: a játék órája, esedékes frissítés, az újonnan felvett parancs, űrlap-ellenőrzés, kérésösszeállítás. A generált modellek segédei a `lib/domain/model/` mappában vannak (extensionök). |
| bloc | `lib/ui/<képernyő>/bloc/` | Az állapot. Az esemény `sealed class … extends Equatable`, az állapot `Equatable`, és csak `copyWith`-szel változik (a ktk mintájára, `part` fájlokban). Az egyszeri üzenetek sorszámozott `Notice` mezőben mennek. |
| widget | `lib/ui/<képernyő>/`, `lib/widgets/` | Csak megjelenít és eseményt küld. A `lib/widgets` a design system tisztán megjelenítő komponensei. |

- **Függőségek:** get_it és injectable, `lib/app/di/`. A regisztrációt a build_runner generálja (`di.config.dart`).
- **Navigáció:** go_router, `lib/app/router/`. Az átirányítás az `AuthBloc` állapota szerint működik. A játék öt füle egy `StatefulShellRoute` ága (`/games/:id/play/{map,city,reports,orders,ranking}`), a városnézet városa és negyede pedig lekérdezési paraméter, így mélylinkelhető. A `GameBloc` a teljes játékot fogja át.
- **API:** Dio, a Firebase ID tokent az `AuthInterceptor` teszi rá. 401-nél a `SessionEvents` jelez, és az `AuthBloc` kiléptet.

## Kódgenerálás

```bash
FLUTTER=/út/a/flutterhez tools/generate_api.sh   # API-kliens és modellek az ../api/openapi.yaml-ból → packages/tron_api
dart run build_runner build                      # DI (injectable)
```

Az API-szerződésről lásd [`../api/README.md`](../api/README.md).

## Tesztek

```bash
flutter test
```

- **Blocok:** bloc_test és mocktail, mockolt service-ekkel vagy repositorykkal (`test/ui/`).
- **Szerződés:** a backend valódi válaszai a generált modellekkel is beolvashatók (`test/contract/`, minta: `test/fixtures/`).
