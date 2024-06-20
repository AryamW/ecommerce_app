import 'dart:convert';

import 'package:ecommerce_app/presentation/controllers/auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import "package:uuid/uuid.dart";
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getInstanceId() async {
  String? id;
  try {
    id = await FirebaseInstallations.instance.getId();
  } catch (e) {}
  id ??= const Uuid().v4();
  return id;
}

Future<void> handleBackgroundMessaging(RemoteMessage message) async {
  print("called here ");
  print("title: ${message.notification?.title}");
  print("body: ${message.notification?.body}");
  print("data: ${message.data}");
}

void handleMessage(RemoteMessage? message) {
  if (message == null) {
    return;
  }
  message.data["route"] != null ? Get.toNamed(message.data["route"]) : null;
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future initLocalNotifications() async {
    const IOS = DarwinInitializationSettings();
    const Android = AndroidInitializationSettings('@drawable/ic_launcher');
    
    const settings = InitializationSettings(android: Android, iOS: IOS);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (receivedNotification) async {
        // Handle notification tap
        if (receivedNotification.payload != null &&
            receivedNotification.payload!.isNotEmpty) {
          // Assuming handleMessage is a method that handles the notification payload
          final message =
              RemoteMessage.fromMap(jsonDecode(receivedNotification.payload!));
          handleMessage(message);
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) {
        return;
      }
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          )),
          payload: jsonEncode(event.toMap()));
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    // better to save it in backend database
    // may
    print("fCMToken: $fCMToken");

    Get.put(LoginController()).saveFCMToken(fCMToken);
    print(
        "loginController token: ${Get.find<LoginController>().fCMToken.value}");
    initPushNotifications();
    initLocalNotifications();
  }
}
