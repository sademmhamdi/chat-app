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
    apiKey: 'AIzaSyCJYDRpczAUNzJcfIgIh-vszwNxUqVZWQM',
    appId: '1:989870492402:web:d08b97ca7f6ea846fb5e6b',
    messagingSenderId: '989870492402',
    projectId: 'chatcall-pro',
    authDomain: 'chatcall-pro.firebaseapp.com',
    storageBucket: 'chatcall-pro.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4B3je6Pkr7jiBymNFQG767eKZNL8JvsQ',
    appId: '1:989870492402:android:5ede856c4f032ea5fb5e6b',
    messagingSenderId: '989870492402',
    projectId: 'chatcall-pro',
    storageBucket: 'chatcall-pro.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCwXKPKK1J7ngOQDhcDer1noi8vYIqkoNo',
    appId: '1:989870492402:ios:d49989aac62e4ae1fb5e6b',
    messagingSenderId: '989870492402',
    projectId: 'chatcall-pro',
    storageBucket: 'chatcall-pro.firebasestorage.app',
    iosBundleId: 'com.example.chattach',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCwXKPKK1J7ngOQDhcDer1noi8vYIqkoNo',
    appId: '1:989870492402:ios:d49989aac62e4ae1fb5e6b',
    messagingSenderId: '989870492402',
    projectId: 'chatcall-pro',
    storageBucket: 'chatcall-pro.firebasestorage.app',
    iosBundleId: 'com.example.chattach',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCJYDRpczAUNzJcfIgIh-vszwNxUqVZWQM',
    appId: '1:989870492402:web:b275e9435a483131fb5e6b',
    messagingSenderId: '989870492402',
    projectId: 'chatcall-pro',
    authDomain: 'chatcall-pro.firebaseapp.com',
    storageBucket: 'chatcall-pro.firebasestorage.app',
  );

}
