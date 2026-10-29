# API contract

[`openapi.yaml`](openapi.yaml) (OpenAPI 3.0.3) is the **single source of truth** for the Trón nélkül API. Both the backend and the mobile client generate code from it, so models and requests never have to be written by hand on either side.

| Side | Generator | What it gets | How |
|---|---|---|---|
| Spring backend (`tron-nelkul/backend`) | openapi-generator 7.25.0, `spring` | the `com.hof.tronnelkul.api` interfaces (AuthApi, LobbyApi, GameApi, AdminApi), implemented by the controllers, and the `…api.model` classes | automatically, on every build (`./gradlew compileJava` → `openApiGenerate`, output: `build/generated/openapi`) |
| Flutter (`city-mob`) | openapi-generator 7.25.0, `dart-dio` + json_serializable | the `packages/tron_api` package: Dio-based API classes and models with `copyWith` | `city-mob/tools/generate_api.sh`; the generated code is version-controlled |

## Making a change

1. Edit `openapi.yaml` (path, schema, field).
2. Backend: `./gradlew compileJava` – the compiler shows where the controller or view needs adjusting.
3. Mobile: `FLUTTER=/path/to/flutter tools/generate_api.sh`, then `flutter analyze`.
4. If the response structure changed, update the sample used by the mobile contract test (`city-mob/test/fixtures`).

## Conventions

- **UI text:** every label of the mobile client comes from the `GET /api/i18n/{lang}` endpoint (easy_localization format, per namespace), without sign-in. Source: `tron-nelkul/backend/src/main/resources/i18n`.
- **Authentication:** every endpoint expects a Firebase ID token (`bearerAuth`), except `/api/auth/discord` and `/api/i18n/{lang}`.
- **Errors:** RFC 9457 ProblemDetail; the `detail` field is displayable Hungarian text.
- **Fields:** every field is `required`. Values that may be missing are marked `nullable: true`, so the generated constructors expect the fields in schema order.
- **Timestamps:** ISO-8601. `Instant` in Java, `DateTime` in Dart.
