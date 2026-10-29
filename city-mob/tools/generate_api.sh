#!/bin/sh
# Generates the Dio-based client and models (packages/tron_api) from the API contract (../tron-nelkul/backend/openapi.yaml).
# The generator is the same openapi-generator Gradle plugin (7.25.0) as in the backend (tools/api_codegen),
# run with the backend's Gradle wrapper (needs Java, not Node). Then json_serializable produces the .g.dart
# files via build_runner. The package's pubspec.yaml is protected by .openapi-generator-ignore.
#   FLUTTER="/path/to/flutter" tools/generate_api.sh
set -e
cd "$(dirname "$0")/.."
FLUTTER="${FLUTTER:-/Users/hoftamas/Downloads/city_sdk/bin/flutter}"
case "$FLUTTER" in */*) DART="${DART:-$(dirname "$FLUTTER")/dart}" ;; *) DART="${DART:-dart}" ;; esac
../tron-nelkul/backend/gradlew --no-daemon -q -p tools/api_codegen openApiGenerate
cd packages/tron_api
"$FLUTTER" pub get
"$DART" run build_runner build --delete-conflicting-outputs
echo "Done: packages/tron_api"
