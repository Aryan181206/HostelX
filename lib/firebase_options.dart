
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDpsfH1SsTa_Hzdm-tadj_JKBcRSvu1Ceo',
    appId: '1:630476076079:web:28df9db1abcd7f8b7d42da',
    messagingSenderId: '630476076079',
    projectId: 'hostelx-1d344',
    authDomain: 'hostelx-1d344.firebaseapp.com',
    storageBucket: 'hostelx-1d344.firebasestorage.app',
    measurementId: 'G-B4PPBM6W1K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfusnV5ftJN088c8UJ2SOCrl2KilhH-4U',
    appId: '1:630476076079:android:e3e765940f4868227d42da',
    messagingSenderId: '630476076079',
    projectId: 'hostelx-1d344',
    storageBucket: 'hostelx-1d344.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAS_L7l8jy7cJV8gWBKm9QNDvu8rSyZtkU',
    appId: '1:630476076079:ios:2126d911ba19e08d7d42da',
    messagingSenderId: '630476076079',
    projectId: 'hostelx-1d344',
    storageBucket: 'hostelx-1d344.firebasestorage.app',
    iosBundleId: 'com.example.amberHackathon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAS_L7l8jy7cJV8gWBKm9QNDvu8rSyZtkU',
    appId: '1:630476076079:ios:2126d911ba19e08d7d42da',
    messagingSenderId: '630476076079',
    projectId: 'hostelx-1d344',
    storageBucket: 'hostelx-1d344.firebasestorage.app',
    iosBundleId: 'com.example.amberHackathon',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDpsfH1SsTa_Hzdm-tadj_JKBcRSvu1Ceo',
    appId: '1:630476076079:web:d5f423854a76e65b7d42da',
    messagingSenderId: '630476076079',
    projectId: 'hostelx-1d344',
    authDomain: 'hostelx-1d344.firebaseapp.com',
    storageBucket: 'hostelx-1d344.firebasestorage.app',
    measurementId: 'G-RFS1ZBD3PZ',
  );
}
