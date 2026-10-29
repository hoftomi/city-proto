# Trón nélkül – Admin

Angular admin web app for the game server (`tron-nelkul/backend`). Angular 22 (standalone components, signals,
zoneless), Angular Material, Firebase Auth (Google sign-in) and an API client generated from the contract
(`../backend/openapi.yaml`, tag `admin`).

Pages: **Dashboard** (`GET /api/admin/overview`: stat cards, registrations/joins per day), **Games** (list with status
filter, new game, recreate sample games, row actions), **Game detail** (start, settle now, advance the game clock,
end season, delete; houses; report counts and latest reports), **Users** (grant/revoke the ADMIN role).

All UI texts are Hungarian and come from the backend: `../backend/src/main/resources/i18n/hu/admin.json` (namespace
`admin`), loaded from `GET /api/i18n/hu` at startup. Code uses English keys (`{{ 'nav.games' | t }}`,
`translator.t('games.npc_count', { n: 3 })`). Error snackbars show the server's `ProblemDetail.detail`.

## Firebase setup (once)

`src/environments/environment*.ts` hold the Firebase config of the project `city-proto`: `apiKey`, `authDomain` and
`projectId` — that is all Google sign-in needs. The key is the project's API key (the one the Android app uses; it is
not restricted to Android). These values are public identifiers, not secrets.

1. Optional: register a web app (Firebase console → project **city-proto** → Project settings → *Your apps* →
   **Add app → Web**) and put its `apiKey` and `appId` into both environment files, if you want the admin to have its
   own app entry (analytics, key restrictions per platform).
2. If the project's API key ever gets restricted to Android apps, step 1 becomes mandatory.
3. Authentication → Sign-in method: **Google** must be enabled (it already is for the mobile).
4. Authentication → Settings → **Authorized domains**: add `localhost` (usually present) and the host the admin is
   served from in production (e.g. `admin.example.com`, or the server's IP/hostname for port 8081).
5. Grant the ADMIN role to the first admin. Sign in once (the first `GET /api/me` creates the user; you will see the
   "no access" page), then in the database:

   ```sql
   update users set role = 'ADMIN'
   where id = (select user_id from user_identities where email = 'you@example.com' limit 1);
   ```

   After that, further admins can be granted on the Users page. (The server refuses removing your own ADMIN role.)

## Development

Requires Node 22.22+/24.15+/26+. The backend runs on `http://localhost:8080`.

```sh
npm install
npm start            # ng serve on http://localhost:4200, /api proxied to localhost:8080 (proxy.conf.json)
npm test             # unit tests (Vitest, jsdom), headless
npm run lint         # angular-eslint
npm run typecheck    # tsc for app and specs
npm run check:i18n   # every key used in src/app exists in ../backend/.../i18n/hu/admin.json
npm run build        # production build → dist/admin/browser
```

New UI text: add the key to `admin.json` (backend), use it via the `t` pipe or `Translator.t()`; keys stored outside a
`t` call go through `key('...')` so `check:i18n` can see them. Dates are formatted in Hungarian, Europe/Budapest.

## API client generation

`src/app/api` is generated (typescript-angular, openapi-generator 7.25.0 – same as the backend and the mobile) and
committed. After changing `../backend/openapi.yaml`:

```sh
npm run api          # = ../backend/gradlew -p tools/api_codegen openApiGenerate (needs Java, not Node)
```

Config: `tools/api_codegen/build.gradle.kts`; skipped files: `src/app/api/.openapi-generator-ignore`. Do not edit the
generated files by hand.

## Auth

- `core/session.ts`: Firebase app/auth from the environment config, Google popup sign-in, `GET /api/me` (cached per
  sign-in).
- `core/auth.interceptor.ts`: adds `Authorization: Bearer <Firebase ID token>` to every `/api/` call except the public
  `/api/i18n/`; the SDK refreshes expiring tokens, and a 401 is retried once with a force-refreshed token.
- `core/guards.ts`: not signed in → `/login`; role ≠ `ADMIN` (or `/api/me` failed) → `/no-access` (with sign-out).

## Docker

Build context is **this folder** (`tron-nelkul/admin`), not the repo root:

```sh
docker build -t tron-admin tron-nelkul/admin
```

Multi-stage: Node builds the app, nginx (port 80) serves it with history fallback (`nginx.conf`) and proxies `/api/` to
`http://backend:8080` (same origin, no CORS). The `backend` name is resolved through Docker's embedded DNS, so the
container must run on the compose network next to the `backend` service, e.g.:

```yaml
  admin:
    build: ../admin          # relative to tron-nelkul/backend/docker-compose.yml
    ports: ["8081:80"]
    depends_on: [backend]
```
