// A Firebase-projekt (city-proto) kliensbeállításai. A `flutterfire configure` újragenerálhatja.
// Ezek nem titkok: a hozzáférést a Firebase biztonsági szabályai és az API-kulcs korlátozásai védik.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) return android;
    throw UnsupportedError('Ehhez a platformhoz még nincs Firebase-alkalmazás. iOS-hez: flutterfire configure');
  }

  static const android = FirebaseOptions(
    apiKey: 'AIzaSyDntM5e1-6mkFucPdOzsnESZjrB4Met4os',
    appId: '1:961636113755:android:5d1622f038e0de6aec4e7e',
    messagingSenderId: '961636113755',
    projectId: 'city-proto',
    storageBucket: 'city-proto.firebasestorage.app',
  );
}
