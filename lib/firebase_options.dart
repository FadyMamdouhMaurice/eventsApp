// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyCmYwqTDpBgwAZd4nzmZDcnKAq6sbc_NMw',
    appId: '1:645858532053:web:1d1cfdbeea97b3b33c205c',
    messagingSenderId: '645858532053',
    projectId: 'symstax-events',
    authDomain: 'symstax-events.firebaseapp.com',
    storageBucket: 'symstax-events.appspot.com',
    measurementId: 'G-PN32LV79N7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQMVPfuo3bVHEvjRn0z_K36Ao8KCEjioY',
    appId: '1:645858532053:android:c6c32671ec782ae33c205c',
    messagingSenderId: '645858532053',
    projectId: 'symstax-events',
    storageBucket: 'symstax-events.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHfkdUGzQKjiCXMjsmOmtBsejIZlipa1Q',
    appId: '1:645858532053:ios:63815c666940e9353c205c',
    messagingSenderId: '645858532053',
    projectId: 'symstax-events',
    storageBucket: 'symstax-events.appspot.com',
    iosBundleId: 'com.example.symstaxEvents',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCHfkdUGzQKjiCXMjsmOmtBsejIZlipa1Q',
    appId: '1:645858532053:ios:63815c666940e9353c205c',
    messagingSenderId: '645858532053',
    projectId: 'symstax-events',
    storageBucket: 'symstax-events.appspot.com',
    iosBundleId: 'com.example.symstaxEvents',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCmYwqTDpBgwAZd4nzmZDcnKAq6sbc_NMw',
    appId: '1:645858532053:web:d652786f15cc978e3c205c',
    messagingSenderId: '645858532053',
    projectId: 'symstax-events',
    authDomain: 'symstax-events.firebaseapp.com',
    storageBucket: 'symstax-events.appspot.com',
    measurementId: 'G-1K5HNBY3N3',
  );
}