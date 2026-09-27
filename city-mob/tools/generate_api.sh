#!/bin/sh
# Az API-szerződésből (../api/openapi.yaml) generálja a Dio-alapú klienst és a modelleket: packages/tron_api.
# Ugyanaz a generátorverzió (7.25.0), mint a backend Gradle-pluginjában (tools/openapitools.json). Kell hozzá Node (npx) és Java 11+.
#   FLUTTER="/út/a/flutterhez" tools/generate_api.sh
set -e
cd "$(dirname "$0")/.."
FLUTTER="${FLUTTER:-/Users/hoftamas/Downloads/city_sdk/bin/flutter}"
case "$FLUTTER" in */*) DART="${DART:-$(dirname "$FLUTTER")/dart}" ;; *) DART="${DART:-/Users/hoftamas/Downloads/city_sdk/bin/dart}" ;; esac
npx --yes @openapitools/openapi-generator-cli --openapitools tools/openapitools.json generate \
  -g dart-dio \
  -i ../api/openapi.yaml \
  -o packages/tron_api \
  --additional-properties=pubName=tron_api,serializationLibrary=json_serializable,dateLibrary=core,hideGenerationTimestamp=true \
  --global-property=apiTests=false,modelTests=false,apiDocs=false,modelDocs=false
cd packages/tron_api
"$FLUTTER" pub get
"$DART" run build_runner build --delete-conflicting-outputs
echo "Kész: packages/tron_api"
