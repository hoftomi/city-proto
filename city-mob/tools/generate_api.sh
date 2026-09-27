#!/bin/sh
# Az API-szerződésből (../api/openapi.yaml) generálja a Dio-alapú klienst és a modelleket: packages/tron_api.
# A generátor ugyanaz az openapi-generator Gradle-plugin (7.25.0), mint a backendben (tools/api_codegen),
# a backend Gradle-wrapperével fut (Java kell hozzá, Node nem). Utána a json_serializable a build_runnerrel
# készíti el a .g.dart fájlokat. A csomag pubspec.yaml-ját a .openapi-generator-ignore védi.
#   FLUTTER="/út/a/flutterhez" tools/generate_api.sh
set -e
cd "$(dirname "$0")/.."
FLUTTER="${FLUTTER:-/Users/hoftamas/Downloads/city_sdk/bin/flutter}"
case "$FLUTTER" in */*) DART="${DART:-$(dirname "$FLUTTER")/dart}" ;; *) DART="${DART:-dart}" ;; esac
../tron-nelkul/backend/gradlew --no-daemon -q -p tools/api_codegen openApiGenerate
cd packages/tron_api
"$FLUTTER" pub get
"$DART" run build_runner build --delete-conflicting-outputs
echo "Kész: packages/tron_api"
