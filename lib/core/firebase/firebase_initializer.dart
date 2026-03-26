import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future<void> ensureFirebaseInitialized() async {
  if (Firebase.apps.isNotEmpty) {
    return;
  }

  try {
    await Firebase.initializeApp();
  } catch (_) {
    await Firebase.initializeApp(options: _firebaseOptionsForCurrentPlatform);
  }
}

bool get isFirebaseInitialized => Firebase.apps.isNotEmpty;

FirebaseOptions get _firebaseOptionsForCurrentPlatform {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return const FirebaseOptions(
        apiKey: 'AIzaSyAHPcEig6FLGEYrjPXlvPm8xMhvm8gRFTA',
        appId: '1:1090385927274:android:3ba967b1668dd3944bbe13',
        messagingSenderId: '1090385927274',
        projectId: 'computer-shop-app-cd0e8',
        storageBucket: 'computer-shop-app-cd0e8.firebasestorage.app',
      );
    default:
      throw UnsupportedError(
        'Firebase options are not configured for this platform yet.',
      );
  }
}
