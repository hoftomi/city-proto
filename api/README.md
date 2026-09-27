# API-szerződés

Az [`openapi.yaml`](openapi.yaml) (OpenAPI 3.0.3) a Trón nélkül API-jának **egyetlen igazságforrása**. A backend és a mobil kliens is ebből generál, ezért a modelleket és a kéréseket egyik oldalon sem kell kézzel írni.

| Oldal | Generátor | Mit kap | Hogyan |
|---|---|---|---|
| Spring backend (`tron-nelkul/backend`) | openapi-generator 7.25.0, `spring` | a `com.hof.tronnelkul.api` interfészek (AuthApi, LobbyApi, GameApi, AdminApi), amelyeket a vezérlők valósítanak meg, és a `…api.model` osztályok | automatikusan, minden fordításkor (`./gradlew compileJava` → `openApiGenerate`, kimenet: `build/generated/openapi`) |
| Flutter (`city-mob`) | openapi-generator 7.25.0, `dart-dio` + json_serializable | a `packages/tron_api` csomag: Dio-alapú API-osztályok és modellek `copyWith`-szel | `city-mob/tools/generate_api.sh`, a generált kód verziókezelt |

## Változtatás menete

1. Szerkeszd az `openapi.yaml`-t (útvonal, séma, mező).
2. Backend: `./gradlew compileJava` – a fordító megmutatja, hol kell a vezérlőt vagy a nézetet igazítani.
3. Mobil: `FLUTTER=/út/a/flutterhez tools/generate_api.sh`, utána `flutter analyze`.
4. Ha a válasz szerkezete változott, frissítsd a mobil szerződéstesztjének mintáját (`city-mob/test/fixtures`).

## Megállapodások

- **Feliratok:** a mobil kliens minden felirata a `GET /api/i18n/{lang}` végpontról jön (easy_localization formátum, névterenként), bejelentkezés nélkül. Forrás: `tron-nelkul/backend/src/main/resources/i18n`.
- **Azonosítás:** minden végpont Firebase ID tokent vár (`bearerAuth`), kivéve a `/api/auth/discord` és a `/api/i18n/{lang}` végpontot.
- **Hibák:** RFC 9457 ProblemDetail, a `detail` mező magyar, megjeleníthető szöveg.
- **Mezők:** minden mező `required`. A hiányozható értékek `nullable: true` jelölést kapnak, így a generált konstruktorok a mezőket a sémabeli sorrendben várják.
- **Időpontok:** ISO-8601. Javában `Instant`, Dartban `DateTime`.
