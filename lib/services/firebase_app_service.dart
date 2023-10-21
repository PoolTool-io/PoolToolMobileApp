import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:pegasus_tool/firebase_options.dart';

class FirebaseAppService {
  late FirebaseApp firebaseApp;

  Future<FirebaseAppService> init() async {
    try {
      firebaseApp = await Firebase.initializeApp(
        name: 'pegasus-pool',
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    } on dynamic catch (_) {
      firebaseApp = Firebase.app("pegasus-pool");
    }
    return this;
  }
}
