#!/bin/sh
# Egyszeri előkészítés: legenerálja az android/ és ios/ mappát a telepített Flutterrel,
# majd beállítja a Trón nélkül igényeit. A lib/ és a pubspec.yaml nem íródik felül.
set -e
cd "$(dirname "$0")"

flutter create . --org com.hof --project-name tron_nelkul --platforms android,ios

# Android: internet, fejlesztői http, Discord-visszahívás
cp platform/android/AndroidManifest.xml android/app/src/main/AndroidManifest.xml

# Android: a flutter_secure_storage legalább API 23-at kér
for f in android/app/build.gradle.kts android/app/build.gradle; do
  if [ -f "$f" ]; then
    perl -pi -e 's/minSdk\s*=\s*flutter\.minSdkVersion/minSdk = 24/; s/minSdkVersion\s+flutter\.minSdkVersion/minSdkVersion 24/' "$f"
  fi
done

flutter pub get
echo
echo "Kész. Ha még nem tetted meg: flutterfire configure, majd flutter run"
