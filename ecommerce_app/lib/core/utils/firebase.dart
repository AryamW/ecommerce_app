import "package:uuid/uuid.dart";
import 'package:firebase_app_installations/firebase_app_installations.dart';

Future<String?> getInstanceId() async {
  String? id;
  try {
    id = await FirebaseInstallations.instance.getId();
  } catch (e) {}
  id ??= const Uuid().v4();
  return id;
}
