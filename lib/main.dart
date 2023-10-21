import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/services.dart';
import 'package:pegasus_tool/pool_tool_app.dart';
import 'package:provider/provider.dart';

import 'network/dio_factory.dart';
import 'provider/theme_provider.dart';

final dio = getDio();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // firebaseMessaging. configure(onMessage: (Map<String, dynamic> message) async {
  //   debugPrint('onMessage: ' + message.toString());
  //   await handleLocalNotification(message);
  // }, onLaunch: (Map<String, dynamic> message) async {
  //   print("onLaunch: $message");
  //   handleNotification(message);
  // }, onResume: (Map<String, dynamic> message) async {
  //   print("onResume: $message");
  //   handleNotification(message);
  // });

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  await Services.registerAll();

  await GetIt.I.allReady();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
    ),
  ], child: const PoolToolApp()));
}
