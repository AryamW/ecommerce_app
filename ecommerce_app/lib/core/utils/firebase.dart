import 'package:ecommerce_app/presentation/controllers/auth.dart';
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
  print("title: ${message.notification?.title}");
  print("body: ${message.notification?.body}");
  print("data: ${message.data}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    // better to save it in backend database
    // may
    print("fCMToken: $fCMToken");
    Get.find<LoginController?>()?.saveFCMToken(fCMToken) ??
        Get.put(LoginController()).saveFCMToken(fCMToken);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
  }
}
