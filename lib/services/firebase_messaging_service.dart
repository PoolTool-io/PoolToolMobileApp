import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/models/received_notification_model.dart';
import 'package:pegasus_tool/services/navigator_service.dart';

import '../screens/pool/chat/chat_proxy_widget.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class FirebaseMessagingService {
  late FirebaseMessaging firebaseMessaging;
  late NotificationSettings settings;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  FirebaseMessagingService() {
    firebaseMessaging = FirebaseMessaging.instance;
    configureNotifications();
  }

  bool pushNotificationReceived = false;

  Future<String?> getToken() async {
    return firebaseMessaging.getToken();
  }

  void configureFlutterLocalNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('logo');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        Constants.POOLTOOL_NOTIFICATIONS_CATEGORY,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(Constants.CHAT_ALERT, 'Action 1',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              }),
          DarwinNotificationAction.plain(Constants.SATURATION_ALERT, 'Action 1',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              }),
          DarwinNotificationAction.plain(
              Constants.BLOCK_PRODUCTION_ALERT, 'Action 1',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              }),
          DarwinNotificationAction.plain(Constants.FEE_CHANGE_ALERT, 'Action 1',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              }),
          DarwinNotificationAction.plain(Constants.PLEDGE_ALERT, 'Action 1',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              }),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  void configureNotifications() async {
    settings = await firebaseMessaging.requestPermission();
    configureFlutterLocalNotifications();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      if (message.notification != null) {
        Map<String, String?> payload = getPayload(message);
        handlePayload(payload);
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      handleLocalNotification(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(handleLocalNotification);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null) {
      Map<String, dynamic> payload = json.decode(notificationResponse.payload!);
      handlePayload(payload);
    }
  }

  Map<String, String?> getPayload(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (kDebugMode) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (notification != null) {
        print('Message also contained a notification: ${notification.body}');
      }
    }

    String? poolId;

    if (message.data['poolId'] != null) {
      //for ios
      poolId = message.data['poolId'];
    }

    String? roomId;
    if (message.data['roomId'] != null) {
      //for ios
      roomId = message.data['roomId'];
    }

    String? destination;
    if (message.data['destination'] != null) {
      destination = message.data['destination'];
    }

    debugPrint("poolId: $poolId");
    debugPrint("roomId: $roomId");
    debugPrint("destination: $destination");

    var payload = {
      "poolId": poolId,
      "roomId": roomId,
      "destination": destination,
    };

    return payload;
  }

  void handlePayload(Map<String, dynamic> payload) {
    debugPrint('notification payload: $payload');
    String? poolId = payload['poolId'];
    String? roomId = payload['roomId'];

    if (roomId != null) {
      GetIt.I<NavigationService>().navigateTo('chatRoom', "$poolId|$roomId");
    } else if (poolId != null) {
      GetIt.I<NavigationService>().navigateTo('poolDetails', poolId);
    } else {
      GetIt.I<NavigationService>().navigateTo("home", null);
    }
  }

  Future handleLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    Map<String, String?> payload = getPayload(message);

    AndroidNotification? android = message.notification?.android;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Pegasus',
      'Pegasus',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ticker: notification?.body,
      icon: android?.smallIcon,
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    if (payload['roomId'] != null &&
        ChatProxyWidget.onChatRooms.contains(payload['roomId'])) {
      //Skip the notification if the user is on the room they are getting the notification about
      return;
    }

    flutterLocalNotificationsPlugin.show(notification.hashCode,
        notification?.title, notification?.body, platformChannelSpecifics,
        payload: json.encode(payload));
  }
}
