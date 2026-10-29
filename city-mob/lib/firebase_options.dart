// Client settings of the Firebase project (city-proto). `flutterfire configure` may regenerate this file.
// These are not secrets: access is protected by the Firebase security rules and the API key restrictions.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) return android;
    throw UnsupportedError('No Firebase app is configured for this platform yet. For iOS: flutterfire configure');
  }

  static const android = FirebaseOptions(
    apiKey: 'AIzaSyDntM5e1-6mkFucPdOzsnESZjrB4Met4os',
    appId: '1:961636113755:android:5d1622f038e0de6aec4e7e',
    messagingSenderId: '961636113755',
    projectId: 'city-proto',
    storageBucket: 'city-proto.firebasestorage.app',
  );
}
